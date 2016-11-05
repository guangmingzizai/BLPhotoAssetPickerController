//
//  BLUserInterfaceTransitionService.m
//  BLPhotoAssetPickerController
//
//  Created by wangjianfei on 2016/11/5.
//  Copyright © 2016年 guangmingzizai. All rights reserved.
//

#import "BLUserInterfaceTransitionService.h"
#import "BLAppDelegate.h"
#import "BLSendNinePicStuatusViewController.h"

@implementation BLUserInterfaceTransitionService

Implement_Singleton(BLUserInterfaceTransitionService)

- (void)showInitialScreen {
    BLSendNinePicStuatusViewController *viewController = [[BLSendNinePicStuatusViewController alloc]init];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self.window makeKeyAndVisible];
}

- (UIWindow *)window {
    BLAppDelegate *appDelegate = (BLAppDelegate *)[[UIApplication sharedApplication] delegate];
    return appDelegate.window;
}

@end
