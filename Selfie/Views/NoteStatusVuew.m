//
//  NoteStatusView.m
//  Selfie
//
//  Created by Daniel Suo on 7/9/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import "NoteStatusVuew.h"

@implementation NoteStatusVuew

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.editable = NO;
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
        self.clipsToBounds = YES;
        self.layer.cornerRadius = kNoConnectionViewHeight / 2;
        [self.layer setBorderColor: [primaryColor CGColor]];
        [self.layer setBorderWidth: 1.5];
        self.text = kNoConnection;
        self.textAlignment = NSTextAlignmentCenter;
        self.textContainerInset = UIEdgeInsetsMake(-self.contentSize.height / 2 - 1, 0, 0, 0);
//        self.textContainerInset = UIEdgeInsetsMake((kNoConnectionViewHeight - kGlobalFontSize) / 2 - 2, kNoConnectionViewHeight, 0, kNoConnectionViewHeight);
    }
    return self;
}

@end
