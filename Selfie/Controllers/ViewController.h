//
//  ViewController.h
//  Selfie
//
//  Created by Daniel Suo on 6/12/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "Reachability.h"

#import "SettingsViewController.h"

#import "Note.h"
#import "NoteView.h"
#import "NoteAttachmentCollectionView.h"
#import "NoteProgressView.h"
#import "NoteRibbonView.h"
#import "NoteStatusView.h"
#import "NotePhotoCell.h"

#import "AttachmentBarButtonItem.h"
#import "CameraBarButtonItem.h"
#import "ImageBarButtonItem.h"
#import "SettingsBarButtonItem.h"
#import "UnsentBarButtonItem.h"
#import "SpacerBarButtonItem.h"

#import "State.h"
#import "Utilities.h"

@interface ViewController : UIViewController <NoteViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>


@end

