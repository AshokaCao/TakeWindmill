//
//  YBFindOwnerCell.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/9/4.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBFindOwnerCell.h"

@interface YBFindOwnerCell ()

/**
 * view
 */
@property (weak, nonatomic) UIView *itemView;

/**
 * 图标
 */
@property (nonatomic, weak) UIImageView *iconImageView;

/**
 * 类型
 */
@property (nonatomic, weak) UILabel *titleLabel;

/**
 * 箭头
 */
@property (nonatomic, weak) UIImageView *arrowImageView;

@end

@implementation YBFindOwnerCell

#pragma mark - lzay
- (UIView *)itemView
{
    if (!_itemView) {
        UIView *itme = [[UIView alloc] init];
        itme.backgroundColor = [UIColor whiteColor];
        //给bgView边框设置阴影
        itme.layer.shadowOffset = CGSizeMake(1,1);
        itme.layer.shadowOpacity = 0.1;
        itme.layer.shadowColor = [UIColor grayColor].CGColor;
        [self addSubview:itme];
        
        _itemView = itme;
    }
    return _itemView;
}
- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        UIImageView *iconImageView = [[UIImageView alloc] init];
        iconImageView.image = [UIImage imageNamed:@"附近乘客"];
        [self addSubview:iconImageView];
        _iconImageView = iconImageView;
    }
    return _iconImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"附近乘客";
        titleLabel.font = YBFont(14);
        [self addSubview:titleLabel];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

- (UIImageView *)arrowImageView
{
    if (!_arrowImageView) {
        UIImageView *arrowImageView = [[UIImageView alloc] init];
        arrowImageView.image = [UIImage imageNamed:@"箭头"];
        [self addSubview:arrowImageView];
        _arrowImageView = arrowImageView;
    }
    return _arrowImageView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor        = [UIColor clearColor];

    self.itemView.frame         = CGRectMake(10,0,self.frame.size.width - 20,self.frame.size.height);
    self.iconImageView.frame    = CGRectMake(20, 15, 20 , 20);
    self.titleLabel.frame       = CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 10, self.iconImageView.frame.origin.y, 120, self.iconImageView.frame.size.height);
    self.titleLabel.text        = self.typeStr;
    self.arrowImageView.frame   = CGRectMake(self.frame.size.width - 25, self.iconImageView.frame.origin.y + 3, 6,12);
    
    for (int i = 0; i < self.passengerArray.count; i ++) {
        
        NSInteger col = i / 3;
        NSInteger row = i % 3;

        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(row * (YBWidth / 4 + 10) + 20,CGRectGetMaxY(self.titleLabel.frame) + 15 + col * 35, YBWidth / 4, 20);
        btn.titleLabel.font = YBFont(14);
        [btn setBackgroundColor:[UIColor lightGrayColor]];
        if ([self.typeStr isEqualToString:@"附近乘客"]) {
            [btn setTitle:[NSString stringWithFormat:@"%@ %@人",self.passengerArray[i][@"EndRoad"],self.passengerArray[i][@"PeopleNumber"]] forState:UIControlStateNormal];
        }
        else {
            [btn setTitle:[NSString stringWithFormat:@"%@ %@人",self.passengerArray[i][@"AreaName"],self.passengerArray[i][@"PeopleNumber"]] forState:UIControlStateNormal];
        }
        [btn addTarget:self action:@selector(lookForNearbyPassengers:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}

- (void)lookForNearbyPassengers:(UIButton *)sender
{
    
}

@end
