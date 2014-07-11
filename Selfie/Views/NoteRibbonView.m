//
//  NoteRibbonView.m
//  Selfie
//
//  Created by Daniel Suo on 7/7/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import "NoteRibbonView.h"

@implementation NoteRibbonView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textView = [[UITextView alloc] init];
        self.textView.editable = NO;
        self.textView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
        
        [self.textView setFont:[UIFont systemFontOfSize:kGlobalFontSize]];
        [self.textView setTextColor:[UIColor whiteColor]];
        self.textView.textContainerInset = UIEdgeInsetsMake((kNoteActionViewHeight - kGlobalFontSize) / 2 - 2, kNoteActionViewHeight, 0, kNoteActionViewHeight);
        
        self.clipsToBounds = YES;
        self.layer.cornerRadius = kNoteActionViewHeight / 2;
        [self addSubview:self.textView];
        
        self.imageView = [[UIImageView alloc] init];
        self.imageView.backgroundColor = secondaryColor;
        [self.imageView.layer setBorderColor: [[UIColor whiteColor] CGColor]];
        [self.imageView.layer setBorderWidth: 1.5];
        self.imageView.clipsToBounds = YES;
        self.imageView.layer.cornerRadius = kNoteActionImageHeight / 2;
        [self addSubview:self.imageView];
    }
    return self;
}

@end
