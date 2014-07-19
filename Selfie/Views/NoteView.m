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

- (id) initWithFrame:(CGRect) frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFont:[UIFont systemFontOfSize:kGlobalFontSize]];
        self.textContainerInset = UIEdgeInsetsMake(8, 8, 0, 0);
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        pan.delegate = self;
        
        NSArray *gestureRecognizers = [self.gestureRecognizers arrayByAddingObject:pan];
        self.gestureRecognizers = gestureRecognizers;
    }
    return self;
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *) gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *) otherGestureRecognizer
{
    return YES;
}

- (void) handlePanGesture: (UIPanGestureRecognizer *) gestureRecognizer {
    [noteViewDelegate didPan:gestureRecognizer];
}

- (void(^)(void)) shiftDownAnimationBlock {
    return ^ {
        self.frame = CGRectOffset(self.frame, 0, kNoteAttachmentCollectionViewHeight);
    };
}

- (void(^)(BOOL)) shiftDownCompletionBlock {
    return ^(BOOL finished) {
        
    };
}

- (void(^)(void)) shiftUpAnimationBlock {
    return ^ {
        self.frame = CGRectOffset(self.frame, 0, -kNoteAttachmentCollectionViewHeight);
    };
}

- (void(^)(BOOL)) shiftUpCompletionBlock {
    return ^(BOOL finished) {
        if (finished) {
        }
    };
}

@end
