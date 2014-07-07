//
//  NoteView.h
//  Selfie
//
//  Created by Daniel Suo on 7/5/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NoteView;

@protocol NoteViewDelegate <UITextViewDelegate>
@required
- (void) test;
@end

@interface NoteView : UITextView
@property (nonatomic, assign) id <NoteViewDelegate> noteViewDelegate;
@end
