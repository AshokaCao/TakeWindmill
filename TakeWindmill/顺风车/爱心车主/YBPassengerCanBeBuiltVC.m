//
//  YBPassengerCanBeBuiltVC.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/12/20.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBPassengerCanBeBuiltVC.h"
#import "YBPassengerTravelVC.h"
#import "YBTakeWindmillViewController.h"

#import "YBPopupMenu.h"
#import "YBWaitingView.h"
#import "YBNearbyCell.h"

@interface YBPassengerCanBeBuiltVC ()<UITableViewDelegate,UITableViewDataSource,BMKRouteSearchDelegate,YBPopupMenuDelegate>

/**
 *线路规划搜搜
 */
@property (nonatomic, strong) BMKRouteSearch *routeSearch;

/**
 * 时间、起点、终点
 */
@property (nonatomic, weak) YBOrderAddressDetails *strokeView;

/**
 * 显示乘客
 */
@property (nonatomic, weak) UITableView *passengerTableView;

/**
 * 乘客数量
 */
@property (nonatomic, weak) UILabel *heardLabel;

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

@implementation YBPassengerCanBeBuiltVC

#pragma mark - lzay
- (UILabel *)heardLabel
{
    if (!_heardLabel) {
        UILabel *label          = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.strokeView.frame), YBWidth, 20)];
        label.text              = @"当前有0位乘客";
        label.font              = YBFont(14);
        label.textColor         = [UIColor lightGrayColor];
        label.backgroundColor   = [UIColor clearColor];
        [self.view addSubview:label];
        _heardLabel = label;
    }
    return _heardLabel;
}

- (UITableView *)passengerTableView
{
    if (!_passengerTableView) {
        UITableView *tableView    = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.heardLabel.frame), YBWidth, YBHeight - CGRectGetMaxY(self.heardLabel.frame))];
        tableView.delegate        = self;
        tableView.dataSource      = self;
        tableView.rowHeight       = 200;
        tableView.backgroundColor = RGBA(245, 245, 245, 1);
        tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;//取消分割线
        tableView.mj_header       =  [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        [self.view addSubview:tableView];
        _passengerTableView = tableView;
    }
    return _passengerTableView;
}

- (YBOrderAddressDetails *)strokeView
{
    if (!_strokeView) {
        YBOrderAddressDetails *strokeView = [[YBOrderAddressDetails alloc] initWithFrame:CGRectMake(0, 0, YBWidth, 90)];
        strokeView.backgroundColor        = [UIColor whiteColor];
        [strokeView noPriceItinerary:NO];
        [self.view addSubview:strokeView];
        _strokeView = strokeView;
    }
    return _strokeView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //界面搭建
    [self interfaceToBuild];

    //请求司机当前行程
    [self travelInformation];
    
    //请求附近乘客
    [self nearbyPassengers];
}

- (void)dealloc
{
    _routeSearch.delegate = nil;
}

#pragma mark - 下拉刷新
- (void)refresh {
    [self nearbyPassengers];
    [self.passengerTableView.mj_header endRefreshing];
}

#pragma mark - 界面搭建
- (void)interfaceToBuild {
    self.title                             = @"可拼乘客";
    self.view.backgroundColor              = LineLightColor;
    
    UIButton *cancelButton       = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 20, 20)];
    cancelButton.titleLabel.font = YBFont(14);
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"更多"] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];    
}

#pragma mark - 请求当前行程信息
- (void)travelInformation {
    NSString *urlStr = travelinfodriverdetailPath;
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    [dict setObject:[YBTooler getTheUserId:self.view] forKey:@"userid"];//用户id
    [dict setObject:self.strokeSysNo forKey:@"travelsysno"];//行程id
    
    [YBRequest postWithURL:urlStr MutableDict:dict View:self.passengerTableView success:^(id dataArray) {
        YBLog(@"%@",dataArray);
        self.orderInformation = dataArray;
        [self.strokeView noPriceItineraryWithDict:dataArray];
    } failure:^(id dataArray) {
        YBLog(@"%@",dataArray);
    }];
}

#pragma mark - 检索附近乘客
- (void)nearbyPassengers
{
    _routeSearch = [[BMKRouteSearch alloc]init];
    _routeSearch.delegate = self;
    
    [MBProgressHUD showOnlyLoadToView:self.passengerTableView];
    
    NSString *urlStr = passengerstartpointnearbypassengerlistPath;
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    [dict setObject:self.travelSysNo forKey:@"travelsysno"];//乘客的sysyNo
    
    [YBRequest postWithURL:urlStr MutableDict:dict success:^(id dataArray) {
        //        YBLog(@"%@",dataArray);
        self.passengerTravel = dataArray[@"TravelInfoList"];
        if (self.passengerTravel.count != 0) {
            self.strokeRow = 0;
            self.suitabilityArray = [NSMutableArray array];
            self.isDriver = YES;
            [self DriversTripDcit:self.orderInformation PassengerDict:self.passengerTravel[self.strokeRow]];
        }else{
            [MBProgressHUD showError:@"附近暂无乘客" toView:self.passengerTableView];
        }
    } failure:^(id dataArray) {
        YBLog(@"%@",dataArray);
        [self.passengerTableView reloadData];
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

#pragma mark - 取消行程
- (void)cancelButtonAction:(UIButton *)sender
{
    [YBPopupMenu showRelyOnView:sender titles:@[@"我的消息",@"取消行程"] icons:@[@"消息",@"页面取消icon"] menuWidth:120 delegate:self];
}

#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu
{
    if (index == 1) {//取消行程
        NSString *urlStr = travelinfodrivercancelPath;
        NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
        [dict setObject:[YBTooler getTheUserId:self.view] forKey:@"userid"];//用户id
        [dict setObject:self.strokeSysNo forKey:@"travelsysno"];//行程id
        
        [YBRequest postWithURL:urlStr MutableDict:dict View:self.passengerTableView success:^(id dataArray) {
            //        YBLog(@"%@",dataArray);
            [self returnToTheWindmill:nil];
        } failure:^(id dataArray) {
            [self returnToTheWindmill:nil];
            //        YBLog(@"%@",dataArray);
        }];
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
    WEAK_SELF;
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
                    weakSelf.travelArray = dataArray[@"TravelInfoList"];
                    [MBProgressHUD hideHUDForView:weakSelf.passengerTableView animated:YES];
                    [weakSelf.passengerTableView reloadData];
                    //结束刷新
                    [weakSelf.passengerTableView.mj_header endRefreshing];
                } failure:^(id dataArray) {
                    [MBProgressHUD hideHUDForView:weakSelf.passengerTableView animated:YES];
                }];
            }else {
                [self DriversTripDcit:self.orderInformation PassengerDict:self.passengerTravel[self.strokeRow]];
            }
        }
    }
}

#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.heardLabel.text = [NSString stringWithFormat:@"当前有%lu位乘客",self.travelArray.count];
    return self.travelArray.count;
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
    peersVC.SysNo                = self.orderInformation[@"SysNo"];
    peersVC.TravelSysNo          = self.travelArray[indexPath.row][@"SysNo"];
    [self.navigationController pushViewController:peersVC animated:YES];
}

@end
