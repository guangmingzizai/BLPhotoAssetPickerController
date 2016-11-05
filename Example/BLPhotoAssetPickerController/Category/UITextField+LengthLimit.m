//
//  UITextField+LengthLimit.m
//  BiLin
//
//  Created by 柬斐 王 on 14-12-8.
//  Copyright (c) 2014年 inbilin. All rights reserved.
//

#import "UITextField+LengthLimit.h"

@implementation UITextField (LengthLimit)

- (void)limitTextLengthTo:(NSInteger)maxLength {
    [self limitTextLengthTo:maxLength limitDo:^{
        self.text = [self.text substringToIndex:maxLength];
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

+ (void)textField:(UITextField*)textField limitTo:(NSUInteger)maxLength {
    [self textField:textField limitTo:maxLength limitDo:nil];
}

+ (void)textField:(UITextField*)textField limitTo:(NSUInteger)maxLength limitDo:(void(^)(void))doBlock {
    [textField limitTextLengthTo:maxLength limitDo:doBlock];
}

@end
