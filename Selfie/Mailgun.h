//
//  Mailgun.h
//  Selfie
//
//  Created by Daniel Suo on 6/15/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Mailgun : NSObject
+ (void)sendMessageTo:(NSString *)toEmail
                 from:(NSString *)fromEmail
          withSubject:(NSString *)subject
             withBody:(NSString *)body
               withID:(NSString *)mailID;

+ (void)sendMessageTo:(NSString *)toEmail
                 from:(NSString *)fromEmail
          withSubject:(NSString *)subject
             withBody:(NSString *)body
               withID:(NSString *)mailID
withCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;
@end