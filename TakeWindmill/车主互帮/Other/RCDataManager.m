



//
//  RCDataManager.m
//  RCIM
//
//  Created by 郑文明 on 15/12/30.
//  Copyright © 2015年 郑文明. All rights reserved.
//

#import "RCDataManager.h"
#import "AppDelegate.h"
#import "YBTaxiStepModel.h"
#import "YBTaxiModel.h"
@implementation RCDataManager{
    NSMutableArray *dataSoure;
}

- (instancetype)init{
    if (self = [super init]) {
        [RCIM sharedRCIM].userInfoDataSource = self;
        [RCIM sharedRCIM].receiveMessageDelegate = self;
        
        [[RCIM sharedRCIM] registerMessageType:[YBTaxiModel class]];
        [[RCIM sharedRCIM] registerMessageType:[YBTaxiStepModel class]];
        [[RCIM sharedRCIM] registerMessageType:[YBHelpMessage class]];
    }
    return self;
}

+ (RCDataManager *)shareManager{
    static RCDataManager* manager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manager = [[[self class] alloc] init];
    });
    return manager;
}
/**
 *  从服务器同步好友列表
 */
-(void)syncFriendList:(void (^)(NSMutableArray* friends,BOOL isSuccess))completion
{
    dataSoure = [[NSMutableArray alloc]init];
    
    //    for (NSInteger i = 1; i<7; i++) {
    //        if(i==1){
    //            RCUserInfo *aUserInfo =[[RCUserInfo alloc]initWithUserId:[NSString stringWithFormat:@"%ld",i] name:@"文明" portrait:@"http://weixin.ihk.cn/ihkwx_upload/fodder/20151210/1449727866527.jpg" QQ:@"740747055" sex:@"男"];
    //            [dataSoure addObject:aUserInfo];
    //        }
    //    }
    
    //[AppDelegate shareAppDelegate].friendsArray = dataSoure;
    completion(dataSoure,YES);
    
}
/**
 *  从服务器同步群组列表
 */
