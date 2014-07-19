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
        
        self.isShown = NO;
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

- (void(^)(void)) showAnimationBlock {
    self.isShown = YES;
    return ^{
        self.frame = CGRectOffset(self.frame, 0, kNoteAttachmentCollectionViewHeight);
    };
}

- (void(^)(BOOL)) showCompletionBlock {
    return ^(BOOL finished) {
        
    };
}

- (void(^)(void)) hideAnimationBlock {
    self.isShown = NO;
    return ^{
        self.frame = CGRectOffset(self.frame, 0, -kNoteAttachmentCollectionViewHeight);
    };
}

- (void(^)(BOOL)) hideCompletionBlock {
    return ^(BOOL finished) {

    };
}

@end
