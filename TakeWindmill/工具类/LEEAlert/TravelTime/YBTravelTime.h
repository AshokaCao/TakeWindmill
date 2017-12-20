//
//  YBTravelTime.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/23.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectButtonBlock)(NSDictionary *dict);

typedef void(^selectCancelBlock)(UIButton *sender);

@interface YBTravelTime : UIView

/**
 * 左边按钮
 */
@property (nonatomic, copy) NSString *leftButtonStr;

/**
 * 右边按钮
 */
@property (nonatomic, copy) NSString *rightButtonStr;

/**
 * 确定按钮
 */
@property (nonatomic, strong) selectButtonBlock selectBlock;

/**
 * 取消按钮
 */
@property (nonatomic, strong) selectCancelBlock cancelBlock;

/**
 * 标题
 */
@property (nonatomic, copy) NSString *deadStr;

/**
* 是否隐藏底部
 */
@property (nonatomic, assign) BOOL isHideBottom;

@end

