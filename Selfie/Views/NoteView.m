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
        [self setFont:[UIFont systemFontOfSize:18]];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        pan.delegate = self;
        
        NSArray *gestureRecognizers = [self.gestureRecognizers arrayByAddingObject:pan];
        self.gestureRecognizers = gestureRecognizers;
        
        if (!self.swipeThreshold) {
            self.swipeThreshold = 100;
        }

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
        // TODO: This needs improvement; causes problems when move y a bit and then x
        if (abs(translation.x) > abs(translation.y)) {
            // TODO: Refactor into state class
            if (translation.x > self.swipeThreshold && ![Utilities isEmptyString:self.text] && [Utilities isValidEmail:[Utilities getSettingsValue:@"swipeRightTo"]]) {
                [noteViewDelegate didPanInDirection:UISwipeGestureRecognizerDirectionRight];
            } else if (translation.x < -self.swipeThreshold && ![Utilities isEmptyString:self.text] && [Utilities isValidEmail:[Utilities getSettingsValue:@"swipeLeftTo"]]) {
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
        if (abs(translation.x) > abs(translation.y)) {
            // TODO: Refactor into state class
            if (translation.x < -self.swipeThreshold && ![Utilities isEmptyString:self.text] && [Utilities isValidEmail:[Utilities getSettingsValue:@"swipeLeftTo"]]) {
                self.leftNoteActionView.backgroundColor = [UIColor blueColor];
            } else {
                self.leftNoteActionView.backgroundColor = [UIColor redColor];
            }
            
            CGPoint newLeftCenter = CGPointMake(self.leftNoteActionViewOriginalCenter.x + translation.x, self.leftNoteActionViewOriginalCenter.y);
            [self.leftNoteActionView setCenter:(newLeftCenter)];
            
            // TODO: Refactor into state class
            if (translation.x > self.swipeThreshold && ![Utilities isEmptyString:self.text] && [Utilities isValidEmail:[Utilities getSettingsValue:@"swipeRightTo"]]) {
                self.rightNoteActionView.backgroundColor = [UIColor blueColor];
            } else {
                self.rightNoteActionView.backgroundColor = [UIColor redColor];
            }
            CGPoint newRightCenter = CGPointMake(self.rightNoteActionViewOriginalCenter.x + translation.x, self.rightNoteActionViewOriginalCenter.y);
            [self.rightNoteActionView setCenter:(newRightCenter)];
        }
    }
}

@end
