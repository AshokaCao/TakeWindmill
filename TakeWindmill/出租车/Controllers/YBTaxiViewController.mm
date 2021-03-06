//
//  YBTaxiViewController.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/11.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBTaxiViewController.h"
#import "YBSearchView.h"
#import "YBTaxiDriverViewController.h"
#import "YBRegisteredTaxiVC.h"

#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Search/BMKPoiSearch.h>
#import <BaiduMapAPI_Search/BMKRouteSearch.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

#import "RouteAnnotation.h"
#import "FirstAnnotationView.h"
#import "FirstPointAnnotation.h"
#import "MyAnnotionView.h"

#import "YBMapPositionSelectionVC.h"
#import "YBAddressSearchSelectionVC.h"

#import "YBTaxiChooseView.h"
#import "YBForMessageViewController.h"

@interface YBTaxiViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,UITextFieldDelegate,BMKPoiSearchDelegate,BMKRouteSearchDelegate, YBMapPositionSelectionVCDelegate, YBAddressSearchSelectionVCDelegate, YBTaxiChooseViewDelegate>
//搜索框
@property (nonatomic, strong) YBSearchView *searchView;

@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) BMKLocationService *locService;
@property (nonatomic, strong) BMKGeoCodeSearch *geoCodeSearch;
@property (nonatomic, strong) BMKAnnotationView *mapAnnoView;
@property (nonatomic, strong) BMKPointAnnotation *pointAnnotation;
@property (nonatomic, strong) BMKPoiSearch *poiSearch;
@property (nonatomic, strong) BMKRouteSearch *routeSearch;
@property (nonatomic, strong) UIImageView *locnImageView;
@property (nonatomic, strong) NSString *currCity;
@property (nonatomic, assign) CLLocationCoordinate2D currPoin;
@property (nonatomic, assign) BOOL isSeletJoin;
@property (nonatomic, strong) RouteAnnotation* straItem;
@property (nonatomic, strong) RouteAnnotation* endItem;
@property (nonatomic, strong) UIView *choosebackView;

//用户位置坐标
@property (nonatomic, strong) BMKUserLocation *positionUserLocation;
/**
 路线
 */
@property (nonatomic, strong) BMKPolyline* polyLine;

/**
 位置信息
 */
@property (nonatomic, strong) NSDictionary *startingPointDict;
@property (nonatomic, strong) NSDictionary *endPointDict;

@property (nonatomic, strong) YBTaxiChooseView *chooseView;

@property (nonatomic, strong) BMKDrivingRouteLine *routeLine;
//@property (nonatomic, assign) NSInteger lineColor;
@end

@implementation YBTaxiViewController

- (void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    _locService.delegate = self;
    _geoCodeSearch.delegate = self;
    _routeSearch.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    _locService.delegate = nil;
    _geoCodeSearch.delegate = nil;
    _routeSearch.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"出租车";
    _locService = [[BMKLocationService alloc]init];
    _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    _mapAnnoView = [[BMKAnnotationView alloc] init];
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:_mapView];
    [self selfLoction];
    [self jinXiangBin];
    
    
    
    _routeSearch = [[BMKRouteSearch alloc] init];
    _routeSearch.delegate = self;
    
    //WithFrame:CGRectMake(0, 0, 20, 29)
    self.locnImageView = [[UIImageView alloc] init];
    self.locnImageView.image = [UIImage imageNamed:@"定位图标"];
    [self.view addSubview:self.locnImageView];
    
    //把当前定位的经纬度换算为了View上的坐标
    CGPoint point = [self.mapView convertCoordinate:self.mapView.centerCoordinate toPointToView:self.mapView];
    
    //当解析出现错误的时候，会出现超出屏幕的情况，一种是大于了屏幕，一种是小于了屏幕
    if(point.x > YBWidth || point.x < YBWidth/5){
        point.x = YBWidth / 2;
        point.y = (YBHeight + 64) / 2 ;
    }
    self.locnImageView.center = point;
    [self.locnImageView setFrame:CGRectMake( point.x - 10, point.y - 29, 20, 29)];
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

    BMKDrivingRoutePlanOption *driveRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
    driveRouteSearchOption.from = start;
    driveRouteSearchOption.to = end;

    BOOL flag = [_routeSearch drivingSearch:driveRouteSearchOption];
    if (flag) {
        YBLog(@"查询成功");
        self.locnImageView.hidden = YES;
        [self showTaxiDetails];
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
        self.routeLine = result.routes[0];
        // 计算路线方案中的路段数目
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i == 0 ){
                self.straItem = [[RouteAnnotation alloc]init];
                self.straItem.coordinate = plan.starting.location;
                self.straItem.title = @"起点";
                self.straItem.type = 0;
                [self.mapView addAnnotation:self.straItem]; // 添加起点标注
            }
            if(i == size-1){
                self.endItem = [[RouteAnnotation alloc]init];
                self.endItem.coordinate = plan.terminal.location;
                self.endItem.title = @"终点";
                self.endItem.type = 1;
                [self.mapView addAnnotation:self.endItem]; // 添加终点标注
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
        if (self.polyLine) {
            [_mapView removeOverlay:self.polyLine];
        }
        self.polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [self.mapView addOverlay:self.polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:self.polyLine];
    }
}

- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor alloc] initWithRed:0 green:1 blue:1 alpha:1];
        polylineView.strokeColor = [[UIColor alloc] initWithRed:0 green:0 blue:1 alpha:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}

//根据polyline设置地图范围
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
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
    [_mapView setVisibleMapRect:rect];
    _mapView.zoomLevel = _mapView.zoomLevel - 0.3;
}


- (void)valueChange:(UITextField *)textField {
    NSLog(@"123");

    _poiSearch = [[BMKPoiSearch alloc] init];
    _poiSearch.delegate = self;
    NSLog(@"搜索：%@",textField.text);
    //附近云检索
    BMKNearbySearchOption *nearBySearchOption = [[BMKNearbySearchOption alloc] init];
    nearBySearchOption.pageIndex = 0;
    nearBySearchOption.pageCapacity = 10;
    nearBySearchOption.keyword = textField.text;

    //检索的中心点
    nearBySearchOption.location = _locService.userLocation.location.coordinate;
    nearBySearchOption.radius = 100;

    BOOL flag = [_poiSearch poiSearchNearBy:nearBySearchOption];
    if (flag) {
        NSLog(@"success");
    } else {
        NSLog(@"fail");
    }
}

- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode {
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        for (int i = 0; i < poiResult.poiInfoList.count; i++) {
            BMKPoiInfo *info = [poiResult.poiInfoList objectAtIndex:i];
            NSLog(@"地址：%@", info.name);
        }
    }
}
#pragma mark  地点改变
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {

    CLLocationCoordinate2D carLocation = [_mapView convertPoint:self.view.center toCoordinateFromView:self.view];
    BMKReverseGeoCodeOption *option = [[BMKReverseGeoCodeOption alloc] init];
    option.reverseGeoPoint = CLLocationCoordinate2DMake(carLocation.latitude, carLocation.longitude);
    NSLog(@"%f - %f", option.reverseGeoPoint.latitude, option.reverseGeoPoint.longitude);
    self.currPoin = CLLocationCoordinate2DMake(carLocation.latitude, carLocation.longitude);
    NSLog(@"currPoin - %f currPoin - %f",self.currPoin.longitude,self.currPoin.latitude);
    //调用发地址编码方法，让其在代理方法onGetReverseGeoCodeResult中输出
    [_geoCodeSearch reverseGeoCode:option];
}

#pragma mark 返回地理反编码
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    
    if (result) {
        NSLog(@"%@ - %@ - %@ - %@ - %@", result.addressDetail.province, result.addressDetail.city, result.addressDetail.streetName, result.address, result.businessCircle);
        self.currCity = result.addressDetail.city;
//        self.currPoin = CLLocationCoordinate2DMake(result.location.latitude, result.location.longitude);
        NSLog(@"currPoin - %f currPoin - %f",self.currPoin.longitude,self.currPoin.latitude);
        //把result.poiList存储到数组中，然后在tableView中显示出来
        [_searchView.startingPoint setTitle:result.address forState:UIControlStateNormal];
    } else {
        NSLog(@"找不到");
    }
    
}

- (void)selfLoction
{
    _locService.delegate = self;
    //启动LocationService

    _mapView.zoomLevel = 14.1;
    _mapView.showsUserLocation = YES;//是否显示小蓝点，no不显示，我们下面要自定义的
    _mapView.userTrackingMode = BMKUserTrackingModeNone;
    //定位
    [_locService startUserLocationService];

    [_mapView removeAnnotation:_pointAnnotation];
}

- (void)custome:(UIButton *)btn {
    [_mapView removeAnnotation:_pointAnnotation];
    [_locService startUserLocationService];
    NSLog(@"定位的经度:%f,定位的纬度:%f",_locService.userLocation.location.coordinate.longitude,_locService.userLocation.location.coordinate.latitude);
    //    FirstAnnotationView *firstView = [[FirstAnnotationView alloc] init];
    FirstPointAnnotation *pointA = [[FirstPointAnnotation alloc] initWithLatitude:_locService.userLocation.location.coordinate.latitude andLongtude:_locService.userLocation.location.coordinate.longitude];
    pointA.title = @"123";
    [_mapView addAnnotation:(BMKPointAnnotation *)pointA];
    [_mapView selectAnnotation:(BMKPointAnnotation *)pointA animated:YES];
}


