//
//  Utilities.m
//  Selfie
//
//  Created by Daniel Suo on 6/15/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities
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

+ (void)loopThroughQueueAndSave:(void(^)(NSMutableArray *, Note *))predicate {
    NSArray *queue = (NSArray *) [Utilities getSettingsObject:@"emailQueue"];
    NSMutableArray *mutableQueue = [queue mutableCopy];
    
    for (int i = 0; i < [queue count]; i++) {
        Note *note = (Note *) [queue objectAtIndex: i];
        predicate(mutableQueue, note);
    }
    
    [Utilities setSettingsObject:mutableQueue forKey:@"emailQueue"];
}

+ (void) initDB {
    // Set up NSUserDefaults
    NSArray *queue = (NSArray *)[Utilities getSettingsObject:@"emailQueue"];
    if (!queue) {
        queue = [[NSArray alloc] init];
    }
    [Utilities setSettingsObject:queue forKey:@"emailQueue"];
    
    NSString *nextID = (NSString *)[Utilities getSettingsValue:@"nextID"];
    if (!nextID) {
        nextID = [NSString stringWithFormat:@"%d", 1];
    }
    [Utilities setSettingsValue:nextID forKey:@"nextID"];
}

+ (void) clearDB {
    // Set up NSUserDefaults
    NSArray *queue = (NSArray *)[Utilities getSettingsObject:@"emailQueue"];
    queue = [[NSArray alloc] init];
    [Utilities setSettingsObject:queue forKey:@"emailQueue"];
    
    NSString *nextID = (NSString *)[Utilities getSettingsValue:@"nextID"];
    nextID = [NSString stringWithFormat:@"%d", 1];
    [Utilities setSettingsValue:nextID forKey:@"nextID"];
}

+ (BOOL) isEmptyString:(NSString *) string {
    return string == nil || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""];
}

+ (BOOL)isFirstLaunch {
    if(![Utilities getSettingsValue:kHasLaunchedBeforeKey]) {
        return YES;
    }
    return NO;
}
@end;

