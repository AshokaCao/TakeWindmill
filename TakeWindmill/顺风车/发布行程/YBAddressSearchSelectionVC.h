//
//  YBAddressSearchSelectionVC.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/15.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBAddressSearchSelectionVC;

#pragma mark - 设置代理
@protocol YBAddressSearchSelectionVCDelegate <NSObject>

- (void)popViewControllerPassTheValue:(NSDictionary *)value;

@end

@interface YBAddressSearchSelectionVC : UIViewController

@property (nonatomic, assign) id<YBAddressSearchSelectionVCDelegate> addDelegate;

/**
 * 城市名称
 */
@property (nonatomic, copy) NSString *cityname;

/**
 * 类型
 */
@property (nonatomic, copy) NSString *typesOf;

@end
