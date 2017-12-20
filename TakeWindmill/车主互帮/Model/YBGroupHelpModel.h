//
//  YBGroupHelpModel.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/11/29.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserInfoList :NSObject//群组互帮
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
@property (nonatomic , copy) NSString              * DriverLicenseTime;
@property (nonatomic , copy) NSString              * ServiceCertificatePicPath;
@property (nonatomic , copy) NSString              * VehicleBrand;
@property (nonatomic , assign) BOOL              HasError;
@property (nonatomic , copy) NSString              * VehicleSeries;
@property (nonatomic , copy) NSString              * Mobile;
@property (nonatomic , assign) BOOL              IsDownWindDriver;
@property (nonatomic , copy) NSString              * ServiceCertificateNo;
@property (nonatomic , copy) NSString              * VehicleLicensePicPath;
@property (nonatomic , copy) NSString              * ColorName;
@property (nonatomic , copy) NSString              * Age;
@property (nonatomic , copy) NSString              * NickName;
@property (nonatomic , assign) NSInteger              AccountMoney;
@property (nonatomic , assign) BOOL              IsTaxiDriver;
@property (nonatomic , copy) NSString              * RealName;
@property (nonatomic , copy) NSString              * ErrorMessage;
@property (nonatomic , copy) NSString              * HeadImgUrl;
@property (nonatomic , copy) NSString              * UserId;
@property (nonatomic , assign) NSString              *CurrentLat;
@property (nonatomic , copy) NSString              * ResponseStr;
@property (nonatomic , copy) NSString              * VehicleCity;
@property (nonatomic , copy) NSString              * ServiceCertificateValidTime;
@property (nonatomic , assign) NSString              *CurrentLng;

//求助信息
@property (nonatomic , assign) NSInteger              UserCommentStar;
@property (nonatomic , copy) NSString              * UserCommentTime;
@property (nonatomic , copy) NSString              * AddTime;
@property (nonatomic , copy) NSString              * ToUserCommentTime;
@property (nonatomic , copy) NSString              * Message;
@property (nonatomic , copy) NSString              * ToUserComment;
@property (nonatomic , copy) NSString              * UserComment;
@property (nonatomic , copy) NSString              * ToUserId;
@property (nonatomic , assign) NSInteger              ToUserCommentStar;
@property (nonatomic , assign) NSInteger              ReplyStat;

@end


@interface YBGroupHelpModel : NSObject
@property (nonatomic , copy) NSString              * ErrorMessage;
@property (nonatomic , strong) NSArray<UserInfoList *>              * UserInfoList;
@property (nonatomic , assign) BOOL              HasError;
//求助信息

@property (nonatomic , strong) NSArray<UserInfoList *>              * DriverHelpInfoList;
@end
