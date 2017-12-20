//
//  YBGroupHelpVC.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/16.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBMapViewController.h"

@interface YBGroupHelpVC : UIViewController
@property (nonatomic, retain)NSString *discussionId;

/**
 * 起点位置信息
 */
@property (nonatomic, strong) BMKReverseGeoCodeResult *startingPoint;
@end
