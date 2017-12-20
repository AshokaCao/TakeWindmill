//
//  YBKeyChainStore.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/22.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBKeyChainStore : NSObject

+ (void)save:(NSString*)service data:(id)data;

+ (id)load:(NSString*)service;

+ (void)deleteKeyData:(NSString*)service;

@end
