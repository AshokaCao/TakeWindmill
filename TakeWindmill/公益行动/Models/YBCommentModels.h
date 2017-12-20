//
//  YBCommentModels.h
//  TakeWindmill
//
//  Created by AshokaCao on 2017/11/22.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YBCommentModels : NSObject

/**
 系统编号
 */
@property (nonatomic, strong) NSString *SysNo;

/**
 捐赠主表SysNo
 */
@property (nonatomic, strong) NSString *PublicWelfareSysNo;

/**
 用户Id
 */
@property (nonatomic, strong) NSString *UserId;

/**
 评论内容
 */
@property (nonatomic, strong) NSString *CommnentContent;

/**
 评论时间
 */
@property (nonatomic, strong) NSString *AddTime;
/**
 评论人昵称
 */
@property (nonatomic, strong) NSString *NickName;
/**
 评论人头像
 */
@property (nonatomic, strong) NSString *HeadImgUrl;
/**
 店铺SysNo
 */
@property (nonatomic, strong) NSString *ShopSysNo;

/**
 星级
 */
@property (nonatomic, strong) NSString *Stars;

/**
 捐款金额
 */
@property (nonatomic, strong) NSString *ContributeMoney;

@property (nonatomic, strong) NSString *ContributeTimeStr;

@end
