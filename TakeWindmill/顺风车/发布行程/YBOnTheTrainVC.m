//
//  YBOnTheTrainVC.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/14.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "YBTravelTime.h"
#import "YBAboutButton.h"
#import "YBOnTheTrainVC.h"
#import "YBThanksTheFee.h"
#import "YBTravelRequest.h"
#import "YBOnTheTrainView.h"
#import "SelectedListView.h"

#import "YBThanksFee.h"
#import "YBWaitingOrdersVC.h"
#import "YBLogInViewController.h"
#import "YBMapPositionSelectionVC.h"
#import "YBAddressSearchSelectionVC.h"

#pragma mark - 价格View

@interface YBAmountMoney()
/**
 * 折扣
 */
@property (nonatomic, weak) UILabel *subTitleLabel;

/**
 * 价格
 */
@property (nonatomic, weak) UILabel *numberLabel;

@end

@implementation YBAmountMoney

- (UILabel *)numberLabel
{
    if (!_numberLabel) {
        UILabel *numberLabel        = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width,self.frame.size.height / 5 * 3)];
        numberLabel.text          = [NSString stringWithFormat:@"0元起"];
        numberLabel.textColor       = [UIColor blackColor];
        numberLabel.textAlignment   = NSTextAlignmentCenter;
        [self addSubview:numberLabel];
        _numberLabel = numberLabel;
    }
    return _numberLabel;
}

- (UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        UILabel *subTitleLabel      = [[UILabel alloc] init];
        subTitleLabel.text          = [NSString stringWithFormat:@"券已抵扣0元"];
        subTitleLabel.font          = YBFont(12);
        subTitleLabel.textColor     = [UIColor lightGrayColor];
        subTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:subTitleLabel];
        _subTitleLabel = subTitleLabel;
    }
    return _subTitleLabel;
}

- (void)setNumberStr:(NSString *)numberStr
{
    self.subTitleLabel.frame    = CGRectMake(0, CGRectGetMaxY(self.numberLabel.frame), self.frame.size.width, self.frame.size.height - _numberLabel.frame.size.height - 10);
    [self.numberLabel setAttributedText:[YBTooler changeLabelWithText:[NSString stringWithFormat:@"%.1f元起",[numberStr    floatValue]]]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundColor        = [UIColor whiteColor];
    self.layer.shadowOffset     = CGSizeMake(2, 2);
    self.layer.shadowRadius     = 0.5;
    self.layer.shadowColor      = [UIColor lightGrayColor].CGColor;
    self.layer.cornerRadius     = 1;
}

@end














@interface YBOnTheTrainVC ()<UIScrollViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKPoiSearchDelegate,BMKRouteSearchDelegate,YBMapPositionSelectionVCDelegate,YBAddressSearchSelectionVCDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;

/**
 * 搜索框
 */
@property (nonatomic, strong) YBOnTheTrainView *trainView;

/**
 * 费用计算
 */
@property (nonatomic, strong) YBAmountMoney *amountMoney;

/**
 * 拼车
 */
@property (nonatomic, strong) YBBaseView *carpoolView;

/**
 * 不拼车
 */
@property (nonatomic, strong) YBBaseView *notCarpoolView;

/**
 * 选择的标准时间
 */
@property (nonatomic, copy) NSString *standardTime;

/**
 * 最晚出发时间
 */
@property (nonatomic, copy) NSString *latestTime;

/**
 * 出行要求
 */
@property (nonatomic, strong) NSMutableArray *subscriptArray;

/**
 * 定位功能
 */
@property (nonatomic, strong) BMKLocationService *locService;

/**
 * 反地理编码
 */
@property (nonatomic, strong) BMKGeoCodeSearch *geocodesearch;

/**
 * 规划驾车路线
 */
@property (nonatomic, strong) BMKDrivingRouteLine *routeLine;

/**
 * POI搜索
 */
@property (nonatomic, strong) BMKPoiSearch *searcher;

/**
 * 线路规划
 */
@property (nonatomic, strong) BMKRouteSearch *routeSearch;

/**
 * 起点位置信息
 */
@property (nonatomic, strong) NSDictionary *startingPointDict;

/**
 * 终点位置信息
 */
@property (nonatomic, strong) NSDictionary *endPointDict;

/**
 * 是否拼车
 */
@property (nonatomic, assign) BOOL isCarpool;

@end

@implementation YBOnTheTrainVC

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, YBWidth, YBHeight)];
        scroll.delegate = self;
        scroll.showsVerticalScrollIndicator = NO;
        scroll.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:scroll];
        _scrollView = scroll;
    }
    return _scrollView;
}

