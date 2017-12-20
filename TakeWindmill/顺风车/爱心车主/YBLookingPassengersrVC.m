//
//  YBLookingPassengersrVC.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/9/12.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBLookingPassengersrVC.h"
#import "YBAutomaticSynchronizationVC.h"
#import "YBTakeWindmillViewController.h"
#import "YBPassengerTravelVC.h"
#import "YBHisHomePageVC.h"

#import "YBWaitingView.h"
#import "DropMenuView.h"
#import "YBNearbyCell.h"

@interface YBLookingPassengersrVC ()<UITableViewDelegate, UITableViewDataSource,BMKRouteSearchDelegate>

//线路规划搜搜
@property (nonatomic, strong) BMKRouteSearch *routeSearch;

/**
 * 时间、起点、终点
 */
@property (nonatomic, weak) YBOrderAddressDetails *strokeView;
//
///**
// * 系统自动帮忙接单
// */
//@property (nonatomic, weak) UIView *bottomView;

@property (nonatomic, weak) UITableView *lookingTableVIew;

/**
 * UITableView的头部试图
 */
@property (nonatomic, strong) YBNearbyTitleView *heardView;

/**
 * 乘客行程数组
 */
@property (nonatomic, strong) NSArray *passengerTravel;

/**
 * 第几个行程
 */
@property (nonatomic, assign) NSInteger strokeRow;

/**
 * 乘客司机匹配度数组
 */
@property (nonatomic, strong) NSMutableArray *suitabilityArray;

/**
 * 显示乘客数据数组
 */
@property (nonatomic, strong) NSArray *travelArray;

/**
 * 订单详情
 */
@property (nonatomic, strong) NSMutableDictionary *orderInformation;

/**
 * 规划完成司机的里程数
 */
@property (nonatomic, assign) int travelMeters;

/**
 * 判断是乘客还是司机里程规划
 */
@property (nonatomic, assign) BOOL isDriver;

@end

@implementation YBLookingPassengersrVC

#pragma mark -lazy
//头部试图
- (YBNearbyTitleView *)heardView
{
    if (!_heardView) {
        _heardView                  = [[YBNearbyTitleView alloc] initWithFrame:CGRectMake(0, 0, YBWidth, 40)];
        _heardView.backgroundColor  = LineLightColor;
    }
    return _heardView;
}

- (UITableView *)lookingTableVIew
{
    if (!_lookingTableVIew) {
        UITableView *tableView    = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.strokeView.frame), YBWidth, YBHeight - CGRectGetMaxY(self.strokeView.frame)) style:UITableViewStylePlain];
        tableView.delegate        = self;
        tableView.dataSource      = self;
        tableView.rowHeight       = 200;
        tableView.backgroundColor = RGBA(245, 245, 245, 1);
        
        [self.view addSubview:tableView];
        _lookingTableVIew = tableView;
    }
    return _lookingTableVIew;
}

////自动设置
//- (UIView *)bottomView
//{
//    if (!_bottomView) {
//        UIView *bottomView         = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.strokeView.frame) + 5, YBWidth, 40)];
//        bottomView.backgroundColor = [UIColor whiteColor];
//        [self.view addSubview:bottomView];
//
//        UILabel *contentLabel      = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, bottomView.frame.size.width - 90, bottomView.frame.size.height)];
//        contentLabel.text          = @"开启自动同行,系统自动帮你抢单";
//        contentLabel.font          = YBFont(13);
//        [bottomView addSubview:contentLabel];
//
//        UIButton *immediatelyBtn            = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(contentLabel.frame), 10, 70, bottomView.frame.size.height - 20)];
//        immediatelyBtn.titleLabel.font      = YBFont(12);
//        immediatelyBtn.layer.cornerRadius   = 5;
//        [immediatelyBtn setBackgroundColor:BtnBlueColor];
//        [immediatelyBtn setTitle:@"立即设置" forState:UIControlStateNormal];
//        [immediatelyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [immediatelyBtn addTarget:self action:@selector(immediatelyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//        [bottomView addSubview:immediatelyBtn];
//
//
//        _bottomView = bottomView;
//    }
//    return _bottomView;
//}

