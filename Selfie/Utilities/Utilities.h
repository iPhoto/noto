//
//  Utilities.h
//  Selfie
//
//  Created by Daniel Suo on 6/15/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Note.h"

#define primaryColor [UIColor colorWithRed:41.0 / 255.0 green:128.0 / 255.0 blue:185.0 / 255.0 alpha:1.0]
#define secondaryColor [UIColor colorWithRed:231.0 / 255.0 green:76.0 / 255.0 blue:60.0 / 255.0 alpha:1.0]

static NSString * const kHasLaunchedBeforeKey = @"selfieHasLaunchedBefore";
static NSString * const SGUsername = @"danielsuo";
static NSString * const SGPassword = @"TheLAC41988";
static NSString * const CrashlyticsAPIKey = @"7052c7c0dfa3dc8a01de1c9fadf87a6abec3d33a";

static NSUInteger const kNoteActionViewHeight = 40;
static NSUInteger const kNoteActionImageBorder = 3;
static NSUInteger const kNoteActionImageHeight = 40 - 2 * kNoteActionImageBorder;
static NSUInteger const kGlobalFontSize = 18;

static NSUInteger const kSwipeThreshold = 120;

@class Note;

@interface Utilities : NSObject
+ (NSString *)appName;
+ (void) setSettingsValue:(NSString *) value forKey:(NSString *) key;
+ (NSString *) getSettingsValue:(NSString *) key;
+ (void) setSettingsObject:(NSObject *) object forKey:(NSString *) key;
+ (NSObject *) getSettingsObject:(NSString *) key;

+ (void)loopThroughQueueAndSave:(void(^)(NSMutableArray*, NSDictionary*))predicate;

+ (void)initDB;
+ (void)clearDB;

+ (BOOL)isValidEmail: (NSString *) candidate;
+ (BOOL)isEmptyString:(NSString *) string;
+ (void)setDefaultSettings;
+ (BOOL)isFirstLaunch;

@end;