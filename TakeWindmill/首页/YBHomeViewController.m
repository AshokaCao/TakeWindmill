//
//  YBHomeViewController.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/7.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBHomeViewController.h"
#import "YBUpDownButton.h"
#import "SDCycleScrollView.h"
#import "YBLogInViewController.h"
//#import "YBMessageViewController.h"

#import "YBTakeWindmillViewController.h"
#import "YBTrafficConditionsVC.h"
#import "YBCarpoolOrdersVC.h"
#import "YBRedEnvelopesViewController.h"
#import "YBTaxiViewController.h"
#import "YBOwnersHelpVC.h"
#import "YBCarServicesVC.h"
#import "YBPublicActionVC.h"
#import "YBOnTheTrainVC.h"

#import "YBRoadTestVC.h"
#import "YBConversationListVC.h"
#import "YBChatVC.h"
#import "YZLocationManager.h"




@interface YBHomeViewController ()<SDCycleScrollViewDelegate,YBReceiveMsgValueDelegate>
{

}
//头部按钮试图
@property (nonatomic, strong) UIView *itemView;

//无限轮播视图
//定时器
@property (nonatomic, strong) NSTimer *rotateTimer;
//点
@property (nonatomic, strong) UIPageControl *myPageControl;

@property (nonatomic, strong) UILabel *msgValue;

@end

@implementation YBHomeViewController