- (YBOrderAddressDetails *)strokeView
{
    if (!_strokeView) {
        YBOrderAddressDetails *strokeView = [[YBOrderAddressDetails alloc] initWithFrame:CGRectMake(0, 0, YBWidth, 90)];
        strokeView.backgroundColor        = [UIColor whiteColor];
        [strokeView noPriceItinerary:NO];
        [self.view addSubview:strokeView];
        
//        UIButton *subscript = [[UIButton alloc] init];
//        [subscript setImage:[UIImage imageNamed:@"下角"] forState:UIControlStateNormal];
//        [subscript setBackgroundColor:[UIColor whiteColor]];
//        [subscript addTarget:self action:@selector(subscriptAction:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:subscript];
        
//        [subscript mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.equalTo(self.view);
//            make.top.equalTo(strokeView.mas_bottom).offset(0);
//            make.bottom.equalTo(strokeView.mas_bottom).offset(4);
//
//            make.size.mas_equalTo(CGSizeMake(8, 4));
//        }];
        
        _strokeView = strokeView;
    }
    return _strokeView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //界面搭建
    [self interfaceToBuild];
    [self travelInformation];

    [self.lookingTableVIew mj_header];
    //请求附近乘客
    [self nearbyPassengers];
}

- (void)dealloc
{
    _routeSearch.delegate = nil;
}

#pragma mark - 检索附近乘客
- (void)nearbyPassengers
{
    _routeSearch = [[BMKRouteSearch alloc]init];
    _routeSearch.delegate = self;
    
    NSString *urlStr = driverstartpointnearbypassengerlistPath;
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    [dict setObject:[YBTooler getTheUserId:self.view] forKey:@"userid"];//用户id
    
    [YBRequest postWithURL:urlStr MutableDict:dict success:^(id dataArray) {
//        YBLog(@"%@",dataArray);
        self.passengerTravel = dataArray[@"TravelInfoList"];
        if (self.passengerTravel.count != 0) {
            self.strokeRow = 0;
            self.suitabilityArray = [NSMutableArray array];
            self.isDriver = YES;
            [self DriversTripDcit:self.orderInformation PassengerDict:self.passengerTravel[self.strokeRow]];
        }else{
            [MBProgressHUD showError:@"附近暂无乘客" toView:self.lookingTableVIew];
        }
    } failure:^(id dataArray) {
        YBLog(@"%@",dataArray);
        [self.lookingTableVIew reloadData];
    }];

}

#pragma mark - 界面搭建
- (void)interfaceToBuild
{
    self.title                             = @"正在寻找乘客";
    self.view.backgroundColor              = LineLightColor;
    
    UIButton *leftButton         = [[UIButton alloc] initWithFrame:CGRectMake(-10, 0, 10, 20)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"箭头2"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(returnToTheWindmill:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cancelButton       = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 30, 30)];
    cancelButton.titleLabel.font = YBFont(14);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem  = nil;
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];

}

#pragma mark - 请求当前行程信息
- (void)travelInformation
{
    NSString *urlStr = travelinfodriverdetailPath;
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    [dict setObject:[YBTooler getTheUserId:self.view] forKey:@"userid"];//用户id
    [dict setObject:self.strokeSysNo forKey:@"travelsysno"];//行程id

    [YBRequest postWithURL:urlStr MutableDict:dict View:self.lookingTableVIew success:^(id dataArray) {
        YBLog(@"%@",dataArray);
        self.orderInformation = dataArray;
        [self.strokeView noPriceItineraryWithDict:dataArray];
    } failure:^(id dataArray) {
        YBLog(@"%@",dataArray);
    }];

}

