//
//  YBPassengerTravelVC.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/9/5.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBMapViewController.h"

@interface YBPassengerTravelVC : YBMapViewController

/**
* 司机的id
*/
@property (nonatomic, strong) NSString *SysNo;

/**
 * 乘客行程的id
 */
@property (nonatomic, strong) NSString *TravelSysNo;

@end
