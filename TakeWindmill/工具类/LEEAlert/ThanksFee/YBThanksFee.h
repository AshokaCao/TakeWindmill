//
//  YBThanksFee.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/23.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectDetermineBlock)(UIButton *sender);

typedef void(^selectedBlock)(UIButton *sender);


@interface YBThanksFee : UIView

/**
 * 要显示的金额
 */
@property (nonatomic, strong) NSArray *moneyArray;

/**
 * 确定选择块
 */
@property (nonatomic, strong) selectDetermineBlock selectDetermine;

/**
 * 选择其他文字回调
 */
@property (nonatomic, strong) selectedBlock selectedBlock;

/**
 * 选中按钮
 */
@property (nonatomic, weak) UIButton *selectedBtn;

/**
 * 确认按钮
 */
@property (nonatomic, weak) UIButton *determineBtn;


@end
