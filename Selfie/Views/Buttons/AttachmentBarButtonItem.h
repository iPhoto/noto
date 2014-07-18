//
//  AttachmentBarButtonItem.h
//  Selfie
//
//  Created by Daniel Suo on 7/16/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotoBarButtonItem.h"

@interface AttachmentBarButtonItem : NotoBarButtonItem
@property (nonatomic) BOOL attachmentBarOpen;
@property (strong, nonatomic) UIImageView *imageView;

- (void) toggle;
@end
