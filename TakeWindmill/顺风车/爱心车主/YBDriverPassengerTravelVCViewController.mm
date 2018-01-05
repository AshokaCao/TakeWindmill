//
//  YBDriverPassengerTravelVCViewController.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/12/28.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBDriverPassengerTravelVCViewController.h"
#import "YBPassengerCanBeBuiltVC.h"
#import "YBEvaluationPassengersVC.h"
#import "YBTakeWindmillViewController.h"
#import "YBComplaintDriverVC.h"

#import "BNRoutePlanModel.h"
#import "BNCoreServices.h"
#import "BNaviModel.h"

#import "YBWaitingView.h"
#import "YBThanksFee.h"
#import "YBThanksTheFee.h"
#import "RouteAnnotation.h"
#import "SelectedListView.h"

@interface YBDriverPassengerTravelVCViewController ()<BMKRouteSearchDelegate,BNNaviRoutePlanDelegate,BNNaviUIManagerDelegate>

/**
 * 乘客一View
 */
@property (nonatomic, weak) UIView *passengerView1;

/**
 * 乘客二View
 */
@property (nonatomic, weak) UIView *passengerView2;

/**
 * 线路规划搜索
 */
@property (nonatomic, strong) BMKRouteSearch *routeSearch;

/**
 * 请他接我信息
 */
@property (nonatomic, weak) YBWaitingView *waitingView;

/**
 * 司机绑定乘客行程信息
 */
@property (nonatomic, strong) NSArray *passengerArray;

/**
 * 司机的行程
 */
@property (nonatomic, strong) NSDictionary *driverDict;

/**
 * 线路颜色
 */
@property (nonatomic, copy) NSString *lineColor;

/**
 * 导航栏按钮
 */
@property (nonatomic, strong) UIView *navigationView;

@end

@implementation YBDriverPassengerTravelVCViewController

#pragma mark - lazy
- (UIView *)navigationView
{
    if (!_navigationView) {
        _navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBWidth / 2, 44)];
    }
    return _navigationView;
}

- (UIView *)passengerView1
{
    if (!_passengerView1) {
        UIView *view                = [UIView new];
        view.tag                    = 0;
        view.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(passengerView1Tap:)];
        [view addGestureRecognizer:viewTap];
        
        UIImageView *passengerImage  = [[UIImageView alloc] init];
        passengerImage.layer.cornerRadius = 17;
        passengerImage.layer.masksToBounds = YES;
        [passengerImage sd_setImageWithURL:self.passengerArray[0][@"HeadImgUrl"] placeholderImage:[UIImage imageNamed:@"小草"]];
        [view addSubview:passengerImage];
        
        [passengerImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view);
            make.left.equalTo(view).with.offset(5);
            make.right.equalTo(view).with.offset(-5);
            make.bottom.equalTo(view).with.offset(-10);
        }];
        
        UILabel *passengerLabel         = [UILabel new];
        passengerLabel.text             = @"乘客一";
        passengerLabel.font             = YBFont(10);
        passengerLabel.textAlignment    = NSTextAlignmentCenter;
//        passengerLabel.textColor = [UIColor grayColor];
        [view addSubview:passengerLabel];
        
        [passengerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(passengerImage.mas_bottom);
            make.bottom.equalTo(view.mas_bottom);
            make.left.equalTo(view.mas_left);
            make.width.equalTo(view);
        }];
        
        [self.navigationView addSubview:view];
        _passengerView1 = view;
    }
    return _passengerView1;
}

- (UIView *)passengerView2
{
    if (!_passengerView2) {
        UIView *view                = [[UIView alloc] init];
        view.tag                    = 1;
        view.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(passengerView2Tap:)];
        [view addGestureRecognizer:viewTap];
        
        UIImageView *passengerImage  = [UIImageView new];
        passengerImage.layer.cornerRadius  = 17;
        passengerImage.layer.masksToBounds = YES;
        [passengerImage sd_setImageWithURL:self.passengerArray[0][@"HeadImgUrl"] placeholderImage:[UIImage imageNamed:@"小草"]];
        [view addSubview:passengerImage];
        
        [passengerImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view);
            make.left.equalTo(view).with.offset(5);
            make.right.equalTo(view).with.offset(-5);
            make.bottom.equalTo(view).with.offset(-10);
        }];
        
        UILabel *passengerLabel = [UILabel new];
        passengerLabel.text     = @"乘客二";
        passengerLabel.font     = YBFont(10);
        passengerLabel.textAlignment    = NSTextAlignmentCenter;
        [view addSubview:passengerLabel];
        
        [passengerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(passengerImage.mas_bottom);
            make.bottom.equalTo(view.mas_bottom);
            make.left.equalTo(view.mas_left);
            make.width.equalTo(view);
        }];
        
        [self.navigationView addSubview:view];
        _passengerView2 = view;
    }
    return _passengerView2;
}

