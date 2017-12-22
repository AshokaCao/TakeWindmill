//
//  YBTechnicianCell.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/17.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBTechnicianCell.h"

@interface YBTechnicianCell ()


@end

@implementation YBTechnicianCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIImageView *iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:iconImageView];
        self.iconImageView = iconImageView;
        
        UILabel *technicianLabel = [[UILabel alloc] init];
        [self.contentView addSubview:technicianLabel];
        self.technicianLabel = technicianLabel;
        
        UILabel *yearsLabel = [[UILabel alloc] init];
        [self.contentView addSubview:yearsLabel];
        self.yearsLabel = yearsLabel;

        UILabel *speciesLabel = [[UILabel alloc] init];
        [self.contentView addSubview:speciesLabel];
        self.speciesLabel = speciesLabel;

        UIImageView *openImage = [[UIImageView alloc] init];
        [self.contentView addSubview:openImage];
        self.openImage = openImage;

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.iconImageView.frame = CGRectMake(20, 10, 60, 60);
//    self.iconImageView.image = [UIImage imageNamed:@"headimg.gif"];
    
    self.technicianLabel.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 10, 0, YBWidth / 6, self.contentView.frame.size.height);
    self.technicianLabel.textAlignment = NSTextAlignmentCenter;
//    self.technicianLabel.text = @"刘师傅";

    self.yearsLabel.frame = CGRectMake(CGRectGetMaxX(self.technicianLabel.frame) + 10, 0, YBWidth / 6, self.contentView.frame.size.height);
    self.yearsLabel.textAlignment = NSTextAlignmentCenter;
//    self.yearsLabel.text = @"3年";
    
    self.speciesLabel.frame = CGRectMake(CGRectGetMaxX(self.yearsLabel.frame) + 10, 0, YBWidth / 4, self.contentView.frame.size.height);
    self.speciesLabel.textAlignment = NSTextAlignmentCenter;
    self.speciesLabel.text = @"汽车维修检测";
    self.speciesLabel.font = YBFont(12);
    
    self.openImage.frame = CGRectMake(CGRectGetMaxX(self.speciesLabel.frame) + 10, 30, 20, 20);
    self.openImage.image = [UIImage imageNamed:@"箭头"];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
