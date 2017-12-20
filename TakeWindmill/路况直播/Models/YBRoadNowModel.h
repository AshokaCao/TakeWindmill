//
//  YBRoadNowModel.h
//  TakeWindmill
//
//  Created by AshokaCao on 2017/10/25.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface YBRoadNowModel : JSONModel

@property (nonatomic, strong) NSString *OccupationNum;
@property (nonatomic, strong) NSString *HeadImgUrl;
@property (nonatomic, strong) NSString *AddTime;
@property (nonatomic, strong) NSString *Advice;
@property (nonatomic, strong) NSString *HasError;
@property (nonatomic, strong) NSString *UploadFiles;
@property (nonatomic, strong) NSString *City;
@property (nonatomic, strong) NSString *CityId;
@property (nonatomic, strong) NSString *Address;
@property (nonatomic, strong) NSString *NickName;
@property (nonatomic, strong) NSString *JamReason;
@property (nonatomic, strong) NSString *CurrentTraffic;
@property (nonatomic, strong) NSString *FileTypeFID;
@property (nonatomic, strong) NSString *SysNo;
@property (nonatomic, strong) NSString *ErrorMessage;
@property (nonatomic, strong) NSString *CurrentLat;
@property (nonatomic, strong) NSString *CurrentLng;
@property (nonatomic, strong) NSString *UserId;
@property (nonatomic, strong) NSString *MainFilePath;


@property (nonatomic ,strong) NSString *intro;


@property (nonatomic ,assign) BOOL isliked;

@property (nonatomic ,strong) NSMutableArray * images;

@property (nonatomic, assign) BOOL isOpening;

@property (nonatomic, assign, readonly) BOOL shouldShowMoreButton;

+ (instancetype)modelWithDic:(NSDictionary *)dic;
@end
