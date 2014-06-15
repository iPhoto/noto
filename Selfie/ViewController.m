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

- (void)pollEmailQueue {
    NSArray *queue = [[NSUserDefaults standardUserDefaults] objectForKey:@"emailQueue"];
    NSMutableArray *mutableQueue = [queue mutableCopy];
    
    for (int i = 0; i < [queue count]; i++) {
        NSDictionary *message = (NSDictionary *) [queue objectAtIndex: i];
        [self.mailgun sendMessageTo:[message valueForKey:@"toEmail"]
                               from:[message valueForKey:@"fromEmail"]
                            subject:[message valueForKey:@"subject"]
                               body:[message valueForKey:@"body"]
                            success:sendSuccess
                            failure:sendFailure];
        [mutableQueue removeObjectAtIndex: 0];
        NSLog([message valueForKey:@"subject"]);
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:mutableQueue forKey:@"emailQueue"];
    [userDefaults synchronize];
};

void (^sendSuccess)(NSString *) = ^(NSString *message) {
    NSLog(@"success!");
};

void (^sendFailure)(NSError *, MGMessage *) = ^(NSError *error, MGMessage *msg) {
    NSArray *keys = [NSArray arrayWithObjects: @"toEmail", @"fromEmail", @"subject", @"body", nil];
    NSArray *values = [NSArray arrayWithObjects: msg.to[0], msg.from, msg.subject, msg.text, nil];
    NSMutableArray *queue = [[[NSUserDefaults standardUserDefaults] objectForKey:@"emailQueue"] mutableCopy];
    if (!queue) {
        queue = [[NSMutableArray alloc] init];
    }
    [queue addObject:[NSDictionary dictionaryWithObjects:values forKeys:keys]];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:queue forKey:@"emailQueue"];
    [userDefaults synchronize];
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
        if (!fromEmail || [[fromEmail stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
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
            
            NSArray *keys = [NSArray arrayWithObjects: @"toEmail", @"fromEmail", @"subject", @"body", nil];
            NSArray *values = [NSArray arrayWithObjects: toEmail, fromEmail, subject, body, nil];
            NSMutableArray *queue = [[[NSUserDefaults standardUserDefaults] objectForKey:@"emailQueue"] mutableCopy];
            if (!queue) {
                queue = [[NSMutableArray alloc] init];
            }
            [queue addObject:[NSDictionary dictionaryWithObjects:values forKeys:keys]];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:queue forKey:@"emailQueue"];
            [userDefaults synchronize];
            
            [self pollEmailQueue];
            
            self.text.text = nil;
            self.message = nil;
        }
    } else {
        NSLog(@"Fail");
    }
}


- (void)viewDidAppear:(BOOL)animated {
    self.text.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardIsUp:) name:UIKeyboardDidShowNotification object:nil];
    [self.text becomeFirstResponder];
    self.text.contentInset = UIEdgeInsetsMake(74, 0, 0, 0);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    self.navigationController.navigationBar.translucent = NO;
}

- (void)scrollToCaretInTextView:(UITextView *)textView animated:(BOOL)animated
{
    CGRect rect = [textView caretRectForPosition:textView.selectedTextRange.end];
    rect.size.height += textView.textContainerInset.bottom;
    [textView scrollRectToVisible:rect animated:animated];
}

- (void)keyboardIsUp:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    UIEdgeInsets inset = self.text.contentInset;
    inset.bottom = keyboardRect.size.height;
    self.text.contentInset = inset;
    self.text.scrollIndicatorInsets = inset;
    
    [self scrollToCaretInTextView:self.text animated:YES];
}

- (void)textViewDidChange:(UITextView *)textView {
    if ([textView.text hasSuffix:@"\n"]) {
        
        [CATransaction setCompletionBlock:^{
            [self scrollToCaretInTextView:textView animated:NO];
        }];
        
    } else {
        [self scrollToCaretInTextView:textView animated:NO];
    }
}

//-(void)observeValueForKeyPath:(NSString *)keyPath
//                     ofObject:(id)object
//                       change:(NSDictionary *)change
//                      context:(void *)context
//{
//    NSLog(@"KVO: %@ changed property %@ to value %@", object, keyPath, change);
//}

@end
