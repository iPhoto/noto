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
                                    "Tap the settings icon in the top right to set your emails.\n"
                                    "Swipe left or right to send to the corresponding email.\n"
                                    "\n"
                                    "<3\n"
                                    "The Selfie Team";

@interface ViewController ()
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
}

- (void)viewWillAppear:(BOOL)animated {
    self.noteView.delegate = self;
    self.noteView.noteViewDelegate = self;
    [self.noteView setUserInteractionEnabled:TRUE];
    [self.noteView becomeFirstResponder];
    self.noteView.textContainerInset = UIEdgeInsetsMake(6, 6, 0, 0);
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
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

- (void) didPanInDirection:(UISwipeGestureRecognizerDirection)direction {
    Note *note = [[Note alloc] initWithString:self.noteView.text direction:direction];
    
    if (note) {
        [note send];
    }
    
    [self initNote];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    CGFloat actionViewHeight = self.view.frame.size.height -
        [UIApplication sharedApplication].statusBarFrame.size.height -
        keyboardRect.size.height -
        self.navigationController.navigationBar.frame.size.height -
        80;
    
    self.noteView.leftNoteActionView.frame = CGRectMake(keyboardRect.size.width, actionViewHeight, 1000, 80);
    self.noteView.rightNoteActionView.frame = CGRectMake(-1000, actionViewHeight, 1000, 80);
    
    self.noteView.leftNoteActionViewOriginalCenter = self.noteView.leftNoteActionView.center;
    self.noteView.rightNoteActionViewOriginalCenter = self.noteView.rightNoteActionView.center;
    
    NSLog(@"keyboard: %f %f", keyboardRect.size.width, keyboardRect.size.height);
    NSLog(@"screen: %f %f", self.view.frame.size.width, self.view.frame.size.height);
}

@end
