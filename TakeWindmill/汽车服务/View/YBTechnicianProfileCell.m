//
//  YBTechnicianProfileCell.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/18.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBTechnicianProfileCell.h"
#import "UIView+SDAutoLayout.h"

@implementation YBTechnicianProfileCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)callHimeAction:(UIButton *)sender {
    
}

- (void)showListWIthModel:(YBTechnicianModel *)model
{
    [self.userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:model.WorkerPhotoUrl] placeholderImage:[UIImage imageNamed:@"红包"]];
    self.workerNameLabel.text = model.WorkerName;
    self.workingDaysLabel.text = model.Experience;
    self.easyInstall.text = model.JobIntrduction;
//    self.easyInstall.
    [self.easyInstall setSingleLineAutoResizeWithMaxWidth:self.mj_w - 110];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
