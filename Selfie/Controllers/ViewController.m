//
//  ViewController.m
//  Selfie
//
//  Created by Daniel Suo on 6/12/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import "ViewController.h"

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
        self.noteView.text = [@[@"The first line becomes the subject.\n",
                                @"New lines below are the email body!\n",
                                @"Tap the settings icon in the top right to set your emails.\n",
                                @"\n",
                                @"Swipe left or right to send to the corresponding email.\n",
                                @"\n",
                                @"(｡･ω･｡)ﾉ♡\n",
                                @"The ",
                                [Utilities appName],
                                @" Team"] componentsJoinedByString:@""];
        
        self.navBarTitle.title = @"New Note";
        // Now that we've shown the first launch text,
        // save that they've launched before
        [Utilities setSettingsValue:@"notFirstLaunch" forKey:kHasLaunchedBeforeKey];
    }
    
    self.noteView.leftNoteActionView.textView.text = [Utilities getSettingsValue:@"swipeLeftTo"];
    self.noteView.rightNoteActionView.textView.text = [Utilities getSettingsValue:@"swipeRightTo"];

    [self.view addSubview:self.noteView];
}

- (void)viewWillAppear:(BOOL)animated {
    self.noteView.delegate = self;
    self.noteView.noteViewDelegate = self;
    [self.noteView setUserInteractionEnabled:TRUE];
    [self.noteView becomeFirstResponder];
    self.noteView.textContainerInset = UIEdgeInsetsMake(8, 8, 0, 0);
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
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
        if ([Utilities isEmptyString:self.noteView.text]) {
            self.navBarTitle.title = kEmptyNoteSubject;
        } else {
            self.navBarTitle.title = kNoSubject;
        }
        
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

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    self.noteView.panGestureRecognizer.enabled = NO;
    
    CGRect statusBarFrame = [self.view.window convertRect:UIApplication.sharedApplication.statusBarFrame toView:self.view];
    CGFloat statusBarHeight = statusBarFrame.size.height;
    
    // TODO: Move magic numbers into NoteView constants
    CGFloat actionViewHeight = self.view.frame.size.height -
        statusBarHeight -
        keyboardRect.size.height -
        self.navigationController.navigationBar.frame.size.height -
        kNoteActionViewHeight;
    
    // TODO: Change rectangle widths to be frame widths
    self.noteView.leftNoteActionView.frame = CGRectMake(keyboardRect.size.width, actionViewHeight, keyboardRect.size.width, kNoteActionViewHeight);
    self.noteView.rightNoteActionView.frame = CGRectMake(-keyboardRect.size.width, actionViewHeight, keyboardRect.size.width, kNoteActionViewHeight);
    
    // TODO: Subviews can be moved into initialization
    self.noteView.leftNoteActionView.textView.frame = CGRectMake(0, 0, keyboardRect.size.width, kNoteActionViewHeight);
    self.noteView.rightNoteActionView.textView.frame = CGRectMake(0, 0, keyboardRect.size.width, kNoteActionViewHeight);
    
    // TODO: This should be done with constraints
    self.noteView.leftNoteActionView.imageView.frame = CGRectMake(kNoteActionImageBorder, kNoteActionImageBorder, kNoteActionImageHeight, kNoteActionImageHeight);
    self.noteView.rightNoteActionView.imageView.frame = CGRectMake(keyboardRect.size.width - kNoteActionViewHeight + kNoteActionImageBorder, kNoteActionImageBorder, kNoteActionImageHeight, kNoteActionImageHeight);
    
    self.noteView.leftNoteActionViewOriginalCenter = self.noteView.leftNoteActionView.center;
    self.noteView.rightNoteActionViewOriginalCenter = self.noteView.rightNoteActionView.center;
}

- (void)keyboardDidShow:(NSNotification *)notification {
    self.noteView.panGestureRecognizer.enabled = YES;
}

@end
