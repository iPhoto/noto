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
        self.textView.selectable = NO;
        self.textView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
        
        [self.textView setFont:[UIFont systemFontOfSize:kGlobalFontSize]];
        [self.textView setTextColor:[UIColor whiteColor]];
        self.textView.textContainerInset = UIEdgeInsetsMake((kNoteRibbonViewHeight - kGlobalFontSize) / 2 - 2, kNoteRibbonTextOffset, 0, kNoteRibbonTextOffset);
        
//        self.clipsToBounds = YES;
        self.layer.cornerRadius = kNoteRibbonViewHeight / 2;
        [self addSubview:self.textView];
        
        self.imageView = [[UIImageView alloc] init];
        self.imageView.backgroundColor = secondaryColor;
        [self.imageView.layer setBorderColor: [[UIColor whiteColor] CGColor]];
        [self.imageView.layer setBorderWidth: kNoteRibbonImageBorder];
        self.imageView.clipsToBounds = YES;
        self.imageView.layer.cornerRadius = kNoteRibbonImageHeight / 2;
        [self addSubview:self.imageView];
        
        self.layer.shadowOffset = CGSizeMake(0.25, 0.25);
        self.layer.shadowRadius = 1.0;
        self.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.layer.shadowOpacity = 0.6;
    }
    return self;
}

// TODO: refactor constants to Utilities
- (void) finalizePosition {
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.center = self.originalCenter;
    } completion:^(BOOL finished) {
        
    }];
}

- (void) panWithTranslation:(CGPoint) translation {
    // Ignoring y pans for now
    CGPoint newCenter = CGPointMake(self.originalCenter.x + translation.x, self.originalCenter.y);
    [self setCenter:(newCenter)];
}

- (void) setColorWithPastTheshold:(BOOL) pastThreshold validSend:(BOOL) validity {
    
    UIColor *currColor = self.backgroundColor;
    UIColor *nextColor = self.backgroundColor;
    
    if (validity) {
        nextColor = pastThreshold ? primaryColor : tertiaryColor;
        [UIView animateWithDuration:0.25
                              delay:0
             usingSpringWithDamping:1
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.backgroundColor = nextColor;
                             self.imageView.backgroundColor = nextColor;
                         }
                         completion:^(BOOL finished) {
                             
                         }
         ];
    } else {
        self.backgroundColor = secondaryColor;
        self.imageView.backgroundColor = secondaryColor;
    }
    
}

- (void) updateFrameToKeyboard:(CGRect) keyboardRect {
    // TODO: Move magic numbers into NoteView constants
    CGFloat ribbonViewHeight = self.superview.frame.size.height -
    keyboardRect.size.height -
    kNoteRibbonViewHeight;
    
    BOOL isLeft = self.direction == SwipeDirectionLeft;
    
    // TODO: Change rectangle widths to be frame widths
    CGFloat xOffset = isLeft ? keyboardRect.size.width : -kNoteRibbonViewWidth;
    self.frame = CGRectMake(xOffset, ribbonViewHeight, kNoteRibbonViewWidth, kNoteRibbonViewHeight);
    
    // TODO: Subviews can be moved into initialization
    self.textView.frame = CGRectMake(0, 0, kNoteRibbonViewWidth, kNoteRibbonViewHeight);
    
    // TODO: This should be done with constraints
    CGFloat xImageOffset = kNoteRibbonImageBorderSpacing + (isLeft ? 0 : kNoteRibbonViewWidth - kNoteRibbonViewHeight);
    self.imageView.frame = CGRectMake(xImageOffset, kNoteRibbonImageBorderSpacing, kNoteRibbonImageHeight, kNoteRibbonImageHeight);
    
    self.originalCenter = self.center;
}

@end
