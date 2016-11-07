//
//  BLSendNinePicStuatusViewController.m
//  BiLin
//
//  Created by devduwan on 15/9/21.
//  Copyright © 2015年 inbilin. All rights reserved.
//

#import "BLSendNinePicStuatusViewController.h"
#import "ImageUtils.h"
#import "MBProgressHUD.h"
#import "SDWebImageManager.h"
#import "MBProgressHUD+Add.h"
#import "ImageUtils.h"
#import "UITextView+LengthLimit.h"
#import "BLPhotoAssetPickerController.h"
#import "BLPhotoAssetViewController.h"
#import "BLPhotoDataCenter.h"
#import "BLPhotoUtils.h"
#import <MWPhotoBrowser_guangmingzizai/MWPhotoBrowser.h>
#import <Masonry/Masonry.h>
#import <RMUniversalAlert/RMUniversalAlert.h>

#define IS_IOS8PLUS ([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] != NSOrderedAscending)

static NSString *QiniuAccessKey = @"U2my4pIj06AXA7hkvE6oj5iIGajiUys9kSNVDjts";
static NSString *QiniuSecretKey = @"gAsgwF57-rzlSuS3Njj7ji8SCeyAD5CtTswUeW32";
static NSString *QiniuBucketName = @"img-bilin";

@interface BLSendNinePicStuatusViewController () <MWPhotoBrowserDelegate>

@property (nonatomic, weak) MBProgressHUD *lengthExccedHUD;
@property (nonatomic, strong) NSMutableArray *systemTags;
@property (nonatomic, strong) UITextView *statusTextView;
@property (nonatomic, assign) NSInteger maxSelectionNum;

@end

@implementation BLSendNinePicStuatusViewController {
    UILabel *_tipLabel;
    UICollectionView *_statusCollectionView;
    UICollectionViewFlowLayout *_flowLayout;
    NSMutableArray *_dataSource;
    NSMutableArray *_sendImage;
    NSMutableArray *_sendImageBigPath;
    MBProgressHUD *_uploadHud;
    NSArray *_requestImageIdArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (iOS_Version >= 7.0) {
        //        ios7  高度显示  兼容性问题
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.systemTags = [NSMutableArray array];
    
    [self setupUI];
    [self setupDataSource];
    _statusTextView.text = self.defaultContent;
    [self textViewDidChange:_statusTextView];
    [_statusTextView becomeFirstResponder];
    self.maxSelectionNum = 4;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([self isBeingPresented] || [self isMovingToParentViewController]) {
        if (self.defaultContent) {
            [_statusTextView becomeFirstResponder];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillDisappear:animated];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self changeCollectionViewConstrain];
    });
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
}

- (void)setupUI {
    self.view.backgroundColor = UIColorFromRGB(0xeff0f2);
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"custom_nav_back_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelStatus)];
    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"status_sendninestatus"] style:UIBarButtonItemStylePlain target:self action:@selector(sendStatus)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = sendButton;
    self.title = NSLocalizedString(@"发动态", nil);
    
    UIView *textBgView = [[UIView alloc]init];
    textBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:textBgView];
    [textBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(131);
    }];
    
    _statusTextView = [[UITextView alloc]init];
    _statusTextView.delegate = self;
    _statusTextView.textColor = UIColorFromRGB(0x838383);
    _statusTextView.textAlignment = NSTextAlignmentLeft;
    _statusTextView.font = [UIFont systemFontOfSize:16];
    _statusTextView.returnKeyType = UIReturnKeyDone;
    _statusTextView.backgroundColor = [UIColor clearColor];
    [_statusTextView setScrollEnabled:YES];
    [_statusTextView setUserInteractionEnabled:YES];
    _statusTextView.textContainerInset = UIEdgeInsetsZero;
    _statusTextView.textContainer.lineFragmentPadding = 0;
    _statusTextView.layoutManager.allowsNonContiguousLayout = NO;
    [self.view  addSubview:_statusTextView];
    [_statusTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(119);
    }];
    
    _tipLabel = [[UILabel alloc]init];
    _tipLabel.text = NSLocalizedString(@"输入你想说的话，给懂的人", nil);
    _tipLabel.textColor = UIColorFromRGB(0x838383);
    _tipLabel.font = [UIFont systemFontOfSize:16];
    _tipLabel.backgroundColor = [UIColor clearColor];
    CGSize size = [@"输入你想说的话，给懂的人" sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]}];
    [_statusTextView addSubview:_tipLabel];
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(UI_SCREEN_WIDTH - 50, size.height));
    }];
    [_statusTextView layoutIfNeeded];
    
    _flowLayout = [[UICollectionViewFlowLayout alloc]init];
    _flowLayout.itemSize = CGSizeMake(UI_SCREEN_WIDTH/3-36/3, UI_SCREEN_WIDTH/3-36/3);
    CGFloat paddingX = 0;
    CGFloat paddingY = 0;
    _flowLayout.sectionInset = UIEdgeInsetsMake(paddingY, paddingX, paddingY, paddingX);
    _flowLayout.minimumLineSpacing = 6;
    _flowLayout.minimumInteritemSpacing = 6;
    
    
    _statusCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_flowLayout];
    _statusCollectionView.delegate = self;
    _statusCollectionView.dataSource = self;
    _statusCollectionView.backgroundColor = [UIColor whiteColor];
    _statusCollectionView.contentInset = UIEdgeInsetsMake(12,12,12,12);
    _statusCollectionView.scrollEnabled = NO;
    [_statusCollectionView registerClass:[BLNinePicCollectionViewCell class] forCellWithReuseIdentifier:@"reuseCollectionView"];
    [_statusCollectionView registerClass:[BLNinePicAddCollectionViewCell class] forCellWithReuseIdentifier:@"reuseAddCollectionView"];
    [self.view addSubview:_statusCollectionView];
    [_statusCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(_statusTextView.mas_bottom).with.offset(0);
        make.height.mas_equalTo(UI_SCREEN_WIDTH/3-36/3+12*2);
    }];
}

