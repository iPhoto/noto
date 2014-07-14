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
    NSArray *queue = (NSArray *) [Utilities getSettingsObject:kQueueKey];
    NSMutableArray *mutableQueue = [queue mutableCopy];
    
    for (int i = 0; i < [queue count]; i++) {
        predicate(mutableQueue, (NSDictionary *)[queue objectAtIndex: i]);
    }
    
    [Utilities setSettingsObject:mutableQueue forKey:kQueueKey];
}

+ (void) initDB {
    // Set up NSUserDefaults
    NSArray *queue = (NSArray *)[Utilities getSettingsObject:kQueueKey];
    if (!queue) {
        queue = [[NSArray alloc] init];
    }
    [Utilities setSettingsObject:queue forKey:kQueueKey];
}

+ (void) clearDB {
    // Set up NSUserDefaults
    NSArray *queue = (NSArray *)[Utilities getSettingsObject:kQueueKey];
    queue = [[NSArray alloc] init];
    [Utilities setSettingsObject:queue forKey:kQueueKey];
}

+ (BOOL) isEmptyString:(NSString *) string {
    return string == nil || [[Utilities trimWhiteSpace:string] isEqualToString:@""];
}

+ (NSString *) trimWhiteSpace:(NSString *) string {
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (BOOL) isValidEmailString:(NSString *) candidate {
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

+ (BOOL) isValidEmailAddressWithDirection:(SwipeDirection) direction {
    return [Utilities isValidEmailString:[Utilities getEmailWithDirection:direction]];
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

+ (NSString *) getFirstLaunchText {
    return [@[[NSString stringWithFormat:@"Welcome to %@!\n\n", [Utilities appName]],
              @"First, tap the gear icon to set your email addresses. ",
              @"Then, swipe in the corresponding direction to email yourself notes.\n",
              @"\n",
              @"(｡･ω･｡)ﾉ♡\n",
              [NSString stringWithFormat:@"The %@ Team", [Utilities appName]]]
            componentsJoinedByString:@""];
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

+ (UIImage*) compareeImageWithImage:(UIImage*) image {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat longSideScreen = MAX(screenRect.size.width, screenRect.size.height);
    CGFloat shortSideScreen = MIN(screenRect.size.width, screenRect.size.height);
    
    CGFloat longSideImage = MAX(image.size.width, image.size.height);
    CGFloat shortSideImage = MIN(image.size.width, image.size.height);
    
    CGFloat scale = MIN(1, MIN(longSideScreen / longSideImage, shortSideScreen / shortSideImage));
    
    CGFloat newWidth = image.size.width * scale;
    CGFloat newHeight = image.size.height * scale;
    
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    UIGraphicsBeginImageContextWithOptions(newSize, YES, 0.0);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end;

