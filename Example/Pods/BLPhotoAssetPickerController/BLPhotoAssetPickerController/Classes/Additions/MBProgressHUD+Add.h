//
//  MBProgressHUD+Add.h
//  BiLin
//
//  Created by Liu Feng on 14-5-21.
//  Copyright (c) 2014年 inbilin. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (Add)

+ (instancetype)showProcessTip:(NSString *)tip;
+ (instancetype)showProcessTip:(NSString *)tip inView:(UIView *)superview;
+ (void)showProcessTip:(NSString *)tip offY:(CGFloat)y;
+ (void)hideProcessTip;
+ (void)hideProcessTip:(UIView *)superview;
+ (void)showSuccessTip:(NSString *)tip;
+ (void)showFailTip:(NSString *)tip;
+ (void)showFailTipInFront:(NSString *)tip;
+ (void)showTip:(NSString *)tip;
+ (void)showTip:(NSString *)tip duration:(CGFloat)duration;
+ (void)showHUDInFrontWindowWithImage:(NSString *)imageName text:(NSString *)text detailText:(NSString *)detailsText detailFont:(UIFont *)detailsFont duration:(float)duration;

+ (MB_INSTANCETYPE)showHUDAddedTo:(UIView *)view animated:(BOOL)animated withTitle:(NSString *)title;
+ (MB_INSTANCETYPE)showHUDAddedTo:(UIView *)view animated:(BOOL)animated withTitle:(NSString *)title moveY:(CGFloat) offY;
+ (MB_INSTANCETYPE)showHUDInKeyWindowWithImage:(NSString *)imageName text:(NSString *)text duration:(float)duration ;
+ (MB_INSTANCETYPE)showHUDInKeyWindowWithImage:(NSString *)imageName text:(NSString *)text detailText:(NSString *)detailsText detailFont:(UIFont *)detailsFont duration:(float)duration ;
@end
