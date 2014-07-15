//
//  NoteAttachmentView.h
//  Selfie
//
//  Created by Daniel Suo on 7/11/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotePhotoCell.h"
#import "Utilities.h"

@interface NoteAttachmentView : UICollectionView
@property (nonatomic, strong) UIButton *takePhotoButton;
//@property (nonatomic, strong) 

- (void) updateFrameToKeyboard:(CGRect) keyboardRect;
@end
