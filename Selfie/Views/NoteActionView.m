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
        self.textView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
        
        [self.textView setFont:[UIFont systemFontOfSize:kGlobalFontSize]];
        [self.textView setTextColor:[UIColor whiteColor]];
        self.textView.textContainerInset = UIEdgeInsetsMake((kNoteActionViewHeight - kGlobalFontSize) / 2, 6, (kNoteActionViewHeight - kGlobalFontSize) / 2, 6);
        
        [self addSubview:self.textView];
        
        self.imageView = [[UIImageView alloc] init];
        [self addSubview:self.imageView];
    }
    return self;
}

- (NSString *)getActionText:(NSString *)noteText {
    NSString *actionText;
    NSString *emailAddress;
    
    if (self.direction == UISwipeGestureRecognizerDirectionLeft) {
        emailAddress = [Utilities getSettingsValue:@"swipeLeftTo"];
    } else if (self.direction == UISwipeGestureRecognizerDirectionRight) {
        emailAddress = [Utilities getSettingsValue:@"swipeRightTo"];
    }
    
    // TODO: Refactor into state class
    if ([Utilities isEmptyString:emailAddress]) {
        actionText = @"No email address!";
    } else if (![Utilities isValidEmail:emailAddress]) {
        actionText = @"Invalid email address!";
    } else if ([Utilities isEmptyString:noteText]) {
        actionText = @"No Note! ";
    } else {
        actionText = emailAddress;
    }

    // TODO: Refactor into state class
//    if (![ReachabilityManager isReachable]) {
//        [actionText appendString:@"No connection!"];
//    }
    
    return actionText;
}

@end