-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    // [self aliPay];//支付宝
//    [self wechatPay];//微信
}
- (void)wechatPay{
    WEAK_SELF;
    NSMutableDictionary *parm = [YBTooler dictinitWithMD5];
    parm[@"orderno"] = @"kjdfljfjf";//传订单号
    [YBRequest postWithURL:WeixinPay MutableDict:parm success:^(id dataArray) {
        //YBLog(@"dataArray==%@",dataArray);
        YBPayconfigModel *paymodel = [YBPayconfigModel yy_modelWithJSON:dataArray];
        
        PayReq* req = [[PayReq alloc] init];
        req.partnerId = paymodel.partnerid;
        req.prepayId= paymodel.prepayid;
        req.package = paymodel.packagevalue;
        req.nonceStr= paymodel.noncestr;
        req.timeStamp= paymodel.timestamp.intValue;
        req.sign= paymodel.Sign;//paymodel.sign;
        [FLPAYMANAGER fl_payWithOrderMessage:req callBack:^(FLErrCode errCode, NSString *errStr) {
            //NSLog(@"errCode = %zd,errStr = %@",errCode,errStr);
            
        }];
    } failure:^(id dataArray) {
        //YBLog(@"failureDataArray==%@",dataArray);
        [MBProgressHUD showError:dataArray[@"ErrorMessage"] toView:weakSelf.view];
    }];
}
-(void)aliPay{
    WEAK_SELF;
    NSMutableDictionary *parm = [YBTooler dictinitWithMD5];
    parm[@"configtype"] =@"alipay";
    
    //YBLog(@"url==%@",Apiconfig);
    //YBLog(@"parm==%@",parm);
    
    [YBRequest postWithURL:Apiconfig MutableDict:parm success:^(id dataArray) {
        YBLog(@"dataArray==%@",dataArray);
        YBPayconfigModel *payModel = [YBPayconfigModel yy_modelWithJSON:dataArray];
        // 重要说明
        // 这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
        // 真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
        // 防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
        
        NSString *appID = payModel.APPID;
        
        // 如下私钥，rsa2PrivateKey 或者 rsaPrivateKey 只需要填入一个
        // 如果商户两个都设置了，优先使用 rsa2PrivateKey
        // rsa2PrivateKey 可以保证商户交易在更加安全的环境下进行，建议使用 rsa2PrivateKey
        // 获取 rsa2PrivateKey，建议使用支付宝提供的公私钥生成工具生成，
        // 工具地址：https://doc.open.alipay.com/docs/doc.htm?treeId=291&articleId=106097&docType=1
        NSString *rsa2PrivateKey = payModel.PrivateKeyIOS;
        NSString *rsaPrivateKey = @"";
        
        /*
         *生成订单信息及签名
         */
        //将商品信息赋予AlixPayOrder的成员变量
        APOrderInfo *order = [[APOrderInfo alloc]init];
        
        // NOTE: app_id设置
        order.app_id =appID;
        
        order.notify_url = payModel.NotifyUrl;
        
        // NOTE: 支付接口名称
        order.method = @"alipay.trade.app.pay";
        
        // NOTE: 参数编码格式
        order.charset = @"utf-8";
        
        // NOTE: 当前时间点
        NSDateFormatter* formatter = [NSDateFormatter new];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        order.timestamp = [formatter stringFromDate:[NSDate date]];
        
        // NOTE: 支付版本
        order.version = @"1.0";
        
        // NOTE: sign_type 根据商户设置的私钥来决定
        order.sign_type = (rsa2PrivateKey.length > 1)?@"RSA2":@"RSA";
        
        // NOTE: 商品数据
        order.biz_content = [[APBizContent alloc] init];
        order.biz_content.body = @"我是测试数据";
        order.biz_content.subject = @"皕夶打车扣费";
        order.biz_content.out_trade_no = @"hfkhkfhhffhfjfjf"; //订单ID（由商家自行制定）
        order.biz_content.timeout_express = @"30m"; //超时时间设置
        order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f", 0.01]; //商品价格
        
        //将商品信息拼接成字符串
        NSString *orderInfo = [order orderInfoEncoded:NO];
        NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
        
        // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
        //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
        NSString *signedString = nil;
        APRSASigner* signer = [[APRSASigner alloc] initWithPrivateKey:((rsa2PrivateKey.length > 1)?rsa2PrivateKey:rsaPrivateKey)];
        
        if (orderInfo.length) {
            if ((rsa2PrivateKey.length > 1)) {
                signedString = [signer signString:orderInfo withRSA2:YES];
            } else {
                signedString = [signer signString:orderInfo withRSA2:NO];
            }
        }
        //NOTE: 如果加签成功，则继续执行支付
        if (signedString != nil) {
            // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
            NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                     orderInfoEncoded, signedString];
            [FLPAYMANAGER fl_payWithOrderMessage:orderString callBack:^(FLErrCode errCode, NSString *errStr) {
                NSLog(@"errCode = %zd,errStr = %@",errCode,errStr);
            }];
        }
        
    } failure:^(id dataArray) {
        YBLog(@"failureDataArray==%@",dataArray);
        [MBProgressHUD showError:dataArray[@"ErrorMessage"] toView:weakSelf.view];
    }];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kPersonreloadData object:nil userInfo:nil];
    
    [self updateMsgValue];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //        "rc" : {
    //            "oName" : "RC:TxtMsg",
    //            "id" : "",
    //            "fId" : "A651B4968A96438F924A4F7139687C1F",
    //            "cType" : "PR",
    //            "tId" : "A651B4968A96438F924A4F7139687C1F"
    //        }
    NSDictionary * dic = [YBUserDefaults objectForKey:kPushRC];
    
    if (dic) {
        //会话类型。PR 指单聊、 DS 指讨论组、 GRP 指群组、 CS 指客服、SYS 指系统会话、 MC 指应用内公众服务、 MP 指跨应用公众服务。
        //
        NSString * cType = dic[@"cType"];
        if ([cType isEqualToString:@"PR"]) {
            YBChatVC *vc = [[YBChatVC alloc]init];
            vc.conversationType = ConversationType_PRIVATE;
            vc.targetId = dic[@"tId"];
            [self.navigationController pushViewController:vc animated:NO];
        } else if([cType isEqualToString:@"DS"]){
            YBChatVC *vc = [[YBChatVC alloc]init];
            vc.conversationType = ConversationType_DISCUSSION;
            vc.targetId = dic[@"tId"];
            [self.navigationController pushViewController:vc animated:NO];
        }
    }
    [YBUserDefaults removeObjectForKey:kPushRC];

}
-(UILabel *)msgValue{
    if (_msgValue == nil) {
        UILabel * label = [[UILabel alloc]init];
        label.userInteractionEnabled = YES;
        label.font = [UIFont systemFontOfSize:10];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor redColor];
        label.textColor = [UIColor whiteColor];
        label.frame = CGRectMake(10, -5, 15, 15);
        label.layer.cornerRadius = label.frame.size.height/2;
        label.clipsToBounds = YES;
        label.hidden = YES;
        _msgValue = label;
    }
    return _msgValue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 这个方法是为了，不让隐藏状态栏的时候出现view上移
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNav];
    
    RCDataManager * mg =[RCDataManager shareManager];
    mg.delegate = self;
    
    //功能模块
    [self buttonsAction];
    //轮播图
    [self scrollViewInit];
    
    if ([YBUserDefaults boolForKey:isLogin]) {//已登录校验
        
        if (![YBUserDefaults objectForKey:_userId]) {
            [YBUserDefaults setBool:NO forKey:isLogin];
            [YBUserDefaults setObject:nil forKey:_userId];
            [YBUserDefaults synchronize];
            return;
        }
        NSString *URLStr = [NSString stringWithFormat:@"%@",UserclientidCheckPath];
        NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
        [dict setObject:[YBUserDefaults objectForKey:_userId]  forKey:@"userid"];
        
        [YBRequest postWithURL:URLStr MutableDict:dict View:self.view success:^(id dataArray) {
            
            YBLog(@"%@",dataArray);
            [YBUserDefaults setBool:YES forKey:isLogin];
            [YBUserDefaults synchronize];
            
        } failure:^(id dataArray) {
            YBLog(@"---%@",dataArray);
            
            [YBUserDefaults setBool:NO forKey:isLogin];
            [YBUserDefaults setObject:nil forKey:_userId];
            [YBUserDefaults synchronize];
            [self profileCenter];
        }];
        
        
        //
        [[RCDataManager shareManager] loginRongCloudWithUserInfo:nil withToken:nil];
    }
    else{//未登录
        [self profileCenter];
        
    }
    
    
}

