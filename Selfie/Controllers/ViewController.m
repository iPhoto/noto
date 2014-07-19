//
//  ViewController.m
//  Selfie
//
//  Created by Daniel Suo on 6/12/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(nonatomic, strong) NSMutableArray *assets;

@property (strong, nonatomic) NoteView *noteView;
@property (strong, nonatomic) NoteRibbonView *leftRibbon;
@property (strong, nonatomic) NoteRibbonView *rightRibbon;
@property (strong, nonatomic) NoteStatusView *statusView;
@property (strong, nonatomic) NoteAttachmentCollectionView *attachmentCollectionView;
@property (strong, nonatomic) NoteProgressView *progressView;
@property (strong, nonatomic) UIImage *imageAttachment;

@property (strong, nonatomic) AttachmentBarButtonItem *attachmentBarButtonItem;
@property (strong, nonatomic) CameraBarButtonItem *cameraBarButtonItem;
@property (strong, nonatomic) SettingsBarButtonItem *settingsBarButtonItem;
@property (strong, nonatomic) UnsentBarButtonItem *unsentBarButtonItem;
@end

@implementation ViewController

- (void) initNote {
    self.noteView.text = nil;
    self.navigationItem.title = kEmptyNoteSubject;
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

- (NoteAttachmentCollectionView *) attachmentCollectionView {
    if (!_attachmentCollectionView) {
        _attachmentCollectionView = [[NoteAttachmentCollectionView alloc] init];
    }
    
    return _attachmentCollectionView;
}

- (AttachmentBarButtonItem *) attachmentBarButtonItem {
    if (!_attachmentBarButtonItem) {
        _attachmentBarButtonItem = [[AttachmentBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_add_attachment"]];
    }
    
    return _attachmentBarButtonItem;
}

- (CameraBarButtonItem *) cameraBarButtonItem {
    if (!_cameraBarButtonItem) {
        _cameraBarButtonItem = [[CameraBarButtonItem alloc] init];
    }
    return _cameraBarButtonItem;
}

- (SettingsBarButtonItem *) settingsBarButtonItem {
    if (!_settingsBarButtonItem) {
        _settingsBarButtonItem = [[SettingsBarButtonItem alloc] init];
    }
    return _settingsBarButtonItem;
}


- (UnsentBarButtonItem *) unsentBarButtonItem {
    if (!_unsentBarButtonItem) {
        _unsentBarButtonItem = [[UnsentBarButtonItem alloc] init];
    }
    return _unsentBarButtonItem;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self onFirstLaunch];
    
    [self getPhotoLibrary];
    
    [self.noteView becomeFirstResponder];
    
    [self.view addSubview:self.noteView];
    [self.view addSubview:self.attachmentCollectionView];
    [self.view addSubview:self.statusView];
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.leftRibbon];
    [self.view addSubview:self.rightRibbon];
    
    [self.attachmentBarButtonItem setAction:@selector(toggleAttachmentCollectionView) withTarget:self];
    
    [self.cameraBarButtonItem setAction:@selector(takePhoto:) withTarget:self];
    self.cameraBarButtonItem.customView.hidden = YES;
    
    // TODO: create unsent viewcontroller
    self.unsentBarButtonItem.customView.hidden = YES;
    
    [self.settingsBarButtonItem setAction:@selector(showSettings:) withTarget:self];
    
    SpacerBarButtonItem *spacer = [[SpacerBarButtonItem alloc] init];
    [self.navigationItem setRightBarButtonItems:@[self.attachmentBarButtonItem, spacer, self.cameraBarButtonItem]];
    [self.navigationItem setLeftBarButtonItems:@[self.settingsBarButtonItem, spacer, self.unsentBarButtonItem]];
    
    self.noteView.delegate = self;
    self.noteView.noteViewDelegate = self;
    
    self.attachmentCollectionView.dataSource = self;
    self.attachmentCollectionView.delegate = self;
    
    [Radio addObserver:self
              selector:@selector(keyboardWillShow:)
                  name:UIKeyboardWillShowNotification
                object:nil];
    
    [Radio addObserver:self
              selector:@selector(keyboardDidShow:)
                  name:UIKeyboardDidShowNotification
                object:nil];
    
    [Radio addObserver:self
              selector:@selector(reachabilityChanged:)
                  name:kReachabilityChangedNotification
                object:nil];
    
    [Radio addObserver:self
              selector:@selector(reloadAttachmentCollectionView:)
                  name:kEnumerateGroupCompleteNotification
                object:nil];
}

- (void) toggleAttachmentCollectionView {
    [self dismissAutocorrectSuggestionForNoteView];
    
    if (self.attachmentBarButtonItem.attachmentBarOpen) {
        [self hideAttachmentCollectionView];
    } else {
        [self showAttachmentCollectionView];
    }
}

- (void) hideAttachmentCollectionView {
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.attachmentBarButtonItem.toggleAnimationBlock();
        self.cameraBarButtonItem.hideAnimationBlock();
        self.attachmentCollectionView.hideAnimationBlock();
        self.noteView.shiftUpAnimationBlock();
    } completion:^(BOOL finished) {
        self.cameraBarButtonItem.hideCompletionBlock(finished);
        self.unsentBarButtonItem.hideCompletionBlock(finished);
    }];
}