#pragma mark - 出行要求
- (NSMutableArray *)subscriptArray
{
    if (!_subscriptArray) {
        _subscriptArray = [NSMutableArray array];
    }
    return _subscriptArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"确认上车点";
    self.view.backgroundColor = LineLightColor;
    
    //初始化View
    [self scrollViewUI];
    
    //开始定位
    [self initWithlocService];
    
    //通知
    [self notificationCenter];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //开启反地理编码
    _geocodesearch = [[BMKGeoCodeSearch alloc] init];
    _geocodesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _geocodesearch.delegate = nil;
    _routeSearch.delegate = nil;
    _locService.delegate = nil;
}

- (void)dealloc{
    NSLog(@"%s",__func__);

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"passengerSide_pointSelection" object:nil];//乘客端多界面传值
}

- (void)notificationCenter {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTheStartingPoint:) name:@"passengerSide_pointSelection" object:nil];
}

#pragma mark - 页面布局
- (void)scrollViewUI {
    
    //搜索
    self.trainView = [[YBOnTheTrainView alloc] initWithFrame:CGRectMake(5, 10, YBWidth - 10, 200)];
    self.trainView.backgroundColor = [UIColor whiteColor];
    self.trainView.layer.cornerRadius = 1;
    [self.scrollView addSubview:self.trainView];
    //设置阴影
    [YBTooler setTheControlShadow:self.trainView];
    
    __weak typeof(self) weakSelf = self;
    //点击了出行起点
    self.trainView.startingPointView.selectBlock = ^(YBBaseView *view) {
        YBMapPositionSelectionVC *selec = [[YBMapPositionSelectionVC alloc] init];
        selec.cityName = weakSelf.startingPointDict[@"City"];
        selec.delegate = weakSelf;
        [weakSelf presentViewController:selec animated:YES completion:nil];
    };
    
    //点击了出行终点
    self.trainView.endView.selectBlock = ^(YBBaseView *view) {
        
        if ([weakSelf.trainView.startingPointView.label.text isEqualToString:@"你在哪儿"]) {
            [MBProgressHUD showError:@"请完成起点位置选择" toView:self.view];
            return ;
        }
        
        YBAddressSearchSelectionVC *selec = [[YBAddressSearchSelectionVC alloc] init];
        selec.typesOf = @"终点";
        selec.addDelegate = weakSelf;
        if ([weakSelf.trainView.endView.label.text isEqualToString:@"你要去哪儿"]) {
            selec.cityname = weakSelf.startingPointDict[@"City"];
        }
        else {
            selec.cityname = [weakSelf.trainView.endView.label.text componentsSeparatedByString:@"·"][0];
        }
        [weakSelf presentViewController:selec animated:YES completion:nil];
    };
    
    //点击了跨城时间
    self.trainView.cityTimeView.startTime.selectBlock = ^(YBBaseView *view) {
        [weakSelf cityTravelTime:view];
    };
    self.trainView.cityTimeView.endTime.selectBlock = ^(YBBaseView *view) {
        [weakSelf TravelTime:view];
    };
    
    //点击了出行时间
    self.trainView.timeView.selectBlock = ^(YBBaseView *view) {
        [weakSelf TravelTime:view];
    };
    
    //点击了出行人数
    self.trainView.numberpeopleView.selectBlock = ^(YBBaseView *view) {
        [weakSelf numberPeopleAction:view];
    };
    
    //点击了感谢费
    self.trainView.fightView.selectBlock = ^(YBBaseView *view) {
        [weakSelf ThanksFee:view];
    };
    
    //点击了出行要求
    self.trainView.claimView.selectBlock = ^(YBBaseView *view) {
        [weakSelf TravelRequest:view];
    };
    
    //金额
    _amountMoney = [[YBAmountMoney alloc] initWithFrame:CGRectMake(5, YBHeight - 140, YBWidth - 10, 80)];
    _amountMoney.numberStr = @"0";
    [self.scrollView addSubview:_amountMoney];
    [YBTooler setTheControlShadow:_amountMoney];
    
    //发布按钮
    YBBaseButton *confirmRelease = [YBBaseButton buttonWithFrame:CGRectMake(5, CGRectGetMaxY(_amountMoney.frame) + 10, YBWidth - 10, 40) Strtitle:@"确认发布" titleColor:[UIColor whiteColor] titleFont:16 textAlignment:NSTextAlignmentCenter image:nil BackgroundColor:BtnBlueColor cornerRadius:3];
    
    [confirmRelease addTarget:self action:@selector(conformReleaseAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:confirmRelease];
    
    self.scrollView.contentSize = CGSizeMake(YBWidth, CGRectGetMaxY(confirmRelease.frame) + 10);
    
}

#pragma mark - 计算价格
- (void)routePlanningStarting:(CLLocationCoordinate2D)startting end:(CLLocationCoordinate2D)endting srartCityStr:(NSString *)cityStr endCity:(NSString *)endCity{

    // 开启线路规划
    _routeSearch = [[BMKRouteSearch alloc] init];
    _routeSearch.delegate = self;
    
    //构造公共交通路线规划检索信息类
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.pt = startting;
    start.cityName = cityStr;
    
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.pt = endting;
    end.cityName = endCity;
    
    BMKDrivingRoutePlanOption *option = [[BMKDrivingRoutePlanOption alloc]init];
    option.from = start;
    option.to = end;
    //发起检索
    BOOL flag = [self.routeSearch drivingSearch:option];
    if(flag) {
        YBLog(@"驾车交通检索（支持垮城）发送成功");
    } else {
        YBLog(@"驾车交通检索（支持垮城）发送失败");
    }
    
    if ([self.trainView.startingPointView.label.text isEqualToString:@"你在哪儿"]) {//起点位置未选择
        [MBProgressHUD showError:@"请输入起点位置" toView:self.view];
    }
    else {
        if ([self.endPointDict[@"City"] isEqualToString:self.startingPointDict[@"City"]]) {//相同城市
            if ([self.trainView.numberpeopleView.label.text isEqualToString:@"乘车人数"]) {
                [self numberPeopleAction:nil];
            }else {
                [self TravelTime:nil];
            }
        }else {
            [self.trainView CrossTheCity:YES];
            [self cityTravelTime:nil];
        }
    }

}

#pragma mark - 起点位置
- (void)setTheStartingPoint:(NSNotification *)notificatin {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.startingPointDict = [notificatin.userInfo objectForKey:@"startingPoint"];
        NSString *progress = [NSString stringWithFormat:@"%@·%@",self.startingPointDict[@"City"],self.startingPointDict[@"Name"]];
        [self.trainView.startingPointView initLabelStr:progress];

        if ([self.trainView.endView.label.text isEqualToString:@"你要去哪儿"]) {
            [MBProgressHUD showError:@"请输入终点位置" toView:self.view];
            return ;
        }
        else {
            [self priceLinePlanning:self.routeLine];
            
            CLLocationCoordinate2D startingPt = CLLocationCoordinate2DMake([self.startingPointDict[@"Lat"] doubleValue],[self.startingPointDict[@"Lng"] doubleValue]);
            CLLocationCoordinate2D endPt = CLLocationCoordinate2DMake([self.endPointDict[@"Lat"] doubleValue],[self.endPointDict[@"Lng"] doubleValue]);
            [self routePlanningStarting:startingPt end:endPt srartCityStr:self.startingPointDict[@"City"] endCity:self.endPointDict[@"City"]];

        }
        if ([self.trainView.numberpeopleView.label.text isEqualToString:@"乘车人数"]){
            [self numberPeopleAction:nil];
        }
    });
}

