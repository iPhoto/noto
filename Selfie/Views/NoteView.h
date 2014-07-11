//
//  NoteView.h
//  Selfie
//
//  Created by Daniel Suo on 7/5/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "NoteRibbonView.h"

@class NoteView;

@protocol NoteViewDelegate <UITextViewDelegate>
@required
//- (void) didPanInDirection:(UISwipeGestureRecognizerDirection) direction;
- (void) didPan:(UIPanGestureRecognizer *) gestureRecognizer;
@end

@interface NoteView : UITextView <UIGestureRecognizerDelegate>
@property (nonatomic, assign) id <NoteViewDelegate> noteViewDelegate;
@property (nonatomic, strong) NoteRibbonView *leftNoteActionView;
@property (nonatomic, strong) NoteRibbonView *rightNoteActionView;
@property (nonatomic) CGPoint leftNoteActionViewOriginalCenter;
@property (nonatomic) CGPoint rightNoteActionViewOriginalCenter;
@end
