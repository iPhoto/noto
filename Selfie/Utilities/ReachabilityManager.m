//
//  ReachabilityManager.m
//  Selfie
//
//  Created by Daniel Suo on 7/8/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import "ReachabilityManager.h"

@implementation ReachabilityManager

#pragma mark -
#pragma mark Default Manager
+ (ReachabilityManager *)reachabilityManager {
    static ReachabilityManager *_reachabilityManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _reachabilityManager = [[self alloc] init];
    });
    
    return _reachabilityManager;
}

//WithReachableBlock:(void(^)(Reachability *))reachableBlock UnreachableBlock:(void(^)(Reachability *))unreachableBlock

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
    return [[[ReachabilityManager reachabilityManager] reachability] isReachable];
}

+ (BOOL)isUnreachable {
    return ![[[ReachabilityManager reachabilityManager] reachability] isReachable];
}

+ (BOOL)isReachableViaWWAN {
    return [[[ReachabilityManager reachabilityManager] reachability] isReachableViaWWAN];
}

+ (BOOL)isReachableViaWiFi {
    return [[[ReachabilityManager reachabilityManager] reachability] isReachableViaWiFi];
}

+ (void)setReachableBlock:(void(^)(Reachability *))reachableBlock {
    [[[ReachabilityManager reachabilityManager] reachability] setReachableBlock:reachableBlock];
}

+ (void)setUnreachableBlock:(void(^)(Reachability *))unreachableBlock {
    [[[ReachabilityManager reachabilityManager] reachability] setUnreachableBlock:unreachableBlock];
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