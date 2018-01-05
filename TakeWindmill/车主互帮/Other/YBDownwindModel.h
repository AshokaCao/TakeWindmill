//
//  YBDownwindModel.h
//  TakeWindmill
//
//  Created by HSH on 2018/1/5.
//  Copyright © 2018年 浙江承御天泽公司. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>
#import "YBTaxiStepModel.h"

/*!
 顺风车消息类型：BB:Downwind
 */
#define RCDDownwindMessageTypeIdentifier @"BB:Downwind"

@interface YBDownwindModel : RCMessageContent
@property(nonatomic, strong) NSString *content;
@property(nonatomic, strong) NSString *extra;

@property(nonatomic, strong) NSString *op;
@property(nonatomic, strong) Travelinfo *travelinfo;

@end