#pragma mark - 价格计算 没选人
- (void)priceLinePlanning:(BMKDrivingRouteLine *)text {
    
    [MBProgressHUD showOnlyLoadToView:self.amountMoney];
    //1.创建队列组
    dispatch_group_t group = dispatch_group_create();
    //2.创建队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_async(group,queue, ^{
        //不拼车
        NSString *URLStr = travelcostdownwindcalcPath;
        NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
        [dict setObject:[NSString stringWithFormat:@"%d",text.distance] forKey:@"mileage"];
        [dict setObject:self.startingPointDict[@"CityId"] forKey:@"startcityid"];
        [dict setObject:@"false" forKey:@"isjoin"];

        [YBRequest postWithURL:URLStr MutableDict:dict success:^(id dataArray) {
            YBLog(@"%@",dataArray[@"TravelCost"]);
            self.amountMoney.numberStr = dataArray[@"TravelCost"];
        } failure:^(id dataArray) {
        }];
        
    });
    
    //4.都完成后会自动通知
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.amountMoney];
    });
}

#pragma mark - 线路规划 拼车 OR 不拼车 计算价格
- (void)LinePlanning:(BMKDrivingRouteLine *)text numberPeople:(NSString *)number ThanksFee:(NSString *)fee{
    
    [MBProgressHUD showOnlyLoadToView:self.amountMoney];
    //1.创建队列组
    dispatch_group_t group = dispatch_group_create();
    //2.创建队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    for(UIView *view in [self.amountMoney subviews])
    {
        [view removeFromSuperview];
    }
    
    //拼座
    self.carpoolView = [[YBBaseView alloc] initWithFrame:CGRectMake(0, 0, self.amountMoney.frame.size.width /  2, self.amountMoney.frame.size.height)];
    [self.amountMoney addSubview:self.carpoolView];
    
    self.carpoolView.CanClick = YES;
    self.isCarpool            = YES;
    [self.carpoolView checkTheStatus:YES success:nil];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(self.amountMoney.frame.size.width /  2, 10, 1, self.amountMoney.frame.size.height - 20)];
    line.backgroundColor = LightGreyColor;
    [self.amountMoney addSubview:line];
    
    //不拼座
    self.notCarpoolView = [[YBBaseView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(line.frame), 0, self.amountMoney.frame.size.width /  2, self.amountMoney.frame.size.height)];
    [self.amountMoney addSubview:self.notCarpoolView];
    [self.notCarpoolView checkTheStatus:NO success:nil];

    
    __weak typeof(self.carpoolView) carpool= self.carpoolView;
    __weak typeof(self.notCarpoolView) notCarpool = self.notCarpoolView;
    __weak typeof(self) weakSelf = self;

    //3.多次使用队列组的方法执行任务, 只有异步方法
    dispatch_group_async(group,queue, ^{
        //拼车
        NSString *URLStr = travelcostdownwindcalcPath;
        NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
        [dict setObject:[NSString stringWithFormat:@"%d",text.distance] forKey:@"mileage"];//总路程距离(米)
        [dict setObject:self.startingPointDict[@"CityId"] forKey:@"startcityid"];//起点的城市id
        [dict setObject:@"true" forKey:@"isjoin"];//是否拼车
        [dict setObject:number forKey:@"peoplenumber"];//乘客人数
        [dict setObject:fee forKey:@"gratitudefee"];//感谢费金额
        
        self.carpoolView.selectBlock = ^(YBBaseView *view) {
            weakSelf.isCarpool = YES;
            [carpool checkTheStatus:YES success:nil];
            [notCarpool checkTheStatus:NO success:nil];
        };
        
        [YBRequest postWithURL:URLStr MutableDict:dict success:^(id dataArray) {
//            YBLog(@"%@",dataArray);
            [self.carpoolView ridePriceisIsFight:YES priceStr:[NSString stringWithFormat:@"%.1f元起",[dataArray[@"TravelCost"] floatValue]]];
        } failure:^(id dataArray) {
//            [MBProgressHUD showError:dataArray[@"ErrorMessage"] toView:self.amountMoney];
            YBLog(@"%@",dataArray);
        }];
    });
    
    dispatch_group_async(group,queue, ^{
        //不拼车
        NSString *URLStr = travelcostdownwindcalcPath;
        NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
        [dict setObject:[NSString stringWithFormat:@"%d",text.distance] forKey:@"mileage"];
        [dict setObject:self.startingPointDict[@"CityId"] forKey:@"startcityid"];
        [dict setObject:@"false" forKey:@"isjoin"];
        [dict setObject:number forKey:@"peoplenumber"];
        [dict setObject:fee forKey:@"gratitudefee"];

        self.notCarpoolView.selectBlock = ^(YBBaseView *view) {
            weakSelf.isCarpool = NO;
            [notCarpool checkTheStatus:YES success:nil];
            [carpool checkTheStatus:NO success:nil];
        };

        [YBRequest postWithURL:URLStr MutableDict:dict success:^(id dataArray) {
            [self.notCarpoolView ridePriceisIsFight:NO priceStr:[NSString stringWithFormat:@"%.1f元",[dataArray[@"TravelCost"] floatValue]]];
        } failure:^(id dataArray) {
            YBLog(@"%@",dataArray);
        }];
        
    });
    
    //4.都完成后会自动通知
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.amountMoney];
    });
}