- (void)setupDataSource {
    _dataSource = [[NSMutableArray alloc]initWithObjects:@"DEFAULT_ADD", nil];
    
}

#pragma mark - UI-Action
- (void)cancelStatus {
    if ([_dataSource count] == 1) {
        [self.statusTextView removeFromSuperview];
        self.statusTextView = nil;
        [BLPhotoUtils setWillUseCount:0];
        [BLPhotoUtils setUseCount:0];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    weakifySelf
    [RMUniversalAlert showAlertInViewController:self
                                      withTitle:@"您要放弃发布吗？"
                                        message:nil
                              cancelButtonTitle:@"放弃"
                         destructiveButtonTitle:@"继续编辑"
                              otherButtonTitles:nil
                                       tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                                           strongifySelf
                                           if (buttonIndex == alert.cancelButtonIndex) {
                                               [self.statusTextView removeFromSuperview];
                                               self.statusTextView = nil;
                                               [BLPhotoUtils setWillUseCount:0];
                                               [BLPhotoUtils setUseCount:0];
                                               [weakSelf.navigationController popViewControllerAnimated:YES];
                                           }
                                       }];
}
- (void)sendStatus {
    [_statusTextView resignFirstResponder];
    
    if (_dataSource.count < 2) {
        self.lengthExccedHUD = [MBProgressHUD showHUDInKeyWindowWithImage:nil text:NSLocalizedString(@"请至少选择一张图", nil) duration:1];
        return;
    }
    
    if (_statusTextView.text.length > 300) {
        self.lengthExccedHUD = [MBProgressHUD showHUDInKeyWindowWithImage:nil text:NSLocalizedString(@"字数已达上限", nil) duration:1];
        return;
    }
    
    //把选中的图片设置为0
    [BLPhotoUtils setUseCount:0];
    [BLPhotoUtils setWillUseCount:0];
   
    _sendImage = [NSMutableArray array];
    _sendImageBigPath = [NSMutableArray array];
    for (int i = 0; i< _dataSource.count; i++) {
        //不是默认的add控件(add空间在数据源中用一个NSString表示的
        if (![[_dataSource objectAtIndex:i] isKindOfClass:[NSString class]]) {
            [_sendImage addObject:[_dataSource objectAtIndex:i]];
        }
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *directoryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:[NSString stringWithFormat:@"/Caches/BiLin"]];
    if ([fileManager fileExistsAtPath:directoryPath] == NO) {
        NSError *error = nil;
        BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (!success) {
            NSLog(@"create status image directory error:%@", error);
        }
    }
    for (int  i = 0; i<_sendImage.count; i++) {
        NSTimeInterval createOn = [[NSDate date] timeIntervalSince1970];
        NSString *bigPath = [directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%f", createOn]];
        [_sendImageBigPath addObject:bigPath];
        NSData *bigImageData = UIImageJPEGRepresentation([_sendImage objectAtIndex:i], 0.4);
        BOOL success = [bigImageData writeToFile:bigPath atomically:YES];
        if (!success) {
            NSLog(@"save status image failed.");
        }
    }
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == (_dataSource.count - 1) && [_dataSource.lastObject isKindOfClass:[NSString class]] && [_dataSource.lastObject isEqualToString:@"DEFAULT_ADD"]) {
        BLNinePicAddCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuseAddCollectionView" forIndexPath:indexPath];
        if (!cell) {
            cell = [[BLNinePicAddCollectionViewCell alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH/3-36/3, UI_SCREEN_WIDTH/3-36/3)];
        }
        cell.addDelegate = self;
        return cell;
    } else {
         BLNinePicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuseCollectionView" forIndexPath:indexPath];
        if (!cell) {
            cell = [[BLNinePicCollectionViewCell alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH/3-36/3, UI_SCREEN_WIDTH/3-36/3)];
        }
        cell.indexPath = indexPath;
        cell.removeDelegate = self;
        cell.picImageView.image = [_dataSource objectAtIndex:indexPath.row];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == (_dataSource.count - 1) && [_dataSource.lastObject isKindOfClass:[NSString class]] && [_dataSource.lastObject isEqualToString:@"DEFAULT_ADD"]) {
    } else {
        [self bl_browseOriginalRepresentationPhotos:indexPath.item];
    }
}

