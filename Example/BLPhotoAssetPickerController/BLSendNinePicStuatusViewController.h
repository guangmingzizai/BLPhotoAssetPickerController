//
//  BLSendNinePicStuatusViewController.h
//  BiLin
//
//  Created by devduwan on 15/9/21.
//  Copyright © 2015年 inbilin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLNinePicAddCollectionViewCell.h"
#import "BLNinePicCollectionViewCell.h"
#import "BLPhotoAssetPickerController.h"

@protocol BLSendNinePicStatusViewControllerDelegate;

@interface BLSendNinePicStuatusViewController : UIViewController
<UICollectionViewDataSource,
    UICollectionViewDelegate,
    UITextViewDelegate,
    BLNinePicCollectionViewCellRemove,
    BLNinePicAddCollectionViewCellDelegate,
    UIImagePickerControllerDelegate,
    BLPhotoAssetPickerControllerDelegate,
    UINavigationControllerDelegate>

@property (nonatomic, strong) NSArray * choosedImages;
@property (nonatomic, copy) NSString *fromPageIdentifier;
@property (nonatomic, copy) NSString *defaultContent;
@property (nonatomic, weak) id<BLSendNinePicStatusViewControllerDelegate> delegate;

@end

@protocol BLSendNinePicStatusViewControllerDelegate <NSObject>
@optional
- (void)sendNewStatusViewControllerDidSend:(BLSendNinePicStuatusViewController *)viewController;
@end
