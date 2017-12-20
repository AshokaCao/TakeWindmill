//
//  YBPassengerTableView.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/11/14.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBPassengerTableView : UITableView

/**
 * 环保乘客是否有未完成的行程
 */
@property (nonatomic, assign) NSInteger isPassengerNotCompleted;

/**
 * 环保乘客显示的tableView
 */
@property (nonatomic, strong) NSArray *dictArray;

/**
 * 环保乘客显示的tableView
 */
@property (nonatomic, strong) NSDictionary *passengerDict;

@end
