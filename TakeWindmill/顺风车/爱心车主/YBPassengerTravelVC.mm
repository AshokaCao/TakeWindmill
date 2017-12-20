//
//  YBPassengerTravelVC.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/9/5.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBPassengerTravelVC.h"
#import "YBEvaluationPassengersVC.h"

#import "YBWaitingView.h"
#import "YBThanksFee.h"
#import "YBThanksTheFee.h"
#import "RouteAnnotation.h"

@interface YBPassengerTravelVC ()<BMKRouteSearchDelegate>

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
 * 线路颜色
 */
@property (nonatomic, copy) NSString *lineColor;

/**
 * 乘客帮司机接单
 */
@property (nonatomic, weak) UIButton *helpOrdersButton;

/**
 * 导航栏按钮
 */
@property (nonatomic, weak) UIView *navigationView;

@end

@implementation YBPassengerTravelVC

- (UIButton *)helpOrdersButton
{
    if (!_helpOrdersButton) {
        UIButton *order = [[UIButton alloc] init];
        [order setBackgroundColor:BtnBlueColor];
        [order setTitle:@"乘客帮司机接单" forState:UIControlStateNormal];
    }
    return _helpOrdersButton;
}

- (UIView *)navigationView
{
    if (!_navigationView) {
        //        UIView *navigationView = [[UIView alloc] init];
        
    }
    return _navigationView;
}

- (YBWaitingView *)waitingView
{
    if (!_waitingView) {
        YBWaitingView *waiting  = [[YBWaitingView alloc] initWithFrame:CGRectMake(5, YBHeight - 240, YBWidth - 10, 220)];
        waiting.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:waiting];
        
        __weak __typeof__(waiting) waitingS = waiting;
        waiting.clickeBlock = ^(UIButton *sender) {
            if (sender.tag == 1) {
                [sender setTitle:@"接到乘客" forState:UIControlStateNormal];
                sender.tag ++;
            }
            else if (sender.tag == 2){
                [sender setTitle:@"到达目的地" forState:UIControlStateNormal];
                sender.tag ++;
            }
            else if (sender.tag == 3){
                YBEvaluationPassengersVC *ebalu = [[YBEvaluationPassengersVC alloc] init];
                [self.navigationController pushViewController:ebalu animated:YES];
            }
            else {
                
                [waitingS passengerTravel_ConfirmPeer];
            }
        };
        _waitingView = waiting;
    }
    return _waitingView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"乘客行程";
    //
    [self.waitingView driverPassengerTravel:nil];
    //请求乘客行程信息
    [self networkRequestPassengerTravel];
    //请求司机信息
    [self networkRequest];
    
}

- (void)dealloc
{
    _routeSearch.delegate = nil;
}

#pragma mark - 邀请乘客行程信息
- (void)networkRequestPassengerTravel
{
    //    [self.waitingView passengerPriceWithDict:nil];
    
    //    _passengerDict = [NSDictionary dictionary];
    //
    //    NSString *urlStr          = travelinfodetailbysysnoPath;
    //    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    //    [dict setObject:self.TravelSysNo forKey:@"travelsysno"];
    //    [dict setObject:@"1" forKey:@"userid"];
    //
    //    [YBRequest postWithURL:urlStr MutableDict:dict View:self.waitingView success:^(id dataArray) {
    //        YBLog(@"%@",dataArray);
    //        _passengerDict = dataArray;
    //        //订单详情
    //        CLLocationCoordinate2D start = CLLocationCoordinate2DMake([dataArray[@"StartLat"] doubleValue], [dataArray[@"StartLng"] doubleValue]);
    //        CLLocationCoordinate2D end = CLLocationCoordinate2DMake([dataArray[@"EndLat"] doubleValue], [dataArray[@"EndLng"] doubleValue]);
    //        [self openMapViewStartCityName:dataArray[@"StartCity"] startPT:start endCityName:dataArray[@"EndCity"] endPT:end];
    //        //
    //        [self.waitingView passengerPriceWithDict:dataArray];
    //    } failure:^(id dataArray) {
    //        YBLog(@"%@",dataArray);
    //
    //    }];
}

#pragma mark - 司机行程
- (void)networkRequest
{
    [self DriversTripDcit:nil PassengerDict:nil];
    
    //    NSString *urlStr          = travelinfodriverdetailPath;
    //    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    //    [dict setObject:self.SysNo forKey:@"sysno"];
    //    [dict setObject:@"1" forKey:@"userid"];
    //
    //    [YBRequest postWithURL:urlStr MutableDict:dict success:^(id dataArray) {
    //        YBLog(@"%@",dataArray);
    //        //订单详情
    //        [self.waitingView inviteColleagues:dataArray];
    //        [self DriversTripDcit:dataArray PassengerDict:self.passengerDict];
    //    } failure:^(id dataArray) {
    //        YBLog(@"%@",dataArray);
    //
    //    }];
}

#pragma mark - 乘客行程行程规划
- (void)openMapViewStartCityName:(NSString *)cityName startPT:(CLLocationCoordinate2D)startPt endCityName:(NSString *)city endPT:(CLLocationCoordinate2D)endPt
{
    _routeSearch = [[BMKRouteSearch alloc]init];
    _routeSearch.delegate = self;
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
        self.lineColor = @"乘客";//乘客
    }
    else {
        YBLog(@"查询失败");
    }
}

#pragma mark - 司机的行程
- (void)DriversTripDcit:(NSDictionary *)dreverDit PassengerDict:(NSDictionary *)passDict
{
    //    self.lineColor = @"司机";//司机
    _routeSearch = [[BMKRouteSearch alloc]init];
    _routeSearch.delegate = self;
    
    CLLocationCoordinate2D start1 = CLLocationCoordinate2DMake([dreverDit[@"StartLat"] doubleValue], [dreverDit[@"StartLng"] doubleValue]);
    CLLocationCoordinate2D end1 = CLLocationCoordinate2DMake([dreverDit[@"EndLat"] doubleValue], [dreverDit[@"EndLng"] doubleValue]);
    //发起检索
    BMKPlanNode* start = [[BMKPlanNode alloc]init] ;
    start.cityName = dreverDit[@"StartCity"];
    start.pt = start1;
    
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.cityName = dreverDit[@"EndCity"];
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
    if (![self.lineColor isEqualToString:@"乘客"]  && ![self.lineColor isEqualToString:@"司机"]) {
        NSArray* array = [NSArray arrayWithArray:self.mapView.annotations];
        [self.mapView removeAnnotations:array];
        
        array = [NSArray arrayWithArray:self.mapView.overlays];
        [self.mapView removeOverlays:array];
    }
    
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = [NSString stringWithFormat:@"%@起点",self.lineColor];
                item.type = 0;
                [self.mapView addAnnotation:item]; // 添加起点标注
            }
            if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = [NSString stringWithFormat:@"%@终点",self.lineColor];
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
        polylineView.lineWidth = 10.0;
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
    self.mapView.zoomLevel = self.mapView.zoomLevel - 2.3;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

