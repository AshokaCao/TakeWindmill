//
//  YBNearbyPassengersVC.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/9/4.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBNearbyPassengersVC : UIViewController

/**
 * 市内0 or 跨城1
 */
@property (nonatomic, assign) NSInteger isTypes;

/**
 * 城市id
 */
@property (nonatomic, copy) NSString *cityId;

/**
 * 目的地名称
 */
@property (nonatomic, copy) NSString *destination;

@end
