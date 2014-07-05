//
//  Utilities.h
//  Selfie
//
//  Created by Daniel Suo on 6/15/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Note.h"

static NSString * const kHasLaunchedBeforeKey = @"selfieHasLaunchedBefore";
static NSString * const SGUsername = @"danielsuo";
static NSString * const SGPassword = @"TheLAC41988";
static NSString * const CrashlyticsAPIKey = @"7052c7c0dfa3dc8a01de1c9fadf87a6abec3d33a";

@class Note;

@interface Utilities : NSObject
+ (void) setSettingsValue:(NSString *) value forKey:(NSString *) key;
+ (NSString *) getSettingsValue:(NSString *) key;
+ (void) setSettingsObject:(NSObject *) object forKey:(NSString *) key;
+ (NSObject *) getSettingsObject:(NSString *) key;

+ (void)loopThroughQueueAndSave:(void(^)(NSMutableArray*, Note*))predicate;

+ (void)initDB;
+ (void)clearDB;

+ (BOOL) isEmptyString:(NSString *) string;
+ (void) setDefaultSettings;
+ (BOOL)isFirstLaunch;
@end;