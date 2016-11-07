//
//  BLPhotoAssetViewController.h
//  BiLin
//
//  Created by devduwan on 15/9/24.
//  Copyright © 2015年 inbilin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "BLAssetPhotoCollectionViewCell.h"
#import "BLPhotoAssetPickerController.h"

@interface BLPhotoAssetViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,BLAssetPhotoCollectionViewCellDelegate>

@property(nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property(nonatomic, strong) NSMutableArray *groups;
@property(nonatomic, assign) BOOL cameraEnable;

@end
