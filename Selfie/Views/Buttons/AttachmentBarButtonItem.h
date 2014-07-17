//
//  AttachmentBarButtonItem.h
//  Selfie
//
//  Created by Daniel Suo on 7/16/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttachmentBarButtonItem : UIBarButtonItem
- (void) setAction:(SEL) action withTarget:(id) target;
- (void) setImage:(UIImage *) image;
@end
