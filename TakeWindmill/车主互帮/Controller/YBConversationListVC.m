//
//  YBConversationListVC.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/11/27.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBConversationListVC.h"
#import "YBChatVC.h"

@interface YBConversationListVC ()

@end

@implementation YBConversationListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置需要显示哪些类型的会话
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_DISCUSSION),
                                       // @(ConversationType_CHATROOM),
                                        //@(ConversationType_GROUP),
                                        //@(ConversationType_APPSERVICE),
                                        @(ConversationType_SYSTEM)]];
    
    //设置需要将哪些类型的会话在会话列表中聚合显示
    //[self setCollectionConversationType:@[@(ConversationType_DISCUSSION),
//                                          @(ConversationType_GROUP)]];
    
}
//重写RCConversationListViewController的onSelectedTableRow事件
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
   
    if (model.conversationType==ConversationType_PRIVATE) {//单聊
        RCUserInfo *aUserInfo = [[RCDataManager shareManager] currentUserInfoWithUserId:model.targetId];
        
        YBChatVC *conversationVC = [[YBChatVC alloc]init];
        conversationVC.conversationType = model.conversationType;
        conversationVC.targetId = model.targetId;
        conversationVC.title = aUserInfo.name;
        [self.navigationController pushViewController:conversationVC animated:NO];
        
    }else if (model.conversationType==ConversationType_GROUP){//群聊
//        WMConversationViewController *_conversationVC = [[WMConversationViewController alloc]init];
//        _conversationVC.conversationType = model.conversationType;
//        _conversationVC.targetId = model.targetId;
//        _conversationVC.title = model.conversationTitle;
//        [self.navigationController pushViewController:_conversationVC animated:YES];
    }else if (model.conversationType==ConversationType_DISCUSSION){//讨论组
        YBChatVC *_conversationVC = [[YBChatVC alloc]init];
        _conversationVC.conversationType = model.conversationType;
        _conversationVC.targetId = model.targetId;
        _conversationVC.title = model.conversationTitle;
        [self.navigationController pushViewController:_conversationVC animated:NO];
    }else if (model.conversationType==ConversationType_CHATROOM){//聊天室
        
    }else if (model.conversationType==ConversationType_APPSERVICE){//客服
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
