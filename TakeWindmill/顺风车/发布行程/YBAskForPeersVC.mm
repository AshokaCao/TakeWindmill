          //
//  YBAskForPeersVC.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/15.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBAskForPeersVC.h"
#import "YBComplaintDriverVC.h"
#import "YBEvaluationDriverVC.h"

#import "YBWaitingView.h"
#import "YBThanksFee.h"
#import "YBThanksTheFee.h"
#import "RouteAnnotation.h"
#import "SelectedListView.h"


@interface YBPayView ()

/**
 * 提示
 */
@property (nonatomic, weak) UILabel *promptLabel;

/**
 * 价格
 */
@property (nonatomic, weak) UILabel *priceLabel;

/**
 * 车费
 */
@property (nonatomic, weak) UILabel *fareLabel;

/**
 * 微信icon
 */
@property (nonatomic, weak) UIImageView *weChatImageView;
@property (nonatomic, weak) UILabel *weChatLabel;
@property (nonatomic, weak) UIButton *weChatBtn;

/**
 * 支付宝icon
 */
@property (nonatomic, weak) UIImageView *alipayImageView;
@property (nonatomic, weak) UILabel *alipayLabel;
@property (nonatomic, weak) UIButton *alipayBtn;

//选中按钮
@property (nonatomic, weak) UIButton *selectedBtn;

/**
 * 支付按钮
 */
@property (nonatomic, weak) UIButton *payButton;

@end

@implementation YBPayView

- (UILabel *)promptLabel
{
    if (!_promptLabel) {
        UILabel *promptLabel      = [[UILabel alloc] init];
        promptLabel.text          = @"确认上车需预付车费到平台,平台将在2小时内到达车主账户";
        promptLabel.font          = YBFont(14);
        promptLabel.textAlignment = NSTextAlignmentCenter;
        promptLabel.textColor = [UIColor grayColor];
        [self addSubview:promptLabel];
        
        _promptLabel = promptLabel;
    }
    return _promptLabel;
}

- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        UILabel *priceLabel       = [[UILabel alloc] init];
        priceLabel.font           = YBFont(14);
        priceLabel.textAlignment  = NSTextAlignmentCenter;
        [self addSubview:priceLabel];
        
        _priceLabel               = priceLabel;
    }
    return _priceLabel;
}

- (UILabel *)fareLabel
{
    if (!_fareLabel) {
        UILabel *fareLabel      = [[UILabel alloc] init];
        fareLabel.font          = YBFont(14);
        fareLabel.text          = @"车费合计";
        fareLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:fareLabel];
        
        _fareLabel = fareLabel;
    }
    return _fareLabel;
}

- (UIImageView *)weChatImageView
{
    if (!_weChatImageView) {
        UIImageView *weChatImageView = [[UIImageView alloc] init];
        weChatImageView.image        = [UIImage imageNamed:@"icon_weixin"];
        [self addSubview:weChatImageView];
        _weChatImageView             = weChatImageView;
    }
    return _weChatImageView;
}

- (UILabel *)weChatLabel
{
    if (!_weChatLabel) {
        UILabel *weChatLabel      = [[UILabel alloc] init];
        weChatLabel.font          = YBFont(14);
        weChatLabel.text          = @"微信支付";
        [self addSubview:weChatLabel];
        
        _weChatLabel = weChatLabel;
    }
    return _weChatLabel;
}

