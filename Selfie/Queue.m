//
//  Queue.m
//  Selfie
//
//  Created by Daniel Suo on 6/17/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import "Queue.h"

@interface Queue ()
@end;

@implementation Queue

+ (void)enqueue:(Note *) note {
    
    NSMutableArray *queue = [[Utilities getSettingsObject:@"emailQueue"] mutableCopy];
    [queue addObject:note];
    [Utilities setSettingsObject:queue forKey:@"emailQueue"];
}

+ (NSUInteger)count {
    return [(NSArray *)[Utilities getSettingsObject:@"emailQueue"] count];
}

+ (void)pollQueue {
    [Queue pollQueueWithCompletionHandler:nil];
}

+ (void)pollQueueWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"emailQueueFull" object:nil];
    [Utilities loopThroughQueueAndSave:^(NSMutableArray *queue, Note *note) {
        [note sendWithCompletionHandler:completionHandler];
        [queue removeObject:note];
        NSLog(note.subject);
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stopMinimumBackgroundFetchInterval" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"emailQueueSent" object:nil];
}

@end;