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

- (NoteView *) noteView {
    if (!_noteView) {
        _noteView = [[NoteView alloc] initWithFrame:self.view.frame];
    }
    
    return _noteView;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    [self onFirstLaunch];
    
    [self.view addSubview:self.noteView];
    
    self.noteView.delegate = self;
    self.noteView.noteViewDelegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardIsUp:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
}

- (void) onFirstLaunch {
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
        
        self.navBarTitle.title = kEmptyNoteSubject;
        
        // Now that we've shown the first launch text,
        // save that they've launched before
        [Utilities setSettingsValue:@"notFirstLaunch" forKey:kHasLaunchedBeforeKey];
    }
}

- (void) scrollToCaretInTextView:(UITextView *) textView animated:(BOOL) animated {
    CGRect rect = [textView caretRectForPosition:textView.selectedTextRange.end];
    rect.size.height += textView.textContainerInset.bottom;
    [textView scrollRectToVisible:rect animated:animated];
}

- (void) textViewDidChange:(UITextView *) textView {
    if ([textView.text hasSuffix:@"\n"]) {
        
        [CATransaction setCompletionBlock:^{
            [self scrollToCaretInTextView:textView animated:NO];
        }];
        
    } else {
        [self scrollToCaretInTextView:textView animated:NO];
    }
    
    NSString *title = [Utilities getNoteSubject:self.noteView.text];
    
    if ([Utilities isEmptyString:title]) {
        if ([Utilities isEmptyString:self.noteView.text]) {
            self.navBarTitle.title = kEmptyNoteSubject;
            [Radio postNotificationName:kEmptyNoteNotification object:nil];
        } else {
            self.navBarTitle.title = kNoSubject;
            [Radio postNotificationName:kEmptySubjectNotification object:nil];
        }
        
    } else {
        self.navBarTitle.title = title;
        [Radio postNotificationName:kUpdateSubjectNotification object:nil];
    }
}

- (void) didPanInDirection:(UISwipeGestureRecognizerDirection) direction {
    Note *note = [[Note alloc] initWithString:self.noteView.text direction:direction];
    
    if (note) {
        [note send];
    }
    
    [self initNote];
}

- (void) keyboardIsUp:(NSNotification *) notification
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

- (void) keyboardWillShow:(NSNotification *) notification {
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
    self.noteView.leftNoteRibbonView.frame = CGRectMake(keyboardRect.size.width, actionViewHeight, keyboardRect.size.width, kNoteActionViewHeight);
    self.noteView.rightNoteRibbonView.frame = CGRectMake(-keyboardRect.size.width, actionViewHeight, keyboardRect.size.width, kNoteActionViewHeight);
    
    // TODO: Subviews can be moved into initialization
    self.noteView.leftNoteRibbonView.textView.frame = CGRectMake(0, 0, keyboardRect.size.width, kNoteActionViewHeight);
    self.noteView.rightNoteRibbonView.textView.frame = CGRectMake(0, 0, keyboardRect.size.width, kNoteActionViewHeight);
    
    // TODO: This should be done with constraints
    self.noteView.leftNoteRibbonView.imageView.frame = CGRectMake(kNoteActionImageBorder, kNoteActionImageBorder, kNoteActionImageHeight, kNoteActionImageHeight);
    self.noteView.rightNoteRibbonView.imageView.frame = CGRectMake(keyboardRect.size.width - kNoteActionViewHeight + kNoteActionImageBorder, kNoteActionImageBorder, kNoteActionImageHeight, kNoteActionImageHeight);
    
    self.noteView.leftNoteRibbonViewOriginalCenter = self.noteView.leftNoteRibbonView.center;
    self.noteView.rightNoteRibbonViewOriginalCenter = self.noteView.rightNoteRibbonView.center;
}

- (void) keyboardDidShow:(NSNotification *) notification {
    self.noteView.panGestureRecognizer.enabled = YES;
}

