//
//  Utilities.h
//  Selfie
//
//  Created by Daniel Suo on 6/15/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

// Debug helpers
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

// Default notification center
#define Radio [NSNotificationCenter defaultCenter]

// Color palette
#define primaryColor [UIColor colorWithRed:75.0 / 255.0 green:139.0 / 255.0 blue:204.0 / 255.0 alpha:1.0]
#define secondaryColor [UIColor colorWithRed:231.0 / 255.0 green:94.0 / 255.0 blue:82.0 / 255.0 alpha:1.0]
#define tertiaryColor [UIColor colorWithRed:170 / 255.0 green:187 / 255.0 blue:205 / 255.0 alpha:1.0]
#define tertiaryColorLight [UIColor colorWithRed:238 / 255.0 green:238 / 255.0 blue:238 / 255.0 alpha:1.0]

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
static NSString * const firebaseBaseURL = @"https://thelac-selfie.firebaseio.com";

// Note default copy
static NSString * const kEmptyNoteSubject = @"New Note";
static NSString * const kNoNoteSubject = @"[No Subject]";
static NSInteger const kMaxSubjectLength = 78;

// Status bar default copy
static NSString * const kStatusNoConnection = @"No connection! Noto will resend.";
static NSString * const kStatusSendingNote = @"Sending note!";
static NSString * const kStatusProgress = @"AFHTTPRequestProgress";

// User data
static NSString * const kSettingsSwipeLeftToEmailKey = @"swipeLeftTo";
static NSString * const kSettingsSwipeRightToEmailKey = @"swipeRightTo";
static NSString * const kSettingsSubjectPrefixKey = @"subjectPrefix";
static NSString * const kSettingsSignatureKey = @"signature";
static NSString * const kSettingsUserName = @"username";

// Queue data
static NSString * const kQueueKey = @"noteQueue";
static NSString * const kQueueNoteDictionaryToEmail = @"toEmail";
static NSString * const kQueueNoteDictionaryFromEmail = @"fromEmail";
static NSString * const kQueueNoteDictionarySubject = @"subject";
static NSString * const kQueueNoteDictionaryBody = @"body";
static NSString * const kQueueNoteDictionaryImagePath = @"imagePath";

// Ribbon layout constants
static NSInteger const kNoteRibbonViewHeight = 40;
static NSInteger const kNoteRibbonImageBorder = 1;
static NSInteger const kNoteRibbonImageBorderSpacing = 2 * kNoteRibbonImageBorder;
static NSInteger const kNoteRibbonImageHeight = kNoteRibbonViewHeight - 2 * kNoteRibbonImageBorderSpacing;
static NSInteger const kNoteRibbonTextOffset = kNoteRibbonImageBorderSpacing / 2 + kNoteRibbonImageHeight;

static NSInteger const kNoteRibbonViewWidth = 1000;
static NSInteger const kSwipeThreshold = 120;

// Attachment view layout constants
static NSInteger const kNoteAttachmentCollectionViewBorder = 5;
static NSInteger const kNoteAttachmentCollectionViewHeight = 80;
static NSInteger const kNoteAttachmentCollectionViewCellDim = kNoteAttachmentCollectionViewHeight - 2 * kNoteAttachmentCollectionViewBorder;
//static NSInteger const kNoteAttachmentNumRows = 1;
//static NSInteger const kNoteAttachmentNumCols = 5;

// Status bar layout constants
static NSInteger const kStatusViewWidth = kNoteRibbonViewWidth;
static NSInteger const kStatusViewHeight = kNoteRibbonViewHeight;

// Icon layout constants
static NSInteger const kIconDim = 30;
static NSInteger const kIconSpacing = 10;

// Notification names
static NSString * const kEmptyNoteNotification = @"emptyNoteNotification";
static NSString * const kUpdateSubjectNotification = @"updateSubjectNotification";
static NSString * const kNoteSendSuccessNotification = @"noteSendSuccessNotification";
static NSString * const kNoteSendFailNotification = @"noteSendFailNotification";
static NSString * const kEnumerateGroupCompleteNotification = @"enumerateGroupCompletionNotification";
static NSString * const kRibbonChangeInBackGroundNotification = @"ribbontChangeInBackGroundNotification";

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
+ (NSString *) trimWhiteSpace:(NSString *) string;

+ (BOOL) isFirstLaunch;
+ (void) setDefaultSettings;
+ (NSString *) getFirstLaunchText;

+ (NSString *) getEmailWithDirection:(SwipeDirection) direction;

+ (UIImage *) compressImageWithImage:(UIImage *) image;

+ (ALAssetsLibrary *) defaultAssetsLibrary;
@end;