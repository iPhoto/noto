//
//  MailQueue.m
//  Selfie
//
//  Created by Daniel Suo on 6/17/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import "MailQueue.h"
#import "Mailer.h"
#import "Utilities.h"

@interface MailQueue ()
@end;

@implementation MailQueue

+ (void)enqueueMailTo:(NSString *)toEmail
                 from:(NSString *)fromEmail
          withSubject:(NSString *)subject
             withBody:(NSString *)body {
    
    NSMutableArray *queue = [[Utilities getSettingsObject:@"emailQueue"] mutableCopy];
    
    NSArray *keys = [NSArray arrayWithObjects: @"toEmail", @"fromEmail", @"subject", @"body", nil];
    NSArray *values = [NSArray arrayWithObjects: toEmail, fromEmail, subject, body, nil];
    [queue addObject:[NSDictionary dictionaryWithObjects:values forKeys:keys]];
    
    [Utilities setSettingsObject:queue forKey:@"emailQueue"];
    
    [self pollMailQueue];
}

+ (void)pollMailQueue {
    [MailQueue pollMailQueueWithCompletionHandler:nil];
}

+ (void)pollMailQueueWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"emailQueueFull" object:nil];
    [Utilities loopThroughMailQueueAndSave:^(NSMutableArray *queue, NSMutableDictionary *message) {
        [Mailer sendMessageTo:[message valueForKey:@"toEmail"]
                         from:[message valueForKey:@"fromEmail"]
                  withSubject:[message valueForKey:@"subject"]
                     withBody:[message valueForKey:@"body"]
        withCompletionHandler:completionHandler];
        [queue removeObject:message];
        NSLog([message valueForKey:@"subject"]);
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stopMinimumBackgroundFetchInterval" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"emailQueueSent" object:nil];
}

@end;