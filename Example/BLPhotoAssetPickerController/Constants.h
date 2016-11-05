//
//  Constants.h
//  BLPhotoAssetPickerController
//
//  Created by wangjianfei on 2016/11/5.
//  Copyright © 2016年 guangmingzizai. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#define iOS_Version [[[UIDevice currentDevice] systemVersion] floatValue]
#define UI_SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define UI_SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define RGB(r,g,b)          [UIColor colorWithRed:(r)/255.f \
green:(g)/255.f \
blue:(b)/255.f \
alpha:1.f]

#define RGBA(r,g,b,a)       [UIColor colorWithRed:(r)/255.f \
green:(g)/255.f \
blue:(b)/255.f \
alpha:(a)]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGBA(rgbValue, a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

//定义了一个__weak的self_weak_变量
#define weakifySelf  \
__weak __typeof(&*self)weakSelf = self;

//局域定义了一个__strong的self指针指向self_weak
#define strongifySelf \
__strong __typeof(&*weakSelf)self = weakSelf;

//---------------------------------------------------------------------
#pragma mark - singleton

#define Declare_Singleton() + (instancetype)sharedInstance;

#define Implement_Singleton(_class_name)\
+ (instancetype)sharedInstance\
{\
static _class_name* gInstance = nil;\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
gInstance = [[_class_name alloc] init];\
});\
return gInstance;\
}

#define Declare_GetInstance() + (instancetype)getInstance;

#define Implement_GetInstance(_class_name)\
+ (instancetype)getInstance {\
static __weak _class_name *gInstance = nil;\
_class_name *currentInstance = gInstance;\
@synchronized(self) {\
if (!currentInstance) {\
currentInstance = [[_class_name alloc] init];\
gInstance = currentInstance;\
}\
}\
return currentInstance;\
}

//---------------------------------------------------------------------
#pragma mark - dispatch_safe
#define dispatch_main_sync_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}

#define dispatch_main_async_safe(block)\
dispatch_async(dispatch_get_main_queue(), block);\

#define kAppMainColor [UIColor whiteColor]
#define kAppTintColor RGB(36, 189, 152)
#define kAppTextColor UIColorFromRGB(0x3c3c3c)
#define kAppGrayColor RGB(199, 200, 201)
#define kAppLightGrayColor RGB(119, 120, 121)

#endif /* Constants_h */
