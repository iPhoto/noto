//
//  NoteAttachmentView.h
//  Selfie
//
//  Created by Daniel Suo on 7/11/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utilities.h"

@interface NoteAttachmentView : UIView
@property (nonatomic, strong) UIButton *takePhotoButton;

- (void) updateFrameToKeyboard:(CGRect) keyboardRect withNavBarHeight:(CGFloat) height;
@end
