//
//  Tools.m
//  RuiZhi
//
//  Created by zhanshu on 14-8-14.
//  Copyright (c) 2014年 zhanshu. All rights reserved.
//

#import "Tools.h"
#import <MapKit/MapKit.h>

@implementation Tools
-(void)theMessSendTo:(NSString*)tel theDelegate:(UIViewController*)controller
{
    viewController=controller;
    
    if( [MFMessageComposeViewController canSendText] ){
        
        MFMessageComposeViewController * controller1 = [[MFMessageComposeViewController alloc]init]; //autorelease];
        
        controller1.recipients = [NSArray arrayWithObject:tel];
        //controller.body = [_dic objectForKey:@"content"];
        controller1.messageComposeDelegate = self;
        
        //[controller.navigationController pushViewController:controller1 animated:YES];
        // [controller presentModalViewController:controller1 animated:YES];
        [controller presentViewController:controller1 animated:YES completion:nil];
        //        [[[[controller viewControllers] lastObject] navigationItem] setTitle:@"测试短信"];//修改短信界面标题
    }else{
        //[self alertWithTitle:@"提示信息" msg:@"设备没有短信功能"];
    }
}


//MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    // [controller dismissModalViewControllerAnimated:NO];//关键的一句   不能为YES
    [controller dismissViewControllerAnimated:NO completion:nil];
    switch ( result ) {
            
        case MessageComposeResultCancelled:
            [self alertWithTitle:@"提示信息" msg:@"发送取消"];
            break;
        case MessageComposeResultFailed:// send failed
            [self alertWithTitle:@"提示信息" msg:@"发送成功"];
            break;
        case MessageComposeResultSent:
            [self alertWithTitle:@"提示信息" msg:@"发送失败"];
            break;
        default:
            break;
    }
}

- (void) alertWithTitle:(NSString *)title msg:(NSString *)msg {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:viewController
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"确定", nil];
    
    [alert show];
    
}
#pragma mark-打电话
-(void)callAction:(NSString*)tel Delegate:(UIViewController*)controller
{
    viewController=controller;
    //    NSString *tel=sender.titleLabel.text;
    UIWebView*callWebview =[[UIWebView alloc] init];
    
    NSString *telUrl = [NSString stringWithFormat:@"tel:%@",tel];
    
    NSURL *telURL =[NSURL URLWithString:telUrl];// 貌似tel:// 或者 tel: 都行
    
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    
    //记得添加到view上
    [viewController.view addSubview:callWebview];
}

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    return currentVC;
    
}
+ (NSString *)getCurrentVCString
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    

    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    
    
    NSString * vcStr = NSStringFromClass(currentVC.class);
    return vcStr;
}
+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else {
        // 根视图为非导航类
        currentVC = rootVC;
    }
    
    return currentVC;
}


//打开苹果自带地图导航
+(void)openMapWithAddress:(NSString *)address{
    // if (address.length == 0)  return;
    
    CLGeocoder * geo = [[CLGeocoder alloc] init];
    [geo  geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        /**
         取得第一个地标，地标中存储了详细的地址信息，注意：一个地名可能搜索出多个地址
         获取到终点的MKplaceMark，MKPlaceMark 是ClPlaceMark的子类。
         */
        MKPlacemark *endPlace = [[MKPlacemark alloc] initWithPlacemark:[placemarks firstObject]];
        /**
         将MKPlaceMark转换成MKMapItem，这样可以放入到item这个数组中
         */
        MKMapItem *endItem = [[MKMapItem alloc ] initWithPlacemark:endPlace];
        
        MKMapItem *startItem = [MKMapItem mapItemForCurrentLocation];
        NSArray *item = @[startItem ,endItem];
        
        //建立字典存储导航的相关参数
        NSMutableDictionary *md = [NSMutableDictionary dictionary];
        md[MKLaunchOptionsDirectionsModeKey] = MKLaunchOptionsDirectionsModeDriving;
        md[MKLaunchOptionsMapTypeKey] = [NSNumber numberWithInteger:MKMapTypeStandard];
        //md[MKLaunchOptionsMapTypeKey] = @YES;
        
        /**
         *调用app自带导航，需要传入一个数组和一个字典，数组中放入MKMapItem，
         字典中放入对应键值
         MKLaunchOptionsDirectionsModeKey   开启导航模式
         MKLaunchOptionsMapTypeKey  //地图类型
         MKMapTypeStandard = 0,//标准地图，一般情况下使用此地图即可满足；
         MKMapTypeSatellite,//卫星地图；
         MKMapTypeHybrid//混合地图，加载最慢比较消耗资源；
         // 导航模式
         MKLaunchOptionsDirectionsModeDriving 开车;
         MKLaunchOptionsDirectionsModeWalking 步行;
         */
        [MKMapItem openMapsWithItems:item launchOptions:md];
    }];
    
}
+(void)showProgress:(UIView *)view{
    [MBProgressHUD showHUDAddedTo:view animated:YES];
}

