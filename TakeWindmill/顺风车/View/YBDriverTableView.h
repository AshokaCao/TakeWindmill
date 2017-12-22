//
//  YBDriverTableView.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/11/14.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBDriverTableView : UITableView

/**
 * 爱心车主显示的未完成行程
 */
@property (nonatomic, strong) NSDictionary *driverDict;

/**
 * 我的订单数据
 */
@property (nonatomic, strong) NSArray *myOrderArray;

/**
 * 车主附近乘客
 */
@property (nonatomic, strong) NSArray *passengersNearby;

/**
 * 车主跨城乘客
 */
@property (nonatomic, strong) NSArray *passengersCity;

/**
 * 常用路线
 */
@property (nonatomic, strong) NSArray *commonRoute;

/**
 * 车主所在城市的id
 */
@property (nonatomic, copy) NSString *cityId;

/**
 * 爱心车主是否有未完成的行程
 */
@property (nonatomic, assign) NSInteger isDriverNotCompleted;


@end
