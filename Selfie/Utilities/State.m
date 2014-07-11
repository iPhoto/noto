//
//  ReachabilityManager.m
//  Selfie
//
//  Created by Daniel Suo on 7/8/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import "State.h"

@implementation State

#pragma mark -
#pragma mark Default Manager
+ (State *)state {
    static State *_state = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _state = [[self alloc] init];
    });
    
    return _state;
}

#pragma mark -
#pragma mark Memory Management
- (void)dealloc {
    // Stop Notifier
    if (_reachability) {
        [_reachability stopNotifier];
    }
}

#pragma mark -
#pragma mark Class Methods
+ (BOOL)isReachable {
    return [[[State state] reachability] isReachable];
}

+ (BOOL)isUnreachable {
    return ![[[State state] reachability] isReachable];
}

+ (BOOL)isReachableViaWWAN {
    return [[[State state] reachability] isReachableViaWWAN];
}

+ (BOOL)isReachableViaWiFi {
    return [[[State state] reachability] isReachableViaWiFi];
}

+ (void)setReachableBlock:(void(^)(Reachability *))reachableBlock {
    [[[State state] reachability] setReachableBlock:reachableBlock];
}

+ (void)setUnreachableBlock:(void(^)(Reachability *))unreachableBlock {
    [[[State state] reachability] setUnreachableBlock:unreachableBlock];
}

#pragma mark -
#pragma mark Private Initialization
- (id)init {
    self = [super init];
    
    if (self) {
        // Initialize Reachability
        self.reachability = [Reachability reachabilityWithHostname:@"www.google.com"];
        
        // Start Monitoring
        [self.reachability startNotifier];
    }
    
    return self;
}

@end