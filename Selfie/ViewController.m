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

- (IBAction)processSwipe:(UISwipeGestureRecognizer *)sender {

    NSString *directionEmail;
    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        directionEmail = @"swipeRightEmail";
    } else {
        directionEmail = @"swipeLeftEmail";
    }

    NSString *email = [self getSettingsValue:directionEmail];
    if (email) {
        NSArray *lines = [self.message componentsSeparatedByString:@"\n"];
        NSUInteger count = [lines count];
        if (count > 0) {
            NSString *subject = lines[0];
            NSString *body = count > 1 ? [[lines subarrayWithRange:NSMakeRange(1, [lines count] - 1)] componentsJoinedByString:@"\n"] : @" ";
            
            [self.mailgun sendMessageTo:email
                              from:email
                           subject:subject
                              body:body];
            
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
}


@end
