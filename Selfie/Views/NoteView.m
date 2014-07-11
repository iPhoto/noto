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

        // Swipe left
        self.leftNoteRibbonView = [[NoteRibbonView alloc] init];
        self.leftNoteRibbonView.textView.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.leftNoteRibbonView];
        
        self.leftNoteRibbonView.originalCenter = self.leftNoteRibbonView.center;
        
        // Swipe right
        self.rightNoteRibbonView = [[NoteRibbonView alloc] init];
        self.rightNoteRibbonView.textView.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.rightNoteRibbonView];
        
        self.leftNoteRibbonView.originalCenter = self.rightNoteRibbonView.center;
        
        [self becomeFirstResponder];
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

@end
