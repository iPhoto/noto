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
@property (strong, nonatomic) NoteStatusView *statusView;
@property (strong, nonatomic) NoteAttachmentView *attachmentView;
@property (strong, nonatomic) NoteProgressView *progressView;
@property (strong, nonatomic) UIImage *imageAttachment;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *attachmentBarButtonItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *settingsBarButtonItem;
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

- (UIProgressView *) progressView {
    if (!_progressView) {
        _progressView = [[NoteProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    }
    return _progressView;
}

- (NoteRibbonView *) leftRibbon {
    if (!_leftRibbon) {
        _leftRibbon = [[NoteRibbonView alloc] init];
        _leftRibbon.textView.textAlignment = NSTextAlignmentLeft;
        _leftRibbon.direction = SwipeDirectionLeft;
    }
    return _leftRibbon;
}

- (NoteRibbonView *) rightRibbon {
    if (!_rightRibbon) {
        _rightRibbon = [[NoteRibbonView alloc] init];
        _rightRibbon.textView.textAlignment = NSTextAlignmentRight;
        _rightRibbon.direction = SwipeDirectionRight;
    }
    return _rightRibbon;
}

- (NoteStatusView *) statusView {
    if (!_statusView) {
        _statusView = [[NoteStatusView alloc] init];
    }
    
    return _statusView;
}

- (NoteAttachmentView *) attachmentView {
    if (!_attachmentView) {
        _attachmentView = [[NoteAttachmentView alloc] init];
    }
    
    return _attachmentView;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    [self onFirstLaunch];
    
    [self.noteView becomeFirstResponder];
    
    [self.view addSubview:self.noteView];
    [self.view addSubview:self.attachmentView];
    [self.view addSubview:self.statusView];
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.leftRibbon];
    [self.view addSubview:self.rightRibbon];
    
    self.noteView.delegate = self;
    self.noteView.noteViewDelegate = self;
    
    [self.attachmentBarButtonItem setTarget:self];
    [self.attachmentBarButtonItem setAction:@selector(selectPhoto:)];
    
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
              selector:@selector(keyboardWillHide:)
                  name:UIKeyboardWillHideNotification
                object:nil];
    
    [Radio addObserver:self
              selector:@selector(sendSuccess:)
                  name:kNoteSendSuccessNotification
                object:nil];
    
    [Radio addObserver:self
              selector:@selector(sendFailure:)
                  name:kNoteSendFailNotification
                object:nil];
    
    [Radio addObserver:self
              selector:@selector(reachabilityChanged:)
                  name:kReachabilityChangedNotification
                object:nil];
    
    [Radio addObserver:self
              selector:@selector(progressUpdated:)
                  name:kStatusProgress
                object:nil];
}

- (void) onFirstLaunch {
    if([Utilities isFirstLaunch]) {
        self.noteView.text = [Utilities getFirstLaunchText];
        
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
    
    if ([Utilities isEmptyString:self.noteView.text]) {
        self.navBarTitle.title = kEmptyNoteSubject;
        [Radio postNotificationName:kEmptyNoteNotification object:nil];
    } else {
        self.navBarTitle.title = [Note getNoteSubject:self.noteView.text];
        [Radio postNotificationName:kUpdateSubjectNotification object:nil];
    }
}

- (void) keyboardIsUp:(NSNotification *) notification {
    NSDictionary *info = [notification userInfo];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    UIEdgeInsets inset = self.noteView.contentInset;
    inset.bottom = keyboardRect.size.height;
    if (self.statusView.hidden == NO) {
        inset.bottom += kStatusViewHeight;
    }
    self.noteView.contentInset = inset;
    self.noteView.scrollIndicatorInsets = inset;
    
    [self scrollToCaretInTextView:self.noteView animated:YES];
}

- (void) keyboardWillHide:(NSNotification *) notification {
}

- (void) keyboardDidHide:(NSNotification *) notification {
}

- (void) keyboardWillShow:(NSNotification *) notification {
    NSDictionary *info = [notification userInfo];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    self.noteView.panGestureRecognizer.enabled = NO;
    
    [self.leftRibbon updateFrameToKeyboard:keyboardRect];
    [self.rightRibbon updateFrameToKeyboard:keyboardRect];
    [self.statusView updateFrameToKeyboard:keyboardRect];
    [self.progressView updateFrameToKeyboard:keyboardRect];
}

- (void) keyboardDidShow:(NSNotification *) notification {
    self.noteView.panGestureRecognizer.enabled = YES;
}

- (void) didPan:(UIPanGestureRecognizer *) gestureRecognizer {
    // TODO: Refactor and delegate to viewcontroller
    NoteView *noteView = (NoteView *) gestureRecognizer.view;
    CGPoint translation = [gestureRecognizer translationInView:noteView];

    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self.leftRibbon.textView setText:[State getRibbonText:noteView.text withDirection:SwipeDirectionLeft withAttachment:self.imageAttachment]];
        [self.leftRibbon.imageView setImage:[State getRibbonImage:noteView.text withDirection:SwipeDirectionLeft withAttachment:self.imageAttachment]];
        
        [self.rightRibbon.textView setText:[State getRibbonText:noteView.text withDirection:SwipeDirectionRight withAttachment:self.imageAttachment]];
        [self.rightRibbon.imageView setImage:[State getRibbonImage:noteView.text withDirection:SwipeDirectionRight withAttachment:self.imageAttachment]];
        
        [State state].isValidSendLeft = [State isValidSend:noteView.text withDirection:SwipeDirectionLeft withAttachment:self.imageAttachment];
        [State state].isValidSendRight = [State isValidSend:noteView.text withDirection:SwipeDirectionRight withAttachment:self.imageAttachment];
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        // TODO: make sure send gesture and view gesture are identical; don't want users to be confused
        if (abs(translation.x) > abs(translation.y) && abs(translation.x) > kSwipeThreshold) {
            // TODO: Refactor into state class
            if (translation.x > 0 && [State state].isValidSendRight) {
                [self didPanInDirection:SwipeDirectionRight];
                [State state].isValidSendRight = NO;
            } else if (translation.x < 0 && [State state].isValidSendLeft) {
                [self didPanInDirection:SwipeDirectionLeft];
                [State state].isValidSendLeft = NO;
            }
        }
        
        [self.leftRibbon finalizePosition];
        [self.rightRibbon finalizePosition];
    } else {
        if (abs(translation.x) < self.view.frame.size.width) {
            [self.rightRibbon setColorWithPastTheshold:(translation.x > kSwipeThreshold) validSend:([State state].isValidSendRight)];
            [self.rightRibbon panWithTranslation:translation];
            
            [self.leftRibbon setColorWithPastTheshold:(translation.x < -kSwipeThreshold) validSend:([State state].isValidSendLeft)];
            [self.leftRibbon panWithTranslation:translation];
        }
    }
}