- (UIButton *)weChatBtn
{
    if (!_weChatBtn) {
        UIButton *weChatBtn       = [[UIButton alloc] init];
        weChatBtn.tag             = 1001;
        weChatBtn.selected        = YES;
        [weChatBtn setImage:[UIImage imageNamed:@"灰色打钩"] forState:UIControlStateNormal];
        [weChatBtn setImage:[UIImage imageNamed:@"蓝色打钩"] forState:UIControlStateSelected];
        [weChatBtn addTarget:self action:@selector(PayButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:weChatBtn];

        _weChatBtn = weChatBtn;
    }
    return _weChatBtn;
}

- (UIImageView *)alipayImageView
{
    if (!_alipayImageView) {
        UIImageView *alipayImageView = [[UIImageView alloc] init];
        alipayImageView.image        = [UIImage imageNamed:@"icon_zfb"];
        [self addSubview:alipayImageView];
        _alipayImageView = alipayImageView;
    }
    return _alipayImageView;
}

- (UILabel *)alipayLabel
{
    if (!_alipayLabel) {
        UILabel *alipayLabel      = [[UILabel alloc] init];
        alipayLabel.font          = YBFont(14);
        alipayLabel.text          = @"支付宝支付";
        [self addSubview:alipayLabel];
        _alipayLabel = alipayLabel;
    }
    return _alipayLabel;
}

- (UIButton *)alipayBtn
{
    if (!_alipayBtn) {
        UIButton *alipayBtn       = [[UIButton alloc] init];
        alipayBtn.tag             = 1002;
        [alipayBtn setImage:[UIImage imageNamed:@"灰色打钩"] forState:UIControlStateNormal];
        [alipayBtn setImage:[UIImage imageNamed:@"蓝色打钩"] forState:UIControlStateSelected];
        [alipayBtn addTarget:self action:@selector(PayButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:alipayBtn];
        _alipayBtn = alipayBtn;
    }
    return _alipayBtn;
}

- (UIButton *)selectedBtn
{
    if (!_selectedBtn) {
        UIButton *btn = [[UIButton alloc] init];
        [self addSubview:btn];
        _selectedBtn = btn;
    }
    return _selectedBtn;
}

- (UIButton *)payButton
{
    if (!_payButton) {
        UIButton *payButton          = [[UIButton alloc] init];
        payButton.layer.cornerRadius = 5;
        [payButton setBackgroundColor:BtnBlueColor];
        [payButton addTarget:self action:@selector(confirmPaymentButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:payButton];
        _payButton = payButton;
    }
    return _payButton;
}

- (void)pay
{
    self.promptLabel.frame = CGRectMake(10, 10, YBWidth - 20, 40);
    self.priceLabel.frame  = CGRectMake(0, CGRectGetMaxY(self.promptLabel.frame) + 5, YBWidth, 40);
    //价格
    NSString *str1 = [NSString stringWithFormat:@"共%@元",self.priceStr];
    YBLog(@"%ld",str1.length - 2);
    NSMutableAttributedString *priceStr = [YBTooler labelThreeFontsAllWords:str1 oneFont:13 oneSubscript:0 oneLength:1 twoFont:28 twoSubscript:1 twoLength:str1.length - 2  threeFont:13 threeSubscript:str1.length - 1 threeLength:1];
    [self.priceLabel setAttributedText:priceStr];
    
    self.fareLabel.frame = CGRectMake(0, CGRectGetMaxY(self.priceLabel.frame), YBWidth, 20);
    
    self.weChatImageView.frame = CGRectMake(30, CGRectGetMaxY(self.fareLabel.frame) + 30, 20, 20);
    self.weChatLabel.frame     = CGRectMake(CGRectGetMaxX(self.weChatImageView.frame) + 5, self.weChatImageView.frame.origin.y, 100, 20);
    self.weChatBtn.frame = CGRectMake(YBWidth - 50, self.weChatImageView.frame.origin.y, 20, 20);
    self.selectedBtn = self.weChatBtn;
    
    self.alipayImageView.frame = CGRectMake(30, CGRectGetMaxY(self.weChatImageView.frame) + 10, 20, 20);
    self.alipayLabel.frame     = CGRectMake(CGRectGetMaxX(self.alipayImageView.frame) + 5, self.alipayImageView.frame.origin.y, 100, 20);
    self.alipayBtn.frame       = CGRectMake(YBWidth - 50, self.alipayLabel.frame.origin.y, 20, 20);
    
    self.payButton.frame = CGRectMake(10, CGRectGetMaxY(self.alipayBtn.frame) + 20, self.frame.size.width - 20, 40);
    [self.payButton setTitle:[NSString stringWithFormat:@"确认上车,预付%@元",self.priceStr] forState:UIControlStateNormal];
    
    self.frame = CGRectMake(0, 0, YBWidth, CGRectGetMaxY(self.payButton.frame) + 10);
}

#pragma mark - 支付按钮
- (void)PayButtonAction:(UIButton *)sender
{
    if (sender != self.selectedBtn) {
        self.selectedBtn.selected = NO;
        sender.selected = YES;
        self.selectedBtn = sender;
    }else{
        self.selectedBtn.selected = YES;
    }
}

#pragma mark - 确认支付按钮
- (void)confirmPaymentButtonAction
{
    if (_payButtonBlock) {
        _payButtonBlock(self.selectedBtn);
    }
}

@end

@interface YBAskForPeersVC ()<BMKRouteSearchDelegate>

//线路规划搜搜
@property (nonatomic, strong) BMKRouteSearch *routeSearch;

/**
 * 请他接我信息
 */
@property (nonatomic, weak) YBWaitingView *waitingView;

/**
 * 乘客的行程
 */
@property (nonatomic, strong) NSDictionary *passengerDict;

/**
 * 司机的行程
 */
@property (nonatomic, strong) NSDictionary *driverDict;

/**
 * 第几段路线路
 */
@property (nonatomic, assign) NSInteger lineColor;

@end

@implementation YBAskForPeersVC

- (YBWaitingView *)waitingView
{
    if (!_waitingView) {
        YBWaitingView *waiting  = [[YBWaitingView alloc] initWithFrame:CGRectMake(5, YBHeight - 230, YBWidth - 10, 210)];
        waiting.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:waiting];
        
        __weak typeof(self) weakSelf = self;
        
        //点击请他接我
        waiting.clickeBlock = ^(UIButton *sender) {
            YBLog(@"%ld",sender.tag);
            if (sender.tag == 0) {//请他接我
                [weakSelf confirmTheInvitation:sender btnStr:@"确认邀请"];
            }
            else if (sender.tag == 1) {//点击确认上车并付费
                [weakSelf confirmTheCarAndPay:self.passengerDict[@"TravelCost"]];
            }
            else if (sender.tag == 2) {//点击确认到达
                [weakSelf makeSureToReachTheEnd];
            }
        };
        
        //展开后的按钮
        waiting.moreBottomView.selectBtn = ^(UIButton *sender) {
            if (sender.tag == 1) {//感谢费
                [weakSelf confirmTheInvitation:nil btnStr:@"增加感谢费"];
            }
            else if (sender.tag == 2) {//联系客服
                [weakSelf phoneButtonAction];
            }
            else if (sender.tag == 3) {//更多
                SelectedListView *view = [[SelectedListView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), 0) style:UITableViewStylePlain];
                
                view.isSingle = YES;
                
                view.array = @[[[SelectedListModel alloc] initWithSid:0 Title:@"需要帮助"] ,
                               [[SelectedListModel alloc] initWithSid:1 Title:@"投诉"]];
                
                view.selectedBlock = ^(NSArray<SelectedListModel *> *array) {
                    [LEEAlert closeWithCompletionBlock:^{
                        if (array[0].sid == 0) {
                            
                        }
                        else {//投诉
                            YBComplaintDriverVC *driverVC = [[YBComplaintDriverVC alloc] init];
                            driverVC.driverDict           = self.driverDict;
                            [self.navigationController pushViewController:driverVC animated:YES];
                        }
                    }];
                };
                
                [LEEAlert actionsheet].config
//                .LeeTitle(@"举报内容问题")
                .LeeItemInsets(UIEdgeInsetsMake(20, 0, 20, 0))
                .LeeAddCustomView(^(LEECustomView *custom) {
                    
                    custom.view = view;
                    
                    custom.isAutoWidth = YES;
                })
                .LeeItemInsets(UIEdgeInsetsMake(0, 0, 0, 0))
                .LeeAddAction(^(LEEAction *action) {
                    
                    action.title = @"关闭";
                    
                    action.titleColor = [UIColor blackColor];
                    
                    action.backgroundColor = [UIColor whiteColor];
                })
                .LeeHeaderInsets(UIEdgeInsetsMake(10, 0, 0, 0))
                .LeeHeaderColor([UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1.0f])
                .LeeActionSheetBottomMargin(0.0f) // 设置底部距离屏幕的边距为0
                .LeeCornerRadius(0.0f) // 设置圆角曲率为0
                .LeeConfigMaxWidth(^CGFloat(LEEScreenOrientationType type) {
                    
                    // 这是最大宽度为屏幕宽度 (横屏和竖屏)
                    
                    return CGRectGetWidth([[UIScreen mainScreen] bounds]);
                })
                .LeeShow();
            }
            
        };
        
        [waiting.formationView.phoneButton addTarget:self action:@selector(phoneButtonAction) forControlEvents:UIControlEventTouchUpInside];
        _waitingView = waiting;
    }
    return _waitingView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"请他接我";

    //请求乘客行程信息
    [self networkRequestPassengerTravel];
}

- (void)dealloc
{
    _routeSearch.delegate = nil;
}


#pragma mark - 点击电话
- (void)phoneButtonAction
{
    [YBTooler dialThePhoneNumber:@"10086" displayView:self.view];
}

#pragma mark - 邀请乘客行程信息
- (void)networkRequestPassengerTravel
{
    _passengerDict = [NSDictionary dictionary];
    
    NSString *urlStr          = travelinfodetailbysysnoPath;
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    [dict setObject:self.TravelSysNo forKey:@"travelsysno"];
    [dict setObject:[YBTooler getTheUserId:self.view] forKey:@"userid"];
    
    [YBRequest postWithURL:urlStr MutableDict:dict View:self.waitingView success:^(id dataArray) {
        YBLog(@"乘客本人行程信息%@",dataArray);
        _passengerDict = dataArray;
        //请求司机信息
        [self networkRequest];
    } failure:^(id dataArray) {
        YBLog(@"%@",dataArray);
    }];
}

#pragma mark - 司机订单详情
- (void)networkRequest
{
    NSString *urlStr          = travelinfodriverdetailPath;
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    [dict setObject:self.SysNo forKey:@"travelsysno"];
    [dict setObject:self.driverUserId forKey:@"userid"];
    
    [YBRequest postWithURL:urlStr MutableDict:dict success:^(id dataArray) {
//        YBLog(@"司机行程信息%@",dataArray);
        //订单详情
        self.driverDict = dataArray;
        //view 内容显示
        [self.waitingView passengerPriceWithDict:self.passengerDict driverDict:dataArray];

        _routeSearch = [[BMKRouteSearch alloc]init];
        _routeSearch.delegate = self;
        
        //分三段显示总路径
        //第一段 司机起点&&乘客起点
        CLLocationCoordinate2D start = CLLocationCoordinate2DMake([dataArray[@"StartLat"] doubleValue], [dataArray[@"StartLng"] doubleValue]);
        CLLocationCoordinate2D end = CLLocationCoordinate2DMake([self.passengerDict[@"StartLat"] doubleValue], [self.passengerDict[@"StartLng"] doubleValue]);
        self.lineColor = 1;
        [self openMapViewStartCityName:dataArray[@"StartCity"] startPT:start endCityName:self.passengerDict[@"StartCity"] endPT:end];
    } failure:^(id dataArray) {
        YBLog(@"查询司机信息失败%@",dataArray);
    }];
}

#pragma Mark - 增加感谢费 刷新金额
- (void)refreshThePrice
{
    NSString *urlStr          = travelinfodetailbysysnoPath;
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    [dict setObject:self.TravelSysNo forKey:@"travelsysno"];
    [dict setObject:[YBTooler getTheUserId:self.view] forKey:@"userid"];
    
    [YBRequest postWithURL:urlStr MutableDict:dict View:self.waitingView success:^(id dataArray) {
        YBLog(@"乘客本人行程信息%@",dataArray);
        _passengerDict = dataArray;
        [self.waitingView refreshThePriceDict:dataArray];
    } failure:^(id dataArray) {
        YBLog(@"%@",dataArray);
    }];
}

#pragma Mark - 确认到达
- (void)makeSureToReachTheEnd
{
    NSString *urlStr = passangerarrivetoendPath;
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    [dict setObject:self.passengerDict[@"SysNo"] forKey:@"passengertravelsysno"];//乘客行程SysNo
    [dict setObject:self.driverDict[@"UserId"] forKey:@"driveruserid"];//司机Id
    
    [YBRequest postWithURL:urlStr MutableDict:dict View:self.view success:^(id dataArray) {
        YBLog(@"完成跳转评价页面%@",dataArray);
        YBEvaluationDriverVC *evaluation = [[YBEvaluationDriverVC alloc] init];
        evaluation.driverDict            = self.driverDict;
        [self.navigationController pushViewController:evaluation animated:YES];
    } failure:^(id dataArray) {
        
    }];
    
}


#pragma mark - 点击确认上车并付费
- (void)confirmTheCarAndPay:(NSString *)str
{
    YBPayView *payView = [[YBPayView alloc] initWithFrame:CGRectMake(0, 0, YBWidth, 200)];
    payView.priceStr = self.passengerDict[@"TravelCost"];
    [payView pay];
    payView.payButtonBlock = ^(UIButton *sender) {
        YBLog(@"%ld----",sender.tag);
        if (sender.tag == 1001) { // 微信支付
            YBLog(@"选择了微信支付");
        }
        else if (sender.tag == 1002) {//支付宝
            YBLog(@"选择了支付宝支付");
        }

        __weak typeof(self) weakSelf = self;
        [LEEAlert closeWithCompletionBlock:^{
            self.title = @"行程中";
            [weakSelf.waitingView duringTheTrip];
        }];
    };
    
    [LEEAlert actionsheet].config
    .LeeTitle(@"确认上车并付费")
    .LeeCustomView(payView)
    .LeeActionSheetBottomMargin(0.0f) // 设置底部距离屏幕的边距为0
    .LeeCornerRadius(0.0f) // 设置圆角曲率为0
    .LeeWindowLevel(2)
    .LeeHeaderInsets(UIEdgeInsetsMake(10, 0, 0, 0))
    .LeeItemInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeClickBackgroundClose(YES)
    .LeeConfigMaxWidth(^CGFloat(LEEScreenOrientationType type) {
        return YBWidth;
    })
    .LeeShow();
}

#pragma mark - 请他接我
- (void)confirmTheInvitation:(UIButton *)sender btnStr:(NSString *)btnStr
{
    UIView *bgView                   = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBWidth, YBHeight / 1.7)];
    bgView.backgroundColor           = LightGreyColor;
    
    YBOrderAddressDetails *orderView = [[YBOrderAddressDetails alloc] initWithFrame:CGRectMake(0, 0, YBWidth, 100)];
    [orderView confirmTheItinerary];
    [orderView confirmTheItineraryDict:self.passengerDict];
    [bgView addSubview:orderView];
    
    UIView *informationView         = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(orderView.frame) + 2, YBWidth, 60)];
    informationView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:informationView];
    
    UILabel *lable                  = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, YBWidth, 20)];
    lable.text                      = @"车主需要延后1小时30分钟开接你";
    lable.font                      = YBFont(14);
    [informationView addSubview:lable];
    
    UILabel *label1                 = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(lable.frame), YBWidth, 20)];
    label1.text                     = @"单独给车主加感谢费，车主更愿意来接你";
    label1.font                     = YBFont(14);
    [informationView addSubview:label1];
    
    YBThanksFee *thanke             = [[YBThanksFee alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(informationView.frame) , YBWidth, 120)];
    thanke.backgroundColor          = [UIColor whiteColor];
    thanke.moneyArray               = @[@"0元",@"5元",@"10元",@"15元"];
    [thanke.determineBtn setTitle:btnStr forState:UIControlStateNormal];
    
    __weak typeof(thanke) weakThanke = thanke;
    __weak typeof(self) weakSelf = self;

    //点击其他按钮调用方法
    thanke.selectedBlock = ^(UIButton *sender) {
        
    };

    //点击确认邀请
    thanke.selectDetermine = ^(UIButton *sender) {
        
        if (weakThanke.selectedBtn.titleLabel.text) {//没有选择增加感谢费
//            YBLog(@"%ld %@",weakThanke.selectedBtn.tag,weakThanke.selectedBtn.titleLabel.text);
            NSArray *feeArray = [weakThanke.selectedBtn.titleLabel.text componentsSeparatedByString:@"元"];
            
            NSString *urlStr = travelcostaddgratitudefeePath;
            NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
            [dict setObject:self.passengerDict[@"SysNo"] forKey:@"travelsysno"];
            [dict setObject:[YBTooler getTheUserId:self.view] forKey:@"userid"];
            [dict setObject:feeArray[0] forKey:@"gratitudefee"];

            [YBRequest postWithURL:urlStr MutableDict:dict success:^(id dataArray) {
                YBLog(@"%@",dataArray);
                [LEEAlert closeWithCompletionBlock:^{
                    if ([weakThanke.determineBtn.titleLabel.text isEqualToString:@"增加感谢费"]) {
                        [weakSelf refreshThePrice];
                    }
                    else {
                        self.title = @"待上车";
                        sender.tag ++;
                        [weakSelf.waitingView passenger_PleaseTakeHim];
                    }
                }];
            } failure:^(id dataArray) {
            }];
        }
    };
    [bgView addSubview:thanke];
    bgView.frame = CGRectMake(0, 0, YBWidth, CGRectGetMaxY(thanke.frame) + 10);

    [LEEAlert actionsheet].config
    .LeeTitle(@"请确认你的行程")
    .LeeCustomView(bgView)
    .LeeActionSheetBottomMargin(0.0f) // 设置底部距离屏幕的边距为0
    .LeeCornerRadius(0.0f) // 设置圆角曲率为0
    .LeeWindowLevel(2)
    .LeeHeaderInsets(UIEdgeInsetsMake(10, 0, 0, 0))
    .LeeItemInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeClickBackgroundClose(YES)
    .LeeConfigMaxWidth(^CGFloat(LEEScreenOrientationType type) {
        return YBWidth;
    })
    .LeeShow();
    
}

