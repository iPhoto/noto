//
//  Mail.h
//  Selfie
//
//  Created by Daniel Suo on 6/30/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

#import "sendgrid.h"
#import "Queue.h"
#import "Utilities.h"

@interface Note : NSObject
@property (strong, nonatomic) NSString *toEmail;
@property (strong, nonatomic) NSString *fromEmail;
@property (strong, nonatomic) NSString *subject;
@property (strong, nonatomic) NSString *body;

- (instancetype)initWithToEmail:(NSString *)toEmail
                      fromEmail:(NSString *)fromEmail
                        subject:(NSString *)subject
                           body:(NSString *)body;

- (instancetype)initWithString:(NSString *)string
                     direction:(NSUInteger) direction;

- (void)send;
- (void)sendWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;
@end
