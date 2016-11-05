//
//  UITextField+LengthLimit.h
//  BiLin
//
//  Created by 柬斐 王 on 14-12-8.
//  Copyright (c) 2014年 inbilin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (LengthLimit)

- (void)limitTextLengthTo:(NSInteger)maxLength;
- (void)limitTextLengthTo:(NSInteger)maxLength limitDo:(void(^)(void))doBlock;
+ (void)textField:(UITextField*)textField limitTo:(NSUInteger)maxLength;
+ (void)textField:(UITextField*)textField limitTo:(NSUInteger)maxLength limitDo:(void(^)(void))doBlock;

@end
