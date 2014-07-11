//
//  Utilities.h
//  Selfie
//
//  Created by Daniel Suo on 6/15/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import <Foundation/Foundation.h>

// Default notification center
#define Radio [NSNotificationCenter defaultCenter]

// Color palette
#define primaryColor [UIColor colorWithRed:75.0 / 255.0 green:139.0 / 255.0 blue:204.0 / 255.0 alpha:1.0]
#define secondaryColor [UIColor colorWithRed:231.0 / 255.0 green:94.0 / 255.0 blue:82.0 / 255.0 alpha:1.0]
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

// Note default copy
static NSString * const kEmptyNoteSubject = @"New Note";
static NSString * const kNoSubject = @"[No subject]";

// Status bar default copy
static NSString * const kStatusNoConnection = @"No connection! Notes will be saved.";

// User data
static NSString * const kSettingsNoteQueueKey = @"noteQueue";
static NSString * const kSettingsSwipeLeftToEmailKey = @"swipeLeftTo";
static NSString * const kSettingsSwipeRightToEmailKey = @"swipeRightTo";
static NSString * const kSettingsSubjectPrefixKey = @"subjectPrefix";
static NSString * const kSettingsSignatureKey = @"signature";

// Ribbon layout constants
static NSInteger const kNoteRibbonViewHeight = 40;
static NSInteger const kNoteRibbonImageBorder = 1;
static NSInteger const kNoteRibbonImageBorderSpacing = 2 * kNoteRibbonImageBorder;
static NSInteger const kNoteRibbonImageHeight = kNoteRibbonViewHeight - 2 * kNoteRibbonImageBorderSpacing;
static NSInteger const kNoteRibbonTextOffset = kNoteRibbonImageBorderSpacing / 2 + kNoteRibbonImageHeight;

static NSInteger const kNoteRibbonViewWidth = 1000;
static NSInteger const kSwipeThreshold = 120;

// Status bar layout constants
static NSInteger const kStatusViewWidth = kNoteRibbonViewWidth;
static NSInteger const kStatusViewHeight = kNoteRibbonViewHeight;

// Notification names
static NSString * const kEmptyNoteNotification = @"emptyNoteNotification";
static NSString * const kEmptySubjectNotification = @"emptySubjectNotification";
static NSString * const kUpdateSubjectNotification = @"updateSubjectNotification";
static NSString * const kNoteSendSuccessNotification = @"noteSendSuccessNotification";
static NSString * const kNoteSendFailNotification = @"noteSendFailNotification";

@interface Utilities : NSObject
+ (NSString *) appName;
+ (void) setSettingsValue:(NSString *) value forKey:(NSString *) key;
+ (NSString *) getSettingsValue:(NSString *) key;
+ (void) setSettingsObject:(NSObject *) object forKey:(NSString *) key;
+ (NSObject *) getSettingsObject:(NSString *) key;

+ (void) loopThroughQueueAndSave:(void(^)(NSMutableArray*, NSDictionary*)) predicate;

+ (void) initDB;
+ (void) clearDB;

+ (BOOL) isValidEmailString:(NSString *) candidate;
+ (BOOL) isValidEmailAddressWithDirection:(SwipeDirection) direction;

+ (BOOL) isEmptyString:(NSString *) string;

+ (BOOL) isFirstLaunch;
+ (void) setDefaultSettings;

+ (NSString *) getEmailWithDirection:(SwipeDirection) direction;
+ (NSString *) getNoteSubject:(NSString *) text;
@end;