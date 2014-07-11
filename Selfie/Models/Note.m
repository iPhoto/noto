//
//  Note.h
//  Selfie
//
//  Created by Daniel Suo on 6/30/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import "Note.h"

@implementation Note

- (instancetype)initFromDictionary:(NSDictionary *)dict {
    Note *note = [self initWithToEmail:[dict valueForKey:@"toEmail"] fromEmail:[dict valueForKey:@"fromEmail"] subject:[dict valueForKey:@"subject"] body:[dict valueForKey:@"body"]];
    return note;
}

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

- (instancetype)initWithString:(NSString *) string
                     direction:(SwipeDirection) direction {
    
    NSString *toEmail = [Utilities getEmailWithDirection:direction];
    NSString *fromEmail = toEmail;
    
    if (toEmail) {
        
        NSString *message = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if ([Utilities isEmptyString:message]) {
            return self;
        }
        
        NSArray *lines = [message componentsSeparatedByString:@"\n"];
        NSUInteger count = [lines count];
        
        if (count > 0) {
            NSMutableString *subject = lines[0];
            NSMutableString *body;
            NSString *signature = (NSString *)[Utilities getSettingsValue:kSettingsSignatureKey];
            NSString *subjectPrefix = (NSString *)[Utilities getSettingsValue:kSettingsSubjectPrefixKey];
            
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

- (BOOL)validNote {
    return ![Utilities isEmptyString:self.toEmail] &&
    ![Utilities isEmptyString:self.fromEmail] &&
    ![Utilities isEmptyString:self.subject];
}

- (void)sendWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    if ([self validNote]) {
        sendgrid *msg = [sendgrid user:SGUsername andPass:SGPassword];
        msg.to = self.toEmail;
        msg.from = self.fromEmail;
        msg.subject = self.subject;
        msg.text = self.body;
        msg.fromName = [Utilities appName];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        // List of all system sounds
        // https://github.com/TUNER88/iOSSystemSoundsLibrary
        AudioServicesPlaySystemSound (1001);
        
        [msg sendWithWebUsingSuccessBlock:^(id responseObject) {
            NSLog(@"Success!: %@", self.subject);
            
            [Radio postNotificationName:kNoteSendSuccessNotification object:nil];
            
            if (completionHandler) {
                completionHandler(UIBackgroundFetchResultNewData);
            }
            
            [self onComplete];
        } failureBlock:^(NSError *error) {
            NSLog(@"Error sending email: %@", error);
            
            [Radio postNotificationName:kNoteSendFailNotification object:nil];
            
            [Queue enqueue:self];
            
            if (completionHandler) {
                completionHandler(UIBackgroundFetchResultFailed);
            }
            
            [self onComplete];
            
            // TODO: Handle Sendgrid error codes here. Send NSNotifications to trigger UI events.
        }];
    } else {
        // TODO: Handle invalid note
    }
}

- (NSDictionary *)toDictionary {
    NSDictionary *dict = [[NSDictionary alloc]
                          initWithObjects:@[self.toEmail, self.fromEmail, self.subject, self.body]
                          forKeys:@[@"toEmail", @"fromEmail", @"subject", @"body"]];
    return dict;
}

// TODO: refactor to respond to notifications
- (void)onComplete {
    [UIApplication sharedApplication].applicationIconBadgeNumber = [Queue count];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
        
@end
