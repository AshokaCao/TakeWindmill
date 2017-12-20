//
//  Tools.h
//  RuiZhi
//
//  Created by zhanshu on 14-8-14.
//  Copyright (c) 2014年 zhanshu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MessageUI/MessageUI.h>

@interface Tools : NSObject<MFMessageComposeViewControllerDelegate>
{
    UIViewController *viewController;
}
@property (nonatomic,strong)UIViewController *vc;


//发送短信
-(void)theMessSendTo:(NSString*)tel theDelegate:(UIViewController*)controller;
//打电话
-(void)callAction:(NSString*)tel Delegate:(UIViewController*)controller;

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC;
//获取当前屏幕显示的viewcontroller string
+ (NSString *)getCurrentVCString;

//打开苹果地图导航
+(void)openMapWithAddress:(NSString *)address;

//加载圆圈
+(void)showProgress:(UIView *)view;
+(void)dismissProgress:(UIView *)view;
//分享
+(void)shareType:(NSInteger)type viewController:(UIViewController*)controller;


//用牌选项 1/2 1:整副牌 2:9-A
+(NSString *)nUseCard:(NSUInteger)ID;
//int 转 英文名字
+(NSString *)integerGetName:(NSUInteger)ID;
//得到牌
+(NSString *)getCardName:(NSUInteger)ID;
+(NSString *)getCardsType:(NSUInteger)cardsType;
+(NSString *)getState:(NSUInteger)state;

@end
