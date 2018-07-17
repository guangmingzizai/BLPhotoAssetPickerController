//
//  BLPhotoAssetImageRequestResultItem.m
//  ActionSheetPicker-3.0
//
//  Created by wangjianfei on 2018/7/17.
//

#import "BLPhotoAssetImageRequestResultItem.h"

@implementation BLPhotoAssetImageRequestResultItem

+ (instancetype)itemWithImage:(UIImage *)image imageData:(NSData *)imageData {
    return [[BLPhotoAssetImageRequestResultItem alloc] initWithImage:image imageData:imageData];
}

- (instancetype)initWithImage:(UIImage *)image imageData:(NSData *)imageData {
    if (self = [super init]) {
        self.image = image;
        self.imageData = imageData;
    }
    return self;
}

@end
