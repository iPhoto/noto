//
//  Mail.m
//  Selfie
//
//  Created by Daniel Suo on 6/30/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import "Note.h"

@implementation Note

- (instancetype)initWithToEmail:(NSString *)toEmail
                      fromEmail:(NSString *)fromEmail
                        subject:(NSString *)subject
                           body:(NSString *)body {
    self = [super init];
    if (self) {
        _toEmail = toEmail;
        _fromEmail = fromEmail;
        _subject = subject;
        _body = body;
    }
    return self;
}

- (instancetype)initWithString:(NSString *)string
                     direction:(NSUInteger)direction {
    
    NSString *emailTo;
    NSString *emailFrom;
    
    if (direction == UISwipeGestureRecognizerDirectionRight) {
        emailTo = @"swipeRightTo";
        emailFrom = @"swipeRightFrom";
    } else if (direction == UISwipeGestureRecognizerDirectionLeft) {
        emailTo = @"swipeLeftTo";
        emailFrom = @"swipeLeftFrom";
    } else {
        return self;
    }
    
    NSString *toEmail = (NSString *)[Utilities getSettingsObject:emailTo];
    NSString *fromEmail = (NSString *)[Utilities getSettingsObject:emailFrom];
    
    if (toEmail) {
        if ([Utilities isEmptyString:fromEmail]) {
            fromEmail = toEmail;
        }
        
        NSString *message = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if ([Utilities isEmptyString:message]) {
            return self;
        }
        
        NSArray *lines = [message componentsSeparatedByString:@"\n"];
        NSUInteger count = [lines count];
        
        if (count > 0) {
            NSMutableString *subject = lines[0];
            NSMutableString *body;
            NSString *signature = (NSString *)[Utilities getSettingsObject:@"signature"];
            NSString *subjectPrefix = (NSString *)[Utilities getSettingsObject:@"subjectPrefix"];
            
            // Build body
            if (count > 1) {
                body = [[NSMutableString alloc] initWithString:[[lines subarrayWithRange:NSMakeRange(1, [lines count] - 1)] componentsJoinedByString:@"\n"] ];
            } else {
                body = [[NSMutableString alloc] initWithString:@" "];
            }
            
            if (![Utilities isEmptyString:signature]) {
                [body appendString:@"\n\n"];
                [body appendString: signature];
            }
            
            if (![Utilities isEmptyString:subjectPrefix]) {
                subject = [[NSString stringWithFormat:@"%@ %@", subjectPrefix, subject] mutableCopy];
            }
            
            self.toEmail = toEmail;
            self.fromEmail = fromEmail;
            self.subject = subject;
            self.body = body;
        }
    }
    return self;
}
        
- (void)send {
    [self sendWithCompletionHandler:nil];
}
- (void)sendWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    sendgrid *msg = [sendgrid user:SGUsername andPass:SGPassword];
    msg.to = self.toEmail;
    msg.from = self.fromEmail;
    msg.subject = self.subject;
    msg.text = self.body;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    // List of all system sounds
    // https://github.com/TUNER88/iOSSystemSoundsLibrary
    AudioServicesPlaySystemSound (1001);
    
    [msg sendWithWebUsingSuccessBlock:^(id responseObject) {
        NSLog(@"Success!: %@", self.subject);
        
        if (completionHandler) {
            completionHandler(UIBackgroundFetchResultNewData);
        }
        
        [self onComplete];
    } failureBlock:^(NSError *error) {
        NSLog(@"Error sending email: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setMinimumBackgroundFetchInterval" object:nil];
        [Queue enqueue:self];
        
        if (completionHandler) {
            completionHandler(UIBackgroundFetchResultFailed);
        }
        
        [self onComplete];
        
        // TODO: Handle Sendgrid error codes here. Send NSNotifications to trigger UI events.
    }];
}
- (void)onComplete {
    [UIApplication sharedApplication].applicationIconBadgeNumber = [Queue count];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
        
@end