- (void)initWithlocService
{
    //开启定位
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
}

- (void)conformReleaseAction:(UIButton *)sender {

    if (![self.trainView.startingPointView.label.text isEqualToString:@"你在哪儿"] && ![self.trainView.endView.label.text isEqualToString:@"你要去哪儿"] && ![self.trainView.numberpeopleView.label.text isEqualToString:@"乘车人数"]) {
        
        NSString *urlStr = travelinfosavePath;
        NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
        [dict setObject:[YBTooler getTheUserId:self.view] forKey:@"userid"];
        //起点信息
        [dict setObject:self.startingPointDict[@"Lng"] forKey:@"startlng"];
        [dict setObject:self.startingPointDict[@"Lat"] forKey:@"startlat"];
        [dict setObject:self.startingPointDict[@"City"] forKey:@"startcity"];
        [dict setObject:self.startingPointDict[@"Name"] forKey:@"startaddress"];
        [dict setObject:self.startingPointDict[@"CityId"] forKey:@"startcityid"];
        //终点信息
        [dict setObject:self.endPointDict[@"Lng"] forKey:@"endlng"];
        [dict setObject:self.endPointDict[@"Lat"] forKey:@"endlat"];
        [dict setObject:self.endPointDict[@"City"] forKey:@"endcity"];
        [dict setObject:self.endPointDict[@"Name"] forKey:@"endaddress"];
        [dict setObject:self.endPointDict[@"District"] forKey:@"endroad"];//街道名称
        [dict setObject:self.endPointDict[@"CityId"] forKey:@"endcityid"];
        //乘车信息
        //人数
        [dict setObject:[self.trainView.numberpeopleView.label.text componentsSeparatedByString:@"人"][0] forKey:@"peoplenumber"];
        //时间
        [dict setObject:self.standardTime forKey:@"setouttime"];
        if (self.latestTime) {
            [dict setObject:self.latestTime forKey:@"setouttimelate"];
        }
        NSString *mileage = [NSString stringWithFormat:@"%d",self.routeLine.distance];
        [dict setObject:mileage forKey:@"mileage"];
        //感谢费
        NSArray *gratitu = [self.trainView.fightView.label.text componentsSeparatedByString:@"元"];
        [dict setObject:gratitu[0] forKey:@"gratitudefee"];
        //要求
        NSString *str = [self.subscriptArray componentsJoinedByString:@","];
        [dict setObject:str forKey:@"note"];
        //是否跨域
        if ([self.startingPointDict[@"City"] isEqualToString:self.endPointDict[@"City"]]) {
            [dict setObject:@"true" forKey:@"isoverarea"];
        }else {
            [dict setObject:@"false" forKey:@"isoverarea"];
        }
        //是否拼座
        [dict setObject:self.isCarpool ? @"true" : @"false"  forKey:@"isjoin"];
        
        [YBRequest postWithURL:urlStr MutableDict:dict View:self.view success:^(id dataArray) {

            [MBProgressHUD showError:dataArray[@"StatName"] toView:self.view];
            YBWaitingOrdersVC *wang = [[YBWaitingOrdersVC alloc] init];
            wang.travelSysNo        = dataArray[@"SysNo"];
            [self.navigationController pushViewController:wang animated:YES];
        } failure:^(id dataArray) {
//            YBLog(@"提交失败：%@",dataArray);
            if ([dataArray[@"ErrorMessage"] isEqualToString:@"用户Id不能为空"]) {
                YBLogInViewController *login = [[YBLogInViewController alloc] init];
                [self.navigationController pushViewController:login animated:YES];
            }
            else {
                [MBProgressHUD showError:dataArray[@"ErrorMessage"] toView:self.view];
            }
        }];
    }else {
        [MBProgressHUD showError:@"请填写完整的行程信息" toView:self.view];
    }
}