#pragma mark - 取消行程
- (void)cancelButtonAction:(UIButton *)sender
{

    NSString *urlStr = travelinfodrivercancelPath;
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    [dict setObject:[YBTooler getTheUserId:self.view] forKey:@"userid"];//用户id
    [dict setObject:self.strokeSysNo forKey:@"travelsysno"];//行程id

    [YBRequest postWithURL:urlStr MutableDict:dict View:self.lookingTableVIew success:^(id dataArray) {
//        YBLog(@"%@",dataArray);
        [self returnToTheWindmill:sender];
    } failure:^(id dataArray) {
//        YBLog(@"%@",dataArray);
    }];
}

#pragma mark - 返回
- (void)returnToTheWindmill:(UIButton *)sender
{
    NSArray *temArray = self.navigationController.viewControllers;
    for(UIViewController *temVC in temArray)
    {
        if ([temVC isKindOfClass:[YBTakeWindmillViewController class]])
        {
            [self.navigationController popToViewController:temVC animated:YES];
        }
    }
}
#pragma mark - 乘客行程里程计算
- (void)passengerMileageCalculation:(NSDictionary *)passDict
{
    CLLocationCoordinate2D start1 = CLLocationCoordinate2DMake([passDict[@"StartLat"] doubleValue], [passDict[@"StartLng"] doubleValue]);
    CLLocationCoordinate2D end1 = CLLocationCoordinate2DMake([passDict[@"EndLat"] doubleValue], [passDict[@"EndLng"] doubleValue]);
    //发起检索
    BMKPlanNode* start = [[BMKPlanNode alloc]init] ;
    start.cityName = passDict[@"StartCity"];
    start.pt = start1;
    
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.cityName = passDict[@"EndCity"];
    end.pt = end1;
    
    BMKDrivingRoutePlanOption *driveRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
    driveRouteSearchOption.from                       = start;
    driveRouteSearchOption.to                         = end;
    
    BOOL flag = [_routeSearch drivingSearch:driveRouteSearchOption];
    if (flag) {
        YBLog(@"乘客里程查询成功");
    }
    else {
        YBLog(@"乘客里程查询失败");
    }

}

#pragma mark - 司机与乘客行程匹配
- (void)DriversTripDcit:(NSDictionary *)dreverDit PassengerDict:(NSDictionary *)passDict
{

    CLLocationCoordinate2D start1 = CLLocationCoordinate2DMake([dreverDit[@"StartLat"] doubleValue], [dreverDit[@"StartLng"] doubleValue]);
    CLLocationCoordinate2D end1 = CLLocationCoordinate2DMake([dreverDit[@"EndLat"] doubleValue], [dreverDit[@"EndLng"] doubleValue]);
    //发起检索
    BMKPlanNode* start = [[BMKPlanNode alloc]init] ;
    start.cityName = dreverDit[@"StartCity"];
    start.pt = start1;
    
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.cityName = dreverDit[@"PassCitys"];
    end.pt = end1;
    
    CLLocationCoordinate2D start2 = CLLocationCoordinate2DMake([passDict[@"StartLat"] doubleValue], [passDict[@"StartLng"] doubleValue]);
    CLLocationCoordinate2D end2 = CLLocationCoordinate2DMake([passDict[@"EndLat"] doubleValue], [passDict[@"EndLng"] doubleValue]);
    //途经点
    NSMutableArray * array                 = [[NSMutableArray alloc] initWithCapacity:10];
    BMKPlanNode* wayPointItem1             = [[BMKPlanNode alloc]init];
    wayPointItem1.cityName                 = passDict[@"StartCity"];
    wayPointItem1.pt                       = start2;
    [array addObject:wayPointItem1];
    
    BMKPlanNode* wayPointItem2        = [[BMKPlanNode alloc]init];
    wayPointItem2.cityName            = passDict[@"EndCity"];
    wayPointItem2.pt                  = end2;
    [array addObject:wayPointItem2];
    
    BMKDrivingRoutePlanOption *driveRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
    driveRouteSearchOption.from                       = start;
    driveRouteSearchOption.to                         = end;
    driveRouteSearchOption.wayPointsArray             = array;
    
    
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
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
        
        if (self.isDriver) {//司机里程
            self.travelMeters = plan.distance;
            [self passengerMileageCalculation:self.passengerTravel[self.strokeRow]];
            self.isDriver = NO;
        }
        else{
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:self.passengerTravel[self.strokeRow][@"SysNo"] forKey:@"TravelSysNo"];//行程TravelSysNo
            [dict setObject:self.orderInformation[@"UserId"] forKey:@"DriverUserId"];//司机的usid
            [dict setObject:@(self.travelMeters) forKey:@"DriverMileage"];//司机的里程数
            [dict setObject:@(plan.distance) forKey:@"PassengerMileage"];//乘客的里程数
            [dict setObject:@(0) forKey:@"MatchRate"];//行程匹配度
            [self.suitabilityArray addObject:dict];//加进数组
            
            self.strokeRow ++;//递增
            self.isDriver = YES;
            if (self.passengerTravel.count == self.strokeRow) {//完成计算
                NSString *urlStr = dirvertravelmatchpassengerlistPath;
                NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
                NSDictionary *route = @{@"RoutePlanResult":self.suitabilityArray};
                [dict setObject:[YBRequest convertToJsonData:route] forKey:@"routeplanresult"];
                [YBRequest postWithURL:urlStr MutableDict:dict success:^(id dataArray) {
                    YBLog(@"规划后的匹配度%@",dataArray);
                    self.travelArray = dataArray[@"TravelInfoList"];
                    [self.lookingTableVIew reloadData];
                } failure:^(id dataArray) {
                }];
            }else {
                [self DriversTripDcit:self.orderInformation PassengerDict:self.passengerTravel[self.strokeRow]];
            }
        }
    }
}

