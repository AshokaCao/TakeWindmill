//
//  YBWaitingOrdersVC.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/14.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "YBOnTheTrainVC.h"
#import "YBAskForPeersVC.h"
#import "YBWaitingOrdersVC.h"
#import "YBMapViewController.h"
#import "YBTakeWindmillViewController.h"

#import "RouteAnnotation.h"

#import "YBWaitingView.h"
#import "YBNearbyCell.h"
#import "TQMultistageTableView.h"
#import "YBWaitingOrdersCell.h"
#import "SelectedListView.h"

//****************************************超级分割线*************************************************//

@interface YBWaitingOrdersVC ()<UITableViewDelegate,UITableViewDataSource,BMKRouteSearchDelegate>

@property (nonatomic, weak) UITableView *waitingTableView;
/**
 * 头部视图
 */
@property (nonatomic, strong) UIView *headView;
/**
 * 司机个数
 */
@property (nonatomic, weak) UILabel *numberdriversLabel;

//线路规划搜搜
@property (nonatomic, strong) BMKRouteSearch *routeSearch;

/**
 * 司机数据
 */
@property (nonatomic, strong) NSDictionary *orderDict;

/**
 * 司机规划数据
 */
@property (nonatomic, strong) NSArray *planningArray;

/**
 * 发给服务器的司机数组
 */
@property (nonatomic, strong) NSMutableArray *mileageArray;

//是否是最后一个
@property (nonatomic, assign) int planningRow;

/**
 * 司机数据
 */
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation YBWaitingOrdersVC

#pragma mark - lzay
- (UITableView *)waitingTableView
{
    if (!_waitingTableView) {
        UITableView *tableView      = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.numberdriversLabel.frame), YBWidth, YBHeight - CGRectGetMaxY(self.numberdriversLabel.frame))];
        tableView.delegate          = self;
        tableView.dataSource        = self;
        tableView.rowHeight         = 220;
        tableView.backgroundColor   = RGBA(245, 245, 245, 1);
        tableView.separatorStyle    = UITableViewCellSeparatorStyleNone;
//        UIView *viewal = [[UIView alloc] init];
//        [viewal addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headimg.gif"]]];
//        tableView.placeHolderView   = viewal;
        [self.view addSubview:tableView];
        _waitingTableView           = tableView;
    }
    return _waitingTableView;
}

- (UILabel *)numberdriversLabel
{
    if (!_numberdriversLabel) {
        UILabel *label  = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.headView.frame), YBWidth - 20, 30)];
        label.text      = @"当前暂无司机";
        label.font      = YBFont(13);
        label.textColor = [UIColor grayColor];
        [self.view addSubview:label];
        _numberdriversLabel = label;
    }
    return _numberdriversLabel;
}
- (UIView *)headView {
    if (!_headView) {
        _headView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBWidth, 150)];
        [self.view addSubview:_headView];
        
        //等待接单
        YBOrdersView *ordersView = [[YBOrdersView alloc] initWithFrame:CGRectMake(0, 10, YBWidth, 40)];
        ordersView.backgroundColor = [UIColor whiteColor];
        [_headView addSubview:ordersView];

        //个人行程详情
        YBOrderAddressDetails *detailsView = [[YBOrderAddressDetails alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(ordersView.frame) +1, YBWidth, _headView.frame.size.height - CGRectGetMaxY(ordersView.frame))];
        [detailsView basseView];
        NSString *urlStr = travelinfodetailbysysnoPath;
        NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
        [dict setObject:self.travelSysNo  forKey:@"travelsysno"];
        [YBRequest postWithURL:urlStr MutableDict:dict success:^(id dataArray) {
            self.orderDict = dataArray;
            //订单详情
            [detailsView orderDetailsDictionary:dataArray];
        } failure:^(id dataArray) {
        }];
        [_headView addSubview:detailsView];

     }
    return _headView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //导航
    [self navigationItemButton];

    //匹配度司机
    [self driverMatchingDegree];
}

- (void)dealloc
{
    _routeSearch.delegate = nil;
}