-(void) syncGroupList:(void (^)(NSMutableArray * groups,BOOL isSuccess))completion{
    //    if ([AppDelegate shareAppDelegate].groupsArray.count) {
    //        [[AppDelegate shareAppDelegate].groupsArray removeAllObjects];
    //    }
    //    for (NSInteger i = 1; i<4; i++) {
    //        if (i==1) {
    //            RCGroup *aGroup = [[RCGroup alloc]initWithGroupId:[NSString stringWithFormat:@"%ld",i] groupName:@"斧头帮" portraitUri:@"http://farm2.staticflickr.com/1709/24157242566_98d0192315_m.jpg"];
    //            [[AppDelegate shareAppDelegate].groupsArray addObject:aGroup];
    //
    //        }
    //    }
    //    completion([AppDelegate shareAppDelegate].groupsArray,YES);
    
    NSMutableArray * array;
    completion(array,YES);
    
}
#pragma mark
#pragma mark 根据userId获取RCUserInfo
-(RCUserInfo *)currentUserInfoWithUserId:(NSString *)userId{
    //    for (NSInteger i = 0; i<[AppDelegate shareAppDelegate].friendsArray.count; i++) {
    //        RCUserInfo *aUser = [AppDelegate shareAppDelegate].friendsArray[i];
    //        if ([userId isEqualToString:aUser.userId]) {
    //            NSLog(@"current ＝ %@",aUser.name);
    //            return aUser;
    //        }
    //    }
    return nil;
}
#pragma mark
#pragma mark 根据userId获取RCGroup
-(RCGroup *)currentGroupInfoWithGroupId:(NSString *)groupId{
    //    for (NSInteger i = 0; i<[AppDelegate shareAppDelegate].groupsArray.count; i++) {
    //        RCGroup *aGroup = [AppDelegate shareAppDelegate].groupsArray[i];
    //        if ([groupId isEqualToString:aGroup.groupId]) {
    //            return aGroup;
    //        }
    //    }
    return nil;
}
-(NSString *)currentNameWithUserId:(NSString *)userId{
    //    for (NSInteger i = 0; i<[AppDelegate shareAppDelegate].friendsArray.count; i++) {
    //        RCUserInfo *aUser = [AppDelegate shareAppDelegate].friendsArray[i];
    //        if ([userId isEqualToString:aUser.userId]) {
    //            NSLog(@"current ＝ %@",aUser.name);
    //            return aUser.name;
    //        }
    //    }
    return nil;
}
#pragma mark
#pragma mark - RCIMUserInfoDataSource
- (void)getUserInfoWithUserId:(NSString*)userId completion:(void (^)(RCUserInfo*))completion
{
    NSLog(@"getUserInfoWithUserId ----- %@", userId);
    
    if (userId == nil || [userId length] == 0 )
    {
        [self syncFriendList:^(NSMutableArray *friends, BOOL isSuccess) {
            
        }];
        
        completion(nil);
        return ;
    }
    
    //    if ([userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
    //        RCUserInfo *myselfInfo = [[RCUserInfo alloc]initWithUserId:[RCIM sharedRCIM].currentUserInfo.userId name:[RCIM sharedRCIM].currentUserInfo.name portrait:[RCIM sharedRCIM].currentUserInfo.portraitUri QQ:[RCIM sharedRCIM].currentUserInfo.QQ sex:[RCIM sharedRCIM].currentUserInfo.sex];
    //        completion(myselfInfo);
    //
    //    }
    
    //    for (NSInteger i = 0; i<[AppDelegate shareAppDelegate].friendsArray.count; i++) {
    //        RCUserInfo *aUser = [AppDelegate shareAppDelegate].friendsArray[i];
    //        if ([userId isEqualToString:aUser.userId]) {
    //            completion(aUser);
    //            break;
    //        }
    //    }
}
#pragma mark
#pragma mark - RCIMGroupInfoDataSource
- (void)getGroupInfoWithGroupId:(NSString *)groupId
                     completion:(void (^)(RCGroup *groupInfo))completion{
    //    for (NSInteger i = 0; i<[AppDelegate shareAppDelegate].groupsArray.count; i++) {
    //        RCGroup *aGroup = [AppDelegate shareAppDelegate].groupsArray[i];
    //        if ([groupId isEqualToString:aGroup.groupId]) {
    //            completion(aGroup);
    //            break;
    //        }
    //    }
}
-(void)loginRongCloudWithUserInfo:(RCUserInfo *)userInfo withToken:(NSString *)token{
    NSMutableDictionary *parm = [YBTooler dictinitWithMD5];
    NSString *userID = [YBUserDefaults valueForKey:_userId];
    parm[@"userid"] = userID;
    //parm[@"username"] = userID;
    //parm[@"headimgurl"] = userID;
    
    [YBRequest postWithURL:RongcloudGettoken MutableDict:parm success:^(id dataArray) {
        YBLog(@"dataArray=1=%@",dataArray);
        //[MBProgressHUD showError:@"认证成功"toView:self.view];
        
        NSString * Token= dataArray[@"Token"];
        YBLog(@"Token==%@",Token);
        [[RCIM sharedRCIM] connectWithToken:Token  success:^(NSString *userId) {
            NSLog(@"==登陆成功。当前登录的用户ID：%@", userId);
            
            RCUserInfo * userInfo;
            if ([userID isEqualToString:@"8FA57A8A259E42EB95766C7E04E3BC1A"]) {
                
                userInfo = [[RCUserInfo alloc]initWithUserId:@"8FA57A8A259E42EB95766C7E04E3BC1A" name:@"王五" portrait:@"http://121.40.76.10:93/images/driver/servicecard.png"];
            }else{
                userInfo = [[RCUserInfo alloc]initWithUserId:@"A651B4968A96438F924A4F7139687C1F" name:@"HSH" portrait:@"http://121.40.76.10:93/images/driver/identcard.png"];
            }
            
            [RCIMClient sharedRCIMClient].currentUserInfo = userInfo;
            
        } error:^(RCConnectErrorCode status) {
            NSLog(@"==登陆的错误码为:%ld", status);
        } tokenIncorrect:^{
            //token过期或者不正确。
            //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
            //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
            NSLog(@"==token错误");
        }];
        
    } failure:^(id dataArray) {
        YBLog(@"failureDataArray=2=%@",dataArray);
        //[MBProgressHUD showError:dataArray[@"ErrorMessage"] toView:self.view];
    }];
    
}

-(void)refreshBadgeValue{
    
    dispatch_async(dispatch_get_main_queue(), ^{

        NSInteger unreadMsgCount = (NSInteger)[[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION),@(ConversationType_GROUP),@(ConversationType_CHATROOM)]];

        YBLog(@"unreadMsgCount==%ld",unreadMsgCount);
//        UINavigationController  *chatNav = [AppDelegate shareAppDelegate].tabbarVC.viewControllers[1];
//        if (unreadMsgCount == 0) {
//            chatNav.tabBarItem.badgeValue = nil;
//        }else{
//            chatNav.tabBarItem.badgeValue = [NSString stringWithFormat:@"%li",(long)unreadMsgCount];
//        }
    });
}
-(BOOL)hasTheFriendWithUserId:(NSString *)userId{
    //    if ([AppDelegate shareAppDelegate].friendsArray.count) {
    //        NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    //
    //        for (RCUserInfo *aUserInfo in [AppDelegate shareAppDelegate].friendsArray) {
    //            [tempArray addObject:aUserInfo.userId];
    //        }
    //
    //        if ([tempArray containsObject:userId]) {
    //            return YES;
    //        }
    //    }
    
    
    return NO;
}

/*!
 接收消息的回调方法
 *
 */
-(void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left
{
    //YBHelpMessage *helpMessage = (YBHelpMessage *)message.content;
    NSLog(@"content==%@",message.content);
    //YBTaxiStepModel *taxiStep = (YBTaxiStepModel *)message.content;
   
    if ([self.delegate respondsToSelector:@selector(receiveMessage:MsgValue:)]) {
         NSInteger unreadMsgCount = (NSInteger)[[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION),@(ConversationType_GROUP),@(ConversationType_CHATROOM)]];
        [self.delegate receiveMessage:message MsgValue:unreadMsgCount];
    }
    
    //[[RCDataManager shareManager] refreshBadgeValue];
//    [self.conversationListTableView reloadData];
}

@end
