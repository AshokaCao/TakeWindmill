//
//  YBDriverPassengerTravelVCViewController.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/12/28.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBMapViewController.h"

@interface YBDriverPassengerTravelVCViewController : YBMapViewController

/**
 * 司机的行程id
 */
@property (nonatomic, strong) NSString *SysNo;

/**
 * 当前显示的乘客
 */
@property (nonatomic, assign) int currentPassenger;

@end
