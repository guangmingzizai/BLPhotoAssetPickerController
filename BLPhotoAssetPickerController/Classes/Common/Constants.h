//
//  Constants.h
//  Pods
//
//  Created by wangjianfei on 2016/11/5.
//
//

#ifndef Constants_h
#define Constants_h

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGBA(rgbValue, a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#define UI_SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define UI_SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

#define iOS_Version [[[UIDevice currentDevice] systemVersion] floatValue]

#endif /* Constants_h */
