//
//  YBRedEnvelopesCell.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/10.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBRedEnvelopesCell.h"

@implementation YBRedEnvelopesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setListMessageWithModel:(YBUserListModel *)model
{
    _model = model;
    NSString *timeStr = model.AddTime;
    self.timeLabel.text = [timeStr stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    self.moneyLabel.text = [NSString stringWithFormat:@"%@ 元",model.Money];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
