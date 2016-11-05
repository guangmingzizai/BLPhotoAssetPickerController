//
//  BLNinePicCollectionViewCell.m
//  BiLin
//
//  Created by devduwan on 15/9/22.
//  Copyright © 2015年 inbilin. All rights reserved.
//

#import "BLNinePicCollectionViewCell.h"

@implementation BLNinePicCollectionViewCell{
    UIButton *closeButton;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    self.contentView.backgroundColor = [UIColor purpleColor];
    _picImageView = [[UIImageView alloc]init];
    _picImageView.clipsToBounds = YES;
    _picImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_picImageView];
    [_picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    _closeView = [[UIView alloc]init];
    [self addSubview:_closeView];
    [_closeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(28, 28));
    }];

    closeButton = [[UIButton alloc]init];
    [closeButton setBackgroundColor:UIColorFromRGBA(0x000000, 0.3)];
    [closeButton setImage:[UIImage imageNamed:@"status_removepic"] forState:UIControlStateNormal];
    [closeButton setImageEdgeInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    [_closeView addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(22, 22));
        make.left.top.mas_equalTo(3);
    }];
    closeButton.layer.masksToBounds = YES;
    closeButton.layer.cornerRadius = 11;
    [closeButton addTarget:self action:@selector(removeTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    //[closeButton addTarget:self action:@selector(removeTouchCancel) forControlEvents:UIControlEventTouchCancel];

    
    //[closeButton addTarget:self action:@selector(removePic) forControlEvents:UIControlEventTouchUpOutside];
}

- (void)removeTouchUpInside {
    [closeButton setBackgroundColor:UIColorFromRGBA(0x000000, 0.4)];
    [self removePic];
}

- (void)removePic {
    if([self.removeDelegate respondsToSelector:@selector(removePicNine:)]){
        [self.removeDelegate removePicNine:self.indexPath];
    }
}

@end
