//
//  NotoBarButtonItem.m
//  Selfie
//
//  Created by Daniel Suo on 7/17/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import "NotoBarButtonItem.h"

@implementation NotoBarButtonItem

- (instancetype) initWithImage:(UIImage *) image {
    self = [super init];
    if (self) {
        self.button = [UIButton buttonWithType:UIButtonTypeSystem];
        self.button.frame = CGRectMake(0, 0, 20, 20);
        [self.button setBackgroundImage:image forState:UIControlStateNormal];
        
        self.customView = self.button;
    }
    return self;
}

- (void) setAction:(SEL) action withTarget:(id) target {
    [self.button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void(^)(void)) showAnimationBlock {
    self.customView.alpha = 0;
    self.customView.hidden = NO;
    return ^{
        self.customView.alpha = 1;
    };
}

- (void(^)(BOOL)) showCompletionBlock {
    return ^(BOOL finished) {
        
    };
}

- (void(^)(void)) hideAnimationBlock {
    return ^{
        self.customView.alpha = 0;
    };
}

- (void(^)(BOOL)) hideCompletionBlock {
    return ^(BOOL finished) {
        if (finished) {
            self.customView.hidden = YES;
        }
    };
}

@end
