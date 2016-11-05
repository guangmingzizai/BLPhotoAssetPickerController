//
//  BLNinePicAddCollectionViewCell.h
//  BiLin
//
//  Created by devduwan on 15/9/22.
//  Copyright © 2015年 inbilin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BLNinePicAddCollectionViewCellDelegate <NSObject>

- (void)addPicNineStatus;

@end

@interface BLNinePicAddCollectionViewCell : UICollectionViewCell

@property(nonatomic, assign) id<BLNinePicAddCollectionViewCellDelegate> addDelegate;

@end
