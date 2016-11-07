//
//  BLPhotoDataCenter.m
//  BiLin
//
//  Created by devduwan on 15/9/29.
//  Copyright © 2015年 inbilin. All rights reserved.
//

#define IS_IOS8PLUS             ([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] != NSOrderedAscending)
#define kThumbnailLength    (UI_SCREEN_WIDTH/3 -36/3)
#define UPLOAD_IMAGE_WIDTH   800
#define UPLOAD_IMAGE_HEIGHT  1280

#import "BLPhotoDataCenter.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "PHAssetCollection+BLPhotoUtils.h"
#import "ImageUtils.h"

@implementation BLPhotoDataCenter {
//iOS7
    ALAssetsLibrary *_assetsLibrary;
    ALAssetsFilter *_assetsFilter;
    
//iOS8+
    NSArray *_phAssetsCollectionSubtypes;
    PHFetchOptions *_photoGroupFetchOptions;
    PHFetchOptions *_photoFetchOptions;
    
//dataSource
    NSMutableArray *_photoGroupDatasource;
    
    
}

#pragma mark - sharedInstance
+ (instancetype)sharedInstance {
    static BLPhotoDataCenter *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BLPhotoDataCenter alloc] init];
    });
    return sharedInstance;
}

+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

#pragma mark - AuthorPhoto
//授权相册功能
+ (void)authorPhotoPermission:(void (^) (bool result))authorBlock {
    if (!IS_IOS8PLUS) {
        [[BLPhotoDataCenter sharedInstance] checkiOS7Authrization:authorBlock];
    }else {
        [[BLPhotoDataCenter sharedInstance] checkiOS8Authorization:authorBlock];
    }
}

- (void)checkiOS8Authorization:(void (^) (bool result))authorBlock {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    switch (status)
    {
        case PHAuthorizationStatusNotDetermined:
            [[BLPhotoDataCenter sharedInstance] requestiOS8AuthorizationStatus:authorBlock];
            break;
        case PHAuthorizationStatusRestricted:
        case PHAuthorizationStatusDenied:
        {
            authorBlock(NO);
            break;
        }
        case PHAuthorizationStatusAuthorized:
        default:
        {
            authorBlock(YES);
            break;
        }
    }
}

- (void)requestiOS8AuthorizationStatus:(void (^) (bool result))authorBlock {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
        switch (status) {
            case PHAuthorizationStatusAuthorized:
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    authorBlock(YES);
                });
                break;
            }
            default:
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    authorBlock(NO);
                });
                break;
            }
        }
    }];
}

- (void)checkiOS7Authrization:(void (^) (bool result))authorBlock {
    ALAssetsLibrary *assetsLibrary = [self.class defaultAssetsLibrary];
    //取得一次授权即可 不然会多次调用授权产生重复相册
    __block int authorCount = 0;
    ALAssetsLibraryGroupsEnumerationResultsBlock resultsBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        if (authorCount == 0) {
            authorBlock(YES);
        }
        authorCount ++;
    };
    
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        authorBlock(NO);
    };
    // Enumerate Camera roll first
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                      usingBlock:resultsBlock
                                    failureBlock:failureBlock];
}

#pragma mark - FecthGroupdata

+ (void)fetchPhotoGroupData:(void (^) (NSArray *photoGroup)) photoGroupBlock {
    if (!IS_IOS8PLUS) {
        [[BLPhotoDataCenter sharedInstance] fetchPhotoGroupiOS7Data:photoGroupBlock];
    }else {
        [[BLPhotoDataCenter sharedInstance] fetchPhotoGroupiOS8PlusData:photoGroupBlock];
    }
}

- (void) fetchPhotoGroupiOS8PlusData:(void (^) (NSArray *photoGroup)) photoGroupBlock {
    [[BLPhotoDataCenter sharedInstance] bl_setPhAsssetsDefaultOptions];
    
    if (!_photoGroupDatasource) {
        _photoGroupDatasource =[[NSMutableArray alloc]init];
    }else {
        [_photoGroupDatasource removeAllObjects];
    }
    
    for (NSNumber *subNumber in _phAssetsCollectionSubtypes) {
        PHAssetCollectionType type = [PHAssetCollection blPickerAssetCollectionTypeOfSubtype:subNumber.integerValue];
        PHAssetCollectionSubtype subtype = subNumber.integerValue;
        PHFetchResult *fetchResult = [PHAssetCollection fetchAssetCollectionsWithType:type subtype:subtype options:_photoGroupFetchOptions];
        if (fetchResult.count > 0) {
            for (PHAssetCollection *assetCollection in fetchResult) {
                _photoFetchOptions = [PHFetchOptions new];
                _photoFetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
                PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:assetCollection options:_photoFetchOptions];
                if(result.count > 0) {
                    [_photoGroupDatasource addObject:assetCollection];
                }
            }
        }
    }
    photoGroupBlock(_photoGroupDatasource);
}