#pragma mark - 用户校验


- (void)scrollViewInit {
    
    //滚动图片
    NSArray *imageArray = @[@"首页4_01",@"首页4_02"];
    
    // >>>>>>>>>>>>>>>>>>>>>>>>> demo轮播图1 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    // 本地加载 --- 创建不带标题的图片轮播器
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, CGRectGetMaxY(self.itemView.frame), YBWidth, YBHeight - _itemView.bounds.size.height ) shouldInfiniteLoop:YES imageNamesGroup:imageArray];
    cycleScrollView.delegate = self;
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    [self.view addSubview:cycleScrollView];
    cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //         --- 轮播时间间隔，默认1.0秒，可自定义
    cycleScrollView.autoScrollTimeInterval = 3.0;
    
    
}

- (void)buttonsAction {
    
    CGFloat with = YBWidth / 4 ;
    
    _itemView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, YBWidth, with * 3.5)];
    _itemView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_itemView];
    
    NSArray *nameItem = @[@"顺风车",@"出租车",@"路况直播",@"拼车接单",@"车主互帮",@"汽车服务",@"公益行动",@"我的红包"];
    
    for (int i = 0; i < nameItem.count; i ++) {
        
        NSInteger row = i % 4;
        NSInteger col = i / 4;
        
        YBUpDownButton *btn = [YBUpDownButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(row * with , col * with, with - 5, with - 5) title:nameItem[i] titleColor:[UIColor blackColor] titleFont:14 textAlignment:NSTextAlignmentCenter image:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",i + 1]] imageViewContentMode:UIViewContentModeScaleToFill handler:^(UIButton *sender) {
            [self clickButtonsAction:sender];
        }];
        btn.tag = i;
        [_itemView addSubview:btn];
    }
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, with * 2 + 10, YBWidth - 60, 30)];
    nameLabel.text = @"木星，你好";
    nameLabel.font = YBFont(16);
    [_itemView addSubview:nameLabel];
    
    UILabel *welcomLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, CGRectGetMaxY(nameLabel.frame) + 2, YBWidth - 60, 20)];
    welcomLabel.text = @"欢迎乘坐皕夶顺风车";
    welcomLabel.font = YBFont(13);
    [_itemView addSubview:welcomLabel];
    
    UIButton *issueButton = [[UIButton alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(welcomLabel.frame) + 5, YBWidth - 60, 40)];
    issueButton.layer.cornerRadius = 5;
    issueButton.clipsToBounds = YES;
    [issueButton setTitle:@"发布行程" forState:UIControlStateNormal];
    [issueButton setBackgroundColor:BtnBlueColor];
    [issueButton addTarget:self action:@selector(releaseMap) forControlEvents:UIControlEventTouchUpInside];
    [_itemView addSubview:issueButton];
    
}

- (void)clickButtonsAction:(UIButton *)sender {
    if (sender.tag == 0) {//顺风车
        YBTakeWindmillViewController *ytake = [[YBTakeWindmillViewController alloc] init];
        [self.navigationController pushViewController:ytake animated:YES];
    }
    else if (sender.tag == 1) {//出租车
        YBTaxiViewController *taxi = [[YBTaxiViewController alloc] init];
        [self.navigationController pushViewController:taxi animated:YES];
    }
    else if (sender.tag == 2){//路况直播
        YBRoadTestVC *traffic = [[YBRoadTestVC alloc] init];
        [self.navigationController pushViewController:traffic animated:YES];
    }
    else if (sender.tag == 3) {//拼车接单
        YBCarpoolOrdersVC *carpool = [[YBCarpoolOrdersVC alloc] init];
        [self.navigationController pushViewController:carpool animated:YES];
    }
    else if (sender.tag == 4) {//车主互帮
        YBOwnersHelpVC *help = [[YBOwnersHelpVC alloc] init];
        [self.navigationController pushViewController:help animated:YES];
    }
    else if (sender.tag == 5) {//汽车服务
        YBCarServicesVC *car = [[YBCarServicesVC alloc] init];
        [self.navigationController pushViewController:car animated:YES];
    }
    else if (sender.tag == 6) {//公益行动
        YBPublicActionVC *pub = [[YBPublicActionVC alloc] init];
        [self.navigationController pushViewController:pub animated:YES];
    }
    else if (sender.tag == 7) {//我的红包
        YBRedEnvelopesViewController *redEnvelope = [[YBRedEnvelopesViewController alloc] init];
        [self.navigationController pushViewController:redEnvelope animated:YES];
    }
}

