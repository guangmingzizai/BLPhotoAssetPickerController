//
//  BLPhotoAssetImageRequestResultItem.h
//  ActionSheetPicker-3.0
//
//  Created by wangjianfei on 2018/7/17.
//

#import <Foundation/Foundation.h>

@interface BLPhotoAssetImageRequestResultItem : NSObject

@property (nonnull, nonatomic, strong) UIImage *image;
@property (nullable, nonatomic, strong) NSData *imageData;

+ (instancetype)itemWithImage:(UIImage *)image imageData:(NSData *)imageData;
- (instancetype)initWithImage:(UIImage *)image imageData:(NSData *)imageData;

@end
