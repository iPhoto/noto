//
//  AttachmentBarButtonItem.m
//  Selfie
//
//  Created by Daniel Suo on 7/16/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import "AttachmentBarButtonItem.h"

@implementation AttachmentBarButtonItem

- (id) initWithImage:(UIImage *) image {
    self = [super initWithImage:image];
    if (self) {
        self.attachmentBarOpen = NO;
        
        self.imageView = [[UIImageView alloc] initWithImage:image];
        self.imageView.autoresizingMask = UIViewAutoresizingNone;
        self.imageView.contentMode = UIViewContentModeCenter;
        
        [self.button setBackgroundImage:nil forState:UIControlStateNormal];
        [self.button addSubview:self.imageView];
        self.imageView.frame = self.button.frame;
    }
    return self;
}

- (void) toggle {
    CGFloat degreesToRotate = self.attachmentBarOpen == NO ? 45 : 0;
    self.attachmentBarOpen = !self.attachmentBarOpen;
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.imageView.transform = CGAffineTransformMakeRotation( degreesToRotate * M_PI  / 180);
    } completion:nil];
}

@end
