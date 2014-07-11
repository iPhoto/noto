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
@property (strong, nonatomic) NoteRibbonView *leftRibbon;
@property (strong, nonatomic) NoteRibbonView *rightRibbon;
@property (strong, nonatomic) NoConnectionView *noConnection;
@property (strong, nonatomic) IBOutlet UINavigationItem *navBarTitle;
@end

@implementation ViewController

- (void) initNote {
    self.noteView.text = nil;
    self.navBarTitle.title = kEmptyNoteSubject;
}

- (NoteView *) noteView {
    if (!_noteView) {
        _noteView = [[NoteView alloc] initWithFrame:self.view.frame];
    }
    
    return _noteView;
}

- (NoteRibbonView *) leftRibbon {
    if (!_leftRibbon) {
        _leftRibbon = [[NoteRibbonView alloc] init];
        _leftRibbon.textView.textAlignment = NSTextAlignmentLeft;
    }
    return _leftRibbon;
}

- (NoteRibbonView *) rightRibbon {
    if (!_rightRibbon) {
        _rightRibbon = [[NoteRibbonView alloc] init];
        _rightRibbon.textView.textAlignment = NSTextAlignmentRight;
    }
    return _rightRibbon;
}

- (NoConnectionView *) noConnection {
    if (!_noConnection) {
        _noConnection = [[NoConnectionView alloc] init];
    }
    
    return _noConnection;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    [self onFirstLaunch];
    
    [self.view addSubview:self.noteView];
    [self.view addSubview:self.noConnection];
    [self.view addSubview:self.leftRibbon];
    [self.view addSubview:self.rightRibbon];
    
    if ([State isReachable]) {
        self.noConnection.hidden = YES;
    }
    
    self.noteView.delegate = self;
    self.noteView.noteViewDelegate = self;
    
    [Radio addObserver:self
              selector:@selector(keyboardWillShow:)
                  name:UIKeyboardWillShowNotification
                object:nil];
    
    [Radio addObserver:self
              selector:@selector(keyboardDidShow:)
                  name:UIKeyboardDidShowNotification
                object:nil];
    
    [Radio addObserver:self
              selector:@selector(keyboardIsUp:)
                  name:UIKeyboardDidShowNotification
                object:nil];
    
    [Radio addObserver:self
              selector:@selector(reachabilityChanged:)
                  name:kReachabilityChangedNotification
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
    
    // TODO: Move magic numbers into NoteView constants
    CGFloat ribbonViewHeight = self.view.frame.size.height -
        keyboardRect.size.height -
        kNoteRibbonViewHeight;
    
    // TODO: Change rectangle widths to be frame widths
    self.leftRibbon.frame = CGRectMake(keyboardRect.size.width, ribbonViewHeight, kNoteRibbonViewWidth, kNoteRibbonViewHeight);
    self.rightRibbon.frame = CGRectMake(-kNoteRibbonViewWidth, ribbonViewHeight, kNoteRibbonViewWidth, kNoteRibbonViewHeight);
    
    // TODO: Subviews can be moved into initialization
    self.leftRibbon.textView.frame = CGRectMake(0, 0, kNoteRibbonViewWidth, kNoteRibbonViewHeight);
    self.rightRibbon.textView.frame = CGRectMake(0, 0, kNoteRibbonViewWidth, kNoteRibbonViewHeight);
    
    // TODO: This should be done with constraints
    self.leftRibbon.imageView.frame = CGRectMake(kNoteRibbonImageBorder, kNoteRibbonImageBorder, kNoteRibbonImageHeight, kNoteRibbonImageHeight);
    self.rightRibbon.imageView.frame = CGRectMake(kNoteRibbonViewWidth - kNoteRibbonViewHeight + kNoteRibbonImageBorder, kNoteRibbonImageBorder, kNoteRibbonImageHeight, kNoteRibbonImageHeight);
    
    self.leftRibbon.originalCenter = self.leftRibbon.center;
    self.rightRibbon.originalCenter = self.rightRibbon.center;
    
    self.noConnection.frame = CGRectMake((keyboardRect.size.width - kNoConnectionViewWidth) / 2, ribbonViewHeight + (kNoteRibbonViewHeight - kNoConnectionViewHeight) / 2, kNoConnectionViewWidth, kNoConnectionViewHeight);
}

- (void) keyboardDidShow:(NSNotification *) notification {
    self.noteView.panGestureRecognizer.enabled = YES;
}

- (void) didPan:(UIPanGestureRecognizer *) gestureRecognizer {
    // TODO: Refactor and delegate to viewcontroller
    NoteView *noteView = (NoteView *) gestureRecognizer.view;
    CGPoint translation = [gestureRecognizer translationInView:noteView];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self.leftRibbon.textView setText:[State getRibbonText:noteView.text withDirection:SwipeDirectionLeft]];
        [self.leftRibbon.imageView setImage:[State getRibbonImage:noteView.text withDirection:SwipeDirectionLeft]];
        
        [self.rightRibbon.textView setText:[State getRibbonText:noteView.text withDirection:SwipeDirectionRight]];
        [self.rightRibbon.imageView setImage:[State getRibbonImage:noteView.text withDirection:SwipeDirectionRight]];
        
        self.noConnection.hidden = YES;
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
            self.leftRibbon.center = self.leftRibbon.originalCenter;
        } completion:^(BOOL finished){
            
        }];
        
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.rightRibbon.center = self.rightRibbon.originalCenter;
        } completion:^(BOOL finished){
            
        }];
        
        [self reachabilityChanged:nil];
    } else {
        if (abs(translation.x) < self.view.frame.size.width) {
            // TODO: Refactor into state class
            if (![Utilities isEmptyString:self.noteView.text] && [Utilities isValidEmail:[Utilities getSettingsValue:@"swipeLeftTo"]]) {
                if (translation.x < -kSwipeThreshold) {
                    self.leftRibbon.backgroundColor = primaryColor;
                    self.leftRibbon.imageView.backgroundColor = primaryColor;
                } else {
                    self.leftRibbon.backgroundColor = tertiaryColor;
                    self.leftRibbon.imageView.backgroundColor = tertiaryColor;
                }
            } else {
                self.leftRibbon.backgroundColor = secondaryColor;
                self.leftRibbon.imageView.backgroundColor = secondaryColor;
            }
            
            CGPoint newLeftCenter = CGPointMake(self.leftRibbon.originalCenter.x + translation.x, self.leftRibbon.originalCenter.y);
            [self.leftRibbon setCenter:(newLeftCenter)];
            
            // TODO: Refactor into state class
            if (![Utilities isEmptyString:self.noteView.text] && [Utilities isValidEmail:[Utilities getSettingsValue:@"swipeRightTo"]]) {
                if (translation.x > kSwipeThreshold) {
                    self.rightRibbon.backgroundColor = primaryColor;
                    self.rightRibbon.imageView.backgroundColor = primaryColor;
                } else {
                    self.rightRibbon.backgroundColor = tertiaryColor;
                    self.rightRibbon.imageView.backgroundColor = tertiaryColor;
                }
            } else {
                self.rightRibbon.backgroundColor = secondaryColor;
                self.rightRibbon.imageView.backgroundColor = secondaryColor;
            }
            CGPoint newRightCenter = CGPointMake(self.rightRibbon.originalCenter.x + translation.x, self.rightRibbon.originalCenter.y);
            [self.rightRibbon setCenter:(newRightCenter)];
        }
    }
}

- (void) reachabilityChanged:(NSNotification *) notification {
    if ([State isReachable]) {
        self.noConnection.hidden = YES;
    } else {
        self.noConnection.hidden = NO;
    }
}

@end
