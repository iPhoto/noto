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

- (void) show {
    [self showWithDelay:0];
}

- (void) showWithDelay:(NSTimeInterval) delay {
    self.hidden = NO;
    [UIView animateWithDuration:0.5 delay:delay usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished){
        
    }];
}

- (void) hide {
    [self hideWithDelay:0];
}

- (void) hideWithDelay:(NSTimeInterval) delay {
    [UIView animateWithDuration:0.5 delay:delay usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished){
        if (finished) {
            self.hidden = YES;
        }
    }];
}

@end
