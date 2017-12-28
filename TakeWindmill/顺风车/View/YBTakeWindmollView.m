//
//  YBTakeWindmollHeadView.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/9.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBTakeWindmollView.h"

@interface YBTakeWindmollView ()<UIScrollViewDelegate>

///@brife 上方的按钮数组
@property (strong, nonatomic) NSMutableArray *topViews;

/**
 * 乘客
 */
@property (nonatomic, weak) UIButton *passengerButton;

/**
 * 车主
 */
@property (nonatomic, weak) UIButton *ownerButton;

/**
 * 下划线
 */
@property (nonatomic, weak) UIView *lineView;

/**
 * 客服
 */
@property (nonatomic, weak) UIButton *customerButton;

/**
 * 通讯录
 */
@property (nonatomic, weak) UIButton *mailListButton;

@end

@implementation YBTakeWindmollView

- (UIButton *)passengerButton
{
    if (!_passengerButton) {
        UIButton *passengerButton       = [[UIButton alloc] init];
        passengerButton.tag             = 0;
        passengerButton.selected        = YES;
        passengerButton.titleLabel.font = YBFont(13);
        [passengerButton setTitle:@"环保乘客" forState:UIControlStateNormal];
        [passengerButton setTitleColor:BtnBlueColor forState:UIControlStateSelected];
        [passengerButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [passengerButton addTarget:self action:@selector(passengerAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:passengerButton];
        _passengerButton                = passengerButton;
    }
    return _passengerButton;
}

- (UIButton *)ownerButton
{
    if (!_ownerButton) {
        UIButton *ownerButton       = [[UIButton alloc] init];
        ownerButton.tag             = 1;
        ownerButton.titleLabel.font = YBFont(13);
        [ownerButton setTitle:@"爱心车主" forState:UIControlStateNormal];
        [ownerButton setTitleColor:BtnBlueColor forState:UIControlStateSelected];
        [ownerButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [ownerButton addTarget:self action:@selector(passengerAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:ownerButton];
        _ownerButton                = ownerButton;
    }
    return _ownerButton;
}

- (UIView *)lineView
{
    if (!_lineView) {
        UIView *lineView          = [[UIView alloc] init];
        lineView.backgroundColor  = BtnBlueColor;
        [self addSubview:lineView];
        _lineView                 = lineView;
    }
    return _lineView;
}

- (UIButton *)customerButton
{
    if (!_customerButton) {
        UIButton *customerButton  = [[UIButton alloc] init];
        [customerButton setImage:[UIImage imageNamed:@"1_1"] forState:UIControlStateNormal];
        [self addSubview:customerButton];
        _customerButton       = customerButton;
    }
    return _customerButton;
}

- (UIButton *)mailListButton
{
    if (!_mailListButton) {
        UIButton *mailListButton  = [[UIButton alloc] init];
        [mailListButton setImage:[UIImage imageNamed:@"2_2"] forState:UIControlStateNormal];
        [self addSubview:mailListButton];
        _mailListButton           = mailListButton;
    }
    return _mailListButton;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.passengerButton.frame =CGRectMake(10, 10, 60, 20);
    self.ownerButton.frame =CGRectMake(CGRectGetMaxX(self.passengerButton.frame) + 10, 10, 60, 20);
    self.lineView.frame = CGRectMake(10, CGRectGetMaxY(self.passengerButton.frame), 60, 2);
//    self.customerButton.frame =CGRectMake(YBWidth - 65, 10, 20, 20);
//    self.mailListButton.frame =CGRectMake(YBWidth - 30, 10, 20, 20);
    
    _topViews = [NSMutableArray array];
    [self.topViews addObject:self.passengerButton];
    [self.topViews addObject:self.ownerButton];
}

- (void)passengerAction:(UIButton *)sender
{
    if (!sender.selected) {
        self.passengerButton.selected = !self.passengerButton.selected;
        self.ownerButton.selected = !self.ownerButton.selected;
        [UIView animateWithDuration:0.5 animations:^{
            self.scrollView.contentOffset = CGPointMake(sender.tag *YBWidth, 0);
            self.lineView.frame = CGRectMake(10 + sender.tag * (60 + 10), CGRectGetMaxY(self.passengerButton.frame), 60, 2);
        }];
        if (_buttonBlok) {
            _buttonBlok(sender);
        }
    }
}

- (void)changeBackColorWithPage:(NSInteger)currentPage {
    
    for (int i = 0; i < _topViews.count ; i ++) {
        
        UIButton *button = _topViews[i];
        if (i == currentPage) {
            button.selected = YES;
        } else {
            button.selected = NO;
        }
    }
}

- (void)changeTheUnderline:(NSUInteger)pageNumber
{
    [self changeBackColorWithPage:pageNumber];
    self.lineView.frame = CGRectMake(10 + pageNumber * (60 + 10), CGRectGetMaxY(self.passengerButton.frame), 60, 2);
}

@end

















@interface  YBTakeHeadView ()

@property (nonatomic, weak) UILabel *nameLabel;

@property (nonatomic, weak) UIImageView *iconImageView;

@property (nonatomic, weak) UIButton *itineraryButton;

@end

@implementation YBTakeHeadView

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        UILabel *label = [[UILabel alloc] init];
        [self addSubview:label];
        _nameLabel = label;
    }
    return _nameLabel;
}

- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        _iconImageView = imageView;
    }
    return _iconImageView;
}

- (UIButton *)itineraryButton
{
    if (!_itineraryButton) {
        UIButton *button = [[UIButton alloc] init];
        [self addSubview:button];
        _itineraryButton = button;
    }
    return _itineraryButton;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(20);
        make.top.equalTo(self).with.offset(20);
        make.bottom.equalTo(self.iconImageView.mas_bottom);
        make.right.equalTo(self.iconImageView.mas_left).with.offset(-10);
    }];
//    self.nameLabel.text = [NSString stringWithFormat:@"%@,你好",self.nameStr];
    
    self.iconImageView.frame = CGRectMake(YBWidth - 90,  40, 80, 30);
    self.iconImageView.image = [UIImage imageNamed:@"小汽车"];
    
    [self.itineraryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(10);
        make.top.equalTo(self.iconImageView.mas_bottom).with.offset(20);
        make.bottom.equalTo(self).with.offset(-10);
        make.right.equalTo(self).with.offset(-10);
        make.centerX.equalTo(self);
    }];

    self.itineraryButton.layer.cornerRadius = 5;
    [self.itineraryButton setBackgroundColor:BtnBlueColor];
    [self.itineraryButton setTitle:@"发布行程" forState:UIControlStateNormal];
    [self.itineraryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.itineraryButton addTarget:self action:@selector(itineraryButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setNameStr:(NSString *)nameStr
{
    self.nameLabel.text = [NSString stringWithFormat:@"%@,你好",nameStr];
}

- (void)itineraryButtonAction:(UIButton *)sender
{
    if (_selectButtonBlock) {
        _selectButtonBlock(sender);
    }
}

@end
