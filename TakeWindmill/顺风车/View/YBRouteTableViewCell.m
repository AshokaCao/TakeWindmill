//
//  YBRouteTableViewCell.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/9.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBRouteTableViewCell.h"

@interface YBRouteTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *itemView;

@end

@implementation YBRouteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.backgroundColor            = [UIColor clearColor];
    self.itemView.backgroundColor   = [UIColor whiteColor];
    //给bgView边框设置阴影
    self.itemView.layer.shadowOffset    = CGSizeMake(1,1);
    self.itemView.layer.shadowOpacity   = 0.1;
    self.itemView.layer.shadowColor     = [UIColor grayColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
