//
//  YBMyPubTableViewCell.m
//  TakeWindmill
//
//  Created by AshokaCao on 2017/11/28.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBMyPubTableViewCell.h"

@implementation YBMyPubTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)showDetailsWithModel:(YBMineDonationsModel *)model
{
    [self.myImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.PicUrl]] placeholderImage:[UIImage imageNamed:@""]];
    self.titlesLabel.text = [NSString stringWithFormat:@"%@",model.Title];
    self.subTitleLabel.text = [NSString stringWithFormat:@"已捐赠金额%@,已奉献爱心%@份,共%@份爱心",model.RealContributeMoney,model.MyContributeNumberP,model.ContributePeapleNumber];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
