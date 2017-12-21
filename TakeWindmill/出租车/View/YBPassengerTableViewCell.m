//
//  YBPassengerTableViewCell.m
//  TakeWindmill
//
//  Created by AshokaCao on 2017/12/6.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBPassengerTableViewCell.h"

@implementation YBPassengerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self addControl];
    }
    return self;
}

- (void)addControl
{
    UIImageView *timeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_clock"]];
    UIImageView *beginImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_circle_blue"]];
    UIImageView *toImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow_double_todown"]];
    UIImageView *endImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_circle_orenge"]];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.textColor = TxetFiedColor;
    timeLabel.text = [NSString stringWithFormat:@"%@",self.routeModel.SetoutTime];
    UILabel *beginLabel = [[UILabel alloc] init];
    beginLabel.textColor = [UIColor blackColor];
    beginLabel.text = [NSString stringWithFormat:@"%@",self.routeModel.StartAddress];
    UILabel *endLabel = [[UILabel alloc] init];
    endLabel.textColor = [UIColor blackColor];
    endLabel.text = [NSString stringWithFormat:@"%@",self.routeModel.EndAddress];
    
    
    UIImageView *userHeaderImage = [[UIImageView alloc] init];
    [userHeaderImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.routeModel.HeadImgUrl]] placeholderImage:[UIImage imageNamed:@"小草"]];
    [userHeaderImage setContentMode:UIViewContentModeScaleAspectFill];
    
    userHeaderImage.layer.cornerRadius = 25;
    userHeaderImage.layer.masksToBounds = YES;
    
    UILabel *userNameLabel = [[UILabel alloc] init];
    userNameLabel.text = [NSString stringWithFormat:@"%@",self.routeModel.NickName];
    
    UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [messageBtn addTarget:self action:@selector(sendTaxiMessage:) forControlEvents:UIControlEventTouchUpInside];
    [messageBtn setBackgroundImage:[UIImage imageNamed:@"11_1"] forState:UIControlStateNormal];
    
    UIButton *callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [callBtn addTarget:self action:@selector(callTaxi:) forControlEvents:UIControlEventTouchUpInside];
    [callBtn setBackgroundImage:[UIImage imageNamed:@"电话"] forState:UIControlStateNormal];
    
    
    self.timeImageView = timeImageView;
    self.timeLabel = timeLabel;
    self.beginImageView = beginImageView;
    self.beginLabel = beginLabel;
    self.toImageView = toImageView;
    self.endImageView = endImageView;
    self.endLabel = endLabel;
    self.userHeaderImage = userHeaderImage;
    self.userNameLabel = userNameLabel;
    
    
    [self.contentView addSubview:timeImageView];
    [self.contentView addSubview:timeLabel];
    [self.contentView addSubview:beginImageView];
    [self.contentView addSubview:beginLabel];
    [self.contentView addSubview:toImageView];
    [self.contentView addSubview:endImageView];
    [self.contentView addSubview:endLabel];
    
    [self.contentView addSubview:userHeaderImage];
    [self.contentView addSubview:userNameLabel];
    [self.contentView addSubview:callBtn];
    [self.contentView addSubview:messageBtn];
    [timeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.size.sizeOffset(CGSizeMake(25, 25));
    }];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(timeImageView);
        make.left.equalTo(timeImageView.mas_right).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    [beginImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeImageView.mas_bottom).offset(5);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.size.sizeOffset(CGSizeMake(25, 25));
    }];
    [beginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(beginImageView);
        make.left.equalTo(beginImageView.mas_right).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    [toImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(beginImageView.mas_bottom).offset(10);
        make.centerX.equalTo(beginImageView);
        make.size.sizeOffset(CGSizeMake(15, 10));
    }];
    
    [endImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(toImageView.mas_bottom).offset(10);
        make.centerX.equalTo(beginImageView);
        make.size.sizeOffset(CGSizeMake(25, 25));
    }];
    [endLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(endImageView);
        make.left.equalTo(endImageView.mas_right).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    [userHeaderImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(endImageView.mas_bottom).offset(10);
        make.left.equalTo(beginImageView);
        make.size.sizeOffset(CGSizeMake(50, 50));
    }];
    [userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(userHeaderImage);
        make.left.equalTo(userHeaderImage.mas_right).offset(15);
        make.width.offset(70);
    }];
    
    [callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(userNameLabel);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.size.sizeOffset(CGSizeMake(25, 25));
        
    }];
    [messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(callBtn);
        make.right.equalTo(callBtn.mas_left).offset(-15);
        make.size.sizeOffset(CGSizeMake(25, 25));
    }];
    
    UIButton *driverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [driverBtn setBackgroundColor:BtnBlueColor];
    [driverBtn setTitle:@"确认到达乘客上车地点" forState:UIControlStateNormal];
    [driverBtn addTarget:self action:@selector(destinationClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:driverBtn];
    [driverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.left.equalTo(self.contentView.mas_left).offset(15);
    }];
    
}

- (void)showDetailsWith:(YBTaxiStrokeModel *)model
{
    self.routeModel = model;
    [self.userHeaderImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.routeModel.HeadImgUrl]] placeholderImage:[UIImage imageNamed:@"小草"]];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",self.routeModel.SetoutTime];
    self.beginLabel.text = [NSString stringWithFormat:@"%@",self.routeModel.StartAddress];
    self.endLabel.text = [NSString stringWithFormat:@"%@",self.routeModel.EndAddress];
    self.userNameLabel.text = [NSString stringWithFormat:@"%@",self.routeModel.NickName];
}

- (void)sendTaxiMessage:(UIButton *)sender
{
    [self.delegate didselectTaxiTralveBtn:1 andYBPassengerTableViewCell:self];
}

- (void)callTaxi:(UIButton *)sender
{
    [self.delegate didselectTaxiTralveBtn:2 andYBPassengerTableViewCell:self];
}

- (void)destinationClick:(UIButton *)sender
{
    [self.delegate didselectTaxiTralveBtn:3 andYBPassengerTableViewCell:self];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

