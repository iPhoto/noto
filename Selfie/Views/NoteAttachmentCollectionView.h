//
//  NoteAttachmentCollectionView.h
//  Selfie
//
//  Created by Daniel Suo on 7/11/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotePhotoCell.h"
#import "Utilities.h"

@interface NoteAttachmentCollectionView : UICollectionView
- (void) updateFrameToKeyboard:(CGRect) keyboardRect withNavBarHeight:(CGFloat) navBarHeight;

- (void(^)(void)) showAnimationBlock;
- (void(^)(BOOL)) showCompletionBlock;
- (void(^)(void)) hideAnimationBlock;
- (void(^)(BOOL)) hideCompletionBlock;
@end
