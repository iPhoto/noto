//
//  ViewController.h
//  Selfie
//
//  Created by Daniel Suo on 6/12/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "Note.h"
#import "NoteView.h"
#import "NoteAttachmentView.h"
#import "NoteProgressView.h"
#import "NoteRibbonView.h"
#import "NoteStatusView.h"
#import "State.h"
#import "Utilities.h"

@interface ViewController : UIViewController <NoteViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>


@end

