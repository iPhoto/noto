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
    
    UIView *square = [[UIView alloc] initWithFrame:CGRectMake(0, 50, 40, 40)];
    square.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.noteView];
    [self.view addSubview:self.attachmentView];
    [self.view addSubview:self.statusView];
    [self.view addSubview:self.leftRibbon];
    [self.view addSubview:self.rightRibbon];
    
    self.noteView.delegate = self;
    self.noteView.noteViewDelegate = self;
    
    [self.attachmentView.takePhotoButton addTarget:self action:@selector(selectPhoto:) forControlEvents:UIControlEventTouchUpInside];
    
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
              selector:@selector(sendSuccess:)
                  name:kNoteSendSuccessNotification
                object:nil];
    
    [Radio addObserver:self
              selector:@selector(sendFailure:)
                  name:kNoteSendFailNotification
                object:nil];
    
    [self.noteView becomeFirstResponder];
}

- (void) viewWillAppear:(BOOL)animated {
    [Radio addObserver:self
              selector:@selector(reachabilityChanged:)
                  name:kReachabilityChangedNotification
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

- (void) keyboardIsUp:(NSNotification *) notification
{
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

- (void) keyboardWillShow:(NSNotification *) notification {
    NSDictionary *info = [notification userInfo];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    self.noteView.panGestureRecognizer.enabled = NO;
    
    [self.leftRibbon updateFrameToKeyboard:keyboardRect];
    [self.rightRibbon updateFrameToKeyboard:keyboardRect];
    [self.statusView updateFrameToKeyboard:keyboardRect];
    [self.attachmentView updateFrameToKeyboard:keyboardRect withNavBarHeight:self.navigationController.navigationBar.frame.size.height];
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
//        [self.leftRibbon.imageView setImage:[State getRibbonImage:noteView.text withDirection:SwipeDirectionLeft]];
        
        [self.rightRibbon.textView setText:[State getRibbonText:noteView.text withDirection:SwipeDirectionRight]];
        [self.rightRibbon.imageView setImage:[State getRibbonImage:noteView.text withDirection:SwipeDirectionRight]];
        
        [State state].isValidSendLeft = [State isValidSend:noteView.text withDirection:SwipeDirectionLeft];
        [State state].isValidSendRight = [State isValidSend:noteView.text withDirection:SwipeDirectionRight];
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
        if ([State isReachable]) {
            self.statusView.backgroundColor = tertiaryColor;
            self.statusView.text = kStatusSendingNote;
            [self.statusView show];
        }
        [note send];
    }
    
    [self initNote];
}

- (void) reachabilityChanged:(NSNotification *) notification {
    if ([State isReachable]) {
        [self.statusView hide];
        self.statusView.text = @"";
    } else {
        self.statusView.backgroundColor = tertiaryColor;
        self.statusView.text = kStatusNoConnection;
        [self.statusView show];
    }
}

- (void) sendSuccess:(NSNotification *) notification {
    if ([State isReachable]) {
        self.statusView.backgroundColor = primaryColor;
        self.statusView.text = @"Success!";
        [self.statusView hideWithDelay:0.5];
    }
}

- (void) sendFailure:(NSNotification *) notification {
    if ([State isReachable]) {
        self.statusView.backgroundColor = secondaryColor;
        self.statusView.text = @"Failure!";
        [self.statusView hideWithDelay:0.5];
    }
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
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.leftRibbon.imageView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self.noteView becomeFirstResponder];
    }];

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

@end
