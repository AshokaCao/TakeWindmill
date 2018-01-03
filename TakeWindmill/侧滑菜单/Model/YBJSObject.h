//
//  YBJSObject.h
//  TakeWindmill
//
//  Created by HSH on 2018/1/2.
//  Copyright © 2018年 浙江承御天泽公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

/**
 * js调用oc里，需要借助这个协议才行
 */
@protocol JSObjectDelegate <JSExport>

#pragma mark -js调用该oc方法，并且将jsonstring打印出来
-(void)turnTo:(NSString *)jsonString;

@end


@interface YBJSObject : NSObject

@end
