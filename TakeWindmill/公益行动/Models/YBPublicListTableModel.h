//
//  YBPublicListTableModel.h
//  TakeWindmill
//
//  Created by AshokaCao on 2017/11/21.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBPublicListTableModel : NSObject

/**
 纬度
 */
@property (nonatomic, strong) NSString *ActivityLat;

/**
 经度
 */
@property (nonatomic, strong) NSString *ActivityLng;

/**
 地址
 */
@property (nonatomic, strong) NSString *Address;

/**
 捐款金额
 */
@property (nonatomic, strong) NSString *ContributeMoney;

/**
 捐款人次
 */
@property (nonatomic, strong) NSString *ContributePeapleNumber;

/**
 项目详情
 */
@property (nonatomic, strong) NSString *Introduce;

/**
 图片地址
 */
@property (nonatomic, strong) NSString *PicUrl;

/**
 实际捐款金
 */
@property (nonatomic, strong) NSString *RealContributeMoney;

/**
 副标题
 */
@property (nonatomic, strong) NSString *SubTitle;

/**
 系统编号
 */
@property (nonatomic, strong) NSString *SysNo;

/**
 标题
 */
@property (nonatomic, strong) NSString *Title;
@end