+(void)dismissProgress:(UIView *)view{
    [MBProgressHUD hideHUDForView:view animated:YES];
}
+(void)shareType:(NSInteger)type viewController:(UIViewController*)controller{
//    if (type == 1) {//聊天
//        [self shareWebPageToPlatformType:UMSocialPlatformType_WechatSession viewController:controller];
//    }else if (type ==2){//朋友圈
//        [self shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine viewController:controller];
//    }
}
static NSString* const UMS_THUMB_IMAGE = @"https://mobile.umeng.com/images/pic/home/social/img-1.png";
//网页分享
//+ (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType viewController:(UIViewController*)controller
//{
//    //创建分享消息对象
//    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//
//    //创建网页内容对象
//    NSString* thumbURL =  ktestHeaderUrl;//UMS_THUMB_IMAGE;
//    ////分享文字：下载《阿里游玩三张》，即可快速畅玩，邀请好友更有奖品获得哦，多邀多得！
//    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"下载《阿里游玩三张》" descr:@"即可快速畅玩，邀请好友更有奖品获得哦，多邀多得！" thumImage:thumbURL];
//    //设置网页地址
//    shareObject.webpageUrl = [MemoryCache sharedInstance].activitiesModel.szShareUrl;
//
//    //分享消息对象设置分享内容对象
//    messageObject.shareObject = shareObject;
//
//#ifdef UM_Swift
//    [UMSocialSwiftInterface shareWithPlattype:platformType messageObject:messageObject viewController:viewController completion:^(UMSocialShareResponse * data, NSError * error) {
//#else
//        //调用分享接口
//        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:controller completion:^(id data, NSError *error) {
//#endif
//            if (error) {
//                UMSocialLogInfo(@"************Share fail with error %@*********",error);
//            }else{
//                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
//                    UMSocialShareResponse *resp = data;
//                    //分享结果消息
//                    UMSocialLogInfo(@"response message is %@",resp.message);
//                    //第三方原始返回的数据
//                    UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
//
//                }else{
//                    UMSocialLogInfo(@"response data is %@",data);
//                }
//            }
//            //[self alertWithError:error];
//            NSLog(@"error==%@",error);
//        }];
//
//}
 //用牌选项 1/2 1:整副牌 2:9-A
 +(NSString *)nUseCard:(NSUInteger)ID
{
    NSString *result=@"";//结论
    if(ID==1)
    {
        result=@"整副牌";
    }else if (ID==2)
    {
        result=@"只用9-A";
    }
    return result;
}
// //闷牌限制 -1/2/3 -1:无限制
// +(NSString *)nStuffy:(NSUInteger)ID
//{
//    NSString *result;//结论
//    if(ID== -1)
//    {
//        result=@"无限制";
//    }else if (ID==2)
//    {
//        result=@"2";
//    }else if (ID==3)
//    {
//        result=@"2";
//    }
//    return result;
//}
 +(NSString *)integerGetName:(NSUInteger)ID
{
    NSString *result;//结论
    if(ID== 1)
    {
        result=@"one";
    }else if (ID==2)
    {
        result=@"two";
    }else if (ID==3)
    {
        result=@"three";
    }else if (ID==5)
    {
        result=@"five";
    }else if (ID==10)
    {
        result=@"ten";
    }
    return result;
}
 +(NSString *)getCardName:(NSUInteger)ID{
     //黑 0-12
     //红13-25
     //梅花26-38
     //方39-51
     //%13 牌大小
     ///13 颜色
     NSString *result;
     NSString *colorStr;
     NSUInteger color = ID/13;
     int card = ID%13;
     
     if(color == 0){//黑
         colorStr = @"heitao";
     }else if (color ==1){//红
         colorStr = @"hongtao";
     }else if (color ==2){//梅
         colorStr = @"meihua";
     }else if (color ==3){//方
         colorStr = @"fangkuai";
     }
     
     if (card<9) {
         result = [NSString stringWithFormat:@"%@%d",colorStr,card+2];
     }else if (card==9){
         result = [NSString stringWithFormat:@"%@J",colorStr];
     }else if (card==10){
         result = [NSString stringWithFormat:@"%@Q",colorStr];
     }else if (card==11){
         result = [NSString stringWithFormat:@"%@K",colorStr];
     }else if (card==12){
         result = [NSString stringWithFormat:@"%@1",colorStr];
     }
     //NSLog(@"result==%@",result);
     return  result;
 }
 +(NSString *)getCardsType:(NSUInteger)cardsType{
     //-- 牌型 (0:非法; 1:单张; 2:对子; 3:顺子; 4:金花; 5:顺金; 6:豹子)
     NSString *result;//结论
     if(cardsType== 1)
     {
         result=@"sanpai";
     }else if (cardsType==2)
     {
         result=@"duizi";
     }else if (cardsType==3)
     {
         result=@"shunzi";
     }else if (cardsType==4)
     {
         result=@"jinhua";
     }else if (cardsType==5)
     {
         result=@"shunjin";
     }else if (cardsType==6)
     {
         result=@"baozi";
     }else if (cardsType==7)
     {
         result=@"teshu";
     }
     return result;
 }
+(NSString *)getState:(NSUInteger)state{
    NSString *result;//结论
    switch (state) {
        case -1:
            result = @"拒绝帮助";
            break;
        case 0:
            result = @"未处理";
            break;
        case 1:
            result = @"愿意帮助";
            break;
        case 2:
            result = @"完成";
            break;
            
        default:
            break;
    }
    return result;
}
     
     
     
     
     
     
     
@end
