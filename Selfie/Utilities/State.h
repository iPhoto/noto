//
//  ReachabilityManager.h
//  Selfie
//
//  Created by Daniel Suo on 7/8/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "Note.h"
#import "Utilities.h"

@class Reachability;

@interface State : NSObject
@property (strong, nonatomic) Reachability *reachability;
@property (strong, nonatomic) NSString *noteTitle;
@property (nonatomic) BOOL isValidSendLeft;
@property (nonatomic) BOOL isValidSendRight;

#pragma mark -
#pragma mark State
+ (State *) state;

#pragma mark -
#pragma mark Reachability blocks
+ (void) setReachableBlock:(void(^)(Reachability *)) reachableBlock;
+ (void) setUnreachableBlock:(void(^)(Reachability *)) unreachableBlock;

#pragma mark -
#pragma mark Class Methods
+ (BOOL) isReachable;
+ (BOOL) isUnreachable;
+ (BOOL) isReachableViaWWAN;
+ (BOOL) isReachableViaWiFi;

+ (BOOL) isValidSend:(NSString *) text withDirection:(SwipeDirection) direction withAttachment:(NSObject *) attachment;

+ (NSString *) getRibbonText:(NSString *) noteText withDirection:(SwipeDirection) direction withAttachment:(NSObject *) attachment;
+ (UIImage *) getRibbonImage:(NSString *) noteText withDirection:(SwipeDirection) direction withAttachment:(NSObject *) attachment;
@end
