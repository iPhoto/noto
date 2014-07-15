//
//  NoteAttachmentView.m
//  Selfie
//
//  Created by Daniel Suo on 7/11/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import "NoteAttachmentView.h"

// RESOURCES
// http://stackoverflow.com/questions/5743063/xcode-scrollview-with-images-in-scrollview


@implementation NoteAttachmentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    if (self) {
        [self setBackgroundColor:secondaryColor];
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
//        [flowLayout setMinimumInteritemSpacing:0.0f];
//        [flowLayout setMinimumLineSpacing:0.0f];
        [self setPagingEnabled:YES];
//        [flowLayout setItemSize:CGSizeMake(80, 60)];
        [self setCollectionViewLayout:flowLayout];
        [self registerClass:[NotePhotoCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    }
    return self;
}

- (void) updateFrameToKeyboard:(CGRect) keyboardRect {
//    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
//    CGRect statusBarWindowRect = [self.superview.window convertRect:statusBarFrame fromWindow: nil];
//    CGRect statusBarViewRect = [self.superview convertRect:statusBarWindowRect fromView: nil];
    
//    self.frame = CGRectMake(keyboardRect.size.width - kIconDim - kIconSpacing, statusBarViewRect.size.height + height + kIconSpacing, kIconDim, kIconDim);
    
    self.frame = CGRectMake(0, self.superview.frame.size.height - keyboardRect.size.height, keyboardRect.size.width, keyboardRect.size.height);
}

@end
