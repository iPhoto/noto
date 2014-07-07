//
//  NoteView.h
//  Selfie
//
//  Created by Daniel Suo on 7/5/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteActionView.h"

@class NoteView;

@protocol NoteViewDelegate <UITextViewDelegate>
@required
- (void) didPanInDirection:(UISwipeGestureRecognizerDirection)direction;
@end

@interface NoteView : UITextView <UIGestureRecognizerDelegate>
@property (nonatomic, assign) id <NoteViewDelegate> noteViewDelegate;
@property (nonatomic) NSInteger swipeThreshold;
@property (nonatomic, strong) NoteActionView *leftNoteActionView;
@property (nonatomic, strong) NoteActionView *rightNoteActionView;
@property (nonatomic) CGPoint leftNoteActionViewOriginalCenter;
@property (nonatomic) CGPoint rightNoteActionViewOriginalCenter;
@end
