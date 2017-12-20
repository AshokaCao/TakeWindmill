//
//  YBCitySelectionVC.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/29.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBCitySelectionVC;

#pragma mark - 设置代理
@protocol YBCitySelectionVCDelegate <NSObject>

- (void)popViewControllerPassTheValueDict:(NSDictionary *)dict;

@end


@interface YBCitySelectionVC : UIViewController

@property (nonatomic, assign) id<YBCitySelectionVCDelegate> cityDelegate;

/**
 * push层数
 */
@property (nonatomic, assign) NSInteger isPush;

/**
 * 跨城
 */
@property (nonatomic, copy) NSString *cross_City;

@end
