//
//  SettingsViewController.m
//  Selfie
//
//  Created by Daniel Suo on 7/18/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
@property (strong, nonatomic) UITextFieldLabel *leftEmailTextFieldLabel;
@property (strong, nonatomic) UITextField *leftEmailTextField;
@property (strong, nonatomic) UITextFieldLabel *rightEmailTextFieldLabel;
@property (strong, nonatomic) UITextField *rightEmailTextField;
@property (nonatomic, strong) UITextField *myTextField;
@property (nonatomic, strong) UILabel *myLabel;

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
//    [super viewDidLoad];
//    
//    self.view.backgroundColor = [UIColor redColor];
//    
//    self.leftEmailTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 200, 300, 40)];
//    self.leftEmailTextField.delegate = self;
//    [self.view addSubview:self.leftEmailTextField];
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Settings";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //create a label to display current user interaction with our editable text views
    CGRect myFrame = CGRectMake(10.0f, 10.0f, 250.0f, 40.0f);
    self.myLabel = [[UILabel alloc] initWithFrame:myFrame];
    self.myLabel.text = @"Credits: LAC, RRE";
    self.myLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    self.myLabel.textAlignment =  NSTextAlignmentLeft;
    [self.view addSubview:self.myLabel];
    
    //lets create 3 UITextViews on the screen
    for (NSInteger i=1; i<5; i++) {
        
        //set the origin of the frame reference
        myFrame.origin.y += myFrame.size.height + 10.0f;
        //create the text field
        self.myTextField = [[UITextField alloc] initWithFrame:myFrame];
        //set the border style for the text view
//        self.myTextField.borderStyle = UITextBorderStyleRoundedRect;
        self.myTextField.layer.borderColor = [tertiaryColorLight CGColor];
        self.myTextField.layer.cornerRadius=8.0f;
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
        self.myTextField.leftViewMode = UITextFieldViewModeAlways;
        self.myTextField.leftView = leftView;
        self.myTextField.layer.masksToBounds=YES;
        self.myTextField.layer.borderWidth= 0.5f;
        
        [Radio addObserver:self
                  selector:@selector(textFieldDidChange:)
                      name:UITextFieldTextDidChangeNotification
                    object:nil];
        
        switch (i) {
                
            case 1:
                //the vertical alignment of text within the frame, set this to center
                self.myTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                //the horizontal alignment of the text
                self.myTextField.textAlignment = NSTextAlignmentLeft;
                //set the type of the keyboard to display
                self.myTextField.keyboardType = UIKeyboardTypeEmailAddress;
//                self.myTextField.leftViewMode = UITextFieldViewModeAlways;
                self.myTextField.placeholder = @"you@example.com";
                break;
                
            case 2:
                self.myTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                self.myTextField.textAlignment = NSTextAlignmentLeft;
                self.myTextField.keyboardType = UIKeyboardTypeEmailAddress;
                self.myTextField.placeholder = @"you@example.com";
                break;
            case 3:
                self.myTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                self.myTextField.textAlignment = NSTextAlignmentLeft;
                self.myTextField.keyboardType = UIKeyboardTypeEmailAddress;
                break;
                
            default:
                self.myTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                self.myTextField.textAlignment = NSTextAlignmentLeft;
                break;
        }
        
        //display hint for the user data entry when the field is empty
        
        //add tag to identify your text views
        self.myTextField.tag = i;
        //display the clear button on the text field
        self.myTextField.clearButtonMode = UITextFieldViewModeAlways;
        //change the return key text to "Done"
        self.myTextField.returnKeyType = UIReturnKeyDone;
        //set the delegate for the text field to the view controller so that it can listen for events
        self.myTextField.delegate = self;
        //add the text field to the current view
        [self.view addSubview:self.myTextField];
    }
    
}

- (void) textFieldDidChange:(NSNotification *) notification {
    UITextField *textField = (UITextField *) notification.object;
    
    if ([Utilities isValidEmailString:textField.text] || [textField.text isEqualToString:@""]) {
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
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
//    NSInteger i = textField.tag;
//    self.myLabel.text = [NSString stringWithFormat:@"Begin editing Text field %i", i];
    
}

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
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    //Notifies the receiver that it has been asked to relinquish
    //its status as first responder in its window.
    [textField resignFirstResponder];
    return YES;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
