//
//  NoteStatusView.m
//  Selfie
//
//  Created by Daniel Suo on 7/9/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import "NoteStatusView.h"

@implementation NoteStatusView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.editable = NO;
        self.selectable = NO;
        self.backgroundColor = tertiaryColor;
        self.userInteractionEnabled = NO;
        [self setFont:[UIFont systemFontOfSize:kGlobalFontSize]];
        [self setTextColor:[UIColor whiteColor]];
        self.textAlignment = NSTextAlignmentCenter;
        self.textContainerInset = UIEdgeInsetsMake((kStatusViewHeight - kGlobalFontSize)/2 - 2, 0, 0, 0);
    }
    return self;
}

- (void) updateFrameToKeyboard:(CGRect) keyboardRect {
    // TODO: Refactor this duplicate code
    CGFloat ribbonViewHeight = self.superview.frame.size.height -
    keyboardRect.size.height -
    kNoteRibbonViewHeight;
    
    self.frame = CGRectMake((keyboardRect.size.width - kStatusViewWidth) / 2, ribbonViewHeight, kStatusViewWidth, kStatusViewHeight);
}

- (void) show {
    self.hidden = NO;
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0.6;
    } completion:^(BOOL finished){
        
    }];
}

- (void) hide {
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished){
        self.hidden = YES;
    }];
}

@end
