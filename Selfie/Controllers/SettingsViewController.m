//
//  SettingsViewController.m
//  Selfie
//
//  Created by Daniel Suo on 7/18/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import "SettingsViewController.h"

#define rightActionSetting 0
#define leftActionSetting 1
#define otherSettings 2

#define rightActionEmail 0
#define leftActionEmail 1

#define subjectPrefix 2
#define signature 3

#define numberOfSections 3

@interface SettingsViewController ()
@property (strong, nonatomic) UITextField *leftEmailTextField;
@property (strong, nonatomic) UITextField *rightEmailTextField;
@property (strong, nonatomic) UITextField *subjectPrefixTextField;
@property (strong, nonatomic) UITextField *signatureTextField;

@property (nonatomic) CGPoint scrollViewOffset;
@property (nonatomic) CGFloat contentHeight;

@end

@implementation SettingsViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Settings";
    self.view = [[UIScrollView alloc] initWithFrame:self.view.frame];

    self.view.backgroundColor = [UIColor whiteColor];
    [self constructSettingsView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(didCompleteSettingsView)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(didCancelSettingsView)];
    
    [Radio addObserver:self
              selector:@selector(textFieldDidChange:)
                  name:UITextFieldTextDidChangeNotification
                object:nil];
    [Radio addObserver:self
              selector:@selector(textFieldDidEndEditing:)
                  name:UITextFieldTextDidEndEditingNotification
                object:nil];
    [Radio addObserver:self
              selector:@selector(keyboardDidShow:)
                  name:UIKeyboardDidShowNotification
                object:nil];
    [Radio addObserver:self
              selector:@selector(keyboardDidHide:)
                  name:UIKeyboardDidHideNotification
                object:nil];
    
    [Radio addObserver:self
              selector:@selector(constructSettingsView)
                  name:kSettingsViewNeedsUpdateNotification
                object:nil];
}

- (void) didCancelSettingsView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) didCompleteSettingsView {
    [Utilities setSettingsValue:self.rightEmailTextField.text forKey:kSettingsSwipeRightToEmailKey];
    [Utilities setSettingsValue:self.leftEmailTextField.text forKey:kSettingsSwipeLeftToEmailKey];
    [Utilities setSettingsValue:self.subjectPrefixTextField.text forKey:kSettingsSubjectPrefixKey];
    [Utilities setSettingsValue:self.signatureTextField.text forKey:kSettingsSignatureKey];
    
    // TODO: this is all wrong, but just collecting some info for now. This duplicates every time
    // a user hits 'Done' in settings.
    NSString *firebaseURL = [NSString stringWithFormat:@"%@%@", firebaseBaseURL, @"/signups"];
    Firebase *ref = [[Firebase alloc] initWithUrl:firebaseURL];
    Firebase *newRef = [ref childByAutoId];
    
    [newRef setValue:@{@"email": self.rightEmailTextField.text, @"created_at": [NSString stringWithFormat:@"%@", [NSDate date]]}];
    
    newRef = [ref childByAutoId];
    [newRef setValue:@{@"email": self.leftEmailTextField.text, @"created_at": [NSString stringWithFormat:@"%@", [NSDate date]]}];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) keyboardDidShow:(NSNotification *) notification {
    NSDictionary *info = [notification userInfo];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    ((UIScrollView *)self.view).contentSize = CGSizeMake(keyboardRect.size.width, self.contentHeight + keyboardRect.size.height);
}

- (void) keyboardDidHide:(NSNotification *) notification {
    NSDictionary *info = [notification userInfo];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    ((UIScrollView *)self.view).contentSize = CGSizeMake(keyboardRect.size.width, self.contentHeight);
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation) toInterfaceOrientation duration:(NSTimeInterval) duration {
    [self constructSettingsView];
}

