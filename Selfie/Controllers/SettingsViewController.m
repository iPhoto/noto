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
@property (nonatomic) BOOL validSettings;

@end

@implementation SettingsViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Settings";
    self.view = [[UIScrollView alloc] initWithFrame:self.view.frame];
    self.validSettings = YES;

    self.view.backgroundColor = [UIColor whiteColor];
    ((UIScrollView *) self.view).contentSize = CGSizeMake(self.view.frame.size.width, 1000);
    [self constructSettingsView:[[UIScreen mainScreen] bounds].size];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(didCompleteSettingsView)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(didCancelSettingsView)];

//    [Radio addObserver:self
//              selector:@selector(keyboardDidShow:)
//                  name:UIKeyboardDidShowNotification
//                object:nil];
//    
//    [Radio addObserver:self
//              selector:@selector(keyboardDidHide:)
//                  name:UIKeyboardDidHideNotification
//                object:nil];
    
    [Radio addObserver:self
              selector:@selector(textFieldDidChange:)
                  name:UITextFieldTextDidChangeNotification
                object:nil];
    [Radio addObserver:self
              selector:@selector(textFieldDidEndEditing:)
                  name:UITextFieldTextDidEndEditingNotification
                object:nil];
    
    //lets create 3 UITextViews on the screen
//    for (NSInteger i=1; i<20; i++) {
//        
//        //set the origin of the frame reference
//        myFrame.origin.y += myFrame.size.height + 10.0f;
//        //create the text field
//        self.myTextField = [[UITextField alloc] initWithFrame:myFrame];
//        //set the border style for the text view
////        self.myTextField.borderStyle = UITextBorderStyleRoundedRect;
//        self.myTextField.layer.borderColor = [tertiaryColorLight CGColor];
//        self.myTextField.layer.cornerRadius=8.0f;
//        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
//        self.myTextField.leftViewMode = UITextFieldViewModeAlways;
//        self.myTextField.leftView = leftView;
//        self.myTextField.layer.masksToBounds=YES;
//        self.myTextField.layer.borderWidth = 1;
//        
//        
//        
//        switch (i) {
//                
//            case 1:
//                //the vertical alignment of text within the frame, set this to center
//                self.myTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//                //the horizontal alignment of the text
//                self.myTextField.textAlignment = NSTextAlignmentLeft;
//                //set the type of the keyboard to display
//                self.myTextField.keyboardType = UIKeyboardTypeEmailAddress;
////                self.myTextField.leftViewMode = UITextFieldViewModeAlways;
//                self.myTextField.placeholder = @"you@example.com";
//                break;
//                
//            case 2:
//                self.myTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//                self.myTextField.textAlignment = NSTextAlignmentLeft;
//                self.myTextField.keyboardType = UIKeyboardTypeEmailAddress;
//                self.myTextField.placeholder = @"you@example.com";
//                break;
//            case 3:
//                self.myTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//                self.myTextField.textAlignment = NSTextAlignmentLeft;
//                self.myTextField.keyboardType = UIKeyboardTypeDefault;
//                break;
//                
//            default:
//                self.myTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//                self.myTextField.textAlignment = NSTextAlignmentLeft;
//                break;
//        }
//        
//        //display hint for the user data entry when the field is empty
//        
//        //add tag to identify your text views
//        self.myTextField.tag = i;
//        //display the clear button on the text field
//        self.myTextField.clearButtonMode = UITextFieldViewModeAlways;
//        //change the return key text to "Done"
//        self.myTextField.returnKeyType = UIReturnKeyDone;
//        //set the delegate for the text field to the view controller so that it can listen for events
//        self.myTextField.delegate = self;
        //add the text field to the current view
//        [self.view addSubview:self.myTextField];
//    }
    
}

