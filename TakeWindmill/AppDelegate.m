//
//  AppDelegate.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/7.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "AppDelegate.h"
#import "BNCoreServices.h"
#import "YBNavigationController.h"
#import "YBHomeViewController.h"
#import "YBPersonViewController.h"
#import <BaiduMapAPI_Base/BMKMapManager.h>

@interface AppDelegate ()<BMKGeneralDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //初始化百度
    [self baiduMap];
    //初始化融云相关
    [self initRongClould];
    //微信
    [FLPAYMANAGER fl_registerApp];
    
    /**
     * 推送处理1
     */
    if ([application
         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        //注册推送, 用于iOS8以及iOS8之后的系统
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  UIUserNotificationTypeSound |
                                                                  UIUserNotificationTypeAlert)
                                                categories:nil];
        [application registerUserNotificationSettings:settings];
    } else {
        //注册推送，用于iOS8之前的系统
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeAlert |
        UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
    //点击通知栏的远程推送时，如果此时 App 已经被系统冻结
    // 远程推送的内容
    NSDictionary *remoteNotificationUserInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
   // YBLog(@"远程推送的内容==%@",remoteNotificationUserInfo);
   
    NSDictionary * dic = remoteNotificationUserInfo[@"rc"];
    [self receiveLocalNotificationDic:dic];
  
    return YES;
}
-(void)goHome{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    YBNavigationController *contentViewController = [[YBNavigationController alloc]initWithRootViewController:[YBHomeViewController new]];
    YBPersonViewController  *leftMenuViewController = [[YBPersonViewController alloc] init];
    
    YQSlideMenuController *sideMenuController = [[YQSlideMenuController alloc]initWithContentViewController:contentViewController leftMenuViewController:leftMenuViewController];
    sideMenuController.scaleContent = NO;
    self.window.rootViewController = sideMenuController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
}
-(void)initRongClould{
    //融云
    [[RCIM sharedRCIM] initWithAppKey:rongAppKey];
    //设置用户信息提供者为 [RCDataManager shareManager]
    [RCIM sharedRCIM].userInfoDataSource = [RCDataManager shareManager];
    //设置群组信息提供者为 [RCDataManager shareManager]
    [RCIM sharedRCIM].groupInfoDataSource = [RCDataManager shareManager];
    [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
    
}
/**
 * 推送处理2
 */
//注册用户通知设置
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
    // register to receive notifications
    [application registerForRemoteNotifications];
    YBLog(@"==注册用户通知设置");
}
/**
 * 推送处理3
 */
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
    YBLog(@"==推送处理3,token==%@",token);
}
//当App退到后台一段时间，被系统挂起后，点击通知栏会走
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //    userInfo=={
    //        "aps" : {
    //            "category" : "RC:TxtMsg",
    //            "mutable-content" : "1",
    //            "alert" : {
    //                "body" : "bibi:此次 v"
    //            },
    //            "badge" : 1,
    //            "sound" : "sms-received.caf"
    //        },
    //        "rc" : {
    //            "oName" : "RC:TxtMsg",
    //            "id" : "",
    //            "fId" : "A651B4968A96438F924A4F7139687C1F",
    //            "cType" : "PR",
    //            "tId" : "A651B4968A96438F924A4F7139687C1F"
    //        }
    //    }
    
    NSDictionary * dic = userInfo[@"rc"];
    [self receiveLocalNotificationDic:dic];

}

//当App进入后台两分钟之内，点击通知栏的话 会走Appdelegate中的
- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    
   NSDictionary * dic = notification.userInfo[@"rc"];
   [self receiveLocalNotificationDic:dic];
    
}
//当App被结束掉进程，完全退出后，点击通知栏会走
//- (BOOL)application:(UIApplication *)application
//didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//}

-(void)receiveLocalNotificationDic:(NSDictionary *)dic{
    [YBUserDefaults setObject:dic forKey:kPushRC];
    [YBUserDefaults synchronize];
    [self goHome];
}

- (void)baiduMap {
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:BMMapKey generalDelegate:self];
    if (!ret) {
        NSLog(@"百度地图失败!");
    }
    [self.window makeKeyAndVisible];
    
    //初始化导航SDK
    [BNCoreServices_Instance initServices:BMMapKey];
    //TTS在线授权
    [BNCoreServices_Instance setTTSAppId:@"10381219"];
    //设置是否自动退出导航
    [BNCoreServices_Instance setAutoExitNavi:YES];
    [BNCoreServices_Instance startServicesAsyn:nil fail:nil];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
      return [FLPAYMANAGER fl_handleUrl:url];
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    return [FLPAYMANAGER fl_handleUrl:url];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    NSInteger ToatalunreadMsgCount = (NSInteger)[[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION),@(ConversationType_GROUP),@(ConversationType_CHATROOM)]];
    [UIApplication sharedApplication].applicationIconBadgeNumber = ToatalunreadMsgCount;
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
     [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
