//
//  NoteProgressView.m
//  Selfie
//
//  Created by Daniel Suo on 7/13/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import "NoteProgressView.h"

@implementation NoteProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.progressTintColor = primaryColor;
        self.hidden = YES;
    }
    return self;
}

- (void) updateFrameToKeyboard:(CGRect) keyboardRect {
    CGFloat positionHeight = self.superview.frame.size.height -
    keyboardRect.size.height - 2;
    
    self.frame = CGRectMake((keyboardRect.size.width - kStatusViewWidth) / 2, positionHeight, keyboardRect.size.width, 10);
}

- (void) send {
    self.hidden = NO;
    self.progress = 1.0;
    self.alpha = 1.0;
    
    self.frame = CGRectMake(-self.frame.size.width, self.frame.origin.y, self.frame.size.width, 10);
    
    CGRect newFrame = self.frame;
    newFrame.origin.x = 0;
    
    [UIView setAnimationsEnabled:YES];
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.frame = newFrame;
    } completion:^(BOOL finished){
        if (finished) {
            [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.alpha = 0.0;
            } completion:^(BOOL finished) {
                if (finished) {
                    self.hidden = YES;
                }
            }];
        }
    }];
}

- (void) show {
    [self showWithDelay:0];
}

- (void) showWithDelay:(NSTimeInterval) delay {
    self.hidden = NO;
    [UIView animateWithDuration:2.0 delay:delay usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.alpha = 1.0;
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
            self.progress = 0;
        }
    }];
}

@end
