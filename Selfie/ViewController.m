//
//  ViewController.m
//  Selfie
//
//  Created by Daniel Suo on 6/12/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import "ViewController.h"
#import "Mailer.h"
#import "Utilities.h"

@interface ViewController () <UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITextView *text;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activitySpinner;
@property (strong, nonatomic) IBOutlet UINavigationItem *navBarTitle;
@end

@implementation ViewController

- (void) initNote {
    self.text.text = nil;
    self.navBarTitle.title = @"New Note";
}

- (IBAction)processSwipe:(UISwipeGestureRecognizer *)sender {

    NSString *emailTo;
    NSString *emailFrom;
    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        emailTo = @"swipeRightTo";
        emailFrom = @"swipeRightFrom";
    } else if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        emailTo = @"swipeLeftTo";
        emailFrom = @"swipeLeftFrom";
    } else {
        return;
    }

    NSString *toEmail = (NSString *)[Utilities getSettingsObject:emailTo];
    NSString *fromEmail = (NSString *)[Utilities getSettingsObject:emailFrom];
    
    if (toEmail) {
        if (!fromEmail || [[fromEmail stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
            fromEmail = toEmail;
        }
        
        NSString *message = [self.text.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if ([message isEqualToString:@""]) {
            return;
        }
        
        NSArray *lines = [message componentsSeparatedByString:@"\n"];
        NSUInteger count = [lines count];
        
        NSLog([NSString stringWithFormat:@"Email line count: %lu", count]);
        
        if (count > 0) {
            NSString *subject = lines[0];
            NSMutableString *body;
            NSString *signature = (NSString *)[Utilities getSettingsObject:@"signature"];
            
            // Build body
            if (count > 1) {
                body = [[NSMutableString alloc] initWithString:[[lines subarrayWithRange:NSMakeRange(1, [lines count] - 1)] componentsJoinedByString:@"\n"] ];
            } else {
                body = [[NSMutableString alloc] initWithString:@" "];
            }
            
            if (signature) {
                [body appendString:@"\n\n"];
                [body appendString: signature];
            }
            
            [Mailer enqueueMailTo:toEmail from:fromEmail withSubject:subject withBody:body];
            [self initNote];
        }
    } else {
        NSLog(@"Fail");
    }
}

- (void)viewDidAppear:(BOOL)animated {
    self.text.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardIsUp:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startAnimating:) name:@"emailQueueSent" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopAnimating:) name:@"emailQueueEmpty" object:nil];
    
    [self.text becomeFirstResponder];
    self.text.contentInset = UIEdgeInsetsMake(74, 0, 0, 0);

    self.navigationController.navigationBar.translucent = NO;
    [self initNote];
}

- (void)scrollToCaretInTextView:(UITextView *)textView animated:(BOOL)animated
{
    CGRect rect = [textView caretRectForPosition:textView.selectedTextRange.end];
    rect.size.height += textView.textContainerInset.bottom;
    [textView scrollRectToVisible:rect animated:animated];
}

- (void)startAnimating:(NSNotification *)notification {
    [self.activitySpinner startAnimating];
}

- (void)stopAnimating:(NSNotification *)notification {
    [self.activitySpinner stopAnimating];
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
    self.navBarTitle.title = [self.text.text componentsSeparatedByString:@"\n"][0];
}

@end