#pragma mark - BLNinePicCollectionViewCellAdd

- (void)addPicNineStatus {
    [self.view endEditing:YES];
    BLPhotoAssetViewController *assetViewController = [[BLPhotoAssetViewController alloc] init];
    assetViewController.maxSelectionNum = self.maxSelectionNum;
    assetViewController.cameraEnable = NO;
    BLPhotoAssetPickerController *pickerController = [[BLPhotoAssetPickerController alloc] initWithRootViewController:assetViewController];
    pickerController.assetDelegate = self;
    if(_dataSource.count < self.maxSelectionNum) {
        [BLPhotoUtils setUseCount:_dataSource.count - 1];
        [BLPhotoUtils setWillUseCount:0];
    }else {
        if ([_dataSource.lastObject isKindOfClass:[NSString class]] && [_dataSource.lastObject isEqualToString:@"DEFAULT_ADD"]) {
            [BLPhotoUtils setUseCount:_dataSource.count - 1];
            [BLPhotoUtils setWillUseCount:0];
        }else {
            [BLPhotoUtils setUseCount:_dataSource.count];
            [BLPhotoUtils setWillUseCount:0];
        }
    }
    
    [self presentViewController:pickerController animated:YES completion:nil];
}

- (void)changeCollectionViewConstrain {
    int cellLineCount = ((int)(_dataSource.count-1)/3) + 1;
    int contentHeight = cellLineCount*(UI_SCREEN_WIDTH/3-36/3) + 6*(cellLineCount-1);
    int targetHeight = 0;
    if (contentHeight+ 12 *2 >(UI_SCREEN_HEIGHT - 64 - 143)) {
        _statusCollectionView.scrollEnabled = YES;
        targetHeight=UI_SCREEN_HEIGHT - 64 -143;
    }else {
        _statusCollectionView.scrollEnabled = NO;
        targetHeight = contentHeight+ 12 *2;
    };
   
    [_statusCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(_statusTextView.mas_bottom).with.offset(0);
        make.height.mas_equalTo(targetHeight);
    }];
    
}

#pragma mark - BLNinePicCollectionViewCellRemove

- (void)removePicNine:(NSIndexPath *)indexPath {
    //attention 这个里面由于cell绑定了indexpath
    //在使用[_statusCollectionView deleteItemsAtIndexPaths:indexPaths];
    //并没有更新indexpath
    
    [BLPhotoUtils setUseCount:([BLPhotoUtils getUseCount] - 1)];
    
    if ([_dataSource.lastObject isKindOfClass:[NSString class]] && [_dataSource.lastObject isEqualToString:@"DEFAULT_ADD"]) {
       
        NSArray *indexPaths = [[NSArray alloc]initWithObjects:indexPath, nil];
        [_dataSource removeObjectAtIndex:indexPath.row];
        [_statusCollectionView performBatchUpdates:^{
            [_statusCollectionView deleteItemsAtIndexPaths:indexPaths];
            [self changeCollectionViewConstrain];
        } completion:nil];
    }else {
        [_dataSource removeObjectAtIndex:indexPath.row];
        [_dataSource insertObject:@"DEFAULT_ADD" atIndex:_dataSource.count];
       
        [self changeCollectionViewConstrain];
        [_statusCollectionView reloadData];
    }
    [self updateCellAttachIndexPath];
}

