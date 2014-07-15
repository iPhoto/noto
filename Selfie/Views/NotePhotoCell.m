//
//  NotePhotoCell.m
//  Selfie
//
//  Created by Daniel Suo on 7/14/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import "NotePhotoCell.h"

@interface NotePhotoCell ()
@end

@implementation NotePhotoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
        
        CGRect frame  = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        
        self.imageView = imageView;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill ;
        self.imageView.clipsToBounds = YES;
        self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.imageView removeConstraints:self.imageView.constraints];
        
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (void) setAsset:(ALAsset *)asset
{
    // 2
    _asset = asset;
    self.imageView.image = [UIImage imageWithCGImage:[asset thumbnail]];
}
@end