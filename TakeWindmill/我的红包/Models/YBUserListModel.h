//
//  YBUserListModel.h
//  TakeWindmill
//
//  Created by AshokaCao on 2017/11/7.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBUserListModel : NSObject
@property (nonatomic, strong) NSString *TaxiCompany;
@property (nonatomic, strong) NSString *UserType;
@property (nonatomic, strong) NSString *ClientId;
@property (nonatomic, strong) NSString *IsSuccess;
@property (nonatomic, strong) NSString *SysNo;
@property (nonatomic, strong) NSString *IdentityCard;
@property (nonatomic, strong) NSString *VehicleCounty;
@property (nonatomic, strong) NSString *Sex;
@property (nonatomic, strong) NSString *VehicleOwerName;
@property (nonatomic, strong) NSString *VehicleNumber;
@property (nonatomic, strong) NSString *VehicleRegTime;
@property (nonatomic, strong) NSString *VehicleProvince;
@property (nonatomic, strong) NSString *VehicleManPicPath;
@property (nonatomic, strong) NSString *VehicleBrand;

@property (nonatomic, strong) NSString *DriverLicenseTime;

@property (nonatomic, strong) NSString *ServiceCertificatePicPath;

@property (nonatomic, strong) NSString *HasError;

@property (nonatomic, strong) NSString *VehicleSeries;

@property (nonatomic, strong) NSString *Mobile;
@property (nonatomic, strong) NSString *IsDownWindDriver;
@property (nonatomic, strong) NSString *VehicleLicensePicPath;
@property (nonatomic, strong) NSString *ServiceCertificateNo;
@property (nonatomic, strong) NSString *ColorName;
@property (nonatomic, strong) NSString *Age;
@property (nonatomic, strong) NSString *NickName;
@property (nonatomic, strong) NSString *IsTaxiDriver;
@property (nonatomic, strong) NSString *RealName;
@property (nonatomic, strong) NSString *AccountMoney;
@property (nonatomic, strong) NSString *ErrorMessage;
@property (nonatomic, strong) NSString *HeadImgUrl;
@property (nonatomic, strong) NSString *UserId;

@property (nonatomic, strong) NSString *CurrentLat;

@property (nonatomic, strong) NSString *ResponseStr;

@property (nonatomic, strong) NSString *VehicleCity;

@property (nonatomic, strong) NSString *ServiceCertificateValidTime;
@property (nonatomic, strong) NSString *CurrentLng;

/* 收支明细 */
@property (nonatomic, strong) NSString *Abstract;
@property (nonatomic, strong) NSString *AddTime;
@property (nonatomic, strong) NSString *Money;
@property (nonatomic, strong) NSString *TypeFID;
@property (nonatomic, strong) NSString *TypeName;

/* 银行卡信息*/
@property (nonatomic, strong) NSString *BankFID;
@property (nonatomic, strong) NSString *BankName;
@property (nonatomic, strong) NSString *CardCode;
@property (nonatomic, strong) NSString *PicUrl;
@property (nonatomic, strong) NSString *FID;


+ (instancetype)modelWithDic:(NSDictionary *)dic;

@end
