//
//  Mailer.m
//  Selfie
//
//  Created by Daniel Suo on 6/15/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import "Mailer.h"
#import "sendgrid.h"
#import "Utilities.h"

@interface Mailer ()

@end;

@implementation Mailer

static NSString * const SGUsername = @"danielsuo";
static NSString * const SGPassword = @"TheLAC41988";


+ (void)sendMessageTo:(NSString *)toEmail
                 from:(NSString *)fromEmail
          withSubject:(NSString *)subject
             withBody:(NSString *)body
               withID:(NSString *)mailID {
    [Mailer sendMessageTo:toEmail from:fromEmail withSubject:subject withBody:body withID:mailID withCompletionHandler:nil];
}

+ (void)sendMessageTo:(NSString *)toEmail
                 from:(NSString *)fromEmail
          withSubject:(NSString *)subject
             withBody:(NSString *)body
               withID:(NSString *)mailID
withCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
    sendgrid *msg = [sendgrid user:SGUsername andPass:SGPassword];
    msg.to = toEmail;
    msg.from = fromEmail;
    msg.subject = subject;
    msg.text = body;
    
    [msg sendWithWebUsingSuccessBlock:^(id responseObject) {
        [Utilities loopThroughMailQueueAndSave:^(NSMutableArray* queue, NSMutableDictionary *message, int i) {
            if ([[message valueForKey:@"id"] isEqualToString:mailID]) {
                [queue removeObject:message];
            }
            if ([queue count] == 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"stopMinimumBackgroundFetchInterval" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"emailQueueEmpty" object:nil];
            }
        }];
        
        if (completionHandler) {
            completionHandler(UIBackgroundFetchResultNewData);
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"Error sending email: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setMinimumBackgroundFetchInterval" object:nil];
        
        [Utilities loopThroughMailQueueAndSave:^(NSMutableArray* queue, NSMutableDictionary *message, int i) {
            if ([[message valueForKey:@"id"] isEqualToString:mailID]) {
                [[(NSDictionary *)queue[i] mutableCopy] setValue:@"NO" forKey:@"sending"];
            }
        }];
        
        if (completionHandler) {
            completionHandler(UIBackgroundFetchResultFailed);
        }
        
        // TODO: Handle Sendgrid error codes here. Send NSNotifications to trigger UI events.
    }];
}

@end;