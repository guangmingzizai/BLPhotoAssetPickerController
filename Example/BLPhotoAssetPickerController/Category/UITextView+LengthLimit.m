//
//  UITextView+LengthLimit.m
//  BiLin
//
//  Created by 柬斐 王 on 15/7/14.
//  Copyright (c) 2015年 inbilin. All rights reserved.
//

#import "UITextView+LengthLimit.h"

@implementation UITextView (LengthLimit)

- (void)limitTextLengthTo:(NSInteger)maxLength {
    [self limitTextLengthTo:maxLength limitDo:^{
    }];
}

- (void)limitTextLengthTo:(NSInteger)maxLength limitDo:(void(^)(void))doBlock {
    NSString *toBeString = self.text;
    UITextRange *selectedRange = [self markedTextRange];
    //获取高亮部分
    UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position) {
        if (toBeString.length > maxLength) {
            [self deleteBackward];
            if (doBlock) {
                doBlock();
            }
        }
    }
}

+ (void)textView:(UITextView *)textView limitTo:(NSUInteger)maxLength {
    [self textView:textView limitTo:maxLength limitDo:nil];
}

+ (void)textView:(UITextView *)textView limitTo:(NSUInteger)maxLength limitDo:(void(^)(void))doBlock {
    [textView limitTextLengthTo:maxLength limitDo:doBlock];
}

@end
