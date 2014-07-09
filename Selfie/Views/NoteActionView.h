//
//  NoteActionView.h
//  Selfie
//
//  Created by Daniel Suo on 7/7/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ReachabilityManager.h"
#import "Utilities.h"

@interface NoteActionView : UIView
@property (nonatomic) UISwipeGestureRecognizerDirection direction;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIImageView *imageView;

- (NSString *)getActionText:(NSString *)noteText;
@end
