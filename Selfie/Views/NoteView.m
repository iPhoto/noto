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
//        self.autoresizesSubviews = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        pan.delegate = self;
        
        NSArray *gestureRecognizers = [self.gestureRecognizers arrayByAddingObject:pan];
        self.gestureRecognizers = gestureRecognizers;
        
        if (!self.swipeThreshold) {
            self.swipeThreshold = 100;
        }

        // Swipe left
        self.leftNoteActionView = [[NoteActionView alloc] initWithFrame:CGRectMake(self.frame.size.width, 40, 1000, 40)];
        [self addSubview:self.leftNoteActionView];
        
        self.leftNoteActionViewOriginalCenter = self.leftNoteActionView.center;
        
        // Swipe right
        self.rightNoteActionView = [[NoteActionView alloc] initWithFrame:CGRectMake(-1000, 40, 1000, 40)];
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
            NSLog(@"finished!");
        }];
        
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.rightNoteActionView.center = self.rightNoteActionViewOriginalCenter;
        } completion:^(BOOL finished){
            NSLog(@"finished!");
        }];
    } else {
        if (translation.x < -self.swipeThreshold) {
            self.leftNoteActionView.backgroundColor = [UIColor redColor];
        } else {
            self.leftNoteActionView.backgroundColor = [UIColor blueColor];
        }
        
        CGPoint newLeftCenter = CGPointMake(self.leftNoteActionViewOriginalCenter.x + translation.x, self.leftNoteActionViewOriginalCenter.y);
        [self.leftNoteActionView setCenter:(newLeftCenter)];
        
        if (translation.x > self.swipeThreshold) {
            self.rightNoteActionView.backgroundColor = [UIColor redColor];
        } else {
            self.rightNoteActionView.backgroundColor = [UIColor blueColor];
        }
        CGPoint newRightCenter = CGPointMake(self.rightNoteActionViewOriginalCenter.x + translation.x, self.rightNoteActionViewOriginalCenter.y);
        [self.rightNoteActionView setCenter:(newRightCenter)];
        
//        CGPoint location = [gestureRecognizer locationInView:noteView];
//        [self.leftNoteActionView setCenter:location];
//        NSLog(@"x: %f, y: %f", translation.x, translation.y);
        // Update the position and transform. Then, notify any listeners of
        // the updates via the pan block.
        // CGPoint translation = [panGestureRecognizer translationInView:view];
        // translation.y = 0;
        // view.center = MDCCGPointAdd(self.mdc_viewState.originalCenter, translation);
        // [self mdc_rotateForTranslation:translation
        //      rotationDirection:self.mdc_viewState.rotationDirection];
        // [self mdc_executeOnPanBlockForTranslation:translation];
    }
}

@end
