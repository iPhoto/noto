//
//  Mailer.m
//  Selfie
//
//  Created by Daniel Suo on 6/15/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import "Mailer.h"
#import "sendgrid.h"
#import "MailQueue.h"
#import "Utilities.h"

@interface Mailer ()

@end;

@implementation Mailer

static NSString * const SGUsername = @"danielsuo";
static NSString * const SGPassword = @"TheLAC41988";


+ (void)sendMessageTo:(NSString *)toEmail
                 from:(NSString *)fromEmail
          withSubject:(NSString *)subject
             withBody:(NSString *)body {
    [Mailer sendMessageTo:toEmail from:fromEmail withSubject:subject withBody:body withCompletionHandler:nil];
}

+ (void)sendMessageTo:(NSString *)toEmail
                 from:(NSString *)fromEmail
          withSubject:(NSString *)subject
             withBody:(NSString *)body
withCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
    sendgrid *msg = [sendgrid user:SGUsername andPass:SGPassword];
    msg.to = toEmail;
    msg.from = fromEmail;
    msg.subject = subject;
    msg.text = body;
    
    [msg sendWithWebUsingSuccessBlock:^(id responseObject) {
        NSLog(@"Success!: %@", subject);
        
        if (completionHandler) {
            completionHandler(UIBackgroundFetchResultNewData);
        }
        
        [UIApplication sharedApplication].applicationIconBadgeNumber = [MailQueue count];
    } failureBlock:^(NSError *error) {
        NSLog(@"Error sending email: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setMinimumBackgroundFetchInterval" object:nil];
        [MailQueue enqueueMailTo:toEmail from:fromEmail withSubject:subject withBody:body];
        
        if (completionHandler) {
            completionHandler(UIBackgroundFetchResultFailed);
        }
        
        [UIApplication sharedApplication].applicationIconBadgeNumber = [MailQueue count];
        
        // TODO: Handle Sendgrid error codes here. Send NSNotifications to trigger UI events.
    }];
}

@end;