//
//  YBServiceModels.h
//  TakeWindmill
//
//  Created by AshokaCao on 2017/11/13.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBServiceModels : NSObject

/**
 简介
 */
@property (nonatomic, strong) NSString *AbstractContent;

/**
 添加时间
 */
@property (nonatomic, strong) NSString *AddTime;

/**
 地址
 */
@property (nonatomic, strong) NSString *Address;

/**
 评分
 */
@property (nonatomic, strong) NSString *CommentScore;

/**
 下班时间
 */
@property (nonatomic, strong) NSString *EndWorkTime;

/**
 
 */
@property (nonatomic, strong) NSString *ErrorMessage;

@property (nonatomic, strong) NSString *HasError;

/**
 评论人头像
 */
@property (nonatomic, strong) NSString *HeadImgUrl;

/**
 手机号
 */
@property (nonatomic, strong) NSString *Mobile;

/**
 昵称
 */
@property (nonatomic, strong) NSString *NickName;

@property (nonatomic, strong) NSString *ShopLat;

@property (nonatomic, strong) NSString *ShopLng;

/**
 店铺名
 */
@property (nonatomic, strong) NSString *ShopName;

/**
 店铺照片地址
 */
@property (nonatomic, strong) NSString *ShopUrl;

/**
 上班时间
 */
@property (nonatomic, strong) NSString *StartWorkTime;

@property (nonatomic, strong) NSString *SysNo;

/**
 联系电话
 */
@property (nonatomic, strong) NSString *Telephone;

@property (nonatomic, strong) NSString *UserId;

@property (nonatomic, strong) NSString *Experience;

@property (nonatomic, strong) NSString *WorkerPhotoUrl;

@property (nonatomic, strong) NSString *JobIntrduction;

@property (nonatomic, strong) NSString *PhoneNum;

@property (nonatomic, strong) NSString *WorkerName;

@property (nonatomic, strong) NSString *ShopSysNo;

@property (nonatomic, strong) NSString *CommentContent;

@end