#pragma mark - 跨城时间选择
- (void)cityTravelTime:(UIView *)view
{
    
    YBTravelTime *time = [[YBTravelTime alloc] initWithFrame:CGRectMake(0, 0, YBWidth, 300)];
    
    time.leftButtonStr = @"取消";
    time.rightButtonStr = @"下一步";
    time.deadStr = @"最早出发时间";
    
    time.selectBlock = ^(NSDictionary *dict) {
        _standardTime = dict[@"standardTime"];
        [self.trainView.cityTimeView.startTime initLabelStr:dict[@"displayTime"]];

        YBTravelTime *time = [[YBTravelTime alloc] initWithFrame:CGRectMake(0, 0, YBWidth, 300)];
        time.leftButtonStr = @"取消";
        time.rightButtonStr = @"确定";
        time.deadStr = @"最晚出发时间";

        time.selectBlock = ^(NSDictionary *dict) {
            [LEEAlert closeWithCompletionBlock:^{
                _latestTime = dict[@"standardTime"];
                [self.trainView.cityTimeView.endTime initLabelStr:dict[@"displayTime"]];
                if ([self.trainView.fightView.label.text isEqualToString:@"感谢费"]) {
                    [self numberPeopleAction:nil];
                }
            }];
        };

        [LEEAlert actionsheet].config
        .LeeCustomView(time)
        .LeeActionSheetBottomMargin(0.0f) // 设置底部距离屏幕的边距为0
        .LeeCornerRadius(0.0f) // 设置圆角曲率为0
        .LeeHeaderInsets(UIEdgeInsetsMake(10, 0, 0, 0))
        .LeeItemInsets(UIEdgeInsetsMake(0, 0, 0, 0))
        .LeeClickBackgroundClose(YES)
        .LeeConfigMaxWidth(^CGFloat(LEEScreenOrientationType type) {
            return YBWidth;
        })
        .LeeOpenAnimationStyle(LEEAnimationStyleOrientationRight | LEEAnimationStyleFade) //这里设置打开动画样式的方向为左 以及缩放效果.
        .LeeShow();
        
    };
    
    [LEEAlert actionsheet].config
    .LeeCustomView(time)
    .LeeActionSheetBottomMargin(0.0f) // 设置底部距离屏幕的边距为0
    .LeeCornerRadius(0.0f) // 设置圆角曲率为0
    .LeeHeaderInsets(UIEdgeInsetsMake(10, 0, 0, 0))
    .LeeItemInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeClickBackgroundClose(YES)
    .LeeConfigMaxWidth(^CGFloat(LEEScreenOrientationType type) {
        return YBWidth;
    })
    .LeeShow();
}

