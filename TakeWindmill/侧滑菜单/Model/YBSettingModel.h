//
//  YBSettingModel.h
//  TakeWindmill
//
//  Created by HSH on 2017/12/22.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBSettingModel : NSObject
//details = 版本更新;
//ServicePhone = 400-888888;
//code = 1;
//download = http://img.bibizl.com/download/syspackage/2017-12-16.apk;
//SystemName = 皕夶指路;
//WeixinMPUrl = http://weixin.qq.com/r/dSmEnHPE5S6arTf-93xn;
//version = 1.0;
//VerionUpdateTime = 2017-12-16;
//HasError = 0;
//ErrorMessage = ;
//}

/**
 *详细介绍
 */
@property(nonatomic,strong) NSString *details;
/**
 *客服电话
 */
@property(nonatomic,strong) NSString *ServicePhone;
/**
 *内部版本号
 */
@property(nonatomic,strong) NSString *code;
/**
 *版本下载地址
 */
@property(nonatomic,strong) NSString *download;
/**
 *系统名称
 */
@property(nonatomic,strong) NSString *SystemName;
/**
 *微信公众号地址
 */
@property(nonatomic,strong) NSString *WeixinMPUrl;
/**
 *系统版本号
 */
@property(nonatomic,strong) NSString *version;
/**
 *版本更新时间
 */
@property(nonatomic,strong) NSString *VerionUpdateTime;
/**
 *
 */
@property(nonatomic,strong) NSString *HasError;
/**
 *
 */
@property(nonatomic,strong) NSString *ErrorMessage;
/**
 *欢迎页图片地址
 */
@property(nonatomic,strong) NSString *WelcomePicPath;

@end
