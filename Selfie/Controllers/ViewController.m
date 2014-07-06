//
//  ViewController.m
//  Selfie
//
//  Created by Daniel Suo on 6/12/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import "ViewController.h"

NSString *firstLaunchSettingsText = @"The first line becomes the subject.\n"
                                    "New lines below are the email body!\n"
                                    "Tap the settings icon to set your emails.\n"
                                    "\n"
                                    "<3\n"
                                    "The ____ Team\n";

@interface ViewController () <UITextViewDelegate>
//@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) NoteView *noteView;
@property (strong, nonatomic) IBOutlet UINavigationItem *navBarTitle;
@end

@implementation ViewController

- (void) initNote {
    self.noteView.text = nil;
    self.navBarTitle.title = @"New Note";
}

- (NoteView *)noteView {
    if (!_noteView) {
        _noteView = [[NoteView alloc] initWithFrame:self.view.frame];
    }
    
    return _noteView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if([Utilities isFirstLaunch]) {
        self.noteView.text = firstLaunchSettingsText;
        // Now that we've shown the first launch text,
        // save that they've launched before
        [Utilities setSettingsValue:@"notFirstLaunch" forKey:kHasLaunchedBeforeKey];
    }
    
    [self.view addSubview:self.noteView];
    
//    MDCSwipeOptions *options = [MDCSwipeOptions new];
//    options.delegate = self;
//    options.threshold = 100.0f;
//    options.rotationFactor = 0.01;
//    options.onPan = ^(MDCPanState *state) {
//        
//        // Disable autocorrect / autocapitalize on pan
//        self.noteView.autocapitalizationType = UITextAutocapitalizationTypeNone;
//        self.noteView.autocorrectionType = UITextAutocorrectionTypeNo;
//        
//        // Rewrite the text to complete disable
//        NSString *currText = self.noteView.text;
//        self.noteView.text = @"";
//        self.noteView.text = currText;
//        
//        if ([Utilities isEmptyString:self.noteView.text]) {
//            self.backgroundView.backgroundColor = [UIColor lightGrayColor];
//        } else {
//            if (state.thresholdRatio == 1) {
//                self.backgroundView.backgroundColor = [UIColor greenColor];
//            }
//            else {
//                self.backgroundView.backgroundColor = [UIColor lightGrayColor];
//            }
//        }
//    };
//    
//    options.onChosen = ^(MDCSwipeResult *state){
//        if (![Utilities isEmptyString:self.noteView.text]) {
//            Note *note;
//            switch (state.direction) {
//                case MDCSwipeDirectionLeft:
//                    note = [[Note alloc] initWithString:self.noteView.text direction:UISwipeGestureRecognizerDirectionLeft];
//                    break;
//                case MDCSwipeDirectionRight:
//                    note = [[Note alloc] initWithString:self.noteView.text direction:UISwipeGestureRecognizerDirectionRight];
//                    break;
//                case MDCSwipeDirectionNone:
//                    break;
//            }
//            
//            if (note) {
//                [note send];
//            }
//            
//            [self initNote];
//        }
//        [self.noteView mdc_swipe:state.direction];
//    };
//    [self.noteView mdc_swipeToChooseSetup:options];
}

- (void)viewWillAppear:(BOOL)animated {
    self.noteView.delegate = self;
    [self.noteView setUserInteractionEnabled:TRUE];
    [self.noteView becomeFirstResponder];
    self.noteView.textContainerInset = UIEdgeInsetsMake(6, 6, 0, 0);
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
    
    UIEdgeInsets inset = self.noteView.contentInset;
    inset.bottom = keyboardRect.size.height;
    self.noteView.contentInset = inset;
    self.noteView.scrollIndicatorInsets = inset;
    
    [self scrollToCaretInTextView:self.noteView animated:YES];
}

- (void)textViewDidChange:(UITextView *)textView {
    if ([textView.text hasSuffix:@"\n"]) {
        
        [CATransaction setCompletionBlock:^{
            [self scrollToCaretInTextView:textView animated:NO];
        }];
        
    } else {
        [self scrollToCaretInTextView:textView animated:NO];
    }
    
    NSString *title = [self.noteView.text componentsSeparatedByString:@"\n"][0];
    
    if ([Utilities isEmptyString:title]) {
        self.navBarTitle.title = @"New Note";
    } else {
        self.navBarTitle.title = [self.noteView.text componentsSeparatedByString:@"\n"][0];
    }
}

@end
