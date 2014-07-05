//
//  Queue.h
//  Selfie
//
//  Created by Daniel Suo on 6/17/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Note.h"
#import "Utilities.h"

@class Note;

@interface Queue : NSObject
+ (void)enqueue:(Note *)note;

+ (NSUInteger)count;
+ (void)pollQueue;
+ (void)pollQueueWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;
@end