//
//  NotePhotoCell.h
//  Selfie
//
//  Created by Daniel Suo on 7/14/14.
//  Copyright (c) 2014 The Leather Apron Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface NotePhotoCell : UICollectionViewCell
@property(nonatomic, strong) ALAsset *asset;
@end
