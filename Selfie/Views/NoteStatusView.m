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
        
        self.hidden = YES;
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
    [self showWithDelay:0];
}

- (void) showWithDelay:(NSTimeInterval) delay {
    self.hidden = NO;
    [UIView animateWithDuration:2.0 delay:delay usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.alpha = 0.8;
    } completion:^(BOOL finished){
        
    }];
}

- (void) hide {
    [self hideWithDelay:0];
}

- (void) hideWithDelay:(NSTimeInterval) delay {
    [UIView animateWithDuration:2.0 delay:delay usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished){
        if (finished) {
            self.hidden = YES;
            self.text = @"";
        }
    }];
}

@end
