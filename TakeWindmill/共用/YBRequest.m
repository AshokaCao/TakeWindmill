//
//  YBRequest.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/12.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBRequest.h"

@implementation YBRequest

#pragma mark -- POST请求 --
+ (void)postWithURLString:(NSString *)URLString
               parameters:(id)parameters
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure {
    
    //实例化AFHTTPSessionManager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //调出请求头
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html", @"text/plain", nil];

    
    [manager  POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *str = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        YBLog(@"%@",str);
        NSDictionary *dict = [self dictionaryWithJsonString:[YBTooler URLDecodedString:str]];
        if (success) {
            success(dict);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)postWithURL:(NSString *)url MutableDict:(NSMutableDictionary *)dict View:(UIView *)view success:(void (^)(id dataArray))success failure:(void (^)(id dataArray))failure {
    
    [MBProgressHUD showOnlyLoadToView:view];
    
    [self postWithURLString:url parameters:dict success:^(id responseObject) {
//        [MBProgressHUD hideHUDForView:view animated:YES];
        [MBProgressHUD hideHUDForView:view];
        if (responseObject) {
            if ([responseObject[@"Head"][@"IsError"] intValue]== 1) {
                if (failure) {
                    failure(responseObject[@"Head"]);
                }
            }else {
                NSDictionary *dict1 = [self dictionaryWithJsonString:[YBTooler URLDecodedString:responseObject[@"Body"]]];
                dict1 = [NSDictionary changeType:dict1];
                if (success) {
                    success(dict1);
                }
            }
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:[error localizedDescription] toView:view];
    }];
}

+ (void)postWithURL:(NSString *)url MutableDict:(NSMutableDictionary *)dict success:(void (^)(id dataArray))success failure:(void (^)(id dataArray))failure  {
    
    [self postWithURLString:url parameters:dict success:^(id responseObject) {
        
        if (responseObject) {
            if ([responseObject[@"Head"][@"IsError"] intValue]== 1) {
                if (failure) {
                    failure(responseObject[@"Head"]);
                }
            }else {
                NSDictionary *dict1 = [self dictionaryWithJsonString:[YBTooler URLDecodedString:responseObject[@"Body"]]];
                dict1 = [NSDictionary changeType:dict1];
//                YBLog(@"为转换之前--%@  转换之后--%@",dict1,[NSDictionary changeType:dict1]);
                if (success) {
                    success(dict1);
                }
            }
        }
    } failure:^(NSError *error) {
        YBLog(@"请求错误-%@",[error localizedDescription]);
    }];

}

/**
 *  字典转json字符串
 *
 *  字典调用
 *  @return 
 */
+ (NSString *)convertToJsonData:(NSDictionary *)dict
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

/**
 *  数组转json字符串
 *
 *  数组调用
 *  @return
 */
+ (NSString *)arrayToJsonString:(NSArray *)array
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

//JSON字符串转化为字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