- (void)navigationItemButton
{
    self.view.backgroundColor    = LightGreyColor;
    self.title                   = @"等待车主接单";
    UIButton *leftButton         = [[UIButton alloc] initWithFrame:CGRectMake(-10, 0, 10, 20)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"箭头2"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(returnToTheWindmill:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cancelButton       = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    cancelButton.titleLabel.font = YBFont(14);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem  = nil;
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    
    _routeSearch            = [[BMKRouteSearch alloc]init];
    _routeSearch.delegate   = self;
    _planningArray          = [NSArray array];
    _mileageArray           = [NSMutableArray array];
    _dataArray              = [NSMutableArray array];
    _planningRow            = 0;
    
    //下拉刷新
    self.waitingTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
}

- (void)refresh
{
    [self driverMatchingDegree];
    //结束刷新
    [self.waitingTableView.mj_header endRefreshing];
}

#pragma mark - 请求附近司机(计算里程没有公里数)
- (void)driverMatchingDegree
{
    //乘客匹配附近司机
    NSString *urlStr = passengerstartpointPath;
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    [dict setObject:[YBTooler getTheUserId:self.view] forKey:@"userid"];
    [YBRequest postWithURL:urlStr MutableDict:dict View:self.waitingTableView success:^(id dataArray) {
//        YBLog(@"%@",dataArray);
        _planningArray      = dataArray[@"TravelInfoDriverList"];
        if (_planningArray.count == 0) {
            _dataArray = nil;
            [MBProgressHUD showError:@"附近暂无司机" toView:self.view];
        }
        else {
            [MBProgressHUD showHUDAddedTo:self.waitingTableView animated:YES];
            NSDictionary *dict  = _planningArray[0];
            [self openMapViewStartCity:dict[@"StartCity"] StartLat:dict[@"StartLat"] StartLng:dict[@"StartLng"] EndCity:dict[@"EndCity"] EndLat:dict[@"EndLat"] EndLng:dict[@"EndLng"]];
        }
        [self.waitingTableView reloadData];
    } failure:^(id dataArray) {
     [MBProgressHUD showError:dataArray[@"ErrorMessage"] toView:self.waitingTableView];
    }];
}

#pragma mark - 乘客规划司机
- (void)openMapViewStartCity:(NSString *)startCity StartLat:(NSString *)StartLat StartLng:(NSString *)StartLng EndCity:(NSString *)endCity  EndLat:(NSString *)EndLat EndLng:(NSString *)EndLng
{
    
    //发起检索
    //起点
    BMKPlanNode* start        = [[BMKPlanNode alloc]init] ;
    start.cityName            = self.orderDict[@"StartCity"];
    CLLocationCoordinate2D pt = CLLocationCoordinate2DMake([self.orderDict[@"StartLat"] doubleValue],[self.orderDict[@"StartLng"] doubleValue]);
    start.pt                  = pt;
    //终点
    BMKPlanNode* end             = [[BMKPlanNode alloc]init];
    end.cityName                 = self.orderDict[@"EndCity"];
    CLLocationCoordinate2D endPt = CLLocationCoordinate2DMake([self.orderDict[@"EndLat"] doubleValue],[self.orderDict[@"EndLng"] doubleValue]);
    end.pt                       = endPt;
    //途经点
    NSMutableArray * array                 = [[NSMutableArray alloc] initWithCapacity:10];
    BMKPlanNode* wayPointItem1             = [[BMKPlanNode alloc]init];
    wayPointItem1.cityName                 = startCity;
    wayPointItem1.pt                       = CLLocationCoordinate2DMake([StartLat doubleValue],[StartLng doubleValue]);
    [array addObject:wayPointItem1];
    
    BMKPlanNode* wayPointItem2        = [[BMKPlanNode alloc]init];
    wayPointItem2.cityName            = endCity;
    wayPointItem2.pt                = CLLocationCoordinate2DMake([EndLat doubleValue],[EndLng doubleValue]);
    [array addObject:wayPointItem2];
    
    BMKDrivingRoutePlanOption *driveRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
    driveRouteSearchOption.from                       = start;
    driveRouteSearchOption.to                         = end;
    driveRouteSearchOption.wayPointsArray             = array;
    
    BOOL flag = [self.routeSearch drivingSearch:driveRouteSearchOption];
    if (flag) {
        YBLog(@"线路规划检索成功");
    }
    else{
        YBLog(@"线路规划检索失败");
    }
}


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

- (void)cancelButtonAction:(UIButton *)sender
{

    YBBaseView *increaseView = [[YBBaseView alloc] initWithFrame:CGRectMake(0, 0, YBWidth, 50)];
    [increaseView increaseTheThankYouYee];
    
    [LEEAlert actionsheet].config
    .LeeActionSheetBottomMargin(0.0f) // 设置底部距离屏幕的边距为0
    .LeeCornerRadius(0.0f) // 设置圆角曲率为0
    .LeeHeaderInsets(UIEdgeInsetsMake(10, 0, 0, 0))
    .LeeItemInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeClickBackgroundClose(YES)
    .LeeAddAction(^(LEEAction *action) {
        
        action.title = @"重新发布任务";
        action.titleColor = [UIColor grayColor];
        action.height = 45.0f;
        action.clickBlock = ^{
            [self cancelTheItinerary];
        };
    })
    .LeeAddAction(^(LEEAction *action) {
        
        action.title = @"取消订单";
        action.titleColor = [UIColor grayColor];
        action.height = 45.0f;
        action.clickBlock = ^{
            [self cancelTheItinerary];
        };
    })
    .LeeAddCustomView(^(LEECustomView *custom) {
        
        custom.view = increaseView;
        custom.isAutoWidth = YES;
    })
    .LeeActionSheetCancelActionSpaceColor([UIColor colorWithWhite:0.92 alpha:1.0f]) // 设置取消按钮间隔的颜色
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeCancel;
        action.title = @"继续等待";
        action.titleColor = [UIColor grayColor];
        action.height = 45.0f;
        action.clickBlock = ^{
        };
    })
    .LeeConfigMaxWidth(^CGFloat(LEEScreenOrientationType type) {
        return YBWidth;
    })
    .LeeShow();
}

