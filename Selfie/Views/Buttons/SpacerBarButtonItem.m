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
        self.customView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 8, 25)];
    }
    return self;
}

@end


//
//    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:imageattachmentCollectionView];
//
//    UIButton *spacer = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 8, 25)];
//    UIBarButtonItem *spacerBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spacer];
//
//    self.navigationItem.rightBarButtonItems = @[self.attachmentBarButtonItem, spacerBarButtonItem, barButtonItem];
//    ((UIBarButtonItem *)self.navigationItem.rightBarButtonItems[2]).customView.alpha = 0;