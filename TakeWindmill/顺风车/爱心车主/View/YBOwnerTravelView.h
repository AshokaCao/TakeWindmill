//
//  YBOwnerTravelView.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/9/9.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBOwnerTravelView : UIView

/**
 * 单程按钮
 */
@property (nonatomic, weak) UIButton *oneWayButton;

/**
 * 跨城按钮
 */
@property (nonatomic, weak) UIButton *roundTripButton;

/**
 * 下划线
 */
@property (nonatomic, weak) UIView *line;

/**
 * 起点
 */
@property (nonatomic, weak) YBBaseView *startPoint;

/**
 * 终点
 */
@property (nonatomic, weak) YBBaseView *endPoint;

/**
 * 几座
 */
@property (nonatomic, weak) YBBaseView *seatView;

/**
 * 时间
 */
@property (nonatomic, weak) YBBaseView *timeView;

@end


//*************************************************正在寻找乘客(司机端)*************************************************//

@interface YBLookingView : UIView


@end





