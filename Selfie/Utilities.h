//
//  Utilities.h
//  Selfie
//
//  Created by Daniel Suo on 6/15/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Note.h"
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
@end;