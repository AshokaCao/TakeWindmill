//
//  YBMessageTableViewCell.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/8.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBMessageTableViewCell.h"
#import "YBMessageModel.h"

@interface YBMessageTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation YBMessageTableViewCell

- (void)setModel:(YBMessageModel *)model {
    _model = model;
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:model.icon]  placeholderImage:[UIImage imageNamed:@"小草"]];
    self.nameLabel.text = model.nameStr;
    self.contentLabel.text = model.content;
}

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
