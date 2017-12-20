//
//  YBMineDonationsModel.h
//  TakeWindmill
//
//  Created by AshokaCao on 2017/11/23.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBMineDonationsModel : NSObject

@property (nonatomic, strong) NSString *UserId;

/**
 系统编号
 */
@property (nonatomic, strong) NSString *SysNo;

/**
 捐赠对象主表SysNo
 */
@property (nonatomic, strong) NSString *PublicWelfareSysNo;

/**
 捐款金额
 */
@property (nonatomic, strong) NSString *ContributeMoney;

/**
 订单号
 */
@property (nonatomic, strong) NSString *OrderNo;

/**
 支付状态，0-未支付，1-已支付
 */
@property (nonatomic, strong) NSString *PayStat;

/**
 捐款时间
 */
@property (nonatomic, strong) NSString *PicUrl;
@property (nonatomic, strong) NSString *RealContributeMoney;
@property (nonatomic, strong) NSString *SubTitle;
@property (nonatomic, strong) NSString *Title;
@property (nonatomic, strong) NSString *MyContributeNumberP;
//@property (nonatomic, strong) NSString *RealContributeMoney;
@property (nonatomic, strong) NSString *ContributePeapleNumber;

@end
