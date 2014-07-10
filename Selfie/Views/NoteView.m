//
//  NoteView.m
//  Selfie
//
//  Created by Daniel Suo on 7/5/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import "NoteView.h"

@interface NoteView ()

@end

@implementation NoteView

@synthesize noteViewDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFont:[UIFont systemFontOfSize:kGlobalFontSize]];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        pan.delegate = self;
        
        NSArray *gestureRecognizers = [self.gestureRecognizers arrayByAddingObject:pan];
        self.gestureRecognizers = gestureRecognizers;

        // Swipe left
        self.leftNoteActionView = [[NoteActionView alloc] init];
        self.leftNoteActionView.textView.textAlignment = NSTextAlignmentLeft;
        self.leftNoteActionView.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addSubview:self.leftNoteActionView];
        
        self.leftNoteActionViewOriginalCenter = self.leftNoteActionView.center;
        
        // Swipe right
        self.rightNoteActionView = [[NoteActionView alloc] init];
        self.rightNoteActionView.textView.textAlignment = NSTextAlignmentRight;
        self.rightNoteActionView.direction = UISwipeGestureRecognizerDirectionRight;
        [self addSubview:self.rightNoteActionView];
        
        self.rightNoteActionViewOriginalCenter = self.rightNoteActionView.center;
        
        
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)handlePanGesture: (UIPanGestureRecognizer *)gestureRecognizer {
    // TODO: Refactor and delegate to viewcontroller
    NoteView *noteView = (NoteView *)gestureRecognizer.view;
    CGPoint translation = [gestureRecognizer translationInView:noteView];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.leftNoteActionView.textView.text = [self.leftNoteActionView getActionText:noteView.text];
        self.rightNoteActionView.textView.text = [self.rightNoteActionView getActionText:noteView.text];
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        // TODO: make sure send gesture and view gesture are identical; don't want users to be confused
        if (abs(translation.x) > abs(translation.y)) {
            // TODO: Refactor into state class
            if (translation.x > kSwipeThreshold && ![Utilities isEmptyString:self.text] && [Utilities isValidEmail:[Utilities getSettingsValue:@"swipeRightTo"]]) {
                [noteViewDelegate didPanInDirection:UISwipeGestureRecognizerDirectionRight];
            } else if (translation.x < -kSwipeThreshold && ![Utilities isEmptyString:self.text] && [Utilities isValidEmail:[Utilities getSettingsValue:@"swipeLeftTo"]]) {
                [noteViewDelegate didPanInDirection:UISwipeGestureRecognizerDirectionLeft];
            }
        }
        
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.leftNoteActionView.center = self.leftNoteActionViewOriginalCenter;
        } completion:^(BOOL finished){

        }];
        
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.rightNoteActionView.center = self.rightNoteActionViewOriginalCenter;
        } completion:^(BOOL finished){

        }];
    } else {
        
        // TODO: Refactor into state class
        if (![Utilities isEmptyString:self.text] && [Utilities isValidEmail:[Utilities getSettingsValue:@"swipeLeftTo"]]) {
            if (translation.x < -kSwipeThreshold) {
                self.leftNoteActionView.backgroundColor = primaryColor;
                self.leftNoteActionView.imageView.backgroundColor = primaryColor;
            } else {
//                CAKeyframeAnimation *animation = nil;
//                CGColorRef finalColor = nil;
//                CGFloat endSliderVal = 0.0f;
//                
//                animation = [UIColor keyframeAnimationForKeyPath:@"backgroundColor"
//                                                        duration:1.5
//                                               betweenFirstColor:self.leftNoteActionView.backgroundColor
//                                                       lastColor:tertiaryColor];
//                finalColor = tertiaryColor.CGColor;
//                endSliderVal = 0.0f;
//                
//                self.leftNoteActionView.layer.backgroundColor = finalColor;
//                [self.leftNoteActionView.layer addAnimation:animation forKey:@"backgroundColorChange"];
                
                self.leftNoteActionView.backgroundColor = tertiaryColor;
                self.leftNoteActionView.imageView.backgroundColor = tertiaryColor;
            }
        } else {
            self.leftNoteActionView.backgroundColor = secondaryColor;
            self.leftNoteActionView.imageView.backgroundColor = secondaryColor;
        }
        
        CGPoint newLeftCenter = CGPointMake(self.leftNoteActionViewOriginalCenter.x + translation.x, self.leftNoteActionViewOriginalCenter.y);
        [self.leftNoteActionView setCenter:(newLeftCenter)];
        
        // TODO: Refactor into state class
        if (![Utilities isEmptyString:self.text] && [Utilities isValidEmail:[Utilities getSettingsValue:@"swipeRightTo"]]) {
            if (translation.x > kSwipeThreshold) {
                self.rightNoteActionView.backgroundColor = primaryColor;
                self.rightNoteActionView.imageView.backgroundColor = primaryColor;
            } else {
                self.rightNoteActionView.backgroundColor = tertiaryColor;
                self.rightNoteActionView.imageView.backgroundColor = tertiaryColor;
            }
        } else {
            self.rightNoteActionView.backgroundColor = secondaryColor;
            self.rightNoteActionView.imageView.backgroundColor = secondaryColor;
        }
        CGPoint newRightCenter = CGPointMake(self.rightNoteActionViewOriginalCenter.x + translation.x, self.rightNoteActionViewOriginalCenter.y);
        [self.rightNoteActionView setCenter:(newRightCenter)];
    }
}

@end
