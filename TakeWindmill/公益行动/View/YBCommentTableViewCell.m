//
//  YBCommentTableViewCell.m
//  TakeWindmill
//
//  Created by AshokaCao on 2017/11/22.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBCommentTableViewCell.h"

@implementation YBCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)showDetailsWithModel:(YBCommentModels *)model
{
    [self.userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.HeadImgUrl]] placeholderImage:[UIImage imageNamed:@"小草"]];
    NSString *nickName = [NSString stringWithFormat:@"%@",model.NickName];
    if (model.NickName) {
        self.userNameLabel.text = nickName;
    } else {
        self.userNameLabel.text = @"匿名";
    }
    self.contentLabel.text = [NSString stringWithFormat:@"%@",model.CommnentContent];
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
