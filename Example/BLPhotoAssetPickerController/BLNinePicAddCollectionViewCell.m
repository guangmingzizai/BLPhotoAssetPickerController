//
//  BLNinePicAddCollectionViewCell.m
//  BiLin
//
//  Created by devduwan on 15/9/22.
//  Copyright © 2015年 inbilin. All rights reserved.
//

#import "BLNinePicAddCollectionViewCell.h"

@implementation BLNinePicAddCollectionViewCell {
    UIView *_coverView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    self.backgroundColor = UIColorFromRGB(0xf8f8f8);
    self.contentView.backgroundColor = UIColorFromRGB(0xf8f8f8);
    self.layer.borderColor = UIColorFromRGB(0xececec).CGColor;
    self.layer.borderWidth = 1;
    
    _coverView = [[UIView alloc]init];
    _coverView.backgroundColor = UIColorFromRGBA(0x000000, 0.1);
    _coverView.hidden = YES;
    [self addSubview:_coverView];
    [_coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    UIImageView *addImageView = [[UIImageView alloc]init];
    UIImage *addImage = [UIImage imageNamed:@"status_choseninepic"];
    addImageView.image = addImage;
    [self addSubview:addImageView];
    [addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.left.top.mas_equalTo(self.frame.size.width/2-15);
    }];
    
    self.userInteractionEnabled = YES;
    UIGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPic)];
    [self addGestureRecognizer:recognizer];
}

- (void)addPic {
    if ([self.addDelegate respondsToSelector:@selector(addPicNineStatus)]) {
        _coverView.hidden = NO;
        [self.addDelegate addPicNineStatus];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    _coverView.hidden = NO;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    _coverView.hidden = YES;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    _coverView.hidden = YES;
}

@end