#pragma mark - 发起线路规划
- (void)openMapViewStartCityName:(NSString *)cityName startPT:(CLLocationCoordinate2D)startPt endCityName:(NSString *)city endPT:(CLLocationCoordinate2D)endPt
{
    //发起检索
    BMKPlanNode* start = [[BMKPlanNode alloc]init] ;
    start.cityName = cityName;
    start.pt = startPt;

    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.cityName = city;
    end.pt = endPt;

    BMKDrivingRoutePlanOption *driveRouteSearchOption =[[BMKDrivingRoutePlanOption alloc]init];
    driveRouteSearchOption.from = start;
    driveRouteSearchOption.to = end;

    BOOL flag = [_routeSearch drivingSearch:driveRouteSearchOption];
    if (flag) {
        YBLog(@"查询成功");
    }
    else {
        YBLog(@"查询失败");
    }
}

- (void)onGetDrivingRouteResult:(BMKRouteSearch *)searcher result:(BMKDrivingRouteResult *)result errorCode:(BMKSearchErrorCode)error
{
//    NSArray* array = [NSArray arrayWithArray:self.mapView.annotations];
//    [self.mapView removeAnnotations:array];
//
//    array = [NSArray arrayWithArray:self.mapView.overlays];
//    [self.mapView removeOverlays:array];

    if (error == BMK_SEARCH_NO_ERROR) {
    
        BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i == 0 && self.lineColor == 1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [self.mapView addAnnotation:item]; // 添加起点标注
            }
            if(i == size-1 && self.lineColor == 3){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [self.mapView addAnnotation:item]; // 添加终点标注
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [self.mapView addAnnotation:item];

            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        // 添加途经点
        if (plan.wayPoints) {
            for (BMKPlanNode* tempNode in plan.wayPoints) {
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item = [[RouteAnnotation alloc]init];
                item.coordinate = tempNode.pt;
                item.type = 5;
                item.title = tempNode.name;
                [self.mapView addAnnotation:item];
            }
        }
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }

        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [self.mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    }
}

