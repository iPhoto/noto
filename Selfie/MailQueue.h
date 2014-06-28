//
//  MailQueue.h
//  Selfie
//
//  Created by Daniel Suo on 6/17/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MailQueue : NSObject
+ (void)enqueueMailTo:(NSString *)toEmail
                 from:(NSString *)fromEmail
          withSubject:(NSString *)subject
             withBody:(NSString *)body;

+ (NSUInteger)count;
+ (void)pollMailQueue;
+ (void)pollMailQueueWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;
@end