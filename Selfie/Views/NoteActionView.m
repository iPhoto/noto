//
//  NoteActionView.m
//  Selfie
//
//  Created by Daniel Suo on 7/7/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import "NoteActionView.h"

@implementation NoteActionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textView = [[UITextView alloc] init];
        self.textView.editable = NO;
        self.textView.backgroundColor = [UIColor greenColor];
        [self addSubview:self.textView];
        
        self.imageView = [[UIImageView alloc] init];
        [self addSubview:self.imageView];
    }
    return self;
}

- (NSString *)getActionText:(NSString *)noteText {
    NSMutableString *actionText = [[NSMutableString alloc] initWithString:@""];
    NSString *emailAddress;
    
    if (self.direction == UISwipeGestureRecognizerDirectionLeft) {
        emailAddress = [Utilities getSettingsValue:@"swipeLeftTo"];
    } else if (self.direction == UISwipeGestureRecognizerDirectionRight) {
        emailAddress = [Utilities getSettingsValue:@"swipeRightTo"];
    }
    
    // TODO: Refactor into state class
    if ([Utilities isEmptyString:emailAddress]) {
        [actionText appendString:@"No email address!"];
    } else if (![Utilities isValidEmail:emailAddress]) {
        [actionText appendString:@"Invalid email address!"];
    } else {
        [actionText appendString:emailAddress];
    }
    
    [actionText appendString:@"\n"];
    
    // TODO: Refactor into state class
    if ([Utilities isEmptyString:noteText]) {
        [actionText appendString:@"No Note! "];
    }
    
    // TODO: Refactor into state class
    if (![ReachabilityManager isReachable]) {
        [actionText appendString:@"No connection!"];
    }
    
    return actionText;
}

@end