//对于在此界面查看大图的处理
- (void)removePicNineWhenWatchBigPicture:(NSIndexPath *)indexPath {
    [BLPhotoUtils setUseCount:([BLPhotoUtils getUseCount] - 1)];
    
    if ([_dataSource.lastObject isKindOfClass:[NSString class]] && [_dataSource.lastObject isEqualToString:@"DEFAULT_ADD"]) {
        [_dataSource removeObjectAtIndex:indexPath.row];
        [self changeCollectionViewConstrain];
        [_statusCollectionView reloadData];
 
    }else {
        [_dataSource removeObjectAtIndex:indexPath.row];
        [_dataSource insertObject:@"DEFAULT_ADD" atIndex:_dataSource.count];
        
        [self changeCollectionViewConstrain];
        [_statusCollectionView reloadData];
    }
    [self updateCellAttachIndexPath];
}


- (void)updateCellAttachIndexPath {
    for (int i = 0; i < _dataSource.count; i ++) {
        NSObject *object = [_dataSource objectAtIndex:i];
        if (![object isKindOfClass:[NSString class]]) {
            BLNinePicCollectionViewCell *cell = (BLNinePicCollectionViewCell *)[_statusCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            cell.indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        }
 
    }
}

#pragma mark - UITextView delegate
- (void)textViewDidChange:(UITextView *)textView
{
    weakifySelf
    [_statusTextView limitTextLengthTo:300 limitDo:^{
        strongifySelf
        if (!self.lengthExccedHUD) {
            self.lengthExccedHUD = [MBProgressHUD showHUDInKeyWindowWithImage:nil text:NSLocalizedString(@"字数太多", nil) duration:1];
        }
    }];
    
    _tipLabel.hidden = _statusTextView.text.length;
    
    //iOS7
    if (!IS_IOS8PLUS) {
        CGRect line = [textView caretRectForPosition:
                       textView.selectedTextRange.start];
        CGFloat overflow = line.origin.y + line.size.height - ( textView.contentOffset.y + textView.bounds.size.height - textView.contentInset.bottom - textView.contentInset.top );
        if ( overflow > 0 ) {
            // We are at the bottom of the visible text and introduced a line feed, scroll down (iOS 7 does not do it)
            // Scroll caret to visible area
            CGPoint offset = textView.contentOffset;
            offset.y += overflow + 7; // leave 7 pixels margin
            // Cannot animate with setContentOffset:animated: or caret will not appear
            [UIView animateWithDuration:.2 animations:^{
                [textView setContentOffset:offset];
            }];
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark 图片选择器代理方法
- (void)assetPickerController:(BLPhotoAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    [picker dismissViewControllerAnimated:YES completion:^{
        //fix iOS7.0.3 BUG
        
        [self changeCollectionViewConstrain];
    }];
    
    //移除默认的添加
    if([_dataSource count] >0 && [_dataSource.lastObject isKindOfClass:[NSString class]] && [_dataSource.lastObject isEqualToString:@"DEFAULT_ADD"]) {
        [_dataSource removeLastObject];
    }
    __block NSMutableArray *array = [NSMutableArray array];
    __block NSInteger  fetchData = 0;
    [BLPhotoDataCenter getThumbnailDataFromAssets:assets WithBlock:^(NSArray *thumbarray){
        array = [NSMutableArray arrayWithArray:thumbarray];
        fetchData = 1;
        for (int i = 0; i < array.count; i++) {
            [_dataSource addObject:[array objectAtIndex:i]];
        }
        if(_dataSource.count < self.maxSelectionNum) {
            [_dataSource addObject:@"DEFAULT_ADD"];
        }
       
        [self cancelUpload];
        [self changeCollectionViewConstrain];
        [_statusCollectionView reloadData];
        
    } withRequestIDBlock:^(NSArray *requestArray) {
        _requestImageIdArray = requestArray;
    }];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (fetchData == 0) {
            _uploadHud = [MBProgressHUD showProcessTip:@"正在加载..."];
            [_uploadHud addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelUploadAlert)]];
        }
    });
    
}