- (YBWaitingView *)waitingView
{
    if (!_waitingView) {
        YBWaitingView *waiting  = [[YBWaitingView alloc] initWithFrame:CGRectMake(5, YBHeight - 280, YBWidth - 10, 220)];
        waiting.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:waiting];
        
        WEAK_SELF;
//        __weak __typeof__(waiting) waitingS = waiting;
        //点击接我按钮
        waiting.clickeBlock = ^(UIButton *sender) {
            if (sender.tag == 1) {//点击到达乘客起点
                [weakSelf travelStepsAreUpdated:sender];
            }
            else if (sender.tag == 2 ) {//点击接到乘客
                [LEEAlert alert].config
                .LeeTitle(@"提示")
                .LeeContent(@"请确认乘客已上车!")
                .LeeCancelAction(@"取消", ^{
                    // 取消点击事件Block
                })
                .LeeAction(@"确认", ^{
                    //改变乘客信息
                    [weakSelf travelStepsAreUpdated:sender];
                    if (weakSelf.passengerArray.count > 1) {//两个乘客
                        NSInteger current = weakSelf.currentPassenger == 0 ? 1 : 0;
                        [weakSelf DriversTripDcit:weakSelf.passengerArray[weakSelf.currentPassenger] PassengerDict:weakSelf.passengerArray[current]];
                    }
                    else {
                        [weakSelf DriversTripDcit:weakSelf.passengerArray[weakSelf.currentPassenger] PassengerDict:nil];
                    }
                    
                })
                .LeeShow();
            }
            else if (sender.tag == 3){//点击到达目的地
                [LEEAlert alert].config
                .LeeTitle(@"提示")
                .LeeContent(@"请确认乘客已下车!")
                .LeeCancelAction(@"取消", ^{
                    // 取消点击事件Block
                })
                .LeeAction(@"确认", ^{
                    [weakSelf.waitingView passengerTravel_ConfirmPeer:sender.tag];
                })
                .LeeShow();
            }
            else if (sender.tag == 4) {//点击去评价
                YBEvaluationPassengersVC *ebalu = [[YBEvaluationPassengersVC alloc] init];
                ebalu.passengerDict             = weakSelf.passengerArray[weakSelf.currentPassenger];
                [self.navigationController pushViewController:ebalu animated:YES];
            }
            else if (sender.tag == -1) {//取消行程后
                [self returnToPage];
            }
        };
        
        //导航
        waiting.moreBottomView.selectBtn = ^(UIButton *sender) {
            if (sender.tag == 1) {//导航
                [weakSelf realNavi];//开始导航
            }
            if (sender.tag == 2) {//取消行程
                
                [LEEAlert alert].config
                .LeeTitle(@"提示")
                .LeeContent(@"是否取消行程?")
                .LeeCancelAction(@"取消", ^{
                    // 取消点击事件Block
                })
                .LeeAction(@"确定", ^{
                    [weakSelf cancelTheTrip];
                })
                .LeeShow();
            }
            if (sender.tag == 3) {//更多
                [self moreHelp];
            }
        };
        
        //给车主打电话
        [waiting.formationView.phoneButton addTarget:self action:@selector(phoneButtonActoin:) forControlEvents:UIControlEventTouchUpInside];
        _waitingView = waiting;
    }
    return _waitingView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //请求当前数据
    [self requestCurrentPageData];
    
    [BNCoreServices_Location startUpdate];
}

- (void)dealloc
{
    _routeSearch.delegate = nil;
}

