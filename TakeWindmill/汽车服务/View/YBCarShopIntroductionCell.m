//
//  YBCarShopIntroductionCell.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/17.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBCarShopIntroductionCell.h"

@interface YBCarShopIntroductionCell ()

@property (nonatomic, weak) UILabel *introductionLable;

@property (nonatomic, weak) UILabel *timeLable;

@end

@implementation YBCarShopIntroductionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UILabel *introductionLable = [[UILabel alloc] init];
        [self.contentView addSubview:introductionLable];
        self.introductionLable = introductionLable;
        
        UILabel *timeLable = [[UILabel alloc] init];
        [self.contentView addSubview:timeLable];
        self.timeLable = timeLable;

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.introductionLable.frame = CGRectMake(10, 10, YBWidth - 20, 60);
    self.introductionLable.font = YBFont(12);
    self.introductionLable.numberOfLines = 0;
    self.introductionLable.text = @"浙江宝利德股份有限公司是宝利德控股集团与摩根·士丹利共同出资筹建的专业从事高端汽车服务运营的股份公司，在汽车服务行业经营18年，现有员工2500余人。旗下主要经营劳斯莱斯、阿斯顿·马丁、梅赛德斯-奔驰、捷豹路虎、林肯、一汽-大众奥迪等高端品牌授权4S中心，并已成为梅赛德斯-奔驰·中国、捷豹";
    
    self.timeLable.frame = CGRectMake(10, CGRectGetMaxY(self.introductionLable.frame) + 10, YBWidth - 20, 20);
    self.timeLable.font = YBFont(12);
    self.timeLable.numberOfLines = 0;
    self.timeLable.text = @"营业时间：08：00-17：00";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
