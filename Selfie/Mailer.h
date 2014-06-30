//
//  Mailer.h
//  Selfie
//
//  Created by Daniel Suo on 6/15/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "sendgrid.h"
#import "MailQueue.h"
#import "Utilities.h"
#import <AudioToolbox/AudioToolbox.h>

@interface Mailer : NSObject
+ (void)sendMessageTo:(NSString *)toEmail
                 from:(NSString *)fromEmail
          withSubject:(NSString *)subject
             withBody:(NSString *)body;

+ (void)sendMessageTo:(NSString *)toEmail
                 from:(NSString *)fromEmail
          withSubject:(NSString *)subject
             withBody:(NSString *)body
withCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

+ (void)onComplete;
@end