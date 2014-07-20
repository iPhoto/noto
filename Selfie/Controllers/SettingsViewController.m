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
#define leftActionEmail 0

#define subjectPrefix 0
#define signature 1

#define numberOfSections 3

@interface SettingsViewController ()
//@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UITextFieldLabel *leftEmailTextFieldLabel;
@property (strong, nonatomic) UITextField *leftEmailTextField;
@property (strong, nonatomic) UITextFieldLabel *rightEmailTextFieldLabel;
@property (strong, nonatomic) UITextField *rightEmailTextField;
@property (nonatomic, strong) UITextField *myTextField;
@property (nonatomic, strong) UILabel *myLabel;


@property (nonatomic) CGPoint scrollViewOffset;

@property (strong, nonatomic) NSArray *bugs;
@property (strong, nonatomic) NSArray *animals;

@property (strong, nonatomic) NSArray *sectionHeaders;

@end

// TODO: Add settings validity

@implementation SettingsViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.bugs = @[@"Spider",@"Ladybug",@"Firefly"];
    self.animals = @[@"Cat",@"Dog",@"Bigfoot"];
    
    self.title = @"Settings";
    self.view = [[UIScrollView alloc] initWithFrame:self.view.frame];
    
//    [self.tableView registerClass:[SettingsTextFieldCell class] forCellReuseIdentifier:@"settingsCellIdentifier"];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.view addSubview:self.tableView];

    self.view.backgroundColor = [UIColor whiteColor];
    ((UIScrollView *) self.view).contentSize = CGSizeMake(self.view.frame.size.width, 1000);
    [self constructSettingsView:[[UIScreen mainScreen] bounds].size];
    
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
    
//    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
//    CGRect statusBarWindowRect = [self.view.window convertRect:statusBarFrame fromWindow: nil];
//    CGRect statusBarViewRect = [self.view convertRect:statusBarWindowRect fromView: nil];
//    CGFloat statusBarHeight = statusBarViewRect.size.height;
//    
//    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
//    
//    
}

- (void) constructSettingsView:(CGSize) size {
    NSLog(@"%f %f", size.width, size.height);
    
    UIView *view;
    CGFloat nextHeight = 0;

    view = [self constructSectionHeaderWithFrame:CGRectMake(0, nextHeight, size.width, 40) withHeaderText:@"Swipe Left Action"];
    [self.view addSubview:view];
    
    nextHeight += view.frame.size.height;
    
    view = [self constructSectionRowWithFrame:CGRectMake(0, nextHeight, size.width, 40) withLabel:@"Mail to:" withDefaultText:nil withPlaceholder:@"you@sendwithnoto.com" withTag:rightActionEmail];
    [self.view addSubview:view];
    
    nextHeight += view.frame.size.height;
    
    view = [self constructSectionHeaderWithFrame:CGRectMake(0, nextHeight, size.width, 40) withHeaderText:@"Swipe Right Action"];
    [self.view addSubview:view];
    
    nextHeight += view.frame.size.height;
    
    view = [self constructSectionRowWithFrame:CGRectMake(0, nextHeight, size.width, 40) withLabel:@"Mail to:" withDefaultText:nil withPlaceholder:@"you@sendwithnoto.com" withTag:leftActionEmail];
    [self.view addSubview:view];
    
    nextHeight += view.frame.size.height;
    
    view = [self constructSectionHeaderWithFrame:CGRectMake(0, nextHeight, size.width, 40) withHeaderText:@"Other Settings"];
    [self.view addSubview:view];
    
    nextHeight += view.frame.size.height;
    
    view = [self constructSectionRowWithFrame:CGRectMake(0, nextHeight, size.width, 40) withLabel:@"Subj. Prefix:" withDefaultText:@"[Noto]" withPlaceholder:nil withTag:subjectPrefix];
    [self.view addSubview:view];
    
    nextHeight += view.frame.size.height;
    
    view = [self constructSectionRowWithFrame:CGRectMake(0, nextHeight, size.width, 40) withLabel:@"Signature" withDefaultText:@"Sent with Noto" withPlaceholder:nil withTag:signature];
    [self.view addSubview:view];
    
    nextHeight += view.frame.size.height;
    
    view = [self constructSectionHeaderWithFrame:CGRectMake(0, nextHeight, size.width, 40) withHeaderText:@"Made by the Leather Apron Club"];
    [self.view addSubview:view];
}

