//
//  YBTaxiStrokeTableViewCell.m
//  TakeWindmill
//
//  Created by AshokaCao on 2017/12/4.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBTaxiStrokeTableViewCell.h"

@implementation YBTaxiStrokeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)showDetailsWith:(YBTaxiStrokeModel *)model
{
    self.model = model;
    NSString *time = [NSString stringWithFormat:@"%@",self.model.SetoutTime];
    [time stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    self.timeLabel.text = time;
    self.beginLabel.text = [NSString stringWithFormat:@"%@",self.model.StartAddress];
    self.endLabel.text = [NSString stringWithFormat:@"%@",self.model.EndAddress];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
