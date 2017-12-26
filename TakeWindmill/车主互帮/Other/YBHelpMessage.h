//
//  YBHelpMessage.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/12/1.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

/*!
消息的类型名
 */
#define RCDHelpMessageTypeIdentifier @"BB:Help"

@interface UserInfo : RCMessageContent
@property(nonatomic, strong) NSString *icon;
@property(nonatomic, strong) NSString *idid;
@property(nonatomic, strong) NSString *name;
@end

@interface DriverInfo : RCMessageContent<NSCoding>
@property(nonatomic, strong) NSString *ColorName;
@property(nonatomic, strong) NSString *HeadImgUrl;
@property(nonatomic, strong) NSString *Mobile;
@property(nonatomic, strong) NSString *RealName;
@property(nonatomic, strong) NSString *UserId;
@property(nonatomic, strong) NSString *VehicleBrand;
@property(nonatomic, strong) NSString *VehicleNumber;
@property(nonatomic, strong) NSString *VehicleSeries;
@end


@interface YBHelpMessage : RCMessageContent<NSCoding,RCMessageContentView>
@property(nonatomic, strong) NSString *content;
@property(nonatomic, strong) NSString *extra;

@property(nonatomic, strong) UserInfo *user;
@property(nonatomic, strong) DriverInfo *driverInfo;
@property(nonatomic, strong) NSString *message;
@property(nonatomic, assign) NSString *replyStat;
@property(nonatomic, assign) NSString *send;


+(instancetype)messageWithContent:(NSString *)content;
@end
