//
//  NoteAttachmentCollectionView.m
//  Selfie
//
//  Created by Daniel Suo on 7/11/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import "NoteAttachmentCollectionView.h"

// RESOURCES
// http://stackoverflow.com/questions/5743063/xcode-scrollview-with-images-in-scrollview


@implementation NoteAttachmentCollectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    if (self) {
        
        [self registerClass:[NotePhotoCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
        
        [self setCollectionViewLayout:[self createCollectionViewFlowLayoutWithCellDim:50]];
        
        self.contentInset = UIEdgeInsetsMake(kNoteAttachmentCollectionViewBorder, kNoteAttachmentCollectionViewBorder, kNoteAttachmentCollectionViewBorder, kNoteAttachmentCollectionViewBorder);
        
        self.backgroundColor = tertiaryColorLight;
        
        self.hidden = YES;
    }
    return self;
}

- (UICollectionViewFlowLayout *) createCollectionViewFlowLayoutWithCellDim:(CGFloat) dim {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = kNoteAttachmentCollectionViewBorder;
    layout.itemSize = CGSizeMake(dim, dim);
    
    return layout;
}

- (void) updateFrameToKeyboard:(CGRect) keyboardRect withNavBarHeight:(CGFloat) navBarHeight {
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    CGRect statusBarWindowRect = [self.superview.window convertRect:statusBarFrame fromWindow: nil];
    CGRect statusBarViewRect = [self.superview convertRect:statusBarWindowRect fromView: nil];
    
    CGFloat heightOffset = self.hidden == YES ? kNoteAttachmentCollectionViewHeight : 0;
    
    self.frame = CGRectMake(0, statusBarViewRect.size.height + navBarHeight - heightOffset , keyboardRect.size.width, kNoteAttachmentCollectionViewHeight);
    
    CGFloat cellDim = kNoteAttachmentCollectionViewCellDim;
    
    [(UICollectionViewFlowLayout *) self.collectionViewLayout setItemSize:CGSizeMake(cellDim, cellDim)];
}

- (void(^)(void)) showAnimationBlock {
    self.hidden = NO;
    return ^ {
        self.frame = CGRectOffset(self.frame, 0, kNoteAttachmentCollectionViewHeight);
    };
}

- (void(^)(BOOL)) showCompletionBlock {
    return ^(BOOL finished) {
        
    };
}

- (void(^)(void)) hideAnimationBlock {
    return ^ {
        self.frame = CGRectOffset(self.frame, 0, -kNoteAttachmentCollectionViewHeight);
    };
}

- (void(^)(BOOL)) hideCompletionBlock {
    return ^(BOOL finished) {
        if (finished) {
            self.hidden = YES;
        }
    };
}

@end
