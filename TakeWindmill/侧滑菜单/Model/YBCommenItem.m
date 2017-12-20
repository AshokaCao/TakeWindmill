//
//  YBCommenItem.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/8.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBCommenItem.h"

@implementation YBCommenItem

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title subtitle:(NSString *)subtitle destVcClass:(Class)destVcClass {
    YBCommenItem *item = [[self alloc] init];
    item.icon = icon;
    item.title = title;
    item.subtitle = subtitle;
    item.destVcClass = destVcClass;
    return item;
}

@end