#pragma mark - 取消行程
- (void)cancelTheItinerary
{
    NSString *urlStr = travelinfocancelPath;
    
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    [dict setObject:self.travelSysNo forKey:@"travelsysno"];
    [dict setObject:[YBTooler getTheUserId:self.view] forKey:@"userid"];
    
    [YBRequest postWithURL:urlStr MutableDict:dict View:self.view success:^(id dataArray) {
        YBLog(@"%@",dataArray);
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(id dataArray) {
        [MBProgressHUD showError:@"ErrorMessage" toView:self.view];
    }];
}

#pragma mark - 司机行程里数
- (void)onGetDrivingRouteResult:(BMKRouteSearch *)searcher result:(BMKDrivingRouteResult *)result errorCode:(BMKSearchErrorCode)error
{
    BMKDrivingRouteLine *routeLine = result.routes[0];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    NSNumber * DriverMileage =  [NSNumber numberWithInt:routeLine.distance];// 司机里程
    NSNumber * PassengerMileage =  [NSNumber numberWithInt:[self.orderDict[@"Mileage"] intValue]];//乘客里程
    NSNumber * MatchRate =  [NSNumber numberWithInt:0];

    [dict setObject:_planningArray[_planningRow][@"SysNo"] forKey:@"TravelSysNo"];//行程SysNo
    [dict setObject:_planningArray[_planningRow][@"UserId"] forKey:@"DriverUserId"]; //司机UserId
    [dict setObject:DriverMileage forKey:@"DriverMileage"];//司机规里程（单位：米）
    [dict setObject:PassengerMileage forKey:@"PassengerMileage"];//乘客里程（单位：米）
    [dict setObject:MatchRate forKey:@"MatchRate"];//匹配度
    [_mileageArray addObject:dict];
    
    if (error == BMK_SEARCH_NO_ERROR) {
        _planningRow ++;
        if (_planningRow < _planningArray.count) {
            [self openMapViewStartCity:_planningArray[_planningRow][@"StartCity"] StartLat:_planningArray[_planningRow][@"StartLat"] StartLng:_planningArray[_planningRow][@"StartLng"] EndCity:_planningArray[_planningRow][@"EndCity"] EndLat:_planningArray[_planningRow][@"EndLat"] EndLng:_planningArray[_planningRow][@"EndLng"]];
        }
        if (_planningRow == _planningArray.count) {
            [MBProgressHUD hideHUDForView:self.waitingTableView animated:YES];

            //乘客与司机行程匹配度
            NSString *urlStr           = passengertravelPath;
            NSDictionary *data         = [NSDictionary dictionaryWithObject:_mileageArray forKey:@"RoutePlanResult"];
            NSMutableDictionary *dict1 = [YBTooler dictinitWithMD5];
            [dict1 setObject:[YBRequest convertToJsonData:data] forKey:@"routeplanresult"];
            [YBRequest postWithURL:urlStr MutableDict:dict1 success:^(id dataArray) {
                YBLog(@"匹配完成后的司机行程，含有匹配度%@",dataArray);
                _dataArray = dataArray[@"TravelInfoDriverList"];
                self.numberdriversLabel.text = [NSString stringWithFormat:@"当前有%lu位司机",_dataArray.count];
                [self.waitingTableView reloadData];
            } failure:^(id dataArray) {
                YBLog(@"%@",dataArray);
            }];
            _planningRow = 0;
        }
    }
}

#pragma mark - TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *strID = @"YBWaitingOrdersCell";
    YBWaitingOrdersCell *cell = [tableView dequeueReusableCellWithIdentifier:strID];
    if (!cell) {
        cell = [[YBWaitingOrdersCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:strID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.detailsDict = self.dataArray[indexPath.row];
    //点击头像
    cell.iconImageView = ^(UITapGestureRecognizer *gest) {
        YBHisHomePageVC *page = [[YBHisHomePageVC alloc] init];
        [self.navigationController pushViewController:page animated:YES];
    };
    //点击按钮
    cell.bgView.clickeBlock = ^(UIButton *sender) {//无反应
        YBLog(@"asd");
        [self pleaseTakeHim:indexPath];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self pleaseTakeHim:indexPath];
}

- (void)pleaseTakeHim:(NSIndexPath *)indexPath
{
    YBAskForPeersVC *askfor = [[YBAskForPeersVC alloc] init];
    askfor.SysNo            = _dataArray[indexPath.row][@"SysNo"];
    askfor.TravelSysNo      = _orderDict[@"SysNo"];
    askfor.driverUserId     = _dataArray[indexPath.row][@"UserId"];
    [self.navigationController pushViewController:askfor animated:YES];
}


@end
