//
//  YBTaxiModel.h
//  TakeWindmill
//
//  Created by HSH on 2017/12/26.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>
#import "YBTaxiStepModel.h"

/*!
 消息的类型名BB:Taxi
 */
#define RCDTaxiMessageTypeIdentifier @"BB:Taxi"


@interface YBTaxiModel : RCMessageContent
@property(nonatomic, strong) NSString *content;
@property(nonatomic, strong) NSString *extra;
@property(nonatomic, strong) Travelinfo *travelinfo;
@end
