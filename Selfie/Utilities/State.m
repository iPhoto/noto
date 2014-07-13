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
+ (State *) state {
    static State *_state = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _state = [[self alloc] init];
    });
    
    return _state;
}

#pragma mark -
#pragma mark Memory Management
- (void) dealloc {
    // Stop Notifier
    if (_reachability) {
        [_reachability stopNotifier];
    }
}

#pragma mark -
#pragma mark Class Methods
+ (BOOL) isReachable {
    return [[[State state] reachability] isReachable];
}

+ (BOOL) isUnreachable {
    return ![[[State state] reachability] isReachable];
}

+ (BOOL) isReachableViaWWAN {
    return [[[State state] reachability] isReachableViaWWAN];
}

+ (BOOL) isReachableViaWiFi {
    return [[[State state] reachability] isReachableViaWiFi];
}

+ (void) setReachableBlock:(void(^)(Reachability *)) reachableBlock {
    [[[State state] reachability] setReachableBlock:reachableBlock];
}

+ (void) setUnreachableBlock:(void(^)(Reachability *)) unreachableBlock {
    [[[State state] reachability] setUnreachableBlock:unreachableBlock];
}

// TODO: create self.emails and set them on notify

+ (BOOL) isValidSend:(NSString *) text withDirection:(SwipeDirection) direction withAttachment:(NSObject *) attachment {
    return ([Note isValidNote:text] || attachment) && [Utilities isValidEmailAddressWithDirection:direction];
}

// TODO: refactor duplicate ribbontext/image logic with State
// TODO: refactor to be called when status changes
// TODO: add ribbon text/image state getters
+ (NSString *) getRibbonText:(NSString *) noteText
               withDirection:(SwipeDirection) direction
              withAttachment:(NSObject *) attachment {
    NSString *emailAddress = [Utilities getEmailWithDirection:direction];
    NSString *ribbonText;
    
    // TODO: Refactor into state class
    if ([Utilities isEmptyString:noteText] && attachment == NULL) {
        ribbonText = @"No note!";
    } else if ([Utilities isEmptyString:emailAddress]) {
        ribbonText = @"No email address!";
    } else if (![Utilities isValidEmailString:emailAddress]) {
        ribbonText = @"Invalid address!";
    } else {
        ribbonText = emailAddress;
    }
    
    return ribbonText;
}

+ (UIImage *) getRibbonImage:(NSString *) noteText
               withDirection:(SwipeDirection) direction
              withAttachment:(NSObject *) attachment {
    NSString *emailAddress = [Utilities getEmailWithDirection:direction];
    UIImage *ribbonImage;
    
    // TODO: what if attachment isn't image?
    if (attachment) {
        ribbonImage = (UIImage *) attachment;
    } else if ([Utilities isEmptyString:noteText] ||
        [Utilities isEmptyString:emailAddress] ||
        ![Utilities isValidEmailString:emailAddress]) {
        ribbonImage = [UIImage imageNamed: @"icon_warning"];
    } else {
        ribbonImage = [UIImage imageNamed: @"icon_message"];
    }
    
    return ribbonImage;
}

#pragma mark -
#pragma mark Private Initialization
- (id) init {
    self = [super init];
    
    if (self) {
        // Initialize Reachability
        self.reachability = [Reachability reachabilityWithHostname:@"www.google.com"];
        
        // Start Monitoring
        [self.reachability startNotifier];
        
        // Listen for empty note
        [Radio addObserverForName:kEmptyNoteNotification object:nil queue:nil usingBlock:^(NSNotification *notification) {
            self.noteTitle = kEmptyNoteSubject;
        }];
    }
    
    return self;
}

@end