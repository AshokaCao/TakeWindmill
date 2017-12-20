//
//  YBPublicWelfareCell.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/18.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBPublicWelfareCell.h"

@implementation YBPublicWelfareCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)showDetailsWithModel:(YBPublicListTableModel *)model
{
    [self.publicImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.PicUrl]] placeholderImage:[UIImage imageNamed:@"公益"]];
    self.titleLabel.text = [NSString stringWithFormat:@"%@",model.Title];
    self.subTitleLabel.text = [NSString stringWithFormat:@"%@",model.SubTitle];
    self.loverCountLabel.text = [NSString stringWithFormat:@"共 %@ 份爱心",model.ContributePeapleNumber];
    self.targetLabel.text = [NSString stringWithFormat:@"目标 %@ 万",model.ContributeMoney];
    CGFloat propor = (CGFloat )[model.RealContributeMoney integerValue] / [model.ContributeMoney integerValue];
    self.progView.progress = propor;
    self.proporLabel.text = [NSString stringWithFormat:@"%.2f%%",propor * 100];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