#pragma mark - 点击事件
- (void)immediatelyBtnAction:(UIButton *)sender
{
    YBAutomaticSynchronizationVC *aut = [[YBAutomaticSynchronizationVC alloc] init];
    [self.navigationController pushViewController:aut animated:YES];
}

//- (void)subscriptAction:(UIButton *)sender
//{
//    [UIView animateWithDuration:0.2 animations:^{
//        if (!sender.selected) {
//            sender.imageView.transform  = CGAffineTransformMakeRotation(M_PI);
//            self.strokeView.frame       = CGRectMake(0, 0, YBWidth, 80);
//        }
//        else{
//            sender.imageView.transform  = CGAffineTransformIdentity;
//            self.strokeView.frame       = CGRectMake(0, 0, YBWidth, 60);
//        }
//        [self.strokeView noPriceItinerary:sender.selected];
//        sender.selected             = !sender.selected;
////        self.bottomView.frame       = CGRectMake(0, CGRectGetMaxY(self.strokeView.frame) + 5, YBWidth, 40);
////        self.lookingTableVIew.frame = CGRectMake(0, CGRectGetMaxY(self.bottomView.frame), YBWidth, YBHeight - CGRectGetMaxY(self.bottomView.frame));
////        [self.strokeView noPriceItineraryWithDict:nil];
//
//    }];
//}

#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.travelArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.heardView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strID = @"YBNearbyCell";
    YBNearbyCell *cell = [tableView dequeueReusableCellWithIdentifier:strID];
    if (!cell) {
        cell = [[YBNearbyCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:strID];
    }
    cell.selectionStyle = UITableViewCellAccessoryNone;
    cell.detailsDict = self.travelArray[indexPath.row];
    cell.iconImageView = ^(UITapGestureRecognizer *gest) {
        YBHisHomePageVC *page = [[YBHisHomePageVC alloc] init];
        [self.navigationController pushViewController:page animated:YES];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBPassengerTravelVC *peersVC = [[YBPassengerTravelVC alloc] init];
    peersVC.SysNo                = @"";
    peersVC.TravelSysNo          = @"";
    [self.navigationController pushViewController:peersVC animated:YES];
}
@end
