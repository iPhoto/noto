//
//  NotoBarButtonItem.h
//  Selfie
//
//  Created by Daniel Suo on 7/17/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotoBarButtonItem : UIBarButtonItem
@property (strong, nonatomic) UIButton *button;

- (instancetype) initWithImage:(UIImage *) image;
- (void) setAction:(SEL) action withTarget:(id) target;

- (void(^)(void)) showAnimationBlock;
- (void(^)(BOOL)) showCompletionBlock;
- (void(^)(void)) hideAnimationBlock;
- (void(^)(BOOL)) hideCompletionBlock;
@end
