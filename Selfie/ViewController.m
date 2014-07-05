//
//  ViewController.m
//  Selfie
//
//  Created by Daniel Suo on 6/12/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import "ViewController.h"

NSString *firstLaunchSettingsText = @"Welcome to Selfie! "
"Please tap the settings button to configure the app for sending emails";

@interface ViewController () <MDCSwipeToChooseDelegate, UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) IBOutlet UITextView *frontTextView;
@property (strong, nonatomic) IBOutlet UINavigationItem *navBarTitle;
@end

@implementation ViewController

- (void) initNote {
    self.frontTextView.text = nil;
    self.navBarTitle.title = @"New Note";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MDCSwipeOptions *options = [MDCSwipeOptions new];
    options.delegate = self;
    options.threshold = 100.0f;
    options.rotationFactor = 0.01;
    options.onPan = ^(MDCPanState *state) {
        if ([Utilities isEmptyString:self.frontTextView.text]) {
            self.backgroundView.backgroundColor = [UIColor redColor];
        } else {
            if (state.thresholdRatio == 1) {
                self.backgroundView.backgroundColor = [UIColor greenColor];
            }
            else {
                self.backgroundView.backgroundColor = [UIColor lightGrayColor];
            }
        }
    };
    
    options.onChosen = ^(MDCSwipeResult *state){
        if (![Utilities isEmptyString:self.frontTextView.text]) {
            Note *note;
            switch (state.direction) {
                case MDCSwipeDirectionLeft:
                    note = [[Note alloc] initWithString:self.frontTextView.text direction:UISwipeGestureRecognizerDirectionLeft];
                    break;
                case MDCSwipeDirectionRight:
                    note = [[Note alloc] initWithString:self.frontTextView.text direction:UISwipeGestureRecognizerDirectionRight];
                    break;
                case MDCSwipeDirectionNone:
                    break;
            }
            
            if (note) {
                [note send];
            }
            
            [self initNote];
        }
        [self.frontTextView mdc_swipe:state.direction];
    };
    [self.frontTextView mdc_swipeToChooseSetup:options];
}

- (void)viewWillAppear:(BOOL)animated {
    self.frontTextView.delegate = self;
    [self.frontTextView setUserInteractionEnabled:TRUE];
    [self.frontTextView becomeFirstResponder];
    self.frontTextView.textContainerInset = UIEdgeInsetsMake(6, 6, 0, 0);
    
    if([Utilities isFirstLaunch]) {
        self.frontTextView.text = firstLaunchSettingsText;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    
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
    
    UIEdgeInsets inset = self.frontTextView.contentInset;
    inset.bottom = keyboardRect.size.height;
    self.frontTextView.contentInset = inset;
    self.frontTextView.scrollIndicatorInsets = inset;
    
    [self scrollToCaretInTextView:self.frontTextView animated:YES];
}

- (void)textViewDidChange:(UITextView *)textView {
    if ([textView.text hasSuffix:@"\n"]) {
        
        [CATransaction setCompletionBlock:^{
            [self scrollToCaretInTextView:textView animated:NO];
        }];
        
    } else {
        [self scrollToCaretInTextView:textView animated:NO];
    }
    
    NSString *title = [self.frontTextView.text componentsSeparatedByString:@"\n"][0];
    
    if ([Utilities isEmptyString:title]) {
        self.navBarTitle.title = @"New Note";
    } else {
        self.navBarTitle.title = [self.frontTextView.text componentsSeparatedByString:@"\n"][0];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showSettingsFromNote"]) {
        if ([self.frontTextView.text isEqualToString:firstLaunchSettingsText]) {
            self.frontTextView.text = @"";
        }
    }
}

@end