#pragma mark - 请求当前页面数据
- (void)requestCurrentPageData
{
    WEAK_SELF;
    [MBProgressHUD showOnlyLoadToView:self.view];
    //创建信号量
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    //创建全局并行
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    
    //请求一
    dispatch_group_async(group, queue, ^{
        //请求司机信息
        [weakSelf networkRequest:semaphore];
    });
    //请求二
    dispatch_group_async(group, queue, ^{
        //司机绑定乘客行程信息
        [weakSelf passengertravelinfolistbydriver:semaphore];
    });
    //总
    dispatch_group_notify(group, queue, ^{
        // 四个请求对应四次信号等待
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        //在这里 进行请求后的方法，回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:weakSelf.view];
            //初始化界面
            [weakSelf initializationInterface];
            //显示乘客的信息
            [weakSelf.waitingView driverPassengerTravel:weakSelf.passengerArray[weakSelf.currentPassenger]];
            //显示乘客信息
            [weakSelf passengerInformationIsDisplayedFrame];
            [weakSelf passengerInformationIsDisplayed];
            //线路规划
            if ([weakSelf.passengerArray[weakSelf.currentPassenger][@"StatName"] isEqualToString:@"行程已发"] || [weakSelf.passengerArray[weakSelf.currentPassenger][@"StatName"] isEqualToString:@"司机已到达乘客上车点"]) {
                if (weakSelf.passengerArray.count > 1) {//两个乘客
                    NSInteger current = weakSelf.currentPassenger == 0 ? 1 : 0;
                    [weakSelf driverPickUpPassengersVia:weakSelf.passengerArray[current] end:weakSelf.passengerArray[weakSelf.currentPassenger]];
                }else {
                    [weakSelf driverPickUpPassengersVia:nil end:weakSelf.passengerArray[weakSelf.currentPassenger]];
                }
            }
            else if ([weakSelf.passengerArray[weakSelf.currentPassenger][@"StatName"] isEqualToString:@"乘客已上车"]) {
                if ( weakSelf.passengerArray.count > 1) {//两个乘客
                    NSInteger current = weakSelf.currentPassenger == 0 ? 1 : 0;
                    [self DriversTripDcit:weakSelf.passengerArray[weakSelf.currentPassenger] PassengerDict:weakSelf.passengerArray[current]];
                }else {
                    [self DriversTripDcit:weakSelf.passengerArray[weakSelf.currentPassenger] PassengerDict:nil];
                }
            }
        });
    });
}

#pragma Mark - 初始化界面
- (void)initializationInterface
{
    UIButton *leftButton         = [[UIButton alloc] initWithFrame:CGRectMake(-10, 0, 10, 20)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"箭头2"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(returnToTheWindmill:) forControlEvents:UIControlEventTouchUpInside];
   
    self.navigationItem.titleView                   = self.navigationView;
    self.navigationItem.leftBarButtonItem           = nil;
    self.navigationItem.leftBarButtonItem           = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    WEAK_SELF;
    //乘客一
    [self.passengerView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.centerY.mas_equalTo(weakSelf.navigationView.mas_centerY);
        make.left.equalTo(weakSelf.navigationView.mas_left).with.offset(20);
        make.top.equalTo(weakSelf.navigationView.mas_top);
        make.bottom.equalTo(weakSelf.navigationView.mas_bottom);
        make.width.equalTo(weakSelf.navigationView.mas_height);
    }];
    
    //乘客二
    [self.passengerView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.passengerView1);
        make.left.equalTo(weakSelf.passengerView1.mas_right).with.offset(20);
        make.top.equalTo(weakSelf.navigationView);
    }];
}

#pragma mark - 取消行程
- (void)cancelTheTrip
{
    WEAK_SELF;
    NSString *urlStr = travelinfodrivercancelPath;
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    [dict setObject:[YBTooler getTheUserId:weakSelf.view] forKey:@"userid"];//用户id
    [dict setObject:weakSelf.SysNo forKey:@"travelsysno"];//行程id
    
    [YBRequest postWithURL:urlStr MutableDict:dict View:weakSelf.view success:^(id dataArray) {
        // 确认点击事件Block
        [weakSelf.waitingView passengerTravel_ConfirmPeer:-1];
    } failure:^(id dataArray) {
        [MBProgressHUD showError:@"取消失败" toView:weakSelf.view];
        //        YBLog(@"%@",dataArray);
    }];
}

