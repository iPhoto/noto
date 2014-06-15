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
@property (strong, nonatomic) IBOutlet UINavigationItem *navBarTitle;

//- (void)sendSuccess:(NSString *) message;
//- (void (^)(NSError *))sendFailure;

- (void)setSettingsValue:(NSString *)value forKey:(NSString *)key;
- (NSString *)getSettingsValue:(NSString *) key;
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

void (^sendSuccess)(NSString *) = ^(NSString *message) {
    NSLog(@"success!");
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

    NSString *toEmail = [self getSettingsValue:emailTo];
    NSString *fromEmail = [self getSettingsValue:emailFrom];
    
    if (toEmail) {
        if (!fromEmail) {
            fromEmail = toEmail;
        }
        
        NSArray *lines = [self.message componentsSeparatedByString:@"\n"];
        NSUInteger count = [lines count];
        if (count > 0) {
            NSString *subject = lines[0];
            NSMutableString *body;
            NSString *signature = [self getSettingsValue:@"signature"];
            
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
            
            self.text.text = nil;
            self.message = nil;
        }
    } else {
        NSLog(@"Fail");
    }
}

- (void)setSettingsValue:(NSString *)value forKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:value forKey:key];
}

- (NSString *)getSettingsValue:(NSString *) key {
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.text becomeFirstResponder];
    self.text.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)textViewDidChange:(UITextView *)textView {
    NSLog(@"hello!");
}

@end
