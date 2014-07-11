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
    NSLog(@"Queued: %@", note.subject);
    NSMutableArray *queue = [[Utilities getSettingsObject:kSettingsNoteQueueKey] mutableCopy];
    [queue addObject:[note toDictionary]];
    [Utilities setSettingsObject:queue forKey:kSettingsNoteQueueKey];
}

+ (NSUInteger)count {
    return [(NSArray *)[Utilities getSettingsObject:kSettingsNoteQueueKey] count];
}

+ (void)pollQueue {
    [Queue pollQueueWithCompletionHandler:nil];
}

// TODO: refactor notifications
+ (void)pollQueueWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"emailQueueFull" object:nil];
    [Utilities loopThroughQueueAndSave:^(NSMutableArray *queue, NSDictionary *dict) {
        NSLog(@"Queued: %@", [dict valueForKey:@"subject"]);
        [[[Note alloc] initFromDictionary:dict] sendWithCompletionHandler:completionHandler];
        [queue removeObject:dict];
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stopMinimumBackgroundFetchInterval" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"emailQueueSent" object:nil];
}

@end;