- (void)releaseMap {
    YBOnTheTrainVC *map = [[YBOnTheTrainVC alloc] init];
    [self.navigationController pushViewController:map animated:YES];
}
- (void)msgClick {
    //YBMessageViewController *message = [[YBMessageViewController alloc] init];
    YBConversationListVC *message = [[YBConversationListVC alloc] init];
    [self.navigationController pushViewController:message animated:YES];
}

- (void)profileCenter {
    
    if ([YBUserDefaults boolForKey:@"isLogin"]) {
        
        [[self slideMenuController] showMenu];
        return;
    }
    
    YBLogInViewController *login = [[YBLogInViewController alloc] init];
    [self.navigationController pushViewController:login animated:YES];
}

- (void)setupNav {
    
    self.title = @"皕夶指路";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:YBFont(18), NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    //左边按钮
    UIButton *profileButton = [[UIButton alloc] init];
    // 设置按钮的背景图片
    [profileButton setImage:[UIImage imageNamed:@"个人中心"] forState:UIControlStateNormal];
    // 设置按钮的尺寸为背景图片的尺寸
    profileButton.frame = CGRectMake(0, 0, 20, 20);
    //监听按钮的点击
    [profileButton addTarget:self action:@selector(profileCenter) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:profileButton];;
    
    // 右边按钮
    UIButton *searchButton = [[UIButton alloc] init];
    [searchButton setImage:[UIImage imageNamed:@"消息中心"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(msgClick) forControlEvents:UIControlEventTouchUpInside];
    searchButton.frame = CGRectMake(0, 0, 20, 20);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    
    [searchButton addSubview:self.msgValue];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(msgClick)];
    [self.msgValue addGestureRecognizer:tap];
    
    NSString *userID = [YBUserDefaults valueForKey:_userId];
    if (userID) {
        [self initWithlocService];
    }
}

- (void)initWithlocService
{
    YZLocationManager *manager = [YZLocationManager sharedLocationManager];
    manager.isBackGroundLocation = YES;
    manager.locationInterval = 10;
    [manager setYZBackGroundLocationHander:^(CLLocationCoordinate2D coordinate) {
//        _plc(coordinate);
//        NSLog(@">>>>>>>>>>>>>%f,,%f",coordinate.latitude,coordinate.longitude);
        //起点位置信息
        NSMutableDictionary *dict = [YBTooler dictinitWithMD5];;
        
        NSString *userID = [YBUserDefaults valueForKey:_userId];
        dict[@"userid"] = userID;
        [dict setObject:[NSString stringWithFormat:@"%f",coordinate.longitude] forKey:@"lng"];
        [dict setObject:[NSString stringWithFormat:@"%f",coordinate.latitude] forKey:@"lat"];
        
//        NSLog(@"dict - %@",dict);
        [YBUserDefaults setObject:dict forKey:@"currentLocation"];
        [YBUserDefaults synchronize];
        [self uploadCurrentLocationWith:dict];
    }];
    
    [manager startLocationService];
}

- (void)uploadCurrentLocationWith:(NSMutableDictionary *)location
{
    [PPNetworkHelper POST:TaxiSaveLocation parameters:location success:^(id responseObject) {
//        NSLog(@"current - %@",responseObject);
    } failure:^(NSError *error) {

    }];
}
#pragma mark YBReceiveMsgValue
-(void)receiveMessage:(RCMessage *)message MsgValue:(NSInteger)MsgValue{
    
    //    YBTaxiHelpMessage *helpMessage = (YBTaxiHelpMessage *)message.content;
    //    NSLog(@"message - - %@",helpMessage.StartAddress);
    [self updateMsgValue];
}
-(void)updateMsgValue{
    NSInteger unreadMsgCount = (NSInteger)[[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION),@(ConversationType_GROUP),@(ConversationType_CHATROOM)]];
    
    //YBLog(@"unreadMsgCount==%ld",unreadMsgCount);
    WEAK_SELF;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (unreadMsgCount == 0) {
            weakSelf.msgValue.text = nil;
            weakSelf.msgValue.hidden = YES;
        }else{
            weakSelf.msgValue.text = [NSString stringWithFormat:@"%ld",unreadMsgCount];
            weakSelf.msgValue.hidden = NO;
        }
    });
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
