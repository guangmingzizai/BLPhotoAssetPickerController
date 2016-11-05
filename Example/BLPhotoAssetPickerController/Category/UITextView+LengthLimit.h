//
//  UITextView+LengthLimit.h
//  BiLin
//
//  Created by 柬斐 王 on 15/7/14.
//  Copyright (c) 2015年 inbilin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (LengthLimit)

- (void)limitTextLengthTo:(NSInteger)maxLength;
- (void)limitTextLengthTo:(NSInteger)maxLength limitDo:(void(^)(void))doBlock;
+ (void)textView:(UITextView *)textView limitTo:(NSUInteger)maxLength;
+ (void)textView:(UITextView *)textView limitTo:(NSUInteger)maxLength limitDo:(void(^)(void))doBlock;

@end
