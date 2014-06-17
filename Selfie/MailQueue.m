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
    int nextID = [(NSString *)[Utilities getSettingsValue:@"nextID"] intValue];
    
    NSArray *keys = [NSArray arrayWithObjects: @"id", @"toEmail", @"fromEmail", @"subject", @"body", nil];
    NSArray *values = [NSArray arrayWithObjects: [NSString stringWithFormat:@"%d", nextID++], toEmail, fromEmail, subject, body, nil];
    [queue addObject:[NSDictionary dictionaryWithObjects:values forKeys:keys]];
    
    [Utilities setSettingsObject:queue forKey:@"emailQueue"];
    [Utilities setSettingsValue:[NSString stringWithFormat:@"%d", nextID] forKey:@"nextID"];
    
    [self pollMailQueue];
}

+ (void)pollMailQueue {
    [MailQueue pollMailQueueWithCompletionHandler:nil];
}

+ (void)pollMailQueueWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"emailQueueFull" object:nil];
    [Utilities loopThroughMailQueueAndSave:^(NSMutableArray *queue, NSMutableDictionary *message, int i) {
        NSString *sending = [queue[i] valueForKey:@"sending"];
        if (sending == nil || [sending isEqualToString:@"NO"]) {
            [Mailer sendMessageTo:[message valueForKey:@"toEmail"]
                              from:[message valueForKey:@"fromEmail"]
                       withSubject:[message valueForKey:@"subject"]
                          withBody:[message valueForKey:@"body"]
                            withID:[message valueForKey:@"id"]
             withCompletionHandler:completionHandler];
            [[(NSDictionary *)queue[i] mutableCopy] setValue:@"YES" forKey:@"sending"];
        }
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"emailQueueSent" object:nil];
}

@end;