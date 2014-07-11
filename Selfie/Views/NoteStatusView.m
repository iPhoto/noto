//
//  NoteStatusView.m
//  Selfie
//
//  Created by Daniel Suo on 7/9/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import "NoteStatusView.h"

@implementation NoteStatusView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.editable = NO;
        self.backgroundColor = primaryColor;
        [self setAlpha:0.7];
        self.text = kNoConnection;
        self.textAlignment = NSTextAlignmentCenter;
        self.textContainerInset = UIEdgeInsetsMake(-self.contentSize.height / 2 - 1, 0, 0, 0);
    }
    return self;
}

@end
