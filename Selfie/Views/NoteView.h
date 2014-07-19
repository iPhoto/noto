//
//  NoteView.h
//  Selfie
//
//  Created by Daniel Suo on 7/5/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Utilities.h"

@class NoteView;

@protocol NoteViewDelegate <UITextViewDelegate>
@required
- (void) didPan:(UIPanGestureRecognizer *) gestureRecognizer;
@end

@interface NoteView : UITextView <UIGestureRecognizerDelegate>
@property (nonatomic, assign) id <NoteViewDelegate> noteViewDelegate;

- (void(^)(void)) shiftDownAnimationBlock;
- (void(^)(BOOL)) shiftDownCompletionBlock;
- (void(^)(void)) shiftUpAnimationBlock;
- (void(^)(BOOL)) shiftUpCompletionBlock;
@end