#pragma mark - 出行时间
- (void)TravelTime:(UIView *)view
{
    
    if ([self.trainView.startingPointView.label.text isEqualToString:@"你在哪儿"] || [self.trainView.endView.label.text isEqualToString:@"你要去哪儿"]) {
        [MBProgressHUD showError:@"请先选择起点与终点" toView:self.view];
        return;
    }

    YBTravelTime *time = [[YBTravelTime alloc] initWithFrame:CGRectMake(0, 0, YBWidth, 300)];
    time.leftButtonStr = @"取消";
    time.rightButtonStr = @"确定";
    if ([self.startingPointDict[@"City"] isEqualToString:self.endPointDict[@"City"]]) {
        time.deadStr = @"出发时间";
    }else {
        time.deadStr = @"最晚出发时间";
    }

    
    time.selectBlock = ^(NSDictionary *dict) {
        [LEEAlert closeWithCompletionBlock:^{
            self.standardTime = dict[@"standardTime"];

            if (![self.startingPointDict[@"City"] isEqualToString:self.endPointDict[@"City"]]) {//同城
                [self.trainView.cityTimeView.endTime initLabelStr:dict[@"displayTime"]];
                if ([self.trainView.numberpeopleView.label.text isEqualToString:@"乘车人数"]) {
                    [self numberPeopleAction:nil];
                }
                return ;
            }
            
            [self.trainView.timeView initLabelStr:dict[@"displayTime"]];
            if ([self.trainView.fightView.label.text isEqualToString:@"感谢费"]) {
                [self ThanksFee:nil];
                NSString *str1 = [self.trainView.numberpeopleView.label.text componentsSeparatedByString:@"人"][0];
                [self LinePlanning:self.routeLine numberPeople:str1 ThanksFee:@"0"];
            }
            else {
                NSString *str1 = [self.trainView.fightView.label.text componentsSeparatedByString:@"元"][0];
                NSString *str2 = [self.trainView.numberpeopleView.label.text componentsSeparatedByString:@"人"][0];
                [self LinePlanning:self.routeLine numberPeople:str2 ThanksFee:str1];
            }
        }];
    };
    
    time.cancelBlock = ^(UIButton *sender) {
        [LEEAlert closeWithCompletionBlock:nil];
    };
    [LEEAlert actionsheet].config
    .LeeCustomView(time)
    .LeeActionSheetBottomMargin(0.0f) // 设置底部距离屏幕的边距为0
    .LeeCornerRadius(0.0f) // 设置圆角曲率为0
    .LeeHeaderInsets(UIEdgeInsetsMake(10, 0, 0, 0))
    .LeeItemInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeClickBackgroundClose(YES)
    .LeeConfigMaxWidth(^CGFloat(LEEScreenOrientationType type) {
        return YBWidth;
    })
    .LeeShow();
}

#pragma mark - 出行要求
- (void)TravelRequest:(UIView *)view
{
    YBTravelRequest *request = [[YBTravelRequest alloc] initWithFrame:CGRectMake(0, 0, YBWidth, 160)];
    request.subscriptArray = self.subscriptArray;
    
    request.selectedConfirmBlock = ^(NSMutableArray *array) {
        [LEEAlert closeWithCompletionBlock:^{
            if (array.count != 0) {
                self.trainView.claimView.label.text =  @"已添加";
                self.subscriptArray = array;
            }
        }];
    };
    
    [LEEAlert actionsheet].config
    .LeeTitle(@"出行要求")
    .LeeCustomView(request)
    .LeeActionSheetBottomMargin(0.0f) // 设置底部距离屏幕的边距为0
    .LeeCornerRadius(0.0f) // 设置圆角曲率为0
    .LeeHeaderInsets(UIEdgeInsetsMake(10, 0, 0, 0))
    .LeeItemInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeClickBackgroundClose(YES)
    .LeeConfigMaxWidth(^CGFloat(LEEScreenOrientationType type) {
        return YBWidth;
    })
    .LeeClickBackgroundClose(YES)
    .LeeShow();
    
}

