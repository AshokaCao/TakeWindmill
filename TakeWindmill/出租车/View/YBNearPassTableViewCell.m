//
//  YBNearPassTableViewCell.m
//  TakeWindmill
//
//  Created by AshokaCao on 2017/12/22.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBNearPassTableViewCell.h"

@implementation YBNearPassTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)showDetailWith:(YBTaxiStrokeModel *)diction
{
    [self.userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:diction.HeadImgUrl] placeholderImage:[UIImage imageNamed:@"橙色圈32"]];
    self.userNameLabel.text = diction.UserName;
    self.starLabel.text = diction.StartAddress;
    self.endLabel.text = diction.EndAddress;
    NSString *time = [diction.SetoutTimeStr stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    self.timeLabel.text = time;
}
- (IBAction)robOrAction:(UIButton *)sender {
    [self.delegate didselectYBPassengerTableViewCell:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