- (void) showAttachmentCollectionView {
    [self getPhotoLibrary];
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.attachmentBarButtonItem.toggleAnimationBlock();
        self.cameraBarButtonItem.showAnimationBlock();
        self.attachmentCollectionView.showAnimationBlock();
        self.noteView.shiftDownAnimationBlock();
    } completion:nil];
}

- (void) resetAttachmentBarButtonItem {
    [UIView animateWithDuration:0.25 animations:^{
        ((ImageBarButtonItem *)self.navigationItem.rightBarButtonItems[0]).customView.alpha = 0;
    } completion:^(BOOL finished) {
        SpacerBarButtonItem *spacer = [[SpacerBarButtonItem alloc] init];
        self.navigationItem.rightBarButtonItems = @[self.attachmentBarButtonItem, spacer, self.cameraBarButtonItem];
        ((AttachmentBarButtonItem *)self.navigationItem.rightBarButtonItems[0]).customView.alpha = 0;
        [UIView animateWithDuration:0.25 animations:^{
            self.attachmentBarButtonItem.showAnimationBlock();
        }];
    }];
}

- (void) setImageBarButtonItemWithImage:(UIImage *) image withAction:(SEL) action {
    [UIView animateWithDuration:0.25 animations:^{
        self.attachmentBarButtonItem.hideAnimationBlock();
        self.attachmentBarButtonItem.toggleAnimationBlock();
        
        self.cameraBarButtonItem.hideAnimationBlock();
        self.unsentBarButtonItem.hideAnimationBlock();
        self.attachmentCollectionView.hideAnimationBlock();
        self.noteView.shiftUpAnimationBlock();
    } completion:^(BOOL finished) {
        self.cameraBarButtonItem.hideCompletionBlock(finished);
        self.unsentBarButtonItem.hideCompletionBlock(finished);
        ImageBarButtonItem *imageBarButtonItem = [[ImageBarButtonItem alloc] initWithImage:image];
        [imageBarButtonItem setAction:action withTarget:self];
        SpacerBarButtonItem *spacer = [[SpacerBarButtonItem alloc] init];
        self.navigationItem.rightBarButtonItems = @[imageBarButtonItem, spacer, self.cameraBarButtonItem];
        
        [UIView animateWithDuration:0.25 animations:^{
            imageBarButtonItem.showAnimationBlock();
        }];
    }];
}

- (void) showSettings:(UIButton *) sender {
    SettingsViewController *settings = [[SettingsViewController alloc] init];
    [self.navigationController pushViewController:settings animated:YES];
}

- (void) reloadAttachmentCollectionView:(NSNotification*) notification {
    
    // reloadData after receive the notification
    [_attachmentCollectionView reloadData];
}
- (void) onFirstLaunch {
    if([Utilities isFirstLaunch]) {
        self.noteView.text = [Utilities getFirstLaunchText];
        
        self.navigationItem.title = kEmptyNoteSubject;
        
        // Now that we've shown the first launch text,
        // save that they've launched before
        [Utilities setSettingsValue:@"notFirstLaunch" forKey:kHasLaunchedBeforeKey];
    }
}

- (void) scrollViewDidScroll:(UIScrollView *) scrollView{
    
    // Depending on how far the user scrolled, set the new offset.
    // Divide by a hundred so we have a sane value. You could adjust this
    // for different effects.
    // The larger you number divide by, the slower the shadow will change
    
    float shadowOffset = (scrollView.contentOffset.y / 100);
    
    // Make sure that the offset doesn't exceed 3 or drop below 0.5
    shadowOffset = MIN(MAX(shadowOffset, 0.25), 1.25);
    
    //Ensure that the shadow radius is between 1 and 3
    float shadowRadius = MIN(MAX(shadowOffset, 1), 2.5);
    
    //apply the offset and radius
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, shadowOffset);
    self.navigationController.navigationBar.layer.shadowRadius = shadowRadius;
    self.navigationController.navigationBar.layer.shadowColor = [UIColor blackColor].CGColor;
    self.navigationController.navigationBar.layer.shadowOpacity = 0.6;
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
        self.navigationItem.title = kEmptyNoteSubject;
        [Radio postNotificationName:kEmptyNoteNotification object:nil];
    } else {
        self.navigationItem.title = [Note getNoteSubject:self.noteView.text];
        [Radio postNotificationName:kUpdateSubjectNotification object:nil];
    }
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
    
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    CGRect statusBarWindowRect = [self.view.window convertRect:statusBarFrame fromWindow: nil];
    CGRect statusBarViewRect = [self.view convertRect:statusBarWindowRect fromView: nil];
    CGFloat statusBarHeight = statusBarViewRect.size.height;
    
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    
    CGFloat offset = self.attachmentCollectionView.isShown ? 0 : kNoteAttachmentCollectionViewHeight;
    
    self.attachmentCollectionView.frame = CGRectMake(0, statusBarHeight + navBarHeight - offset, keyboardRect.size.width, kNoteAttachmentCollectionViewHeight);
}