- (void)cancelUploadAlert {
    weakifySelf
    [RMUniversalAlert showAlertInViewController:self
                                      withTitle:@"取消图片加载？"
                                        message:nil
                              cancelButtonTitle:@"否"
                         destructiveButtonTitle:@"是"
                              otherButtonTitles:nil
                                       tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                                           strongifySelf
                                           if (buttonIndex != alert.cancelButtonIndex) {
                                               [self cancelUpload];
                                           }
                                       }];
}

- (void)cancelUpload {
    [_uploadHud hide:YES];
    if (_requestImageIdArray && _requestImageIdArray.count >0) {
        for (int i = 0; i<_requestImageIdArray.count; i++) {
            [[PHImageManager defaultManager] cancelImageRequest:[[_requestImageIdArray objectAtIndex:i] intValue]];
        }
    }
    _requestImageIdArray = nil;
    [BLPhotoUtils setUseCount:0];
    [BLPhotoUtils setWillUseCount:0];
}

- (void)assetPickerController:(BLPhotoAssetPickerController *)picker didFinishTakingPhoto:(UIImage *)image andPickingAssets:(NSArray *)assets {
    
    [picker dismissViewControllerAnimated:YES completion:^{
        //fix iOS7.0.3 BUG
        
        [self changeCollectionViewConstrain];
    }];
    
    //移除默认的添加
    if([_dataSource count] >0 && [_dataSource.lastObject isKindOfClass:[NSString class]] && [_dataSource.lastObject isEqualToString:@"DEFAULT_ADD"]) {
        [_dataSource removeLastObject];
    }
    __block NSInteger  fetchData = 0;
    if (assets!=NULL && assets.count >0) {
        __block NSMutableArray *array = [NSMutableArray array];
        
        [BLPhotoDataCenter getThumbnailDataFromAssets:assets WithBlock:^(NSArray *thumbarray) {
            array = [NSMutableArray arrayWithArray:thumbarray];
            fetchData = 1;
            for (int i = 0; i < array.count; i++) {
                [_dataSource addObject:[array objectAtIndex:i]];
            }
            
            [_dataSource addObject:image];
            
            if(_dataSource.count < self.maxSelectionNum) {
                [_dataSource addObject:@"DEFAULT_ADD"];
            }
           
            [self cancelUpload];

            
            [self changeCollectionViewConstrain];
            [_statusCollectionView reloadData];

            
        } withRequestIDBlock:^(NSArray *requestArray) {
            _requestImageIdArray = requestArray;
        }];
    }else {
        fetchData = 1;
        [_dataSource addObject:image];
        
        if(_dataSource.count < self.maxSelectionNum) {
            [_dataSource addObject:@"DEFAULT_ADD"];
        }
       
        [self cancelUpload];

        
        [picker dismissViewControllerAnimated:YES completion:^{
            //fix iOS7.0.3 BUG
            [self changeCollectionViewConstrain];
        }];

        
        [self changeCollectionViewConstrain];
        [_statusCollectionView reloadData];
        
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (fetchData == 0) {
            _uploadHud = [MBProgressHUD showProcessTip:@"正在加载..."];
            [_uploadHud addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelUploadAlert)]];
        }
    });
}

#pragma mark - Browse Big Photo

- (void)bl_browseOriginalRepresentationPhotos:(NSInteger)fromIndex {
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.zoomPhotosToFill = NO;
    browser.mode = MWPhotoBrowserModeSelectedPhoto;
    [browser setCurrentPhotoIndex:fromIndex];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:nc animated:YES completion:nil];
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    if ([_dataSource.lastObject isKindOfClass:[NSString class]]) {
        return (_dataSource.count-1);
    } else {
        return _dataSource.count;
    }
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    id item = _dataSource[index];
    if ([item isKindOfClass:[UIImage class]]) {
        return [MWPhoto photoWithImage:(UIImage *)item];
    } else {
        return nil;
    }
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didTappedDeleteButtonAtIndex:(NSUInteger)index {
    [RMUniversalAlert showActionSheetInViewController:self
                                            withTitle:@"要删除这张照片吗？"
                                              message:nil
                                    cancelButtonTitle:@"取消"
                               destructiveButtonTitle:@"删除"
                                    otherButtonTitles:nil
                   popoverPresentationControllerBlock:nil
                                             tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                                                 if (buttonIndex != alert.cancelButtonIndex) {
                                                     [self removePicNineWhenWatchBigPicture:[NSIndexPath indexPathForItem:index inSection:0]];
                                                     [photoBrowser reloadData];
                                                 }
                   }];
}

@end
