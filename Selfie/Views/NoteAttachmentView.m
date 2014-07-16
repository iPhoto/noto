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
    self = [super initWithFrame:frame];
    if (self) {
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
        
        [self.collectionView registerClass:[NotePhotoCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
        
        [self.collectionView setCollectionViewLayout:[self createCollectionViewFlowLayoutWithCellDim:50]];
        
        self.collectionView.contentInset = UIEdgeInsetsMake(kNoteAttachmentViewBorder, kNoteAttachmentViewBorder, kNoteAttachmentViewBorder, kNoteAttachmentViewBorder);
        
        self.collectionView.backgroundColor = tertiaryColorLight;
        self.collectionView.hidden = YES;
        
        [self addSubview:self.collectionView];
        
//        self.layer.shadowOffset = CGSizeMake(0.25, 0.25);
//        self.layer.shadowRadius = 1.0;
//        self.layer.shadowColor = [[UIColor blackColor] CGColor];
//        self.layer.shadowOpacity = 0.6;
        
        self.hidden = YES;
    }
    return self;
}

- (UICollectionViewFlowLayout *) createCollectionViewFlowLayoutWithCellDim:(CGFloat) dim {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = kNoteAttachmentViewBorder;
    layout.itemSize = CGSizeMake(dim, dim);
    
    return layout;
}

- (void) updateFrameToKeyboard:(CGRect) keyboardRect withNavBarHeight:(CGFloat) navBarHeight {
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    CGRect statusBarWindowRect = [self.superview.window convertRect:statusBarFrame fromWindow: nil];
    CGRect statusBarViewRect = [self.superview convertRect:statusBarWindowRect fromView: nil];
    
    CGFloat heightOffset = self.collectionView.hidden == YES ? kNoteAttachmentViewHeight : 0;
    
    self.frame = CGRectMake(0, statusBarViewRect.size.height + navBarHeight - heightOffset , keyboardRect.size.width, kNoteAttachmentViewHeight);
    
//    self.frame = CGRectMake(0, self.superview.frame.size.height - keyboardRect.size.height, keyboardRect.size.width, keyboardRect.size.height);
    
    self.collectionView.frame = self.frame;
    
    CGFloat cellDim = kNoteAttachmentViewCellDim;
    
    [(UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout setItemSize:CGSizeMake(cellDim, cellDim)];
}

- (void) show {
    [self showWithDelay:0];
}

- (void) showWithDelay:(NSTimeInterval) delay {
    self.hidden = NO;
    self.collectionView.hidden = NO;
    [UIView animateWithDuration:0.5 delay:delay usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.alpha = 1.0;
        self.collectionView.alpha = 1.0;
    } completion:^(BOOL finished){
        
    }];
}

- (void) hide {
    [self hideWithDelay:0];
}

- (void) hideWithDelay:(NSTimeInterval) delay {
    [UIView animateWithDuration:0.5 delay:delay usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.alpha = 0.0;
        self.collectionView.alpha = 0.0;
    } completion:^(BOOL finished){
        if (finished) {
            self.hidden = YES;
            self.collectionView.hidden = YES;
        }
    }];
}

@end
