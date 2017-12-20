//
//  YBWaitingOrdersCell.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/31.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YBWaitingView;

//头像 点击
typedef void(^iconImageView)(UITapGestureRecognizer *gest);

@interface YBWaitingOrdersCell : UITableViewCell

//头像
@property (nonatomic, strong) iconImageView iconImageView;

//数据
@property (nonatomic, strong) NSDictionary *detailsDict;

/**
 * 背景
 */
@property (nonatomic, weak) YBWaitingView *bgView;


@end


