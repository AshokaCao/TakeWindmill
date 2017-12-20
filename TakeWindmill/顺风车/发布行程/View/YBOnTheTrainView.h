//
//  YBOnTheTrainView.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/14.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBCityTimeView;

@interface YBOnTheTrainView : UIView

/**
 * 出行起点
 */
@property (weak, nonatomic) YBBaseView *startingPointView;

/**
 * 出行终点
 */
@property (weak, nonatomic) YBBaseView *endView;

/**
 * 出行时间（同城）
 */
@property (weak, nonatomic) YBBaseView *timeView;

/**
 * 出行时间（跨城）
 */
@property (weak, nonatomic) YBCityTimeView *cityTimeView;

/**
 * 出行人数
 */
@property (weak, nonatomic) YBBaseView *numberpeopleView;

/**
 * 是否愿拼座
 */
@property (weak, nonatomic) YBBaseView *fightView;

/**
 * 出行要求
 */
@property (weak, nonatomic) YBBaseView *claimView;

/**
 * 是否跨城
 */
@property (nonatomic, assign) BOOL isCrossCtiy;


- (void)CrossTheCity:(BOOL)isCross ;
@end

//-------------------------------
@interface YBCityTimeView : UIView

@property (weak, nonatomic) YBBaseView *startTime;

@property (weak, nonatomic) UIImageView *arrowIamgeView;

@property (weak, nonatomic) YBBaseView *endTime;

@end
