//
//  YBGroupHelpModel.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/11/29.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBGroupHelpModel.h"

@implementation YBGroupHelpModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"UserInfoList": [UserInfoList class],
             @"DriverHelpInfoList": [UserInfoList class],
             };
}
@end

@implementation UserInfoList

@end


