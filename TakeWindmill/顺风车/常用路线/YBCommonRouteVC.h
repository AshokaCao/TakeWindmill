//
//  YBCommonRouteVC.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/12.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBMapViewController.h"
#import <UIKit/UIKit.h>

@interface YBCommonRouteSelectView : UIView
/**
 * 起点
 */
@property (nonatomic, weak) YBBaseView *startPoint;

/**
 * 终点
 */
@property (nonatomic, weak) YBBaseView *endPoint;

/**
 * 时间
 */
@property (nonatomic, weak) YBBaseView *timeView;

/**
 * 备注
 */
@property (nonatomic, weak) UITextField *remarksText;

/**
 * 互换
 */
@property (nonatomic, weak) UIButton *exchangeButton;

@end

@interface YBCommonRouteVC : YBMapViewController


@end
