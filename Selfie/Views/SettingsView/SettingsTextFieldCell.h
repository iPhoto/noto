//
//  SettingsTextFieldCell.h
//  Selfie
//
//  Created by Daniel Suo on 7/19/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SettingsTextFieldCell;

@interface SettingsInsetTextField : UITextField

@property (nonatomic, assign) UIEdgeInsets inset;

@end

@protocol SettingsTextFieldDelegate <NSObject>

@optional
//Called to the delegate whenever return is hit when a user is typing into the rightTextField of an SettingsTextFieldCell
- (BOOL)textFieldCell:(SettingsTextFieldCell *)inCell shouldReturnForIndexPath:(NSIndexPath*)inIndexPath withValue:(NSString *)inValue;
//Called to the delegate whenever the text in the rightTextField is changed
- (void)textFieldCell:(SettingsTextFieldCell *)inCell updateTextLabelAtIndexPath:(NSIndexPath *)inIndexPath string:(NSString *)inValue;

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;
- (void)textFieldDidBeginEditing:(UITextField *)textField;
- (void)textFieldDidEndEditing:(UITextField *)textField;

@end

@interface SettingsTextFieldCell : UITableViewCell <UITextFieldDelegate>

@property (nonatomic, weak) id<SettingsTextFieldDelegate> delegate;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) SettingsInsetTextField *rightTextField;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@interface SettingsInsetTextFieldCell : SettingsTextFieldCell
@property (nonatomic, assign) UIEdgeInsets inset;
@end

