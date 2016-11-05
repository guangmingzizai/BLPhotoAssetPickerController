//
//  BLNinePicCollectionViewCell.h
//  BiLin
//
//  Created by devduwan on 15/9/22.
//  Copyright © 2015年 inbilin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BLNinePicCollectionViewCellRemove <NSObject>

- (void)removePicNine:(NSIndexPath *)indexPath;

@end

@interface BLNinePicCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong)UIImageView *picImageView;
@property(nonatomic, strong)UIView *closeView;
@property(nonatomic, strong)NSIndexPath *indexPath;

@property(nonatomic, assign) id<BLNinePicCollectionViewCellRemove> removeDelegate;

@end
