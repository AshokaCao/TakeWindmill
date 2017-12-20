//
//  YBCarShopEvaluationCell.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/17.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBCarShopEvaluationCell.h"
#import "XHStarRateView.h"

@interface YBCarShopEvaluationCell ()

/**
 * 用户头像
 */
@property (nonatomic, weak) UIImageView *iconImageView;

/**
 * 评价星
 */
@property (nonatomic, weak) UIView *starView;

/**
 * 评价星星
 */
@property (nonatomic, weak) UILabel *starLabel;

/**
 * 汽车店级别
 */
@property (nonatomic, weak) UILabel *levelLabel;

/**
 * 发布时间
 */
@property (nonatomic, weak) UILabel *userLabel;

/**
 * 发布图片
 */
@property (nonatomic, weak) UIImageView *storefrontImageView;

/**
 * 发布图片
 */
@property (nonatomic, weak) UIButton *moreButton;

@property (nonatomic, assign) CGFloat cellHeight;


@end

@implementation YBCarShopEvaluationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIImageView *iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:iconImageView];
        self.iconImageView = iconImageView;
        
        XHStarRateView *starView = [[XHStarRateView alloc] init];
        [self.contentView addSubview:starView];
        self.starView = starView;
        
        UILabel *starLabel = [[UILabel alloc] init];
        [self.contentView addSubview:starLabel];
        self.starLabel = starLabel;

        UILabel *levelLabel = [[UILabel alloc] init];
        [self.contentView addSubview:levelLabel];
        self.levelLabel = levelLabel;
        
        UILabel *userLabel = [[UILabel alloc] init];
        [self.contentView addSubview:userLabel];
        self.userLabel = userLabel;
        
        UIImageView *storefrontImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:storefrontImageView];
        self.storefrontImageView = storefrontImageView;

        UIButton *moreButton = [[UIButton alloc] init];
        [self.contentView addSubview:moreButton];
        self.moreButton = moreButton;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.iconImageView.frame = CGRectMake(10, 10, 60, 60);
    self.iconImageView.image = [UIImage imageNamed:@"小草"];
    
    self.starView.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 10, 10, 60, 20);

    CGFloat imageWH = 10;
    for (int i = 0; i < 5; i ++) {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(i * (imageWH + 2), 5, imageWH, imageWH)];
//        if (i > 3) {
//            image.image = [UIImage imageNamed:@"b27_icon_star_gray"];
//        }else {
            image.image = [UIImage imageNamed:@"b27_icon_star_yellow"];
//        }
        [self.starView addSubview:image];
    }

    self.starLabel.frame = CGRectMake(CGRectGetMaxX(self.starView.frame), 10, 40, 20);
    self.starLabel.text = @"5.0";
    self.starLabel.font = YBFont(11);
    self.starLabel.textColor = BtnGreenColor;
    
    self.levelLabel.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 10, CGRectGetMaxY(self.starView.frame), YBWidth / 1.9, 20);
    self.levelLabel.text = @"斯柯达首批七星级经销商 购车首选";
    self.levelLabel.font = YBFont(12);
    
    self.userLabel.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 10, CGRectGetMaxY(self.levelLabel.frame), YBWidth / 1.9, 20);
    self.userLabel.text = @"jy00137787 2015-02-19 12:59";
    self.userLabel.font = YBFont(12);
    
    self.storefrontImageView.frame = CGRectMake(CGRectGetMaxX(self.userLabel.frame), 10,80, 60);
    self.storefrontImageView.image = [UIImage imageNamed:@"首页4_01"];
    
    self.moreButton.frame = CGRectMake(YBWidth / 2 - 60, CGRectGetMaxY(self.iconImageView.frame) + 10 , 120, 30);
    self.moreButton.titleLabel.font = YBFont(14);
    [self.moreButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.moreButton setTitle:@"点击查看更多" forState:UIControlStateNormal];

    self.contentView.frame = CGRectMake(0, 0, YBWidth , CGRectGetMaxY(self.moreButton.frame));
//    self.cellHeight = CGRectGetMaxY(self.moreButton.frame);
}

- (CGFloat)cellHeight
{
    return self.contentView.frame.size.height;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
