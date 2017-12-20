//
//  YBMessageModel.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/8.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBMessageModel : NSObject

/**
 * icon 网址
 */
@property (nonatomic, copy) NSString *icon;

/**
 * 司机名字
 */
@property (nonatomic, copy) NSString *nameStr;

/**
 * 内容
 */
@property (nonatomic, copy) NSString *content;

@end
