//
//  YBSearchColumnView.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/15.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBTextField;

typedef void(^addressBlock)(UITextField *text);

typedef void(^selectButtonBlock)(UIButton *sender);


@interface YBSearchColumnView : UIView


@property (nonatomic, copy) NSString *cityStr;

/**
 * 地址输入
 */
@property (nonatomic, weak) YBTextField *addressText;

/**
 * 城市选择
 */
@property (nonatomic, weak) YBAboutButton *cityButton;


/**
 * 地址输入输入
 */
@property (nonatomic, weak) UIButton *addressButton;

/**
 * 是否可以输入
 */
@property (nonatomic, assign) BOOL isEnter;

/**
 * 是否编辑状态
 */
@property (nonatomic, assign) BOOL isAddress;

/**
 * 点击编辑
 */
@property (nonatomic, strong) addressBlock addressBlock;

/**
 * 点击按钮
 */
@property (nonatomic, strong) selectButtonBlock addressButtonBlock;

/**
 * 点击城市
 */
@property (nonatomic, strong) selectButtonBlock seleCityButtonBlock;

/**
 * 取消按钮
 */
@property (nonatomic, weak)  YBBaseButton *cancelButton;

/**
 * 内容发生变化
 */
@property (nonatomic, strong) addressBlock contentTextBlock;


@end
