//
//  YBHelpWithMeCell.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/11/28.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBHelpWithMeCell.h"
@interface YBHelpWithMeCell()
{
    
}
@property(nonatomic,strong) UIImageView *icon;
@property(nonatomic,strong) UILabel *name;
@property(nonatomic,strong) UILabel *carNumber;
@property(nonatomic,strong) UILabel *info;
@property(nonatomic,strong) UILabel *time;
@end
@implementation YBHelpWithMeCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}
-(void)setUI{
    WEAK_SELF;
    CGFloat font = 14;
    CGFloat timeFont = 12;
    CGSize iconSize = CGSizeMake(50, 50);
    UIImageView * icon = [[UIImageView alloc]init];
    icon.image = [UIImage imageNamed:@"客服中心"];
    icon.layer.cornerRadius = iconSize.height/2;
    icon.clipsToBounds = YES;
    [weakSelf.contentView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kpadding);
        make.centerY.equalTo(weakSelf);
        make.size.mas_equalTo(iconSize);
    }];
    weakSelf.icon = icon;
    
    
    UILabel * ins = [[UILabel alloc]init];
    ins.font = YBFont(font);
    //ins.textColor = kTextGreyColor;
    [weakSelf.contentView addSubview:ins];
    [ins mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.icon.mas_right).offset(kpadding);
        make.top.equalTo(@kpadding);
    }];
    weakSelf.name = ins;
    
    ins = [[UILabel alloc]init];
    ins.font = YBFont(font);
    //ins.textColor = kTextGreyColor;
    [weakSelf.contentView addSubview:ins];
    [ins mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.name.mas_right).offset(kpadding);
        make.top.equalTo(weakSelf.name);
    }];
    weakSelf.carNumber = ins;
    
    
    ins = [[UILabel alloc]init];
    ins.text = @"未处理";
    ins.font = YBFont(font);
    //ins.textColor = kTextGreyColor;
    [weakSelf.contentView addSubview:ins];
    [ins mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kpadding);
        make.centerY.equalTo(weakSelf.name);
    }];
    weakSelf.state = ins;
    
    ins = [[UILabel alloc]init];
    ins.font = YBFont(timeFont);
    ins.textColor = kTextGreyColor;
    [weakSelf.contentView addSubview:ins];
    [ins mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kpadding);
        make.top.equalTo(weakSelf.state.mas_bottom).offset(kpadding);
    }];
    weakSelf.time = ins;
    
    
    ins = [[UILabel alloc]init];
    ins.font = YBFont(timeFont);
    ins.textColor = kTextGreyColor;
    [weakSelf.contentView addSubview:ins];
    [ins mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.name);
        make.centerY.equalTo(weakSelf.time);//.offset(kpadding);
        //make.width.lessThanOrEqualTo(@300);
        //make.right.equalTo(weakSelf.time.mas_left).priority(600);
        //指定宽度为父视图的
        make.width.equalTo(weakSelf.contentView).multipliedBy(0.55);
    }];
    weakSelf.info = ins;
    
}
-(void)setUserInfoList:(UserInfoList *)userInfoList{
    [self.icon sd_setImageWithURL:[NSURL URLWithString:userInfoList.HeadImgUrl] placeholderImage:[UIImage imageNamed:@"车主认证"]];
    self.name.text = userInfoList.NickName;
    self.carNumber.text = userInfoList.VehicleNumber;
    self.info.text = userInfoList.Message;
    self.state.text = [Tools getState:userInfoList.ReplyStat];
    self.time.text = [HSHString timeWithStr:userInfoList.AddTime];
    
}

@end
