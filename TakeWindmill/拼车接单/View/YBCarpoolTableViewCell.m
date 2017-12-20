//
//  YBCarpoolTableViewCell.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/10.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBCarpoolTableViewCell.h"

@interface YBCarpoolTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *itemView;

@property (weak, nonatomic) IBOutlet UILabel *commissionLabel;
@property (weak, nonatomic) IBOutlet UIButton *matchButton;
@property (weak, nonatomic) IBOutlet UIButton *agreeButton;
@property (weak, nonatomic) IBOutlet UIButton *agreeButton1;

@end

@implementation YBCarpoolTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.itemView.layer.shadowOffset=CGSizeMake(1, 1);
    self.itemView.layer.shadowOpacity=0.1;
    
    self.commissionLabel.layer.masksToBounds = YES;
    self.commissionLabel.layer.cornerRadius = 2;
    self.matchButton.layer.cornerRadius = 2 ;
    self.agreeButton.layer.cornerRadius = 2;
    self.agreeButton1.layer.cornerRadius = 2;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
