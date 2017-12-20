//
//  YBRegisteredModel.m
//  TakeWindmill
//
//  Created by HUSHOUHUA华 on 2017/11/16.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBRegisteredModel.h"

@implementation YBRegisteredModel

@end

@implementation VehicleBrandList

@end
@implementation VehicleSeriesList

@end
@implementation Body
//+ (NSDictionary *)modelCustomPropertyMapper {
//    return @{
//             };
//}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"VehicleBrandList": [VehicleBrandList class],
              @"VehicleSeriesList": [VehicleSeriesList class]
             };
}
@end