- (void) didPan:(UIPanGestureRecognizer *) gestureRecognizer {
    // TODO: Refactor and delegate to viewcontroller
    NoteView *noteView = (NoteView *) gestureRecognizer.view;
    CGPoint translation = [gestureRecognizer translationInView:noteView];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self.noteView.leftNoteRibbonView.textView setText:[State getRibbonText:noteView.text withDirection:SwipeDirectionLeft]];
        [self.noteView.leftNoteRibbonView.imageView setImage:[State getRibbonImage:noteView.text withDirection:SwipeDirectionLeft]];
        
        [self.noteView.rightNoteRibbonView.textView setText:[State getRibbonText:noteView.text withDirection:SwipeDirectionRight]];
        [self.noteView.rightNoteRibbonView.imageView setImage:[State getRibbonImage:noteView.text withDirection:SwipeDirectionRight]];
        
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        // TODO: make sure send gesture and view gesture are identical; don't want users to be confused
        if (abs(translation.x) > abs(translation.y)) {
            // TODO: Refactor into state class
            if (translation.x > kSwipeThreshold && ![Utilities isEmptyString:self.noteView.text] && [Utilities isValidEmail:[Utilities getSettingsValue:@"swipeRightTo"]]) {
                [self didPanInDirection:UISwipeGestureRecognizerDirectionRight];
            } else if (translation.x < -kSwipeThreshold && ![Utilities isEmptyString:self.noteView.text] && [Utilities isValidEmail:[Utilities getSettingsValue:@"swipeLeftTo"]]) {
                [self didPanInDirection:UISwipeGestureRecognizerDirectionLeft];
            }
        }
        
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.noteView.leftNoteRibbonView.center = self.noteView.leftNoteRibbonViewOriginalCenter;
        } completion:^(BOOL finished){
            
        }];
        
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.noteView.rightNoteRibbonView.center = self.noteView.rightNoteRibbonViewOriginalCenter;
        } completion:^(BOOL finished){
            
        }];
    } else {
        
        // TODO: Refactor into state class
        if (![Utilities isEmptyString:self.noteView.text] && [Utilities isValidEmail:[Utilities getSettingsValue:@"swipeLeftTo"]]) {
            if (translation.x < -kSwipeThreshold) {
                self.noteView.leftNoteRibbonView.backgroundColor = primaryColor;
                self.noteView.leftNoteRibbonView.imageView.backgroundColor = primaryColor;
            } else {
                self.noteView.leftNoteRibbonView.backgroundColor = tertiaryColor;
                self.noteView.leftNoteRibbonView.imageView.backgroundColor = tertiaryColor;
            }
        } else {
            self.noteView.leftNoteRibbonView.backgroundColor = secondaryColor;
            self.noteView.leftNoteRibbonView.imageView.backgroundColor = secondaryColor;
        }
        
        CGPoint newLeftCenter = CGPointMake(self.noteView.leftNoteRibbonViewOriginalCenter.x + translation.x, self.noteView.leftNoteRibbonViewOriginalCenter.y);
        [self.noteView.leftNoteRibbonView setCenter:(newLeftCenter)];
        
        // TODO: Refactor into state class
        if (![Utilities isEmptyString:self.noteView.text] && [Utilities isValidEmail:[Utilities getSettingsValue:@"swipeRightTo"]]) {
            if (translation.x > kSwipeThreshold) {
                self.noteView.rightNoteRibbonView.backgroundColor = primaryColor;
                self.noteView.rightNoteRibbonView.imageView.backgroundColor = primaryColor;
            } else {
                self.noteView.rightNoteRibbonView.backgroundColor = tertiaryColor;
                self.noteView.rightNoteRibbonView.imageView.backgroundColor = tertiaryColor;
            }
        } else {
            self.noteView.rightNoteRibbonView.backgroundColor = secondaryColor;
            self.noteView.rightNoteRibbonView.imageView.backgroundColor = secondaryColor;
        }
        CGPoint newRightCenter = CGPointMake(self.noteView.rightNoteRibbonViewOriginalCenter.x + translation.x, self.noteView.rightNoteRibbonViewOriginalCenter.y);
        [self.noteView.rightNoteRibbonView setCenter:(newRightCenter)];
    }
}

@end
