//
//  NoteRibbonView.h
//  Selfie
//
//  Created by Daniel Suo on 7/7/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Utilities.h"

@interface NoteRibbonView : UIView
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic) CGPoint originalCenter;

- (void) finalizePosition;
- (void) xPanWithTranslation:(CGFloat) xTranslation;
@end
