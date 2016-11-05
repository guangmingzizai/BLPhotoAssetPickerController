//
//  BLAppearance.m
//  BLPhotoAssetPickerController
//
//  Created by wangjianfei on 2016/11/5.
//  Copyright © 2016年 guangmingzizai. All rights reserved.
//

#import "BLAppearance.h"

@implementation BLAppearance

+ (void)setupGlobalStyle
{
    NSShadow *zeroOffsetShadow = [[NSShadow alloc] init];
    zeroOffsetShadow.shadowOffset = CGSizeMake(0.0, 0.0);
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    UINavigationBar *navBar = [UINavigationBar appearance];
    navBar.barStyle = UIBarStyleDefault;
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : kAppTextColor,
                                     NSFontAttributeName: [UIFont boldSystemFontOfSize:16],
                                     NSShadowAttributeName: zeroOffsetShadow}];
    
    [navBar setShadowImage:[UIImage new]];
    [navBar setTintColor:kAppTintColor];
    [navBar setBackgroundColor:kAppMainColor];
    
    UITabBar *tabBar = [UITabBar appearance];
    tabBar.barStyle = UIBarStyleDefault;
    [tabBar setTintColor:kAppTintColor];
    [tabBar setBackgroundColor:kAppMainColor];
    
    [[UITextView appearance] setTintColor:kAppTintColor];
    [[UITextField appearance] setTintColor:kAppTintColor];
}

@end