- (UIView *) constructSectionRowWithFrame:(CGRect) frame
                                withLabel:(NSString *) labelText
                          withDefaultText:(NSString *) defaultText
                          withPlaceholder:(NSString *) placeholder
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

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView {
    return numberOfSections;
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
//    return 3;
    switch (section){
        case rightActionSetting:
            return 1;
            break;
        case leftActionSetting:
            return 1;
            break;
        case otherSettings:
            return 2;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
    SettingsTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingsCellIdentifier"];

    switch (indexPath.section) {
        case rightActionSetting:
            cell.leftLabel.text = @"Mail to:";
            cell.rightTextField.placeholder = @"you@sendwithnoto.com";
            cell.rightTextField.tag = rightActionEmail;
            break;
        case leftActionSetting:
            cell.leftLabel.text = @"Mail to:";
            cell.rightTextField.placeholder = @"you@sendwithnoto.com";
            cell.rightTextField.tag = leftActionEmail;
            break;
        case otherSettings:
            switch (indexPath.row) {
                case subjectPrefix:
                    cell.leftLabel.text = @"Subj. Prefix:";
                    cell.rightTextField.text = @"[Noto]";
                    cell.rightTextField.tag = subjectPrefix;
                    break;
                case signature:
                    cell.leftLabel.text = @"Signature:";
                    cell.rightTextField.text = @"Sent with Noto";
                    cell.rightTextField.tag = signature;
                    break;
                default:
                    break;
            }
            break;
        default:
            return cell;
            break;
    }
    
    return cell;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger) section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.frame.size.width,20)];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, headerView.frame.size.width, headerView.frame.size.height)];
    
    headerLabel.textAlignment = NSTextAlignmentLeft;
    
    headerLabel.textColor = [UIColor lightGrayColor];
    headerLabel.font = [UIFont systemFontOfSize:14];
    
    switch (section){
        case rightActionSetting:
            headerLabel.text = @"Swipe right action";
            break;
        case leftActionSetting:
            headerLabel.text = @"Swipe left action";
            break;
        case otherSettings:
            headerLabel.text = @"Other settings";
            break;
        default:
            headerLabel.text = @"";
            break;
    }
    headerLabel.backgroundColor = [UIColor whiteColor];
    
    CALayer *bottomBorder = [CALayer layer];
    
    bottomBorder.frame = CGRectMake(0.0f, headerView.frame.size.height, headerView.frame.size.width, 0.5f);
    
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                     alpha:1.0f].CGColor;
    
    [headerView.layer addSublayer:bottomBorder];
    
    [headerView addSubview:headerLabel];
    
    return headerView;
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 40;
//}

//- (NSString *)tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger) section {
//    switch (section){
//        case rightActionSetting:
//            return @"Swipe right action";
//            break;
//        case leftActionSetting:
//            return @"Swipe left action";
//            break;
//        case otherSettings:
//            return @"Other settings";
//            break;
//        default:
//            return 0;
//            break;
//    }
//}

//- (NSString *)tableView:(UITableView *) tableView titleForFooterInSection:(NSInteger) section {
//    return @"Footer";
//}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void) textFieldDidChange:(NSNotification *) notification {
    UITextField *textField = (UITextField *) notification.object;
    
    if ([Utilities isValidEmailString:textField.text] || [textField.text isEqualToString:@""] || textField.keyboardType != UIKeyboardTypeEmailAddress) {
        textField.layer.borderColor = [tertiaryColorLight CGColor];
    } else {
        textField.layer.borderColor = [secondaryColor CGColor];
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
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
//    NSInteger i = textField.tag;
//    self.myLabel.text = [NSString stringWithFormat:@"Editing done for Text field %i", i];
    
}


//Asks the delegate if the specified text should be changed.
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string{
    
    //get the current data strsing inside the text field
//    NSString *myTextData = [textField.text stringByReplacingCharactersInRange:range
//                                                                   withString:string];
//    NSLog(@"Current data in text field is %@", myTextData);
//    NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
//    
    
//
//    //set the display label value with the current data in the text field
//    self.myLabel.text = [NSString stringWithFormat:@"Data: %@", textField.text];

    return YES;
}

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