- (void) constructSettingsView {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGSize size;
    
    if (UIDeviceOrientationIsPortrait(self.interfaceOrientation)) {
        size = screenRect.size;
    } else {
        size = CGSizeMake(screenRect.size.height, self.contentHeight);
    }
    
    CGFloat spacer = 10;
    
    UIView *view;
    self.contentHeight = 0;
    [[self.view subviews]
     makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    view = [self constructSectionHeaderWithFrame:CGRectMake(0, self.contentHeight, size.width, 25) withHeaderText:@"Swipe Right Action"];
    [self.view addSubview:view];
    
    self.contentHeight += view.frame.size.height;
    
    view = [self constructSectionRowWithFrame:CGRectMake(0, self.contentHeight, size.width, 40) withLabel:@"Mail to:" withDefaultText:[Utilities getSettingsValue:kSettingsSwipeRightToEmailKey] withPlaceholder:@"you@sendwithnoto.com" withKeyboardType:
            UIKeyboardTypeEmailAddress withTag:rightActionEmail];
    [self.view addSubview:view];
    
    self.contentHeight += view.frame.size.height + spacer;
    
    view = [self constructSectionHeaderWithFrame:CGRectMake(0, self.contentHeight, size.width, 25) withHeaderText:@"Swipe Left Action"];
    [self.view addSubview:view];
    
    self.contentHeight += view.frame.size.height;
    
    view = [self constructSectionRowWithFrame:CGRectMake(0, self.contentHeight, size.width, 40) withLabel:@"Mail to:" withDefaultText:[Utilities getSettingsValue:kSettingsSwipeLeftToEmailKey] withPlaceholder:@"you@sendwithnoto.com" withKeyboardType:
                                     UIKeyboardTypeEmailAddress withTag:leftActionEmail];
    [self.view addSubview:view];
    
    self.contentHeight += view.frame.size.height + spacer;
    
    view = [self constructSectionHeaderWithFrame:CGRectMake(0, self.contentHeight, size.width, 25) withHeaderText:@"Other Settings"];
    [self.view addSubview:view];
    
    self.contentHeight += view.frame.size.height;
    
    view = [self constructSectionRowWithFrame:CGRectMake(0, self.contentHeight, size.width, 40) withLabel:@"Prefix:" withDefaultText:[Utilities getSettingsValue:kSettingsSubjectPrefixKey] withPlaceholder:nil withKeyboardType:
            UIKeyboardTypeDefault withTag:subjectPrefix];
    [self.view addSubview:view];
    
    self.contentHeight += view.frame.size.height;
    
    view = [self constructSectionRowWithFrame:CGRectMake(0, self.contentHeight, size.width, 40) withLabel:@"Signature:" withDefaultText:[Utilities getSettingsValue:kSettingsSignatureKey] withPlaceholder:nil withKeyboardType:
                 UIKeyboardTypeDefault withTag:signature];
    [self.view addSubview:view];
    
    self.contentHeight += view.frame.size.height + spacer * 3;
    
    view = [self constructFeedback:CGRectMake(0, self.contentHeight, size.width, 40)];
    [self.view addSubview:view];
    
    self.contentHeight += view.frame.size.height;
    
    ((UIScrollView *) self.view).contentSize = CGSizeMake(size.width, self.contentHeight);
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    NSLog(@"tapped");
    return YES; // let the system open this URL
}

- (UIView *) constructFeedback:(CGRect) frame {
    UIView *view = [[UIView alloc] initWithFrame: frame];
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];

    textView.editable = NO;
    textView.scrollEnabled = NO;
    
    NSString *text = @"Please send all feedback to @SendWithNoto!\nMade by The Leather Apron Club.";
    NSMutableAttributedString *link = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange range = [text rangeOfString:@"@SendWithNoto"];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://user?screen_name=SendWithNoto"]]) {
        [link addAttribute:NSLinkAttributeName value:@"twitter://user?screen_name=SendWithNoto" range:range];
    } else {
        [link addAttribute:NSLinkAttributeName value:@"https://twitter.com/SendWithNoto" range:range];
    }
    [link addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:0.8 alpha:1.0] range:NSMakeRange(0, link.length)];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [link addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, link.length)];
    
    NSDictionary *linkAttributes = @{NSForegroundColorAttributeName: primaryColor,
                                     NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)};
    
    textView.textAlignment = NSTextAlignmentCenter;
    textView.linkTextAttributes = linkAttributes;
    textView.attributedText = link;
    textView.delegate = self;
    
    [view addSubview:textView];
    return view;
}

- (UIView *) constructTextRowWithFrame:(CGRect) frame
                              withText:(NSString *) text {
    UIView *view = [[UIView alloc] initWithFrame: frame];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    
    label.text = text;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithWhite:0.8f
                                        alpha:1.0f];
    
    label.textAlignment = NSTextAlignmentCenter;
    
    [view addSubview:label];
    
    return view;
}

- (UIView *) constructSectionRowWithFrame:(CGRect) frame
                                withLabel:(NSString *) labelText
                          withDefaultText:(NSString *) defaultText
                          withPlaceholder:(NSString *) placeholder
                         withKeyboardType:(UIKeyboardType) keyboardType
                                  withTag:(NSInteger) tag {
    CGFloat rowLabelInset = 10;
    CGFloat rowLabelWidth = 100;
    
    UIView *view = [[UIView alloc] initWithFrame: frame];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(rowLabelInset, 0, rowLabelWidth, frame.size.height)];
    
    label.text = labelText;
    label.textColor = primaryColor;
    label.font = [UIFont systemFontOfSize:18];
    label.textAlignment = NSTextAlignmentLeft;
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(rowLabelWidth + rowLabelInset, 0, frame.size.width - rowLabelWidth - rowLabelInset, frame.size.height)];
    
    textField.placeholder = placeholder;
    textField.text = defaultText;
    textField.font = [UIFont systemFontOfSize:18];
    textField.returnKeyType = UIReturnKeyDone;
    textField.keyboardType = keyboardType;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.tag = tag;
    textField.delegate = self;
    
    switch (textField.tag) {
        case rightActionEmail:
            self.rightEmailTextField = textField;
            textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            textField.autocorrectionType = UITextAutocorrectionTypeNo;
            break;
        case leftActionEmail:
            self.leftEmailTextField = textField;
            textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            textField.autocorrectionType = UITextAutocorrectionTypeNo;
            break;
        case subjectPrefix:
            self.subjectPrefixTextField = textField;
            break;
        case signature:
            self.signatureTextField = textField;
            break;
        default:
            break;
    }
    
    [view addSubview:label];
    [view addSubview:textField];
    
    return view;
}

