//
//  YBTechnicianModel.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/17.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBTechnicianModel : NSObject

/**
 * 记录是是都展开
 */
@property (nonatomic, assign) NSUInteger isUnfolded;

/**
 * 技师名字
 */
@property (nonatomic, strong) NSString *WorkerName;

/**
 * 技师简介数组
 */
@property (nonatomic, strong) NSMutableArray *introductionArray;

/**
 * 技师简介
 */
@property (nonatomic, strong) NSString *JobIntrduction;

/**
 * 技师电话
 */
@property (nonatomic, strong) NSString *PhoneNum;

/**
 * 模型
 */
@property (nonatomic, strong) YBTechnicianModel *technicianMode;

/**
 * 技师头像
 */
@property (nonatomic, strong) NSString *WorkerPhotoUrl;

@property (nonatomic, strong) NSString *Experience;

@property (nonatomic, strong) NSString *HeadImgUrl;


- (NSArray *)open;

+ (instancetype)modelWithDic:(NSDictionary *)dic;

+ (instancetype)introductionWithDic:(NSDictionary *)dic;

- (void)closeWithSubmodels:(NSArray *)submodels;

@end

