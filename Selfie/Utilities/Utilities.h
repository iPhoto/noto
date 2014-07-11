//
//  Utilities.h
//  Selfie
//
//  Created by Daniel Suo on 6/15/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Note.h"

// Default notification center
#define Radio [NSNotificationCenter defaultCenter]

// Color palette
#define primaryColor [UIColor colorWithRed:41.0 / 255.0 green:128.0 / 255.0 blue:185.0 / 255.0 alpha:1.0]
#define secondaryColor [UIColor colorWithRed:231.0 / 255.0 green:76.0 / 255.0 blue:60.0 / 255.0 alpha:1.0]
#define tertiaryColor [UIColor colorWithRed:127.0 / 255.0 green:140.0 / 255.0 blue:141.0 / 255.0 alpha:1.0]

// Typography
static NSUInteger const kGlobalFontSize = 18;

// Swipe directions
typedef enum {
    SwipeDirectionLeft = 1,
    SwipeDirectionRight = 2
} SwipeDirection;

// API Keys and passwords
static NSString * const kHasLaunchedBeforeKey = @"selfieHasLaunchedBefore";
static NSString * const SGUsername = @"danielsuo";
static NSString * const SGPassword = @"TheLAC41988";
static NSString * const CrashlyticsAPIKey = @"7052c7c0dfa3dc8a01de1c9fadf87a6abec3d33a";

// Note defaults
static NSString * const kEmptyNoteSubject = @"New Note";
static NSString * const kNoSubject = @"[No subject]";

// User data
static NSString * const kEmailQueueKey = @"emailQueue";
static NSString * const kSwipeLeftToEmailKey = @"swipeLeftTo";
static NSString * const kSwipeRightToEmailKey = @"swipeRightTo";
static NSString * const kSubjectPrefixKey = @"subjectPrefix";
static NSString * const kSignatureKey = @"signature";

// Ribbon layout constants
static NSInteger const kNoteRibbonViewHeight = 40;
static NSInteger const kNoteRibbonImageBorder = 3;
static NSInteger const kNoteRibbonImageHeight = 40 - 2 * kNoteRibbonImageBorder;

static NSInteger const kNoteRibbonViewWidth = 1000;
static NSInteger const kSwipeThreshold = 120;

// Notification names
static NSString * const kEmptyNoteNotification = @"emptyNoteNotification";
static NSString * const kEmptySubjectNotification = @"emptySubjectNotification";
static NSString * const kUpdateSubjectNotification = @"updateSubjectNotification";

@interface Utilities : NSObject
+ (NSString *) appName;
+ (void) setSettingsValue:(NSString *) value forKey:(NSString *) key;
+ (NSString *) getSettingsValue:(NSString *) key;
+ (void) setSettingsObject:(NSObject *) object forKey:(NSString *) key;
+ (NSObject *) getSettingsObject:(NSString *) key;

+ (void) loopThroughQueueAndSave:(void(^)(NSMutableArray*, NSDictionary*)) predicate;

+ (void) initDB;
+ (void) clearDB;

+ (BOOL) isValidEmail:(NSString *) candidate;
+ (BOOL) isEmptyString:(NSString *) string;

+ (BOOL) isFirstLaunch;
+ (void) setDefaultSettings;

+ (NSString *) getEmailWithDirection:(SwipeDirection) direction;
+ (NSString *) getNoteSubject:(NSString *) text;
@end;