#pragma mark - 显示乘客信息farme
- (void)passengerInformationIsDisplayedFrame
{
    WEAK_SELF;
    
    if ([weakSelf.passengerArray[weakSelf.currentPassenger][@"StatName"] isEqualToString:@"行程已发"] || [weakSelf.passengerArray[weakSelf.currentPassenger][@"StatName"] isEqualToString:@"司机已到达乘客上车点"] || [weakSelf.passengerArray[weakSelf.currentPassenger][@"StatName"] isEqualToString:@"乘客已上车"] || [weakSelf.passengerArray[weakSelf.currentPassenger][@"StatName"] isEqualToString:@"乘客已到达目的地"] || [weakSelf.passengerArray[weakSelf.currentPassenger][@"StatName"] isEqualToString:@"行程已完结"]) {
        [weakSelf.waitingView passengerTravel_ConfirmPeerFrame:1];
    }
   
    else if ([weakSelf.passengerArray[weakSelf.currentPassenger][@"StatName"] isEqualToString:@"行程已取消"]) {
        [weakSelf.waitingView passengerTravel_ConfirmPeerFrame:-1];
    }
}

#pragma mark - 显示乘客信息
- (void)passengerInformationIsDisplayed
{
    WEAK_SELF;
    if ([weakSelf.passengerArray[weakSelf.currentPassenger][@"StatName"] isEqualToString:@"行程已发"]) {
        [weakSelf.waitingView passengerTravel_ConfirmPeer:1];
    }
    else if ([weakSelf.passengerArray[weakSelf.currentPassenger][@"StatName"] isEqualToString:@"司机已到达乘客上车点"]) {
        [weakSelf.waitingView passengerTravel_ConfirmPeer:2];
    }
    else if ([weakSelf.passengerArray[weakSelf.currentPassenger][@"StatName"] isEqualToString:@"乘客已上车"]) {
        [weakSelf.waitingView passengerTravel_ConfirmPeer:3];
    }
    else if ([weakSelf.passengerArray[weakSelf.currentPassenger][@"StatName"] isEqualToString:@"乘客已到达目的地"]) {
        [weakSelf.waitingView passengerTravel_ConfirmPeer:4];
    }
    else if ([weakSelf.passengerArray[weakSelf.currentPassenger][@"StatName"] isEqualToString:@"行程已完结"]) {
        [weakSelf.waitingView passengerTravel_ConfirmPeer:4];
    }
    else if ([weakSelf.passengerArray[weakSelf.currentPassenger][@"StatName"] isEqualToString:@"行程已取消"]) {
        [weakSelf.waitingView passengerTravel_ConfirmPeer:-1];
    }
    
}

#pragma mark - 点击乘客一
- (void)passengerView1Tap:(id)tap
{
    self.currentPassenger = 0;
    [self.waitingView changeheCurrentDisplayInformation:self.passengerArray[self.currentPassenger]];
    [self passengerInformationIsDisplayed];
    if ([self.passengerArray[self.currentPassenger][@"StatName"] isEqualToString:@"行程已发"] || [self.passengerArray[self.currentPassenger][@"StatName"] isEqualToString:@"司机已到达乘客上车点"]) {
        if (self.passengerArray.count > 1) {
            [self driverPickUpPassengersVia:self.passengerArray[1] end:self.passengerArray[self.currentPassenger]];
        }
        else {
            [self driverPickUpPassengersVia:nil end:self.passengerArray[self.currentPassenger]];
        }
    }
    else if ([self.passengerArray[self.currentPassenger][@"StatName"] isEqualToString:@"乘客已上车"]) {
            [self DriversTripDcit:self.passengerArray[self.currentPassenger] PassengerDict:self.passengerArray.count > 1 ? self.passengerArray[1] : nil];
    }

}

#pragma mark - 点击乘客二
- (void)passengerView2Tap:(id)tap
{
    self.currentPassenger = 1;
    [self.waitingView changeheCurrentDisplayInformation:self.passengerArray[self.currentPassenger]];
    [self passengerInformationIsDisplayed];
    if ([self.passengerArray[self.currentPassenger][@"StatName"] isEqualToString:@"行程已发"] || [self.passengerArray[self.currentPassenger][@"StatName"] isEqualToString:@"司机已到达乘客上车点"]) {
        [self driverPickUpPassengersVia:self.passengerArray[0] end:self.passengerArray[self.currentPassenger]];
    }
    else if ([self.passengerArray[self.currentPassenger][@"StatName"] isEqualToString:@"乘客已上车"]) {
        [self DriversTripDcit:self.passengerArray[self.currentPassenger] PassengerDict:self.passengerArray[0]];
    }

}

