//
//  SettingsViewController.h
//  Selfie
//
//  Created by Daniel Suo on 7/18/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Utilities.h"

#import "SettingsTextFieldCell.h"

@interface SettingsViewController : UITableViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, SettingsTextFieldDelegate>

@end
