//
//  YBSearchView.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/11.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SearchButtonBlock)(UIButton *sender);

@interface YBSearchView : UIView

@property (nonatomic, strong) SearchButtonBlock selectBlock;

/**
 * 起点
 */
@property (weak, nonatomic)  UIButton *startingPoint;

/**
 * 终点
 */
@property (weak, nonatomic)  UIButton *endButton;

@end
