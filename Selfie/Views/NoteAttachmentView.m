//
//  NoteAttachmentView.m
//  Selfie
//
//  Created by Daniel Suo on 7/11/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import "NoteAttachmentView.h"

@implementation NoteAttachmentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.takePhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.takePhotoButton.frame = CGRectMake(0, 0, kIconDim, kIconDim);
        UIImage *takePhotoButtonImage = [UIImage imageNamed:@"icon_camera_white"];
        [self.takePhotoButton setImage:takePhotoButtonImage forState:UIControlStateNormal];
        self.takePhotoButton.contentEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -10);
        [self addSubview:self.takePhotoButton];
    }
    return self;
}

- (void) updateFrameToKeyboard:(CGRect) keyboardRect withNavBarHeight:(CGFloat) height {
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    CGRect statusBarWindowRect = [self.superview.window convertRect:statusBarFrame fromWindow: nil];
    CGRect statusBarViewRect = [self.superview convertRect:statusBarWindowRect fromView: nil];
    
    self.frame = CGRectMake(keyboardRect.size.width - kIconDim - kIconSpacing, statusBarViewRect.size.height + height + kIconSpacing, kIconDim, kIconDim);
}

@end
