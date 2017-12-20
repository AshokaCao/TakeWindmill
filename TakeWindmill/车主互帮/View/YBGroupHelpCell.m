//
//  YBGroupHelpCell.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/11/28.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBGroupHelpCell.h"

@interface YBGroupHelpCell()
{
}

@end
@implementation YBGroupHelpCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

-(void)setUI{
    WEAK_SELF;
    //CGFloat font = 14;
    CGSize checkSize = CGSizeMake(32, 32);
    CGSize iconSize = CGSizeMake(40, 40);
    UIImageView * icon = [[UIImageView alloc]init];
    icon.image = [UIImage imageNamed:@"未选择"];
    [weakSelf.contentView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kpadding);
        make.centerY.equalTo(weakSelf);
        //make.size.mas_equalTo(checkSize);
    }];
    weakSelf.check = icon;
    
    icon = [[UIImageView alloc]init];
    icon.image = [UIImage imageNamed:@"客服中心"];
    icon.layer.cornerRadius = iconSize.height/2;
    icon.clipsToBounds = YES;
    [weakSelf.contentView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.check.mas_right).offset(kpadding);
        make.centerY.equalTo(weakSelf);
        make.size.mas_equalTo(iconSize);
    }];
    weakSelf.icon = icon;
    
    
    UILabel * ins = [[UILabel alloc]init];
    //ins.text = @"123123132";
    //ins.textColor = kTextGreyColor;
    [weakSelf.contentView addSubview:ins];
    [ins mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.icon.mas_right).offset(kpadding);
        make.centerY.equalTo(weakSelf);
    }];
    weakSelf.nickName = ins;
    
    ins = [[UILabel alloc]init];
    //ins.text = @"222信息";
    //ins.textColor = kTextGreyColor;
    [weakSelf.contentView addSubview:ins];
    [ins mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nickName.mas_right).offset(kpadding);
        make.centerY.equalTo(weakSelf);
    }];
    weakSelf.carNumber = ins;
}
-(void)setUserInfoList:(UserInfoList *)userInfoList{

    [self.icon sd_setImageWithURL:[NSURL URLWithString:userInfoList.HeadImgUrl] placeholderImage:[UIImage imageNamed:@"车主认证"]];
    self.nickName.text = userInfoList.NickName;
    self.carNumber.text = userInfoList.VehicleNumber;
    
    self.textLabel.text = userInfoList.UserId;
    self.textLabel.hidden = YES;

}
@end
