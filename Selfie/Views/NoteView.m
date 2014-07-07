//
//  NoteView.m
//  Selfie
//
//  Created by Daniel Suo on 7/5/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import "NoteView.h"

@implementation NoteView

@synthesize noteViewDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFont:[UIFont systemFontOfSize:18]];
        self.autoresizesSubviews = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        pan.delegate = self;
        
        NSArray *gestureRecognizers = [self.gestureRecognizers arrayByAddingObject:pan];
        self.gestureRecognizers = gestureRecognizers;
        
        if (!self.swipeThreshold) {
            self.swipeThreshold = 100;
        }

        self.leftNoteActionView = [[NoteActionView alloc] initWithFrame:CGRectMake(self.center.x - 10, self.center.y - 10, 20, 20)];
        [self addSubview:self.leftNoteActionView];
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
//            NSLog(@"x: %f, y: %f", translation.x, translation.y);
            NSLog(@"t: %d, x:%f", self.swipeThreshold, translation.x);
            if (translation.x > self.swipeThreshold) {
                NSLog(@"+t: %d, x:%f", self.swipeThreshold, translation.x);
                [noteViewDelegate didPanInDirection:UISwipeGestureRecognizerDirectionRight];
            } else if (translation.x < -self.swipeThreshold) {
                NSLog(@"-t: %d, x:%f", -self.swipeThreshold, translation.x);
                [noteViewDelegate didPanInDirection:UISwipeGestureRecognizerDirectionLeft];
            }
        }
    } else {
        CGPoint location = [gestureRecognizer locationInView:noteView];
        [self.leftNoteActionView setCenter:location];
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
