//
//  YBOwnersHelpAlertView.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/11/30.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBOwnersHelpAlertView.h"
#import "YBChatVC.h"


@interface YBOwnersHelpAlertView()<UITextViewDelegate>

@property (nonatomic, strong) UIView *helpContentView;

@property(nonatomic,strong) DSAlert * alert;

@end

@implementation YBOwnersHelpAlertView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}
-(void)setUI{
    
    self.helpContentView = [[UIView alloc] initWithFrame:CGRectMake(0,30, YBWidth-60, 200)];
    self.helpContentView.backgroundColor = [UIColor whiteColor];
    self.helpContentView.layer.cornerRadius = 8;
    self.helpContentView.clipsToBounds = YES;
    
    //司机信息
    YBOwnerInView *owner = [[YBOwnerInView alloc] initWithFrame:CGRectMake(10,10, self.helpContentView.width-20, 40)];
    [owner.phoneButton addTarget:self action:@selector(phoneButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [owner.SMSButton addTarget:self action:@selector(SMSButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.helpContentView addSubview:owner];
    self.owner = owner;
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(owner.frame) + 10 , self.helpContentView.frame.size.width, 20)];
    titleLabel.text = @"求助内容";
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.font = YBFont(12);
    [self.helpContentView addSubview:titleLabel];
    
    self.contentText = [[UITextView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLabel.frame) + 10, self.helpContentView.frame.size.width - 20, self.helpContentView.frame.size.height / 3)];
    self.contentText.layer.cornerRadius = 10;
    self.contentText.layer.borderWidth = 1;
    self.contentText.layer.borderColor = LightGreyColor.CGColor;
    self.contentText.delegate = self;
    //self.contentText.returnKeyType = UIReturnKeyDefault;
    [self.helpContentView addSubview:self.contentText];
    
    UIButton *helpButton = [[UIButton alloc] initWithFrame:CGRectMake(self.helpContentView.frame.size.width / 2 - 40, CGRectGetMaxY(self.contentText.frame) + 10, 80, 25)];
    [helpButton setTitle:@"我要求助" forState:UIControlStateNormal];
    [helpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [helpButton setBackgroundColor:BtnBlueColor];
    helpButton.layer.cornerRadius = 5;
    helpButton.titleLabel.font = YBFont(14);
    [helpButton addTarget:self action:@selector(helpButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.helpContentView addSubview:helpButton];
    self.helpButton = helpButton;
    
    
    helpButton = [[UIButton alloc] initWithFrame:CGRectMake(self.helpContentView.frame.size.width / 2 - 90, CGRectGetMaxY(self.contentText.frame) + 10, 80, 25)];
    [helpButton setTitle:@"愿意帮助" forState:UIControlStateNormal];
    [helpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [helpButton setBackgroundColor:BtnBlueColor];
    helpButton.layer.cornerRadius = 5;
    helpButton.titleLabel.font = YBFont(14);
    helpButton.tag = 1;
    helpButton.hidden = YES;
    [helpButton addTarget:self action:@selector(tohelpButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.helpContentView addSubview:helpButton];
    self.tohelpButton = helpButton;
    
    helpButton = [[UIButton alloc] initWithFrame:CGRectMake(self.helpContentView.frame.size.width / 2 + 10, CGRectGetMaxY(self.contentText.frame) + 10, 80, 25)];
    [helpButton setTitle:@"拒绝帮助" forState:UIControlStateNormal];
    [helpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [helpButton setBackgroundColor:BtnBlueColor];
    helpButton.layer.cornerRadius = 5;
    helpButton.hidden = YES;
    helpButton.titleLabel.font = YBFont(14);
    [helpButton addTarget:self action:@selector(tohelpButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.helpContentView addSubview:helpButton];
    self.nohelpButton = helpButton;
    
    
    self.helpContentView.size = CGSizeMake(YBWidth-60, CGRectGetMaxY(helpButton.frame) + 10);
    
    _alert = [[DSAlert alloc] initWithCustomView:self.helpContentView];
    //_alert.showAnimate = YES;
    _alert.isTouchEdgeHide = YES;
    [_alert ds_showAlertView];
}

#pragma mark UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //按下return
        //[self endEditing:YES];
        [_contentText resignFirstResponder];
        return NO;
    }
    return YES;
}

//phoneButtonTap
- (void)phoneButtonTap:(UIButton *)sender {
    WEAK_SELF;
    
    if (weakSelf.userInfoList.Mobile.length==0) {
         [MBProgressHUD showError:@"电话号码不能为空" toView:weakSelf.VC.view];
    }
    dispatch_after(0.2, dispatch_get_main_queue(), ^{
        [[[Tools alloc]init] callAction:weakSelf.userInfoList.Mobile Delegate:weakSelf.VC];
    });
}

- (void)SMSButtonTap:(UIButton *)sender {
    
    [_alert ds_dismissAlertView];
    
    RCUserInfo *userInfo = [[RCUserInfo alloc]initWithUserId:self.userInfoList.UserId name:self.userInfoList.NickName portrait:self.userInfoList.HeadImgUrl];
    
    //新建一个聊天会话View Controller对象,建议这样初始化
    YBChatVC *chat = [[YBChatVC alloc] initWithConversationType:ConversationType_PRIVATE
                                                       targetId:userInfo.userId];
    
    //    //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
    //    chat.conversationType = ConversationType_PRIVATE;
    //    //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
    //    chat.targetId = @"";
    //设置聊天会话界面要显示的标题
    //chat.title = userInfo.name;
    //显示聊天会话界面
    [self.VC.navigationController pushViewController:chat animated:YES];
}
- (void)helpButtonAction:(UIButton *)sender {
    
    if ([self.contentText.text isEqualToString:@""]) {
//        UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入您需要帮助的内容" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:nil];
//        [aler addAction:ok];
//        [self.VC presentViewController:aler animated:YES completion:nil];
        
        DSAlert *alertMessage = [[DSAlert alloc] ds_showTitle:@"提示" message:@"请输入您需要帮助的内容" image:nil buttonTitles:@[@"确定"] buttonTitlesColor:@[BtnBlueColor]];
        [alertMessage ds_showAlertView];
        return;
    }
    
    [self endEditing:YES];
    
    [self requstSendMessage];
}
- (void)tohelpButtonAction:(UIButton *)sender {
    WEAK_SELF;
    [weakSelf.alert ds_dismissAlertView];
    
    //SysNo：系统编号，ReplyStat回复状态，1-同意，-1-拒绝，2-完成
    NSMutableDictionary *parm = [YBTooler dictinitWithMD5];
    parm[@"sysno"] = [HSHString toString:_userInfoList.SysNo];
    if (sender.tag == 1) {//愿意帮助
         parm[@"replystat"] = @1;
    } else {
         parm[@"replystat"] = @-1;
    }
    
    [YBRequest postWithURL:DriverhelpDriverhelpinfreply MutableDict:parm success:^(id dataArray) {
        YBLog(@"dataArray==%@",dataArray);
        //YBGroupHelpModel *model = [YBGroupHelpModel yy_modelWithJSON:dataArray];
        //weakSelf.dataArr = [NSMutableArray arrayWithArray:model.UserInfoList];
        //[weakSelf.tableView reloadData];
        
       [MBProgressHUD showError:@"操作成功" toView:weakSelf.VC.view];
        
        if ([weakSelf.delegate respondsToSelector:@selector(clickTap:)]) {
            [weakSelf.delegate clickTap:sender.tag];
        }
    } failure:^(id dataArray) {
         //YBLog(@"failureDataArray==%@",dataArray);
         [MBProgressHUD showError:dataArray[@"ErrorMessage"] toView:weakSelf.VC.view];
    }];
}
-(void)requstSendMessage{
    WEAK_SELF;
    [weakSelf.alert ds_dismissAlertView];
    
    NSMutableDictionary *parm = [YBTooler dictinitWithMD5];
    NSString *userID = [YBUserDefaults valueForKey:_userId];
    //UserId：发送者Id，ToUserId：接收者Id，Message：发送内容
    parm[@"userid"] = userID;
    parm[@"touserid"] = [HSHString IsNotNull:self.userInfoList.UserId];
    parm[@"message"] = self.contentText.text;
    
    [YBRequest postWithURL:DriverhelpDriverhelpinfosave MutableDict:parm success:^(id dataArray) {
        //YBLog(@"dataArray==%@",dataArray);
        //YBGroupHelpModel *model = [YBGroupHelpModel yy_modelWithJSON:dataArray];
        //weakSelf.dataArr = [NSMutableArray arrayWithArray:model.UserInfoList];
        
         [MBProgressHUD showError:@"求助成功" toView:weakSelf.VC.view];
        
    } failure:^(id dataArray) {
        //YBLog(@"failureDataArray==%@",dataArray);
        [MBProgressHUD showError:dataArray[@"ErrorMessage"] toView:weakSelf.VC.view];
    }];
    
}
-(void)setUserInfoList:(UserInfoList *)userInfoList{
    _userInfoList = userInfoList;
     [_owner.imageView sd_setImageWithURL:[NSURL URLWithString:userInfoList.HeadImgUrl] placeholderImage:[UIImage imageNamed:@"车主认证"]];
    _owner.nameLabel.text = userInfoList.NickName;
    _owner.licensePlate.text = userInfoList.VehicleNumber;
    _owner.modelsLabel.text = userInfoList.VehicleSeries;
    
}
-(void)dealloc{
    NSLog(@"%s",__func__);
}
@end
