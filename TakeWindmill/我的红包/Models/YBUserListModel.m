//
//  YBUserListModel.m
//  TakeWindmill
//
//  Created by AshokaCao on 2017/11/7.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBUserListModel.h"

@implementation YBUserListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

+ (instancetype)modelWithDic:(NSDictionary *)dic
{
    YBUserListModel *model = [[YBUserListModel alloc] init];
    [model setValuesForKeysWithDictionary:dic];
    
    return model;
}

@end
