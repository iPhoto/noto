//
//  SpacerBarButtonItem.m
//  Selfie
//
//  Created by Daniel Suo on 7/18/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import "SpacerBarButtonItem.h"

@implementation SpacerBarButtonItem

- (instancetype) init {
    self = [super init];
    if (self) {
        self.customView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 12, 20)];
    }
    return self;
}

@end