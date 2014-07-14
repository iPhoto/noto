//
//  NoteProgressView.h
//  Selfie
//
//  Created by Daniel Suo on 7/13/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utilities.h"

@interface NoteProgressView : UIProgressView
- (void) updateFrameToKeyboard:(CGRect) keyboardRect;
- (void) send;
- (void) show;
- (void) showWithDelay:(NSTimeInterval) delay;
- (void) hide;
- (void) hideWithDelay:(NSTimeInterval) delay;
@end