- (UIView *) constructSectionHeaderWithFrame:(CGRect) frame withHeaderText:(NSString *) headerText {
    CGFloat headerLabelInset = 10;
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(headerLabelInset, 0, frame.size.width - headerLabelInset, frame.size.height)];
    
    label.text = headerText;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithWhite:0.8f
                                        alpha:1.0f];
    label.textAlignment = NSTextAlignmentLeft;
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0, view.frame.size.height, view.frame.size.width, 0.5f);
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                     alpha:1.0f].CGColor;
    
    [view addSubview:label];
    [view.layer addSublayer:bottomBorder];
    
//    CGRect myFrame = CGRectMake(0, 10.0f, size.width, 40.0f);
//    self.myLabel = [[UILabel alloc] initWithFrame:myFrame];
//    self.myLabel.text = @"Credits: LAC, RRE";
//    self.myLabel.font = [UIFont boldSystemFontOfSize:18.0f];
//    self.myLabel.textAlignment =  NSTextAlignmentLeft;
    
    return view;
}

- (void) textFieldDidBeginEditing:(UITextField *) textField {
//    self.scrollViewOffset = ((UIScrollView *) self.view).contentOffset;
//    CGPoint pt;
//    CGRect rc = [textField bounds];
//    rc = [textField convertRect:rc toView:((UIScrollView *) self.view)];
//    pt = rc.origin;
//    pt.x = 0;
//    pt.y -= 0   ;//textField.frame.size.height;
//    [((UIScrollView *) self.view) setContentOffset:pt animated:YES];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *) event{
    //hides keyboard when another part of layout was touched
    NSLog(@"touched");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (BOOL) textFieldShouldReturn:(UITextField *) textField {
//    [((UIScrollView *) self.view) setContentOffset:self.scrollViewOffset animated:YES];
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void) textFieldDidChange:(NSNotification *) notification {
    UITextField *textField = (UITextField *) notification.object;
    
    if ([Utilities isValidEmailString:textField.text] || [textField.text isEqualToString:@""] || textField.keyboardType != UIKeyboardTypeEmailAddress) {
        textField.layer.borderColor = [tertiaryColorLight CGColor];
        self.navigationItem.rightBarButtonItem.enabled = YES;
//        [UIView animateWithDuration:5 animations:^{
//            textField.textColor = [UIColor blackColor];
//        }];
        
        NSLog(@"valid");
    } else {
        textField.layer.borderColor = [secondaryColor CGColor];
        self.navigationItem.rightBarButtonItem.enabled = NO;
//        [UIView animateWithDuration:5 animations:^{
//            textField.textColor = secondaryColor;
//        }];
        NSLog(@"invalid");
    }
}

//Asks the delegate if editing should begin in the specified text field.
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}

//Tells the delegate that editing began for the specified text field.
//- (void)textFieldDidBeginEditing:(UITextField *)textField{

//    NSInteger i = textField.tag;
//    self.myLabel.text = [NSString stringWithFormat:@"Begin editing Text field %i", i];
    
//}

//Asks the delegate if editing should stop in the specified text field.
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    return YES;
}

//Tells the delegate that editing stopped for the specified text field.
- (void) textFieldDidEndEditing:(NSNotification *) notification {
    
//    UITextField *textField = (UITextField *) notification.object;
//    
//    switch (textField.tag) {
//        case rightActionEmail:
//            NSLog(@"finished right");
//            break;
//        case leftActionEmail:
//            NSLog(@"finished left");
//            break;
//        case subjectPrefix:
//            NSLog(@"finished subj");
//            break;
//        case signature:
//            NSLog(@"finished sig");
//            break;
//        default:
//            break;
//    }
//    NSInteger i = textField.tag;
//    self.myLabel.text = [NSString stringWithFormat:@"Editing done for Text field %i", i];
    
}


//Asks the delegate if the specified text should be changed.
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
//replacementString:(NSString *)string{

    //get the current data strsing inside the text field
//    NSString *myTextData = [textField.text stringByReplacingCharactersInRange:range
//                                                                   withString:string];
//    NSLog(@"Current data in text field is %@", myTextData);
//    NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
//    
    
//
//    //set the display label value with the current data in the text field
//    self.myLabel.text = [NSString stringWithFormat:@"Data: %@", textField.text];

//    return YES;
//}

//Asks the delegate if the text field’s current contents should be removed.
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    
    NSInteger i = textField.tag;
    NSLog(@"Text field %i just got cleared", i);
    return YES;
    
}

//Asks the delegate if the text field should process the pressing of the return button.
//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    
//    //Notifies the receiver that it has been asked to relinquish
//    //its status as first responder in its window.
//    [textField resignFirstResponder];
//    return YES;
//}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
