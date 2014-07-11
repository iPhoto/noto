//
//  Utilities.m
//  Selfie
//
//  Created by Daniel Suo on 6/15/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

+ (NSString *) appName {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}

// Convenience methods to help get / set values / objects
// in NSUserDefaults

+ (void) setSettingsValue:(NSString *) value forKey:(NSString *) key {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:value forKey:key];
        [defaults synchronize];
    };

+ (NSString *) getSettingsValue:(NSString *) key {
        return [[NSUserDefaults standardUserDefaults] valueForKey:key];
    };

+ (void) setSettingsObject:(NSObject *) object forKey:(NSString *) key {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:object forKey:key];
        [defaults synchronize];
    };

+ (NSObject *) getSettingsObject:(NSString *) key {
        return [[NSUserDefaults standardUserDefaults] objectForKey:key];
    };

+ (void) loopThroughQueueAndSave:(void(^)(NSMutableArray *, NSDictionary *)) predicate {
    NSArray *queue = (NSArray *) [Utilities getSettingsObject:kSettingsNoteQueueKey];
    NSMutableArray *mutableQueue = [queue mutableCopy];
    
    for (int i = 0; i < [queue count]; i++) {
        predicate(mutableQueue, (NSDictionary *)[queue objectAtIndex: i]);
    }
    
    [Utilities setSettingsObject:mutableQueue forKey:kSettingsNoteQueueKey];
}

+ (void) initDB {
    // Set up NSUserDefaults
    NSArray *queue = (NSArray *)[Utilities getSettingsObject:kSettingsNoteQueueKey];
    if (!queue) {
        queue = [[NSArray alloc] init];
    }
    [Utilities setSettingsObject:queue forKey:kSettingsNoteQueueKey];
}

+ (void) clearDB {
    // Set up NSUserDefaults
    NSArray *queue = (NSArray *)[Utilities getSettingsObject:kSettingsNoteQueueKey];
    queue = [[NSArray alloc] init];
    [Utilities setSettingsObject:queue forKey:kSettingsNoteQueueKey];
}

+ (BOOL) isEmptyString:(NSString *) string {
    return string == nil || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""];
}

+ (BOOL) isValidEmail:(NSString *) candidate {
    NSString *emailRegex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

+ (BOOL) isFirstLaunch {
    if(![Utilities getSettingsValue:kHasLaunchedBeforeKey]) {
        return YES;
    }
    return NO;
}

+ (void) setDefaultSettings {
    [Utilities setSettingsValue:[NSString stringWithFormat:@"[%@]", [Utilities appName]] forKey:kSettingsSubjectPrefixKey];
    [Utilities setSettingsValue:[NSString stringWithFormat:@"Sent with %@", [Utilities appName]] forKey:kSettingsSignatureKey];
}

+ (NSString *) getEmailWithDirection:(SwipeDirection) direction {
    if (direction == SwipeDirectionLeft) {
        return [Utilities getSettingsValue:kSettingsSwipeLeftToEmailKey];
    } else if (direction == SwipeDirectionRight) {
        return [Utilities getSettingsValue:kSettingsSwipeRightToEmailKey];
    } else {
        return nil;
    }
}

+ (NSString *) getNoteSubject:(NSString *) text {
    return [text componentsSeparatedByString:@"\n"][0];
}

@end;

