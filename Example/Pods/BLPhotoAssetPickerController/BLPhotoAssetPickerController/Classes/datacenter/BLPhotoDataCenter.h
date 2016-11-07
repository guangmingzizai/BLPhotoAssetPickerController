//
//  BLPhotoDataCenter.h
//  BiLin
//
//  Created by devduwan on 15/9/29.
//  Copyright © 2015年 inbilin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLPhotoDataCenter : NSObject

//授权相册功能
+ (void)authorPhotoPermission:(void (^) (bool result))authorBlock;

//获取相册数据
+ (void)fetchPhotoGroupData:(void (^) (NSArray *photoGroup)) photoGroupBlock;

//绑定相册组cell的数据
+ (void)bindGroupcellData:(NSObject *)groups withBlock:(void (^) (NSString *title ,NSString *count ,UIImage *posterImage))block;

//转换一个相册的数据源
+ (void)converToPhotoDataSource:(NSObject *)dataSource withBlock:(void (^) (NSArray *))block;
//绑定一个相册相片cell的数据
+ (void)bindPhotoCellData:(NSObject *)asset withBlock:(void (^) (UIImage *thumbnailImage))block;

//从一组phasset(alasset)获取缩略图集合
+ (void)getThumbnailDataFromAssets:(NSArray *)assets WithBlock:(void (^) (NSArray *array))thumbBlock withRequestIDBlock:(void (^) (NSArray *requestArray)) requestIdBlock;

@end
