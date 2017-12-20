//
//  YBRequest.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/12.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YBRequest : NSObject

/**
 * post网络请求
 
 @param url 网址
 @param dict 字典
 @param view 提示view
 @param tabelView tabelView
 @param array 数组
 */
+ (void)postWithURL:(NSString *)url MutableDict:(NSMutableDictionary *)dict View:(UIView *)view success:(void (^)(id dataArray))success failure:(void (^)(id dataArray))failure;

//没有提示框
/**
 * 没有提示框的网络请求
 @param url 网址
 @param dict 字典
 @param success 成功后
 @param failure 失败后
 */
+ (void)postWithURL:(NSString *)url MutableDict:(NSMutableDictionary *)dict success:(void (^)(id dataArray))success failure:(void (^)(id dataArray))failure ;

/**
 * 字典数组转字符串
 @param dict 字典或数组
 @return
 */
+ (NSString *)convertToJsonData:(NSDictionary *)dict;

/**
 * 数组转json

 @param jsonString <#jsonString description#>
 @return <#return value description#>
 */
+ (NSString *)arrayToJsonString:(NSArray *)array;
@end