#pragma mark - 感谢费
- (void)ThanksFee:(UIView *)view
{
    
    YBThanksFee *thanke = [[YBThanksFee alloc] initWithFrame:CGRectMake(0, 0, YBWidth, 130)];
    thanke.moneyArray = @[@"5元",@"10元",@"15元",@"其他>"];
    thanke.selectedBlock = ^(UIButton *sender) {
        
        YBThanksTheFee *ther = [[YBThanksTheFee alloc] initWithFrame:CGRectMake(0, 0, YBWidth - 40, 60)];
        
        __weak typeof(ther) weakSelf = ther;
        [LEEAlert alert].config
        .LeeTitle(@"感谢费")
        .LeeWindowLevel(1)
        .LeeCustomView(ther)
        .LeeHeaderInsets(UIEdgeInsetsMake(10, 0, 0, 0))
        .LeeCornerRadius(5)
        .LeeItemInsets(UIEdgeInsetsMake(0, 0, 0, 0))
        .LeeClickBackgroundClose(YES)
        .LeeConfigMaxWidth(^CGFloat(LEEScreenOrientationType type) {
            return YBWidth - 40;
        })
        .LeeAddAction(^(LEEAction *action) {
            
            action.title = @"确定";
            action.titleColor = [UIColor grayColor];
            action.height = 45.0f;
            action.clickBlock = ^{
                if (![weakSelf.monyText.text isEqualToString:@""]) {
                    
                    if (![self.trainView.numberpeopleView.label.text isEqualToString:@"乘车人数"]) {
                        
                        self.trainView.fightView.label.text =  [NSString stringWithFormat:@"%@元",weakSelf.monyText.text];
                        [self LinePlanning:self.routeLine numberPeople:[self.trainView.numberpeopleView.label.text componentsSeparatedByString:@"人"][0] ThanksFee:weakSelf.monyText.text];
                    }
                    else if ([self.trainView.endView.label.text isEqualToString:@"你要去哪儿"]) {
                        [MBProgressHUD showError:@"请先选择出行终点" toView:self.view];
                    }
                    else {
                        [MBProgressHUD showError:@"请先选择出行人数" toView:self.view];
                    }
                }
            };
        })
        .LeeShow();
    };
    
    __weak typeof(thanke) weakSelf = thanke;
    thanke.selectDetermine = ^(UIButton *sender) {
        [LEEAlert closeWithCompletionBlock:^{
            if (weakSelf.selectedBtn.titleLabel.text) {
                
                if (![self.trainView.numberpeopleView.label.text isEqualToString:@"乘车人数"]) {
                    self.trainView.fightView.label.text =  weakSelf.selectedBtn.titleLabel.text;
                    NSString *str = [self.trainView.numberpeopleView.label.text componentsSeparatedByString:@"人"][0];
                    NSString *str1 = [weakSelf.selectedBtn.titleLabel.text componentsSeparatedByString:@"元"][0];
                    [self LinePlanning:self.routeLine numberPeople:str ThanksFee:str1];
                }
                else if ([self.trainView.endView.label.text isEqualToString:@"你要去哪儿"]) {
                    [MBProgressHUD showError:@"请先选择出行终点" toView:self.view];
                }
                else {
                    [MBProgressHUD showError:@"请先选择出行人数" toView:self.view];
                }

            }
        }];
    };
    
    [LEEAlert actionsheet].config
    .LeeTitle(@"感谢费")
    .LeeCustomView(thanke)
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

#pragma mark - 乘车人数
- (void)numberPeopleAction:(YBBaseView *)sender {
    
    SelectedListView *view = [[SelectedListView alloc] initWithFrame:CGRectMake(0, 0, YBWidth, 0) style:UITableViewStylePlain];
    view.isSingle = YES;
    view.array = @[[[SelectedListModel alloc] initWithSid:0 Title:@"1人"] ,
                   [[SelectedListModel alloc] initWithSid:1 Title:@"2人"] ,
                   [[SelectedListModel alloc] initWithSid:2 Title:@"3人"] ,
                   [[SelectedListModel alloc] initWithSid:3 Title:@"4人"]];
    view.selectedBlock = ^(NSArray<SelectedListModel *> *array) {
        
        [LEEAlert closeWithCompletionBlock:^{
            
            if ([self.trainView.endView.label.text isEqualToString:@"你要去哪儿"]) {
                [MBProgressHUD showError:@"请先选择出行终点" toView:self.view];
                return ;
            }
            if (![self.startingPointDict[@"City"] isEqualToString:self.endPointDict[@"City"]]) {//跨城
                [self ThanksFee:nil];
            }else if ([self.trainView.timeView.label.text isEqualToString:@"出发时间"] && [self.startingPointDict[@"City"] isEqualToString:self.endPointDict[@"City"]]) {//同城
                [self TravelTime:nil];
            }
            
            SelectedListModel *model                   = array[0];
            self.trainView.numberpeopleView.label.text = model.title;
        }];
        
    };
    [LEEAlert actionsheet].config
    .LeeTitle(@"乘车人数")
    .LeeCustomView(view)
    .LeeActionSheetBottomMargin(0.0f) // 设置底部距离屏幕的边距为0
    .LeeCornerRadius(0.0f) // 设置圆角曲率为0
    .LeeHeaderInsets(UIEdgeInsetsMake(10, 0, 0, 0))
    .LeeItemInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeClickBackgroundClose(YES)
    .LeeConfigMaxWidth(^CGFloat(LEEScreenOrientationType type) {
        return YBWidth;
    })
    .LeeShow();
    
}

#pragma mark - 地图选起点代理方法
- (void)popVCPassTheValue:(NSDictionary *)value
{
    dispatch_async(dispatch_get_main_queue(), ^{
    self.startingPointDict = value;
    [self.trainView.startingPointView initLabelStr:[NSString stringWithFormat:@"%@·%@",self.startingPointDict[@"City"],self.startingPointDict[@"Name"]]];
    
    if ([self.trainView.endView.label.text isEqualToString:@"你要去哪儿"]) {
        [MBProgressHUD showError:@"请输入终点位置" toView:self.view];
        return ;
    }
    else {
        
        [self priceLinePlanning:self.routeLine];
        
        CLLocationCoordinate2D startingPt = CLLocationCoordinate2DMake([value[@"Lat"] doubleValue],[value[@"Lng"] doubleValue]);
        CLLocationCoordinate2D endPt = CLLocationCoordinate2DMake([self.endPointDict[@"Lat"] doubleValue],[self.endPointDict[@"Lng"] doubleValue]);
        [self routePlanningStarting:startingPt end:endPt srartCityStr:value[@"City"] endCity:self.endPointDict[@"City"]];
    }
    if ([self.trainView.numberpeopleView.label.text isEqualToString:@"乘车人数"]){
        [self numberPeopleAction:nil];
    }
    });
}

#pragma mark - 关键字检索代理方法
- (void)popViewControllerPassTheValue:(NSDictionary *)value
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.endPointDict = value;//终点信息字典复制
        //终点位置显示
        NSString *progress = [NSString stringWithFormat:@"%@·%@",self.endPointDict[@"City"],self.endPointDict[@"Name"]];
        [self.trainView.endView initLabelStr:progress];
        
        //终点位置经纬度
        CLLocationCoordinate2D startingPt = CLLocationCoordinate2DMake([self.startingPointDict[@"Lat"] doubleValue],[self.startingPointDict[@"Lng"] doubleValue]);
        CLLocationCoordinate2D endPt = CLLocationCoordinate2DMake([self.endPointDict[@"Lat"] doubleValue],[self.endPointDict[@"Lng"] doubleValue]);
        [self routePlanningStarting:startingPt end:endPt srartCityStr:self.startingPointDict[@"City"] endCity:self.endPointDict[@"City"]];
    });
}


