//
//  YBInformationModel.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/11/22.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface YBInformationModel : NSObject
@property (nonatomic , copy) NSString              * TaxiCompany;
@property (nonatomic , assign) NSInteger              UserType;
@property (nonatomic , copy) NSString              * ClientId;
@property (nonatomic , assign) BOOL              IsSuccess;
@property (nonatomic , assign) NSInteger              SysNo;
@property (nonatomic , copy) NSString              * IdentityCard;
@property (nonatomic , copy) NSString              * VehicleCounty;
@property (nonatomic , copy) NSString              * Sex;
@property (nonatomic , copy) NSString              * VehicleOwerName;
@property (nonatomic , copy) NSString              * VehicleNumber;
@property (nonatomic , copy) NSString              * VehicleRegTime;
@property (nonatomic , copy) NSString              * VehicleProvince;
@property (nonatomic , copy) NSString              * VehicleManPicPath;
@property (nonatomic , copy) NSString              * VehicleBrand;
@property (nonatomic , copy) NSString              * DriverLicenseTime;
@property (nonatomic , copy) NSString              * ServiceCertificatePicPath;
@property (nonatomic , assign) BOOL              HasError;
@property (nonatomic , copy) NSString              * VehicleSeries;
@property (nonatomic , copy) NSString              * Mobile;
@property (nonatomic , assign) BOOL              IsDownWindDriver;
@property (nonatomic , copy) NSString              * VehicleLicensePicPath;
@property (nonatomic , copy) NSString              * ServiceCertificateNo;
@property (nonatomic , copy) NSString              * ColorName;
@property (nonatomic , copy) NSString              * Age;
@property (nonatomic , copy) NSString              * NickName;
@property (nonatomic , assign) BOOL              IsTaxiDriver;
@property (nonatomic , copy) NSString              * RealName;
@property (nonatomic , assign) NSInteger              AccountMoney;
@property (nonatomic , copy) NSString              * ErrorMessage;
@property (nonatomic , copy) NSString              * HeadImgUrl;
@property (nonatomic , copy) NSString              * UserId;
@property (nonatomic , assign) NSInteger              CurrentLat;
@property (nonatomic , copy) NSString              * ResponseStr;
@property (nonatomic , copy) NSString              * VehicleCity;
@property (nonatomic , copy) NSString              * ServiceCertificateValidTime;
@property (nonatomic , assign) NSInteger              CurrentLng;
@end