- (void) didPanInDirection:(SwipeDirection) direction {
    Note *note = [[Note alloc] initWithString:self.noteView.text direction:direction];
    
    if (note) {
        [self.progressView send];
        
        if (self.imageAttachment) {
            note.image = self.imageAttachment;
            [self resetAttachmentBarButtonItem];
        }
        
        [note send];
    }
    
    [self initNote];
}

- (void) resetAttachmentBarButtonItem {
    self.imageAttachment = nil;
    [self setAttachmentBarButtonItem:self.attachmentBarButtonItem withImage:[UIImage imageNamed:@"icon_camera"] withAction:@selector(selectPhoto:)];
}

- (void)setAttachmentBarButtonItem:(UIBarButtonItem *) attachmentBarButtonItem withImage:(UIImage *) image withAction:(SEL) action {
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.navigationItem.rightBarButtonItem.customView.alpha = 0;
    } completion:^(BOOL finished){
        if (finished) {
            // TODO: refactor into Utilities
            UIButton *imageAttachmentView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
            [imageAttachmentView addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
            [imageAttachmentView setBackgroundImage:image forState:UIControlStateNormal];
            
            self.attachmentBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:imageAttachmentView];
            [self.navigationItem setRightBarButtonItem:self.attachmentBarButtonItem];
            self.navigationItem.rightBarButtonItem.customView.alpha = 0;
            
            [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.navigationItem.rightBarButtonItem.customView.alpha = 1;
            } completion:^(BOOL finished) {
                [self.navigationItem setRightBarButtonItem:self.attachmentBarButtonItem];
            }];
        }
    }];
}

- (void) reachabilityChanged:(NSNotification *) notification {
    if ([State isReachable]) {
        [self.statusView hide];
    } else {
        self.statusView.backgroundColor = tertiaryColor;
        self.statusView.text = kStatusNoConnection;
        [self.statusView show];
    }
}

- (void) sendSuccess:(NSNotification *) notification {
}

- (void) sendFailure:(NSNotification *) notification {
    // TODO: refactor as [self.statusView flashWithMessage:(NSString *) message withColor:(UIColor *) color];
//    if ([State isReachable]) {
//        self.statusView.hidden = NO;
//        self.statusView.backgroundColor = secondaryColor;
//        self.statusView.text = @"Failure!";
//        [self.statusView hideWithDelay:0.5];
//    }
}

- (void) takePhoto:(UIButton *) sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void) selectPhoto:(UIButton *) sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];

    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void) imagePickerController:(UIImagePickerController *) picker didFinishPickingMediaWithInfo:(NSDictionary *) info {
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    self.imageAttachment = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self setAttachmentBarButtonItem:self.attachmentBarButtonItem withImage:chosenImage withAction:@selector(showAttachmentAlertView:)];
        [self.noteView becomeFirstResponder];
    }];
}

- (void) showAttachmentAlertView:(UIButton *) sender {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Remove attachment?"
                          message: nil
                          delegate: self
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:@"Remove", nil];
    
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"user pressed Cancel");
    } else {
        [self resetAttachmentBarButtonItem];
    }
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        [self.noteView becomeFirstResponder];
    }];
}

- (void) navigationController:(UINavigationController *) navigationController willShowViewController:(UIViewController *) viewController animated:(BOOL)animated
{
    // TODO: refactor into utilities
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[UINavigationBar appearance] setBarTintColor:primaryColor];
    navigationController.navigationBar.tintColor = [UIColor whiteColor];
    navigationController.navigationBar.translucent = NO;
}

- (void) progressUpdated:(NSNotification *) notification {
    // Use actual upload progress
    // NSDictionary *dict = [notification userInfo];
    // [self.progressView setProgress:[[dict valueForKeyPath:kStatusProgress] floatValue] animated:YES];
}

@end