- (void) fetchPhotoGroupiOS7Data:(void (^) (NSArray *photoGroup)) photoGroupBlock {
    if (!_assetsLibrary) {
        _assetsLibrary = [self.class defaultAssetsLibrary];
    }
    
    if (!_photoGroupDatasource) {
        _photoGroupDatasource =[[NSMutableArray alloc]init];
    }else {
        [_photoGroupDatasource removeAllObjects];
    }
    
    _assetsFilter = [ALAssetsFilter allAssets];
    ALAssetsLibraryGroupsEnumerationResultsBlock resultBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [group setAssetsFilter:_assetsFilter];
            if (group.numberOfAssets > 0) {
                [_photoGroupDatasource addObject:group];
                photoGroupBlock(_photoGroupDatasource);
            }
        }
    };
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        
    };
    
    //Euumerate Camera roll first
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:resultBlock failureBlock:failureBlock];
    //Then all other groups
    NSUInteger type = ALAssetsGroupLibrary | ALAssetsGroupAlbum | ALAssetsGroupEvent | ALAssetsGroupFaces | ALAssetsGroupPhotoStream;
    [_assetsLibrary enumerateGroupsWithTypes:type usingBlock:resultBlock failureBlock:failureBlock];
    
    
}

#pragma mark - FetchPhotoPreview

+ (void)fetchPhotopreviewData {
    
}

#pragma mark - PHASSET Utils
- (void) bl_setPhAsssetsDefaultOptions {
    _phAssetsCollectionSubtypes =
    @[[NSNumber numberWithInt:PHAssetCollectionSubtypeSmartAlbumUserLibrary],
      [NSNumber numberWithInt:PHAssetCollectionSubtypeAlbumMyPhotoStream],
      [NSNumber numberWithInt:PHAssetCollectionSubtypeAlbumRegular]];
    
    _photoGroupFetchOptions = [PHFetchOptions new];
    _photoGroupFetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"estimatedAssetCount" ascending:NO]];
}

#pragma mark - 绑定相册组cell的数据

+ (void)bindGroupcellData:(NSObject *)groups withBlock:(void (^) (NSString *title ,NSString *count ,UIImage *posterImage))block {
    if (IS_IOS8PLUS) {
        [[BLPhotoDataCenter sharedInstance] bindiOS8Plus:(PHAssetCollection *)groups withBlock:block];
    }else {
        [[BLPhotoDataCenter sharedInstance] bindiOS7:(ALAssetsGroup *)groups withBlock:block];
    }
}

- (void)bindiOS8Plus:(PHAssetCollection *)phCollection withBlock:(void (^) (NSString *title ,NSString *count ,UIImage *posterImage))block {
    _photoFetchOptions = [PHFetchOptions new];
    _photoFetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:phCollection options:_photoFetchOptions];
    
    PHAsset *asset = [result firstObject];
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.networkAccessAllowed = YES;
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    NSInteger scale = [UIScreen mainScreen].scale;
    CGSize coverSize = CGSizeMake(kThumbnailLength * scale, kThumbnailLength * scale);
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    NSString *countStr = [formatter stringFromNumber:[NSNumber numberWithUnsignedInteger:result.count]];
    NSString *titleStr = phCollection.localizedTitle;
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:coverSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
        if (image) {
            block(titleStr, countStr, image);
        }
    }];
    
    
    
    
}

- (void)bindiOS7:(ALAssetsGroup *) assetGroup withBlock:(void (^) (NSString *title ,NSString *count ,UIImage *posterImage))block {
    CGImageRef posterImage = assetGroup.posterImage;
    size_t height = CGImageGetHeight(posterImage);
    float scale = height / kThumbnailLength;
    UIImage *image = [UIImage imageWithCGImage:posterImage scale:scale orientation:UIImageOrientationUp];
    NSString *titleStr = [assetGroup valueForProperty:ALAssetsGroupPropertyName];
    NSString *countStr = [NSString stringWithFormat:@"%ld",(long)[assetGroup numberOfAssets]];
    block(titleStr, countStr, image);
    
}

