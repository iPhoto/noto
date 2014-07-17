//
//  AttachmentBarButtonItem.m
//  Selfie
//
//  Created by Daniel Suo on 7/16/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import "AttachmentBarButtonItem.h"

@interface AttachmentBarButtonItem ()
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIButton *button;
@end

@implementation AttachmentBarButtonItem


- (id)init
{
    self = [super init];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_add_attachment"]];
        self.imageView.autoresizingMask = UIViewAutoresizingNone;
        self.imageView.contentMode = UIViewContentModeCenter;
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button.frame = CGRectMake(0, -1, 25, 25);
        
        [self.button addSubview:self.imageView];
        
        self.imageView.center = self.button.center;
        self = [[AttachmentBarButtonItem alloc] initWithCustomView:self.button];
    }
    return self;
}

@end
