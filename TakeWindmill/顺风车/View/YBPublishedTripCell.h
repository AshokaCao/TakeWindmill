//
//  YBPublishedTripCell.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/10/18.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBPublishedTripCell : UITableViewCell

/**
 * 环保乘客
 */
@property (nonatomic, strong) NSDictionary *strokeDict;

/**
 * 爱心司机
 */
@property (nonatomic, strong) NSDictionary *driverTripDic;

@end