//生成对应的气泡时候触发的方法
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    //    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
    //      static  NSString *myLocationViewID = @"myID";
    //        MyAnnotionView *newAnnotationView = (MyAnnotionView *)[mapView dequeueReusableAnnotationViewWithIdentifier:myLocationViewID];
    //        if (newAnnotationView == nil) {
    //            newAnnotationView = [[MyAnnotionView alloc] initWithAnnotation:annotation reuseIdentifier:myLocationViewID];
    //        }
    //        return newAnnotationView;
    //    }
    //    else
    if([annotation isKindOfClass:[FirstPointAnnotation class]]) {
        static NSString *firstID = @"firstID";
        FirstAnnotationView *firstView = (FirstAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:firstID];
        if (firstView == nil) {
            firstView = [[FirstAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:firstID];
        }

        return firstView;
    }
    else if ([annotation isKindOfClass:[RouteAnnotation class]]) {
        return [self getRouteAnnotationView:mapView viewForAnnotation:(RouteAnnotation*)annotation];
    }
    return nil;
}

- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation
{
    BMKAnnotationView* view = nil;
    switch (routeAnnotation.type) {
        case 0:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
                view.image = [UIImage imageNamed:@"起点"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 1:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
                view.image = [UIImage imageNamed:@"终点"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 2:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"];
                view.image = [UIImage imageNamed:@"icon_nav_bus.png"];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 3:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"];
                view.image = [UIImage imageNamed:@"icon_nav_rail.png"];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 4:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }

            //            UIImage* image = [UIImage imageNamed:@"icon_direction.png"];
            //            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;

        }
            break;
        case 5:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"waypoint_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }

            //            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_waypoint.png"]];
            //            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
        }
            break;
        default:
            break;
    }

    return view;
}



//需要设置pointAnnotation中设置它的title等属性，
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view {
    if ([view isKindOfClass:[MyAnnotionView class]]) {
        NSLog(@"点击了定位气泡");
    }
    else if([view isKindOfClass:[FirstAnnotationView class]]) {
        NSLog(@"点击了");
    }
}


- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}
#pragma mark 定位
-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    BMKCoordinateRegion region;
    region.center.latitude  = userLocation.location.coordinate.latitude;
    region.center.longitude = userLocation.location.coordinate.longitude;
    region.span.latitudeDelta  = 0.0001;
    region.span.longitudeDelta = 0.0001;
    _mapView.centerCoordinate = userLocation.location.coordinate;
    //选择一个范围，让地图显示到当前界面
    [_mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    [self.mapView setZoomEnabled:YES];
    [self.mapView setZoomEnabledWithTap:YES];
    [self.mapView setZoomLevel:16.1];

    NSLog(@"定位的经度:%f,定位的纬度:%f",userLocation.location.coordinate.longitude,userLocation.location.coordinate.latitude);
    _mapView.showsUserLocation = YES;//显示用户位置
    [_mapView updateLocationData:userLocation];
    _mapView.centerCoordinate = userLocation.location.coordinate; //让地图的中心位置在这里
    [_locService stopUserLocationService];
#pragma mark  添加大头针气泡
    _pointAnnotation = [[BMKPointAnnotation alloc] init];
    _pointAnnotation.coordinate = userLocation.location.coordinate;
//    _pointAnnotation.title = @"我在这个地方";
//    _pointAnnotation.subtitle = @"你在哪呢";
//    [_mapView addAnnotation:_pointAnnotation];
//    [_mapView selectAnnotation:_pointAnnotation animated:YES];
    self.currPoin = CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
    NSLog(@"currPoin - %f currPoin - %f",self.currPoin.longitude,self.currPoin.latitude);
}


- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    NSLog(@"heading is %@",userLocation.heading);
}



















