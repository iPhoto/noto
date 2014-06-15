//
//  ViewController.m
//  Selfie
//
//  Created by Daniel Suo on 6/12/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import "ViewController.h"
#import "Mailgun.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITextView *text;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) Mailgun *mailgun;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *emailCountLabel;
@property (strong, nonatomic) IBOutlet UINavigationItem *navBarTitle;
@end

@implementation ViewController

- (NSString *) message {
    if (!_message) {
        _message = self.text.text;
    }
    
    return _message;
}

- (Mailgun *) mailgun {
    if (!_mailgun) {
        _mailgun = [Mailgun clientWithDomain:@"the-leather-apron-club.mailgun.org"
                                      apiKey:@"key-2w1t601cqh-c32-dc45lqmv0fqspphk7"];
    }
    return _mailgun;
}

void (^setSettingsValue)(NSString *, NSString *) = ^(NSString *key, NSString *value) {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:value forKey:key];
};

NSString * (^getSettingsValue)(NSString *) = ^(NSString * key) {
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
};

void (^sendSuccess)(NSString *) = ^(NSString *message) {
    NSLog(@"success!");
    int count = [getSettingsValue(@"emailCount") intValue] - 1;
    count = MAX(0, count);
    setSettingsValue(@"emailCount", [NSString stringWithFormat:@"%d", count]);
};

void (^sendFailure)(NSError *) = ^(NSError *error) {
    NSLog(@"error!");
};

- (IBAction)processSwipe:(UISwipeGestureRecognizer *)sender {

    NSString *emailTo;
    NSString *emailFrom;
    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        emailTo = @"swipeRightTo";
        emailFrom = @"swipeRightFrom";
    } else {
        emailTo = @"swipeLeftTo";
        emailFrom = @"swipeLeftFrom";
    }

    NSString *toEmail = getSettingsValue(emailTo);
    NSString *fromEmail = getSettingsValue(emailFrom);
    
    if (toEmail) {
        if (!fromEmail) {
            fromEmail = toEmail;
        }
        
        NSArray *lines = [self.message componentsSeparatedByString:@"\n"];
        NSUInteger count = [lines count];
        if (count > 0) {
            NSString *subject = lines[0];
            NSMutableString *body;
            NSString *signature = getSettingsValue(@"signature");
            
            // Build body
            if (count > 1) {
                body = [[NSMutableString alloc] initWithString:[[lines subarrayWithRange:NSMakeRange(1, [lines count] - 1)] componentsJoinedByString:@"\n"] ];
            } else {
                body = [[NSMutableString alloc] initWithString:@" "];
            }
            
            if (signature) {
                [body appendString:@"\n\n"];
                [body appendString: signature];
            }
            
            [self.mailgun sendMessageTo:toEmail
                              from:fromEmail
                           subject:subject
                              body:body
                           success:sendSuccess
                           failure:sendFailure];
            
            int count = [getSettingsValue(@"emailCount") intValue] + 1;
            setSettingsValue(@"emailCount", [NSString stringWithFormat:@"%d", count]);
            
            self.text.text = nil;
            self.message = nil;
        }
    } else {
        NSLog(@"Fail");
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [self.text becomeFirstResponder];
    self.text.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults addObserver:self
               forKeyPath:@"emailCount"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
}

- (void)viewDidDisappear:(BOOL)animated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObserver:self forKeyPath:@"emailCount"];
}

- (void)textViewDidChange:(UITextView *)textView {
    NSLog(@"hello!");
}

-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context
{
    NSLog(@"KVO: %@ changed property %@ to value %@", object, keyPath, change);
    self.emailCountLabel.title = [NSString stringWithFormat:@"Count: %d", [getSettingsValue(@"emailCount") intValue]];
}

@end
