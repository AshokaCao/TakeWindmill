//
//  YBAskForPeersVC.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/15.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBMapViewController.h"


typedef void(^payButtonBlock)(UIButton *sender);
//支付界面
@interface YBPayView : UIView

/**
 * 价格
 */
@property (nonatomic, copy) NSString *priceStr;

@property (nonatomic, strong) payButtonBlock payButtonBlock;

//支付页面
- (void)pay;

@end



@interface YBAskForPeersVC : YBMapViewController

/**
 * 司机的行程id
 */
@property (nonatomic, copy) NSString *SysNo;

/**
 * 司机的userId
 */
@property (nonatomic, copy) NSString *driverUserId;

/**
 * 乘客行程的id
 */
@property (nonatomic, copy) NSString *TravelSysNo;

@end