#pragma mark - converToPhotoDataSource
//转换一个相册的数据源
+ (void)converToPhotoDataSource:(NSObject *)dataSource withBlock:(void (^) (NSArray *))block {
    NSMutableArray *convertSource = [[NSMutableArray alloc] init];
    if (IS_IOS8PLUS) {
        PHFetchOptions *fetchOptions = [PHFetchOptions new];
        fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:(PHAssetCollection *)dataSource options:fetchOptions];
        for (int i = 0; i<result.count; i++) {
            PHAsset *asset = [result objectAtIndexedSubscript:i];
            [convertSource addObject:asset];
        }
        block(convertSource);
    }else {
        ALAssetsGroupEnumerationResultsBlock resultsBlock = ^(ALAsset *asset, NSUInteger index, BOOL *stop) {
            
            if (asset)
            {
                [convertSource addObject:asset];
            }
            block(convertSource);
        };
        [((ALAssetsGroup *)dataSource) enumerateAssetsUsingBlock:resultsBlock];
    }
}

//绑定一个相册相片cell的数据
+ (void)bindPhotoCellData:(NSObject *)asset withBlock:(void (^) (UIImage *thumbnailImage))block {
    if (IS_IOS8PLUS) {
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.resizeMode = PHImageRequestOptionsResizeModeExact;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        options.networkAccessAllowed = YES;
        
        [[PHImageManager defaultManager] requestImageForAsset:(PHAsset *)asset targetSize:CGSizeMake(kThumbnailLength*2, kThumbnailLength*2) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            if (result){
                block(result);
            }
        }];
    }else {
        CGImageRef thumbnailImage = ((ALAsset *)asset).thumbnail;
        size_t height = CGImageGetHeight(thumbnailImage);
        float scale = height / kThumbnailLength*2;
        UIImage *image = [UIImage imageWithCGImage:thumbnailImage scale:scale orientation:UIImageOrientationUp];
        block(image);
    }
}

//从一组phasset(alasset)获取缩略图集合
+ (void)getThumbnailDataFromAssets:(NSArray *)assets WithBlock:(void (^) (NSArray *array))thumbBlock withRequestIDBlock:(void (^) (NSArray *requestArray)) requestIdBlock {
    NSMutableArray *thumbArray = [NSMutableArray array];
    NSMutableArray *requestArray = [NSMutableArray array];
    NSMutableDictionary *assetImageDic = [NSMutableDictionary dictionary];
    if (IS_IOS8PLUS) {
        for (volatile int i = 0; i < assets.count; i ++) {
            PHAsset *asset = [assets objectAtIndex:i];
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            options.resizeMode = PHImageRequestOptionsResizeModeExact;
            options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
            options.networkAccessAllowed = YES;
           
            PHImageRequestID requestID = [[PHImageManager defaultManager] requestImageForAsset:(PHAsset *)asset targetSize:[[BLPhotoDataCenter sharedInstance] caculateTargetSize:CGSizeMake(asset.pixelWidth, asset.pixelHeight)] contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                if (result) {
//                    [thumbArray addObject:result];
                    assetImageDic[@(i)] = result;
                    if (assetImageDic.count == assets.count) {
                        for (int j = 0; j < assets.count; j++) {
                            [thumbArray addObject:assetImageDic[@(j)]];
                        }
                        thumbBlock(thumbArray);
                    }
                }
            }];
            [requestArray addObject:[NSNumber numberWithInt:(requestID)]];
            if (requestArray.count == assets.count) {
                requestIdBlock(requestArray);
            }
        }
    }else {
        for (int i = 0; i <assets.count; i++) {
            ALAsset *asset = [assets objectAtIndex:i];
            ALAssetRepresentation *representation = ((ALAsset *)asset).defaultRepresentation;
            CGImageRef fullImage = representation.fullScreenImage;
            
            CGSize size = [representation dimensions];
            CGFloat scale = MIN((UPLOAD_IMAGE_WIDTH / size.width), (UPLOAD_IMAGE_HEIGHT / size.height));
            if (scale < 1) {
                scale = 1;
            }
            
            UIImage *image = [UIImage imageWithCGImage:fullImage scale:scale orientation:UIImageOrientationUp];
            [thumbArray addObject:image];
        }
        thumbBlock(thumbArray);
    }
}

- (CGSize)caculateTargetSize:(CGSize )fromSize {
    CGSize size = fromSize;
    if ((size.width > UPLOAD_IMAGE_WIDTH) || ((size.height) > UPLOAD_IMAGE_HEIGHT)) {
        if ((size.width / size.height) > 1) {
            // 横图
            CGFloat scale = MIN((UPLOAD_IMAGE_WIDTH / size.height), (UPLOAD_IMAGE_HEIGHT / size.width));
            size = CGSizeMake(size.width * scale, size.height * scale);
        } else {
            // 竖图
            CGFloat scale = MIN((UPLOAD_IMAGE_WIDTH / size.width), (UPLOAD_IMAGE_HEIGHT / size.height));
            size = CGSizeMake(size.width * scale, size.height * scale);
        }
    }
    return size;
}


@end