- (void) keyboardDidShow:(NSNotification *) notification {
    NSDictionary *info = [notification userInfo];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    self.noteView.panGestureRecognizer.enabled = YES;
    
    UIEdgeInsets inset = self.noteView.contentInset;
    inset.bottom = keyboardRect.size.height;
    if (self.statusView.hidden == NO) {
        inset.bottom += kStatusViewHeight;
    }
    self.noteView.contentInset = inset;
    self.noteView.scrollIndicatorInsets = inset;
    
    [self scrollToCaretInTextView:self.noteView animated:YES];
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
            self.imageAttachment = nil;
            [self resetAttachmentBarButtonItem];
        }
        
        [note send];
    }
    
    [self initNote];
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

- (void)dismissAutocorrectSuggestionForNoteView {
    NSRange rangeCopy = self.noteView.selectedRange;
    NSString *textCopy = self.noteView.text.copy;
    [self.noteView resignFirstResponder];
    [self.noteView becomeFirstResponder];
    [self.noteView setText:textCopy];
    [self.noteView setSelectedRange:rangeCopy];
}

- (void) takePhoto:(UIButton *) sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void) imagePickerController:(UIImagePickerController *) picker didFinishPickingMediaWithInfo:(NSDictionary *) info {
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    self.imageAttachment = [Utilities compressImageWithImage:chosenImage];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self setImageBarButtonItemWithImage:self.imageAttachment
                                  withAction:@selector(showAttachmentAlertView:)];
        [self.noteView becomeFirstResponder];
    }];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
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

- (void) alertView:(UIAlertView *) alertView clickedButtonAtIndex:(NSInteger) buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"user pressed Cancel");
    } else {
        [self resetAttachmentBarButtonItem];
    }
}

- (void) navigationController:(UINavigationController *) navigationController willShowViewController:(UIViewController *) viewController animated:(BOOL)animated {
    // TODO: refactor into utilities
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[UINavigationBar appearance] setBarTintColor:primaryColor];
    navigationController.navigationBar.tintColor = [UIColor whiteColor];
    navigationController.navigationBar.translucent = NO;
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *) collectionView {
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assets.count;
}

- (CGSize) collectionView:(UICollectionView *) collectionView layout:(UICollectionViewLayout*) collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *) indexPath {
    return CGSizeMake(kNoteAttachmentCollectionViewCellDim, kNoteAttachmentCollectionViewCellDim);
}

- (UICollectionViewCell *) collectionView:(UICollectionView *) collectionView cellForItemAtIndexPath:(NSIndexPath *) indexPath {
    NotePhotoCell *cell = (NotePhotoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];

    ALAsset *asset = self.assets[indexPath.row];
    cell.asset = asset;
    
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    return cell;
}

- (CGFloat) collectionView:(UICollectionView *) collectionView layout:(UICollectionViewLayout *) collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger) section {
    return kNoteAttachmentCollectionViewBorder;
}
                       
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // If you need to use the touched cell, you can retrieve it like so
    NotePhotoCell *cell = (NotePhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    self.imageAttachment = [UIImage imageWithCGImage:[[cell.asset defaultRepresentation] fullScreenImage]];
    [self setImageBarButtonItemWithImage:self.imageAttachment
                              withAction:@selector(showAttachmentAlertView:)];
}

- (void) getPhotoLibrary {
    _assets = [@[] mutableCopy];
    // 1
    ALAssetsLibrary *assetsLibrary = [Utilities defaultAssetsLibrary];
    // 2
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *innerStop) {
            if(result)
            {
                // 3
                [_assets addObject:result];
            }
        }];
        [Radio postNotificationName:kEnumerateGroupCompleteNotification object:nil];
    } failureBlock:^(NSError *error) {
        NSLog(@"Error loading images %@", error);
    }];
}

@end