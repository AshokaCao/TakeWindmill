//
//  YBPayconfigModel.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/12/9.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBPayconfigModel : NSObject
//支付宝
//"Partner":"2088821481398240",
@property(nonatomic,strong) NSString * Partner;
//"Key":"xgbba4uu6vj4neubn61vlv5v5vc0pn4p",
@property(nonatomic,strong) NSString * Key;
//"InputCharset":"utf-8",
@property(nonatomic,strong) NSString * InputCharset;
//"SignType":"MD5",
@property(nonatomic,strong) NSString * SignType;
//"SellerEmail":"hzbluesun@163.com",
@property(nonatomic,strong) NSString * SellerEmail;
//"NotifyUrl":"http://121.40.76.10:88/Pay/Alipay/NotifyPayOrder.aspx",
@property(nonatomic,strong) NSString * NotifyUrl;
//"PublicKey":"",
@property(nonatomic,strong) NSString * PublicKey;
//"PrivateKey":"",
@property(nonatomic,strong) NSString * PrivateKey;
//"APPID":"2017103009610990",
@property(nonatomic,strong) NSString * APPID;
//"Sign":null,
@property(nonatomic,strong) NSString * Sign;
//"OrderNo":null,
@property(nonatomic,strong) NSString * OrderNo;
//"OrderMoney":0,
@property(nonatomic,strong) NSString * OrderMoney;
//"HasError":false,
@property(nonatomic,strong) NSString * HasError;
//"ErrorMessage":null
@property(nonatomic,strong) NSString * ErrorMessage;

//weixin
@property(nonatomic,strong) NSString * Secret;
@property(nonatomic,strong) NSString * Mchid;

//weixin 支付
@property(nonatomic,strong) NSString * prepayid;
@property(nonatomic,strong) NSString * partnerid;
@property(nonatomic,strong) NSString * packagevalue;
//@property(nonatomic,strong) NSString * ErrorMessage;
@property(nonatomic,strong) NSString * noncestr;
@property(nonatomic,strong) NSString * sign;
@property(nonatomic,strong) NSString * timestamp;
@property(nonatomic,strong) NSString * appid;


@end
