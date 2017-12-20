//
//  YBPublicDetailsView.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/18.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBPublicDetailsView : UIView

/**
 头图
 */
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

/**
 进度条
 */
@property (weak, nonatomic) IBOutlet UIProgressView *progressViews;

/**
 百分比
 */
@property (weak, nonatomic) IBOutlet UILabel *proportionLabel;

/**
 目标金额
 */
@property (weak, nonatomic) IBOutlet UILabel *purposeMoneyLabel;

/**
 用户捐款
 */
@property (weak, nonatomic) IBOutlet UILabel *userMoneyLabel;

/**
 捐款人数
 */
@property (weak, nonatomic) IBOutlet UILabel *peopleCountLabel;

@end
