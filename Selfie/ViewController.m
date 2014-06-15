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

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITextView *text;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) Mailer *mailer;
@property (strong, nonatomic) IBOutlet UINavigationItem *navBarTitle;
@end

@implementation ViewController

- (NSString *) message {
    if (!_message) {
        _message = self.text.text;
    }
    
    return _message;
}

- (Mailer *) mailer {
    if (!_mailer) {
        _mailer = [[Mailer alloc] init];
    }
    return _mailer;
}

- (IBAction)processSwipe:(UISwipeGestureRecognizer *)sender {

    NSString *emailTo;
    NSString *emailFrom;
    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        emailTo = @"swipeRightTo";
        emailFrom = @"swipeRightFrom";
    } else {
        emailTo = @"swipeLeftTo";
        emailFrom = @"swipeLeftFrom";
    }

    NSString *toEmail = (NSString *)[Utilities getSettingsObject:emailTo];
    NSString *fromEmail = (NSString *)[Utilities getSettingsObject:emailFrom];
    
    if (toEmail) {
        if (!fromEmail || [[fromEmail stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
            fromEmail = toEmail;
        }
        
        NSArray *lines = [self.message componentsSeparatedByString:@"\n"];
        NSUInteger count = [lines count];
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
            
            [self.mailer enqueueMailTo:toEmail from:fromEmail withSubject:subject withBody:body];
            
            self.text.text = nil;
            self.message = nil;
        }
    } else {
        NSLog(@"Fail");
    }
}

- (void)viewDidAppear:(BOOL)animated {
    self.text.delegate = (id<UITextViewDelegate>)self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardIsUp:) name:UIKeyboardDidShowNotification object:nil];
    [self.text becomeFirstResponder];
    self.text.contentInset = UIEdgeInsetsMake(74, 0, 0, 0);

    self.navigationController.navigationBar.translucent = NO;
    [self.mailer pollMailQueue];
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
}

@end
