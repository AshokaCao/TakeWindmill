//
//  YBMapPositionSelectionVC.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/15.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBMapViewController.h"

#pragma mark - 代理
@protocol YBMapPositionSelectionVCDelegate <NSObject>

/**
 * 返回上个界面并传值
 @param value 值
 */
- (void)popVCPassTheValue:(NSDictionary *)value;

@end

@interface YBMapPositionSelectionVC : YBMapViewController

@property (nonatomic, assign) id<YBMapPositionSelectionVCDelegate> delegate;

/**
 * 城市名称
 */
@property (nonatomic, copy) NSString *cityName;

/**
 * 角色
 */
@property (nonatomic, copy) NSString *character;

@end
