//
//  YBRegisteredModel.h
//  TakeWindmill
//
//  Created by HUSHOUHUA华 on 2017/11/16.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VehicleBrandList :NSObject
@property (nonatomic , copy) NSString              * VehicleBrand;
@property (nonatomic , assign) BOOL              HasError;
@property (nonatomic , copy) NSString              * ErrorMessage;
@property (nonatomic , assign) NSInteger              SysNo;

@end

@interface VehicleSeriesList :NSObject
@property (nonatomic , assign) NSInteger              VehicleBrandSysNo;
@property (nonatomic , assign) BOOL              HasError;
@property (nonatomic , copy) NSString              * VehicleSeries;
@property (nonatomic , copy) NSString              * ErrorMessage;
@property (nonatomic , assign) NSInteger              SysNo;


@end


//汽车品牌列表
//member/vehiclebrandlist
@interface Body :NSObject
@property (nonatomic , copy) NSString              * ErrorMessage;
@property (nonatomic , strong) NSArray<VehicleBrandList *>              * VehicleBrandList;
@property (nonatomic , assign) BOOL              HasError;

//汽车型号列表（根据汽车品牌SysNo）
@property (nonatomic , strong) NSArray<VehicleSeriesList *>              * VehicleSeriesList;

@end

@interface YBRegisteredModel : NSObject


@end
