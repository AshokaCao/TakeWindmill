//
//  YBStrokeCell.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/12/14.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBStrokeCell.h"
@interface YBStrokeCell()
{
    
}
@property(nonatomic,strong) UILabel *title;
@property(nonatomic,strong) UILabel *state;
@property(nonatomic,strong) UILabel *time;
@property(nonatomic,strong) UILabel *startLoction;
@property(nonatomic,strong) UILabel *endLoction;
@property(nonatomic,strong) UIImageView *imageV;
@end
@implementation YBStrokeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUI];
    }
    return self;
}
-(void)setUI{
    WEAK_SELF;
    CGFloat font = 14;
    CGFloat timeFont = 12;
    CGSize timeIconSize = CGSizeMake(10, 10);
    CGSize circleSize = CGSizeMake(10, 10);
    
    UILabel * ins = [[UILabel alloc]init];
    ins.font = YBFont(font);
    //ins.textColor = kTextGreyColor;
    ins.text = @"顺风车";
    [weakSelf.contentView addSubview:ins];
    [ins mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kpadding);
        make.top.mas_equalTo(kpadding);
    }];
    weakSelf.title = ins;
    
   
    UIImageView * icon = [[UIImageView alloc]init];
    icon.image = [UIImage imageNamed:@"icon_chose_arrow_nor"];//icon_chose_arrow_nor  箭头
    [weakSelf.contentView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kpadding);
        make.centerY.equalTo(weakSelf.title);
        //make.size.mas_equalTo(iconSize);
    }];
    weakSelf.imageV = icon;
    
    ins = [[UILabel alloc]init];
    ins.font = YBFont(font);
    //ins.textColor = kTextGreyColor;
    ins.text = @"顺风车";
    [weakSelf.contentView addSubview:ins];
    [ins mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.imageV.mas_left);
         make.centerY.equalTo(weakSelf.title);
    }];
    weakSelf.state = ins;
    
    icon = [[UIImageView alloc]init];
    icon.image = [UIImage imageNamed:@"icon_clock"];
    [weakSelf.contentView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kpadding);
        make.top.mas_equalTo(weakSelf.title.mas_bottom).offset(kpadding);
        make.size.mas_equalTo(timeIconSize);
    }];
    weakSelf.imageV = icon;
    
    ins = [[UILabel alloc]init];
    ins.font = YBFont(timeFont);
    //ins.textColor = kTextGreyColor;
    ins.text = @"顺风车";
    [weakSelf.contentView addSubview:ins];
    [ins mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.imageV.mas_right).offset(kpadding);
        make.centerY.equalTo(weakSelf.imageV);
    }];
    weakSelf.time = ins;
    
    icon = [[UIImageView alloc]init];
    icon.image = [UIImage imageNamed:@"icon_circle_orenge"];
    [weakSelf.contentView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kpadding);
        make.top.mas_equalTo(weakSelf.time.mas_bottom).offset(kpadding);;
        make.size.mas_equalTo(circleSize);
    }];
    weakSelf.imageV = icon;
    
    ins = [[UILabel alloc]init];
    ins.font = YBFont(font);
    //ins.textColor = kTextGreyColor;
    ins.text = @"顺风车";
    [weakSelf.contentView addSubview:ins];
    [ins mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.imageV.mas_right).offset(kpadding);
        make.centerY.equalTo(weakSelf.imageV);
    }];
    weakSelf.startLoction = ins;
    
    icon = [[UIImageView alloc]init];
    icon.image = [UIImage imageNamed:@"icon_circle_blue"];
    [weakSelf.contentView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kpadding);
        make.top.mas_equalTo(weakSelf.startLoction.mas_bottom).offset(kpadding);;
        make.size.mas_equalTo(circleSize);
    }];
    weakSelf.imageV = icon;
    
    ins = [[UILabel alloc]init];
    ins.font = YBFont(font);
    //ins.textColor = kTextGreyColor;
    ins.text = @"顺风车";
    [weakSelf.contentView addSubview:ins];
    [ins mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.imageV.mas_right).offset(kpadding);
        make.centerY.equalTo(weakSelf.imageV);
    }];
    weakSelf.endLoction = ins;
    

}

//-(void)setUserInfoList:(UserInfoList *)userInfoList{
//    [self.icon sd_setImageWithURL:[NSURL URLWithString:userInfoList.HeadImgUrl] placeholderImage:[UIImage imageNamed:@"车主认证"]];
//    self.name.text = userInfoList.NickName;
//    self.carNumber.text = userInfoList.VehicleNumber;
//    self.info.text = userInfoList.Message;
//    self.state.text = [Tools getState:userInfoList.ReplyStat];
//    self.time.text = [HSHString timeWithStr:userInfoList.AddTime];
//
//}

@end
