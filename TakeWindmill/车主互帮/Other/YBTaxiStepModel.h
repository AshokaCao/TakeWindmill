//
//  YBTaxiStepModel.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/12/9.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

/*!
 消息的类型名BB:TaxiStep
 */
#define RCDTaxiMessageTypeIdentifier @"BB:Taxi"

@interface Travelinfo : RCMessageContent<NSCoding>
@property(nonatomic, strong) NSString *EndAddress;
@property(nonatomic, strong) NSString *Mileage;
@property(nonatomic, strong) NSString *SetoutTime;
@property(nonatomic, strong) NSString *StartAddress;
@property(nonatomic, strong) NSString *TravelSysNo;
@end

//op字段
//PassengerInvite, //乘客邀请司机
//BindPassenger, //司机确认同行（绑定乘客）
//ArriveToStart, //司机到达乘客上车点
//PassangerGetOn, //乘客上车
//PassangerArriveToEnd, //乘客到达终点（目的地）
//PassangerPay, //乘客付款
//DriverTravelCancel, //司机取消行程
//PassengerTravelCancel //乘客取消行程
@interface YBTaxiStepModel : RCMessageContent<NSCoding,RCMessageContentView>
@property(nonatomic, strong) NSString *content;
@property(nonatomic, strong) Travelinfo *travelinfo;
@property(nonatomic, strong) NSString *op;

+(instancetype)messageWithContent:(NSString *)content;
@end
