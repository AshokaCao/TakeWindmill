//
//  YBAdInfoListModel.m
//  TakeWindmill
//
//  Created by HSH on 2017/12/28.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBAdInfoListModel.h"

@implementation YBAdInfoListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"AdInfoList": [AdInfoModel class],
             };
}
@end

@implementation AdInfoModel

@end
