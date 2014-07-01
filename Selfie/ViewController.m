//
//  ViewController.m
//  Selfie
//
//  Created by Daniel Suo on 6/12/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITextView *text;
@property (strong, nonatomic) IBOutlet UINavigationItem *navBarTitle;
@end

@implementation ViewController

- (void) initNote {
    self.text.text = nil;
    self.navBarTitle.title = @"New Note";
}

- (IBAction)processSwipe:(UISwipeGestureRecognizer *)sender {

    Note *note = [[Note alloc] initWithString:self.text.text direction:sender.direction];
    
    if (note) {
        [note send];
    }
    
    [self initNote];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.text becomeFirstResponder];
    self.text.textContainerInset = UIEdgeInsetsMake(6, 6, 0, 0);
}

- (void)viewDidAppear:(BOOL)animated {
    self.text.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardIsUp:) name:UIKeyboardDidShowNotification object:nil];

    self.navigationController.navigationBar.translucent = NO;
}

- (void)scrollToCaretInTextView:(UITextView *)textView animated:(BOOL)animated
{
    CGRect rect = [textView caretRectForPosition:textView.selectedTextRange.end];
    rect.size.height += textView.textContainerInset.bottom;
    [textView scrollRectToVisible:rect animated:animated];
}

- (void)keyboardIsUp:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    UIEdgeInsets inset = self.text.contentInset;
    inset.bottom = keyboardRect.size.height;
    self.text.contentInset = inset;
    self.text.scrollIndicatorInsets = inset;
    
    [self scrollToCaretInTextView:self.text animated:YES];
}

- (void)textViewDidChange:(UITextView *)textView {
    if ([textView.text hasSuffix:@"\n"]) {
        
        [CATransaction setCompletionBlock:^{
            [self scrollToCaretInTextView:textView animated:NO];
        }];
        
    } else {
        [self scrollToCaretInTextView:textView animated:NO];
    }
    
    NSString *title = [self.text.text componentsSeparatedByString:@"\n"][0];
    
    if ([Utilities isEmptyString:title]) {
        self.navBarTitle.title = @"New Note";
    } else {
        self.navBarTitle.title = [self.text.text componentsSeparatedByString:@"\n"][0];
    }
}

@end
