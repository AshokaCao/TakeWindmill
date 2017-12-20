//
//  YBCarServicesVC.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/12.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBMapViewController.h"

@interface YBCarServicesVC : YBMapViewController
/**
 * 定位功能
 */
@property (nonatomic, strong) BMKLocationService *locService;

/**
 * 起点位置信息
 */
@property (nonatomic, strong) BMKReverseGeoCodeResult *startingPoint;
@end

