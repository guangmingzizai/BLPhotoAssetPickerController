//
//  BLAssetPickerController.h
//  BiLin
//
//  Created by devduwan on 15/9/23.
//  Copyright © 2015年 inbilin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "BLAssetSwitch.h"

@class BLPhotoAssetPickerController;

@protocol BLPhotoAssetPickerControllerDelegate<NSObject>

-(void)assetPickerController:(BLPhotoAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets;

-(void)assetPickerController:(BLPhotoAssetPickerController *)picker didFinishTakingPhoto:(UIImage *)image andPickingAssets:(NSArray *)assets;


@optional

-(void)assetPickerControllerDidCancel:(BLPhotoAssetPickerController *)picker;

-(void)assetPickerController:(BLPhotoAssetPickerController *)picker didSelectAsset:(ALAsset*)asset;

-(void)assetPickerController:(BLPhotoAssetPickerController *)picker didDeselectAsset:(ALAsset*)asset;

-(void)assetPickerControllerDidMaximum:(BLPhotoAssetPickerController *)picker;

-(void)assetPickerControllerDidMinimum:(BLPhotoAssetPickerController *)picker;

@end


@interface BLPhotoAssetPickerController : UINavigationController

@property (nonatomic, weak) id <UINavigationControllerDelegate, BLPhotoAssetPickerControllerDelegate> assetDelegate;

@end