/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    if (userLocation.location) {//定位成功 关闭定位
        
        BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];//初始化反编码请求
        reverseGeocodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;//设置反编码的店为pt
        BOOL flag =   [self.geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
        if (flag) {
            YBLog(@"定位成功");
            [self.locService stopUserLocationService];
        }else {
            [MBProgressHUD showError:@"定位失败" toView:self.view];
        }
        return;
    }
    [MBProgressHUD showError:@"定位失败" toView:self.view];

}

#pragma mark - 起点信息
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (result.sematicDescription) {
        NSString *str = [NSString stringWithFormat:@"%@·%@",result.addressDetail.city,result.sematicDescription];
        [self.trainView.startingPointView initLabelStr:str];
        
        //起点位置信息
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:result.cityCode forKey:@"CityId"];//城市id
        [dict setObject:[NSString stringWithFormat:@"%f",result.location.longitude ] forKey:@"Lng"];//
        [dict setObject:[NSString stringWithFormat:@"%f",result.location.latitude ] forKey:@"Lat"];//
        [dict setObject:result.address forKey:@"Address"];//地址名称
        [dict setObject:result.addressDetail.district forKey:@"District"];//所在区域
        [dict setObject:result.sematicDescription forKey:@"Name"];
        [dict setObject:result.addressDetail.city forKey:@"City"];
        self.startingPointDict = dict;

    }

}

#pragma mark - 线路规划信息
- (void)onGetDrivingRouteResult:(BMKRouteSearch *)searcher result:(BMKDrivingRouteResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        
        self.routeLine = result.routes[0];
        if ([self.trainView.numberpeopleView.label.text isEqualToString:@"乘车人数"]) {
            [self priceLinePlanning:result.routes[0]];
        }else {	
            NSString *str1 = [self.trainView.numberpeopleView.label.text componentsSeparatedByString:@"人"][0];
            NSString *str2 = [self.trainView.fightView.label.text componentsSeparatedByString:@"元"][0];
            [self LinePlanning:result.routes[0] numberPeople:str1 ThanksFee:str2];
        }
    }
    else if (error == BMK_SEARCH_NETWOKR_TIMEOUT) {
        [MBProgressHUD showError:@"网络连接超时" toView:self.view];
    }
    else if (error == BMK_SEARCH_NETWOKR_ERROR) {
        [MBProgressHUD showError:@"网络连接错误" toView:self.view];
    }
    else if (error == BMK_SEARCH_ST_EN_TOO_NEAR) {
        [MBProgressHUD showError:@"起终点太近" toView:self.view];
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD) {
        [MBProgressHUD showError:@"检索词有岐义" toView:self.view];
    }
    else if (error == BMK_SEARCH_RESULT_NOT_FOUND) {
        [MBProgressHUD showError:@"没有找到检索结果" toView:self.view];
    }
}


@end