//真实GPS导航
- (void)realNavi
{
    if (![self checkServicesInited]) return;
    [self startNavi];
}

#pragma mark - 初始化百度地图引擎
- (BOOL)checkServicesInited
{
    if(![BNCoreServices_Instance isServicesInited])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"引擎尚未初始化完成，请稍后再试"
                                                           delegate:nil
                                                  cancelButtonTitle:@"我知道了"
                                                  otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    return YES;
}

#pragma mark - 更多
- (void)moreHelp
{
    WEAK_SELF;
    SelectedListView *view = [[SelectedListView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), 0) style:UITableViewStylePlain];
    
    view.isSingle = YES;
    
    view.array = @[[[SelectedListModel alloc] initWithSid:0 Title:@"投诉"],
                   [[SelectedListModel alloc] initWithSid:1 Title:@"解绑当前乘客"],
                   [[SelectedListModel alloc] initWithSid:2 Title:@"紧急求助"]];
    
    view.selectedBlock = ^(NSArray<SelectedListModel *> *array) {
        [LEEAlert closeWithCompletionBlock:^{
            if (array[0].sid == 0) {//投诉
                YBComplaintDriverVC *driverVC = [[YBComplaintDriverVC alloc] init];
                driverVC.driverDict           = weakSelf.driverDict;
                [weakSelf.navigationController pushViewController:driverVC animated:YES];
            }
            if (array[0].sid == 1) {//解绑当前乘客
                [weakSelf unblockTheCurrentPassenger];
            }
            if (array[0].sid == 2) {//紧急求助
                [YBTooler dialThePhoneNumber:@"400820880" displayView:weakSelf.view];
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

#pragma mark - 返回
- (void)returnToTheWindmill:(UIButton *)sender
{
    [LEEAlert alert].config
    .LeeTitle(@"提示")
    .LeeContent(@"订单未完成是否要退出?")
    .LeeCancelAction(@"取消", ^{
        // 取消点击事件Block
    })
    .LeeAction(@"确认退出", ^{
        [self returnToPage];
    })
    .LeeShow();
}

- (void)returnToPage
{
    // 确认点击事件Block
    NSArray *temArray = self.navigationController.viewControllers;
    for(UIViewController *temVC in temArray)
    {
        if ([temVC isKindOfClass:[YBTakeWindmillViewController class]])
        {
            [self.navigationController popToViewController:temVC animated:YES];
        }
    }
}

#pragma mark - 给乘客打电话
- (void)phoneButtonActoin:(UIButton *)sender {
    [YBTooler dialThePhoneNumber:self.passengerArray[self.currentPassenger][@"Mobile"] displayView:self.view];
}

#pragma mark - 乘客行程步骤更新
- (void)travelStepsAreUpdated:(UIButton *)sender
{
    WEAK_SELF;
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    [dict setObject:[NSString stringWithFormat:@"%ld",sender.tag] forKey:@"steptype"];//类型
    [dict setObject:self.passengerArray[self.currentPassenger][@"SysNo"] forKey:@"travelsysno"];//行程sysno
    [dict setObject:[NSString stringWithFormat:@"%f",weakSelf.positionUserLocation.location.coordinate.longitude] forKey:@"currentlng"];//当前位置经纬度
    [dict setObject:[NSString stringWithFormat:@"%f",weakSelf.positionUserLocation.location.coordinate.latitude] forKey:@"currentlat"];//当前位置经纬度

    [YBRequest postWithURL:travelinfostepupdatePath MutableDict:dict View:self.waitingView success:^(id dataArray) {
        YBLog(@"乘客行程步骤更新%@",dataArray);
        sender.tag ++;
        [weakSelf.waitingView passengerTravel_ConfirmPeer:sender.tag];
        [weakSelf passengertravelinfolistbydriver:nil];
    } failure:^(id dataArray) {
        YBLog(@"%@",dataArray);
    }];
}

#pragma mark - 解绑当前乘客
- (void)unblockTheCurrentPassenger
{
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    [dict setObject:self.passengerArray[self.currentPassenger][@"SysNo"] forKey:@"travelsysno"];
    
    [YBRequest postWithURL:drivercancelpassengertravelPath MutableDict:dict View:self.waitingView success:^(id dataArray) {
        YBLog(@"解绑当前乘客%@",dataArray);
        [self.waitingView passengerTravel_ConfirmPeer:-1];
    } failure:^(id dataArray) {
        YBLog(@"%@",dataArray);
    }];
}

#pragma mark - 司机绑定乘客行程信息
- (void)passengertravelinfolistbydriver:(id)semaphore
{
    WEAK_SELF;
    self.passengerArray = [NSArray array];
    NSString *urlStr          = passengertravelinfolistbydriverPath;
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    [dict setObject:[YBTooler getTheUserId:self.view] forKey:@"userid"];
    
    [YBRequest postWithURL:urlStr MutableDict:dict success:^(id dataArray) {
        YBLog(@"司机绑定乘客行程信息%@",dataArray);
        weakSelf.passengerArray = dataArray[@"TravelInfoList"];
        if (weakSelf.passengerArray.count == 1) {
            weakSelf.passengerView2.hidden = YES;
        }
        if (semaphore) {
            dispatch_semaphore_signal(semaphore);
        }
    } failure:^(id dataArray) {
        if (semaphore) {
            dispatch_semaphore_signal(semaphore);
        }
        YBLog(@"=======请求司机所绑定的乘客失败%@",dataArray);
    }];
    
}

#pragma mark - 司机行程
- (void)networkRequest:(id)semaphore
{
    WEAK_SELF;
    NSString *urlStr          = travelinfodriverdetailPath;
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    [dict setObject:self.SysNo forKey:@"travelsysno"];
    [dict setObject:[YBTooler getTheUserId:self.view] forKey:@"userid"];
    
    [YBRequest postWithURL:urlStr MutableDict:dict success:^(id dataArray) {
        YBLog(@"司机行程信息%@",dataArray);
        weakSelf.driverDict = dataArray;
        dispatch_semaphore_signal(semaphore);
    } failure:^(id dataArray) {
        dispatch_semaphore_signal(semaphore);
    }];
}

#pragma Mark- 导航起点终点
- (void)startNavi
{
    BOOL useMyLocation = NO;
    NSMutableArray *nodesArray = [[NSMutableArray alloc]initWithCapacity:2];
    //起点 传入的是原始的经纬度坐标，若使用的是百度地图坐标，可以使用BNTools类进行坐标转化
    CLLocation *myLocation = [BNCoreServices_Location getLastLocation];
    //发起检索
    BNRoutePlanNode *startNode = [[BNRoutePlanNode alloc] init];
    startNode.pos = [[BNPosition alloc] init];
    if (useMyLocation) {
        startNode.pos.x = myLocation.coordinate.longitude;
        startNode.pos.y = myLocation.coordinate.latitude;
        startNode.pos.eType = BNCoordinate_OriginalGPS;
    }
    else {
        startNode.pos.x = self.positionUserLocation.location.coordinate.longitude;
        startNode.pos.y = self.positionUserLocation.location.coordinate.latitude;
        startNode.pos.eType = BNCoordinate_BaiduMapSDK;
    }
    [nodesArray addObject:startNode];
    
    //也可以在此加入1到3个的途经点
//    BNRoutePlanNode *midNode = [[BNRoutePlanNode alloc] init];
//    midNode.pos = [[BNPosition alloc] init];
//    midNode.pos.x = 113.977004;
//    midNode.pos.y = 22.556393;
    //midNode.pos.eType = BNCoordinate_BaiduMapSDK;
    //    [nodesArray addObject:midNode];
    
    //终点
    BNRoutePlanNode *endNode = [[BNRoutePlanNode alloc] init];
    endNode.pos = [[BNPosition alloc] init];
    endNode.pos.x = [self.passengerArray[self.currentPassenger][@"EndLng"] doubleValue];
    endNode.pos.y = [self.passengerArray[self.currentPassenger][@"EndLat"] doubleValue];
    endNode.pos.eType = BNCoordinate_BaiduMapSDK;
    [nodesArray addObject:endNode];
    
    //关闭openURL,不想跳转百度地图可以设为YES
    [BNCoreServices_RoutePlan setDisableOpenUrl:YES];
    [BNCoreServices_RoutePlan startNaviRoutePlan:BNRoutePlanMode_Recommend naviNodes:nodesArray time:nil delegete:self userInfo:nil];
}

#pragma mark - BNNaviRoutePlanDelegate
//算路成功回调
-(void)routePlanDidFinished:(NSDictionary *)userInfo
{
    NSLog(@"算路成功");
    
    //路径规划成功，开始导航
    [BNCoreServices_UI showPage:BNaviUI_NormalNavi delegate:self extParams:nil];
    
    //导航中改变终点方法示例
    /*dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
     BNRoutePlanNode *endNode = [[BNRoutePlanNode alloc] init];
     endNode.pos = [[BNPosition alloc] init];
     endNode.pos.x = 114.189863;
     endNode.pos.y = 22.546236;
     endNode.pos.eType = BNCoordinate_BaiduMapSDK;
     [[BNaviModel getInstance] resetNaviEndPoint:endNode];
     });*/
}

//算路失败回调
- (void)routePlanDidFailedWithError:(NSError *)error andUserInfo:(NSDictionary*)userInfo
{
    switch ([error code]%10000)
    {
        case BNAVI_ROUTEPLAN_ERROR_LOCATIONFAILED:
            NSLog(@"暂时无法获取您的位置,请稍后重试");
            break;
        case BNAVI_ROUTEPLAN_ERROR_ROUTEPLANFAILED:
            NSLog(@"无法发起导航");
            break;
        case BNAVI_ROUTEPLAN_ERROR_LOCATIONSERVICECLOSED:
            NSLog(@"定位服务未开启,请到系统设置中打开定位服务。");
            break;
        case BNAVI_ROUTEPLAN_ERROR_NODESTOONEAR:
            NSLog(@"起终点距离起终点太近");
            break;
        default:
            NSLog(@"算路失败");
            break;
    }
}

//算路取消回调
-(void)routePlanDidUserCanceled:(NSDictionary*)userInfo
{
    NSLog(@"算路取消");
}

#pragma mark - 安静退出导航

- (void)exitNaviUI
{
    [BNCoreServices_UI exitPage:EN_BNavi_ExitTopVC animated:YES extraInfo:nil];
}

#pragma mark - BNNaviUIManagerDelegate

//退出导航页面回调
- (void)onExitPage:(BNaviUIType)pageType  extraInfo:(NSDictionary*)extraInfo
{
    if (pageType == BNaviUI_NormalNavi)
    {
        NSLog(@"退出导航");
    }
    else if (pageType == BNaviUI_Declaration)
    {
        NSLog(@"退出导航声明页面");
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


#pragma mark - 司机去接乘客线路规划
- (void)driverPickUpPassengersVia:(NSDictionary *)viaDict end:(NSDictionary *)endDict
{
    _routeSearch = [[BMKRouteSearch alloc]init];
    _routeSearch.delegate = self;

    //获取司机最后一次定位
    CLLocation *myLocation = [BNCoreServices_Location getLastLocation];
    
    //发起检索
    //起点
    BMKPlanNode* start = [[BMKPlanNode alloc]init] ;
    start.cityName = self.driverDict[@"StartCity"];
    if (!self.positionUserLocation.location) {
        CLLocationCoordinate2D start2D = CLLocationCoordinate2DMake(myLocation.coordinate.latitude, myLocation.coordinate.longitude);
        start.pt = start2D ;
    }else {
        CLLocationCoordinate2D start2D = CLLocationCoordinate2DMake(self.positionUserLocation.location.coordinate.latitude, self.positionUserLocation.location.coordinate.longitude);
        start.pt = start2D ;
    }
    
    //终点
    CLLocationCoordinate2D end2D = CLLocationCoordinate2DMake([endDict[@"StartLat"] doubleValue], [endDict[@"StartLng"] doubleValue]);
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.cityName = endDict[@"StartCity"];
    end.pt = end2D;
    
    BMKDrivingRoutePlanOption *driveRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
    driveRouteSearchOption.from                       = start;
    driveRouteSearchOption.to                         = end;
    
    if (viaDict) {
        //途径点
        CLLocationCoordinate2D via2D = CLLocationCoordinate2DMake([viaDict[@"StartLat"] doubleValue], [viaDict[@"StartLng"] doubleValue]);
        NSMutableArray * array                 = [[NSMutableArray alloc] initWithCapacity:10];
        BMKPlanNode* wayPointItem1             = [[BMKPlanNode alloc]init];
        wayPointItem1.cityName                 = viaDict[@"StartCity"];
        wayPointItem1.pt                       = via2D;
        [array addObject:wayPointItem1];
        driveRouteSearchOption.wayPointsArray             = array;
    }
    
    
    BOOL flag = [_routeSearch drivingSearch:driveRouteSearchOption];
    if (flag) {
        YBLog(@"查询成功");
    }
    else {
        YBLog(@"查询失败");
    }
}

#pragma mark - 司机与乘客的线路规划 / 乘客一乘客二
- (void)DriversTripDcit:(NSDictionary *)passDict PassengerDict:(NSDictionary *)passDict2
{
    _routeSearch = [[BMKRouteSearch alloc]init];
    _routeSearch.delegate = self;
    
    //获取司机最后一次定位
    CLLocation *myLocation = [BNCoreServices_Location getLastLocation];

    //发起检索
    //起点
    BMKPlanNode* start = [[BMKPlanNode alloc]init] ;
    start.cityName = passDict[@"StartCity"];
    if (!self.positionUserLocation.location) {
        CLLocationCoordinate2D start2D = CLLocationCoordinate2DMake(myLocation.coordinate.latitude, myLocation.coordinate.longitude);
        start.pt = start2D ;
    }else {
        CLLocationCoordinate2D start2D = CLLocationCoordinate2DMake(self.positionUserLocation.location.coordinate.latitude, self.positionUserLocation.location.coordinate.longitude);
        start.pt = start2D ;
    }
    
    //终点
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    //途经点
    BMKDrivingRoutePlanOption *driveRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];

    if (passDict2) {// 如果两个乘客
        CLLocationCoordinate2D end1 = CLLocationCoordinate2DMake([passDict2[@"EndLat"] doubleValue], [passDict2[@"EndLng"] doubleValue]);
        end.cityName = passDict2[@"EndCity"];
        end.pt = end1;
        
        CLLocationCoordinate2D start2 = CLLocationCoordinate2DMake([passDict[@"EndLat"] doubleValue], [passDict[@"EndLng"] doubleValue]);
        //途经点
        NSMutableArray * array                 = [[NSMutableArray alloc] initWithCapacity:10];
        BMKPlanNode* wayPointItem1             = [[BMKPlanNode alloc]init];
        wayPointItem1.cityName                 = passDict[@"EndCity"];
        wayPointItem1.pt                       = start2;
        [array addObject:wayPointItem1];
        
       
        driveRouteSearchOption.wayPointsArray             = array;
    }
    else {
        CLLocationCoordinate2D end1 = CLLocationCoordinate2DMake([passDict[@"EndLat"] doubleValue], [passDict[@"EndLng"] doubleValue]);
        end.cityName = passDict[@"EndCity"];
        end.pt = end1;
    }
    
    driveRouteSearchOption.from                       = start;
    driveRouteSearchOption.to                         = end;
    
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
    NSArray* array = [NSArray arrayWithArray:self.mapView.annotations];
    [self.mapView removeAnnotations:array];
    
    array = [NSArray arrayWithArray:self.mapView.overlays];
    [self.mapView removeOverlays:array];
    
    if (error == BMK_SEARCH_NO_ERROR) {
        
        BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i == 0){//起点
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [self.mapView addAnnotation:item]; // 添加起点标注
            }
            if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = [NSString stringWithFormat:@"乘客%d",self.currentPassenger + 1];
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
            
            //            NSLog(@"%@   %@    %@", transitStep.entraceInstruction, transitStep.exitInstruction, transitStep.instruction);
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
        if ([self.lineColor isEqualToString:@"乘客"]) {
            polylineView.strokeColor = RGBA(200, 224, 252, 1);
            self.lineColor = @"司机";
        }
        else {
            polylineView.strokeColor = BtnBlueColor;
            
        }
        polylineView.lineWidth = 5.0;
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
    self.mapView.zoomLevel = self.mapView.zoomLevel - 1.3;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