- (void)jinXiangBin
{
    
    //    __weak __typeof(self)wself = self;
    //    _searchView.selectBlock = ^(UIButton *sender) {
    ////        YBLocationSearchVC *selec = [[YBLocationSearchVC alloc] initWithNibName:@"YBLocationSearchVC" bundle:nil];
    ////        [wself presentViewController:selec animated:YES completion:nil];
    //    };
    
    //扫一扫
    UIButton *scanButton = [[UIButton alloc] initWithFrame:CGRectMake(YBWidth - 30, 30, 30, 30)];
    [scanButton setBackgroundImage:[UIImage imageNamed:@"扫码图标"] forState:UIControlStateNormal];
    [scanButton setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:scanButton];
    
    //切换司机端
    YBBaseButton *driverButton = [YBBaseButton buttonWithFrame:CGRectMake(YBWidth - 70, CGRectGetMaxY(scanButton.frame) + 20, 70, 25) Strtitle:@"切换司机端" titleColor:[UIColor whiteColor] titleFont:12 textAlignment:NSTextAlignmentCenter image:nil BackgroundColor:BtnBlueColor cornerRadius:3];
    [driverButton addTarget:self action:@selector(driverButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:driverButton];
    
    YBBaseButton *registerBtn = [YBBaseButton buttonWithFrame:CGRectMake(YBWidth - 70, CGRectGetMaxY(driverButton.frame) + 20, 70, 25) Strtitle:@"注册出租车" titleColor:[UIColor whiteColor] titleFont:12 textAlignment:NSTextAlignmentCenter image:nil BackgroundColor:BtnBlueColor cornerRadius:3];
    [registerBtn addTarget:self action:@selector(registerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
    //现在预约
    UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(10, YBHeight - 190, 80, 30)];
    statusView.backgroundColor = LightGreyColor;
    statusView.layer.cornerRadius = 15;
    [self.view addSubview:statusView];
    //现在
    UIButton *nowButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    nowButton.layer.cornerRadius = 15;
    nowButton.titleLabel.font = YBFont(14);
    [nowButton setTitle:@"现在" forState:UIControlStateNormal];
    [nowButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [nowButton setBackgroundColor:[UIColor whiteColor]];
    [statusView addSubview:nowButton];
    
    //现在
    UIButton *reservationButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 0, 40, 30)];
    reservationButton.layer.cornerRadius = 10;
    reservationButton.titleLabel.font = YBFont(14);
    [reservationButton setTitle:@"预约" forState:UIControlStateNormal];
    [reservationButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [statusView addSubview:reservationButton];
    
    __weak typeof(self) weakSelf = self;
    _searchView = [[YBSearchView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(statusView.frame) + 20, YBWidth - 20, 100)];
    _searchView.selectBlock = ^(UIButton *sender) {
        NSLog(@"%ld",sender.tag);
        if (sender.tag == 1) {
            YBMapPositionSelectionVC *map = [[YBMapPositionSelectionVC alloc] init];
            map.delegate = weakSelf;
            map.cityName = weakSelf.currCity;
            [weakSelf presentViewController:map animated:YES completion:^{
                
            }];

        } else {
            YBAddressSearchSelectionVC *selec = [[YBAddressSearchSelectionVC alloc] init];
            selec.typesOf = @"终点";
            selec.addDelegate = weakSelf;
            selec.cityname = weakSelf.currCity;
            [weakSelf presentViewController:selec animated:YES completion:nil];
        }
    };
    [self.view addSubview:_searchView];
}

- (void)popVCPassTheValue:(NSDictionary *)value
{
    self.startingPointDict = value;
    
    [_searchView.endButton setTitle:[NSString stringWithFormat:@"%@·%@",self.startingPointDict[@"City"],self.startingPointDict[@"Name"]] forState:UIControlStateNormal];
//    if ([self.trainView.endView.label.text isEqualToString:@"你要去哪儿"]) {
//        [MBProgressHUD showError:@"请输入终点位置" toView:self.view];
//        return ;
//    }
//    else {
//
//        [self priceLinePlanning:self.routeLine];
//
//        CLLocationCoordinate2D startingPt = CLLocationCoordinate2DMake([value[@"Lat"] doubleValue],[value[@"Lng"] doubleValue]);
//        CLLocationCoordinate2D endPt = CLLocationCoordinate2DMake([self.endPointDict[@"Lat"] doubleValue],[self.endPointDict[@"Lng"] doubleValue]);
//        [self routePlanningStarting:startingPt end:endPt srartCityStr:value[@"City"] endCity:self.endPointDict[@"City"]];
//    }
}

- (void)popViewControllerPassTheValue:(NSDictionary *)value
{
    self.endPointDict = value;//终点信息字典复制
    self.startingPointDict = value;
    //终点位置显示
    NSString *progress = [NSString stringWithFormat:@"%@·%@",self.endPointDict[@"City"],self.endPointDict[@"Name"]];
    [_searchView.endButton setTitle:progress forState:UIControlStateNormal];
    
    //终点位置经纬度
    CLLocationCoordinate2D startingPt = CLLocationCoordinate2DMake([self.startingPointDict[@"Lat"] doubleValue],[self.startingPointDict[@"Lng"] doubleValue]);
    CLLocationCoordinate2D endPt = CLLocationCoordinate2DMake([self.endPointDict[@"Lat"] doubleValue],[self.endPointDict[@"Lng"] doubleValue]);
    NSLog(@"currPoin - %f currPoin - %f",self.currPoin.longitude,self.currPoin.latitude);
    [self openMapViewStartCityName:self.currCity startPT:self.currPoin endCityName:self.currCity endPT:endPt];
}

- (void)showTaxiDetails
{
    UIView *taxiList = [[UIView alloc] init];
    taxiList.backgroundColor = [UIColor orangeColor];
    self.choosebackView = taxiList;
    [self.view addSubview:taxiList];
    
    [taxiList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
        make.height.offset(200);
    }];
    
    self.chooseView = [[YBTaxiChooseView alloc] initWithFrame:CGRectMake(0, 0, taxiList.width, taxiList.height)];
    self.chooseView.delegate = self;
    [taxiList addSubview:self.chooseView];
    
    [self routeOfLine];
}
#pragma mark 点击事件
- (void)didselectBtn:(NSInteger)types
{
    switch (types) {
        case 1:
            NSLog(@"重新预约");
            [self againForMap];
            if (self.polyLine) {
                self.locnImageView.hidden = NO;
                [_mapView removeOverlay:self.polyLine];
            }
            if (self.straItem) {
                [_mapView removeAnnotation:self.straItem];
                [_mapView removeAnnotation:self.endItem];
            }
            [self.choosebackView removeFromSuperview];
            break;
        case 2:
            NSLog(@"拼车");
            self.chooseView.jointBtn.selected = self.isSeletJoin = YES;
            self.chooseView.anJointBtn.selected = NO;
            [self routeOfLine];
            break;
        case 3:
            NSLog(@"不拼车");
            self.isSeletJoin = NO;
            self.chooseView.jointBtn.selected = self.isSeletJoin = NO;
            self.chooseView.anJointBtn.selected = YES;
            break;
        case 4:
            NSLog(@"呼叫出租车");
            break;
        case 5:
        {
            YBForMessageViewController *message = [[YBForMessageViewController alloc] init];
            [self.navigationController pushViewController:message animated:YES];
            NSLog(@"行程备注");
        }
            break;
        case 6:
            NSLog(@"打表来接");
            break;
            
        default:
            break;
    }
}

- (void)savingUserTraveList
{
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
}

- (void)routeOfLine
{
    
    [self priceLinePlanning:self.routeLine];
}
#pragma mark - 价格计算 没选人
- (void)priceLinePlanning:(BMKDrivingRouteLine *)text {
    
//    [MBProgressHUD showOnlyLoadToView:self.amountMoney];
    //1.创建队列组
    dispatch_group_t group = dispatch_group_create();
    //2.创建队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_async(group,queue, ^{
        //不拼车
        NSString *URLStr = TaxiMoney;
        NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
        [dict setObject:[NSString stringWithFormat:@"%d",text.distance] forKey:@"mileage"];
        [dict setObject:self.startingPointDict[@"CityId"] forKey:@"startcityid"];
        [dict setObject:@"false" forKey:@"isjoin"];
        
        [YBRequest postWithURL:URLStr MutableDict:dict success:^(id dataArray) {
            YBLog(@"TravelCost- %@",dataArray);
            [self.chooseView.jointBtn setTitle:[NSString stringWithFormat:@"拼车 %@",dataArray[@"TravelCost"]] forState:UIControlStateNormal];
//            self.amountMoney.numberStr = dataArray[@"TravelCost"];
        } failure:^(id dataArray) {
        }];
        
    });
    
    //4.都完成后会自动通知
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//        [MBProgressHUD hideHUDForView:self.amountMoney];
    });
}

- (void)againForMap
{
    if (self.positionUserLocation.location) {//位置不为空
        //获取用户的坐标
        self.mapView.centerCoordinate = self.positionUserLocation.location.coordinate;
        //展示定位
        self.mapView.showsUserLocation = YES;
    }else {
        //开启定位
        [_locService startUserLocationService];
    }
}

- (void)driverButtonAction:(UIButton *)sender {
    YBTaxiDriverViewController *driver = [[YBTaxiDriverViewController alloc] init];
    [self.navigationController pushViewController:driver animated:YES];
}

- (void)registerBtnAction:(UIButton *)sender {
    YBRegisteredTaxiVC *vc = [[YBRegisteredTaxiVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

