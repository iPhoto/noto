//
//  Mailer.m
//  Selfie
//
//  Created by Daniel Suo on 6/15/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import "Mailer.h"
#import "Mailgun.h"
#import "Utilities.h"

@interface Mailer ()
@end;

@implementation Mailer

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
    [Utilities loopThroughMailQueueAndSave:^(NSMutableArray *queue, NSDictionary *message) {
        [Mailgun sendMessageTo:[message valueForKey:@"toEmail"]
                          from:[message valueForKey:@"fromEmail"]
                   withSubject:[message valueForKey:@"subject"]
                      withBody:[message valueForKey:@"body"]
                        withID:[message valueForKey:@"id"]];
        NSLog(@"polling");
        NSLog([message valueForKey:@"subject"]);
    }];
}

+ (void)pollMailQueueWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [Utilities loopThroughMailQueueAndSave:^(NSMutableArray *queue, NSDictionary *message) {
        [Mailgun sendMessageTo:[message valueForKey:@"toEmail"]
                          from:[message valueForKey:@"fromEmail"]
                   withSubject:[message valueForKey:@"subject"]
                      withBody:[message valueForKey:@"body"]
                        withID:[message valueForKey:@"id"]
         withCompletionHandler:completionHandler];
        NSLog(@"pollingWithCompletionHandler");
        NSLog([message valueForKey:@"subject"]);
    }];
}

@end;