- (void) didCancelSettingsView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) didCompleteSettingsView {
    if (self.validSettings) {
        [Utilities setSettingsValue:self.rightEmailTextField.text forKey:kSettingsSwipeRightToEmailKey];
        [Utilities setSettingsValue:self.leftEmailTextField.text forKey:kSettingsSwipeLeftToEmailKey];
        [Utilities setSettingsValue:self.subjectPrefixTextField.text forKey:kSettingsSubjectPrefixKey];
        [Utilities setSettingsValue:self.signatureTextField.text forKey:kSettingsSignatureKey];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//- (void) keyboardDidShow:(NSNotification *) notification {
//    NSDictionary *info = [notification userInfo];
//    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
//    
//    ((UIScrollView *)self.view).contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - keyboardRect.size.height);
//}
//
//- (void) keyboardDidHide:(NSNotification *) notification {
//    ((UIScrollView *)self.view).contentSize = self.view.frame.size;
//}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation) toInterfaceOrientation duration:(NSTimeInterval) duration {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    if (UIDeviceOrientationIsPortrait(toInterfaceOrientation))
    {
        [self constructSettingsView:screenRect.size];
    } else {
        [self constructSettingsView:CGSizeMake(screenRect.size.height, screenRect.size.width)];
    }
}

- (void) constructSettingsView:(CGSize) size {
    NSLog(@"%f %f", size.width, size.height);
    
    UIView *view;
    CGFloat nextHeight = 0;

    view = [self constructSectionHeaderWithFrame:CGRectMake(0, nextHeight, size.width, 40) withHeaderText:@"Swipe Right Action"];
    [self.view addSubview:view];
    
    nextHeight += view.frame.size.height;
    
    view = [self constructSectionRowWithFrame:CGRectMake(0, nextHeight, size.width, 40) withLabel:@"Mail to:" withDefaultText:[Utilities getSettingsValue:kSettingsSwipeRightToEmailKey] withPlaceholder:@"you@sendwithnoto.com" withKeyboardType:
            UIKeyboardTypeEmailAddress withTag:rightActionEmail];
    [self.view addSubview:view];
    
    nextHeight += view.frame.size.height;
    
    view = [self constructSectionHeaderWithFrame:CGRectMake(0, nextHeight, size.width, 40) withHeaderText:@"Swipe Left Action"];
    [self.view addSubview:view];
    
    nextHeight += view.frame.size.height;
    
    view = [self constructSectionRowWithFrame:CGRectMake(0, nextHeight, size.width, 40) withLabel:@"Mail to:" withDefaultText:[Utilities getSettingsValue:kSettingsSwipeLeftToEmailKey] withPlaceholder:@"you@sendwithnoto.com" withKeyboardType:
                                     UIKeyboardTypeEmailAddress withTag:leftActionEmail];
    [self.view addSubview:view];
    
    nextHeight += view.frame.size.height;
    
    view = [self constructSectionHeaderWithFrame:CGRectMake(0, nextHeight, size.width, 40) withHeaderText:@"Other Settings"];
    [self.view addSubview:view];
    
    nextHeight += view.frame.size.height;
    
    view = [self constructSectionRowWithFrame:CGRectMake(0, nextHeight, size.width, 40) withLabel:@"Subj. Prefix:" withDefaultText:[Utilities getSettingsValue:kSettingsSubjectPrefixKey] withPlaceholder:nil withKeyboardType:
            UIKeyboardTypeDefault withTag:subjectPrefix];
    [self.view addSubview:view];
    
    nextHeight += view.frame.size.height;
    
    view = [self constructSectionRowWithFrame:CGRectMake(0, nextHeight, size.width, 40) withLabel:@"Signature" withDefaultText:[Utilities getSettingsValue:kSettingsSignatureKey] withPlaceholder:nil withKeyboardType:
                 UIKeyboardTypeDefault withTag:signature];
    [self.view addSubview:view];
    
    nextHeight += view.frame.size.height;
    
    view = [self constructSectionHeaderWithFrame:CGRectMake(0, nextHeight, size.width, 40) withHeaderText:@"Made by the Leather Apron Club"];
    [self.view addSubview:view];
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
    label.textAlignment = NSTextAlignmentLeft;
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(rowLabelWidth + rowLabelInset, 0, frame.size.width - rowLabelWidth - rowLabelInset, frame.size.height)];
    
    textField.placeholder = placeholder;
    textField.text = defaultText;
    textField.returnKeyType = UIReturnKeyDone;
    textField.keyboardType = keyboardType;
    textField.tag = tag;
    
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
    label.textAlignment = NSTextAlignmentLeft;
    
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0, 0, view.frame.size.width, 0.5f);
    topBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                     alpha:1.0f].CGColor;
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0, view.frame.size.height, view.frame.size.width, 0.5f);
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                     alpha:1.0f].CGColor;
    
    [view addSubview:label];
    [view.layer addSublayer:topBorder];
    [view.layer addSublayer:bottomBorder];
    
//    CGRect myFrame = CGRectMake(0, 10.0f, size.width, 40.0f);
//    self.myLabel = [[UILabel alloc] initWithFrame:myFrame];
//    self.myLabel.text = @"Credits: LAC, RRE";
//    self.myLabel.font = [UIFont boldSystemFontOfSize:18.0f];
//    self.myLabel.textAlignment =  NSTextAlignmentLeft;
    
    return view;
}

- (void) textFieldDidBeginEditing:(UITextField *) textField {
    self.scrollViewOffset = ((UIScrollView *) self.view).contentOffset;
    CGPoint pt;
    CGRect rc = [textField bounds];
    rc = [textField convertRect:rc toView:((UIScrollView *) self.view)];
    pt = rc.origin;
    pt.x = 0;
    pt.y -= 0   ;//textField.frame.size.height;
    [((UIScrollView *) self.view) setContentOffset:pt animated:YES];
}

- (BOOL) textFieldShouldReturn:(UITextField *) textField {
    [((UIScrollView *) self.view) setContentOffset:self.scrollViewOffset animated:YES];
    [textField resignFirstResponder];
    return YES;
}

- (void) textFieldDidChange:(NSNotification *) notification {
    UITextField *textField = (UITextField *) notification.object;
    
    if ([Utilities isValidEmailString:textField.text] || [textField.text isEqualToString:@""] || textField.keyboardType != UIKeyboardTypeEmailAddress) {
        textField.layer.borderColor = [tertiaryColorLight CGColor];
        self.validSettings = YES;
        NSLog(@"valid");
    } else {
        textField.layer.borderColor = [secondaryColor CGColor];
        self.validSettings = NO;
        self.navigationItem.rightBarButtonItem.customView.alpha = 0.2;
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
    
    UITextField *textField = (UITextField *) notification.object;
    
    switch (textField.tag) {
        case rightActionEmail:
            NSLog(@"finished right");
            break;
        case leftActionEmail:
            NSLog(@"finished left");
            break;
        case subjectPrefix:
            NSLog(@"finished subj");
            break;
        case signature:
            NSLog(@"finished sig");
            break;
        default:
            break;
    }
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