#pragma mark 根据overlay生成对应的View
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        if (self.lineColor == 2) {
            polylineView.strokeColor = BtnBlueColor;
        }
        else{
            polylineView.strokeColor = RGBA(187, 255, 255, 1);
        }
        polylineView.lineWidth = 5.0;
        
        //调用第二段
        if (self.lineColor == 1) {
            //第二段 乘客起点&&乘客终点
            CLLocationCoordinate2D start1 = CLLocationCoordinate2DMake([self.passengerDict[@"StartLat"] doubleValue], [self.passengerDict[@"StartLng"] doubleValue]);
            CLLocationCoordinate2D end1 = CLLocationCoordinate2DMake([self.passengerDict[@"EndLat"] doubleValue], [self.passengerDict[@"EndLng"] doubleValue]);
            self.lineColor = 2;
            [self openMapViewStartCityName:self.passengerDict[@"StartCity"] startPT:start1 endCityName:self.passengerDict[@"EndCity"] endPT:end1];
        }
        else if (self.lineColor == 2) {
            //第三段 乘客终点&&司机终点
            CLLocationCoordinate2D start2 = CLLocationCoordinate2DMake([self.passengerDict[@"EndLat"] doubleValue], [self.passengerDict[@"EndLng"] doubleValue]);
            CLLocationCoordinate2D end2 = CLLocationCoordinate2DMake([self.driverDict[@"EndLat"] doubleValue], [self.driverDict[@"EndLng"] doubleValue]);
            self.lineColor = 3;
            [self openMapViewStartCityName:self.passengerDict[@"EndCity"] startPT:start2 endCityName:self.driverDict[@"EndCity"] endPT:end2];
        }
        
        return polylineView;
    }
    return nil;
}

- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[RouteAnnotation class]]) {
        return [(RouteAnnotation*)annotation getRouteAnnotationView:view];
    }
    return nil;
}

#pragma mark  根据polyline设置地图范围
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat ltX, ltY, rbX, rbY;

    if (polyLine.pointCount < 1) return;
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;

    for (int i = 0; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [self.mapView setVisibleMapRect:rect];
    self.mapView.zoomLevel = self.mapView.zoomLevel - 1.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - 司机的行程
//- (void)DriversTripDcit:(NSDictionary *)dreverDit PassengerDict:(NSDictionary *)passDict
//{
//    //    _routeSearch = [[BMKRouteSearch alloc]init];
//    //    _routeSearch.delegate = self;
//
//    CLLocationCoordinate2D start1 = CLLocationCoordinate2DMake([dreverDit[@"StartLat"] doubleValue], [dreverDit[@"StartLng"] doubleValue]);
//    CLLocationCoordinate2D end1 = CLLocationCoordinate2DMake([dreverDit[@"EndLat"] doubleValue], [dreverDit[@"EndLng"] doubleValue]);
//    //发起检索
//    //起点
//    BMKPlanNode* start = [[BMKPlanNode alloc]init] ;
//    start.cityName = dreverDit[@"StartCity"];
//    start.pt = start1;
//    //终点
//    BMKPlanNode* end = [[BMKPlanNode alloc]init];
//    end.cityName = dreverDit[@"EndCity"];
//    end.pt = end1;
//
//    CLLocationCoordinate2D start2 = CLLocationCoordinate2DMake([passDict[@"StartLat"] doubleValue], [passDict[@"StartLng"] doubleValue]);
//    CLLocationCoordinate2D end2 = CLLocationCoordinate2DMake([passDict[@"EndLat"] doubleValue], [passDict[@"EndLng"] doubleValue]);
//    //途经点 乘客起点
//    NSMutableArray * array                 = [[NSMutableArray alloc] initWithCapacity:10];
//    BMKPlanNode* wayPointItem1             = [[BMKPlanNode alloc]init];
//    wayPointItem1.cityName                 = passDict[@"StartCity"];
//    wayPointItem1.pt                       = start2;
//    [array addObject:wayPointItem1];
//
//    //乘客终点
//    BMKPlanNode* wayPointItem2        = [[BMKPlanNode alloc]init];
//    wayPointItem2.cityName            = passDict[@"EndCity"];
//    wayPointItem2.pt                  = end2;
//    [array addObject:wayPointItem2];
//
//    BMKDrivingRoutePlanOption *driveRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
//    driveRouteSearchOption.from                       = start;
//    driveRouteSearchOption.to                         = end;
//    driveRouteSearchOption.wayPointsArray             = array;
//
//
//    BOOL flag = [_routeSearch drivingSearch:driveRouteSearchOption];
//    if (flag) {
//        YBLog(@"查询成功");
//    }
//    else {
//        YBLog(@"查询失败");
//    }
//}

@end
