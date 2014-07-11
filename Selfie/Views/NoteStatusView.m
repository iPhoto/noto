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
        self.selectable = NO;
        self.backgroundColor = tertiaryColor;
        self.userInteractionEnabled = NO;
        [self setAlpha:0.6];
        [self setFont:[UIFont systemFontOfSize:kGlobalFontSize]];
        [self setTextColor:[UIColor whiteColor]];
        self.textAlignment = NSTextAlignmentCenter;
        self.textContainerInset = UIEdgeInsetsMake((kStatusViewHeight - kGlobalFontSize)/2 - 2, 0, 0, 0);
    }
    return self;
}

@end
