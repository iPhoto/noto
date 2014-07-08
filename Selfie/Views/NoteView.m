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
        [self addSubview:self.leftNoteActionView];
        
        self.leftNoteActionViewOriginalCenter = self.leftNoteActionView.center;
        
        // Swipe right
        self.rightNoteActionView = [[NoteActionView alloc] init];
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
    NoteView *noteView = (NoteView *)gestureRecognizer.view;
    CGPoint translation = [gestureRecognizer translationInView:noteView];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (abs(translation.x) > abs(translation.y)) {
            if (translation.x > self.swipeThreshold) {
                [noteViewDelegate didPanInDirection:UISwipeGestureRecognizerDirectionRight];
            } else if (translation.x < -self.swipeThreshold) {
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
        if (translation.x < -self.swipeThreshold) {
            self.leftNoteActionView.backgroundColor = [UIColor blueColor];
        } else {
            self.leftNoteActionView.backgroundColor = [UIColor redColor];
        }
        
        CGPoint newLeftCenter = CGPointMake(self.leftNoteActionViewOriginalCenter.x + translation.x, self.leftNoteActionViewOriginalCenter.y);
        [self.leftNoteActionView setCenter:(newLeftCenter)];
        
        if (translation.x > self.swipeThreshold) {
            self.rightNoteActionView.backgroundColor = [UIColor blueColor];
        } else {
            self.rightNoteActionView.backgroundColor = [UIColor redColor];
        }
        CGPoint newRightCenter = CGPointMake(self.rightNoteActionViewOriginalCenter.x + translation.x, self.rightNoteActionViewOriginalCenter.y);
        [self.rightNoteActionView setCenter:(newRightCenter)];
    }
}

@end
