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
#import "YBCancelTraveView.h"

#import "YBTaxiStepModel.h"

#import "MapPointModel.h"
#import "UIImage+CoCo.h"
#import "BMKGetTool.h"

@interface YBTaxiViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,UITextFieldDelegate,BMKPoiSearchDelegate,BMKRouteSearchDelegate, YBMapPositionSelectionVCDelegate, YBAddressSearchSelectionVCDelegate, YBTaxiChooseViewDelegate>
{
    NSInteger           _count;
    NSMutableArray     *_pointArr;
    BMKPointAnnotation *_annotationPoint;
    BMKAnnotationView  *_markView;
    BMKMapView         *_mapV;
}
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
@property (nonatomic, assign) BOOL isSeletJoin;
@property (nonatomic, strong) RouteAnnotation* straItem;
@property (nonatomic, strong) RouteAnnotation* endItem;
@property (nonatomic, strong) UIView *choosebackView;
@property (nonatomic, strong) NSString *sendMessage;
@property (nonatomic, strong) NSString *taxiSysNum;
@property (nonatomic, strong) YBCancelTraveView *cancelView;
@property (nonatomic, strong) NSString *isCome;
@property (nonatomic, strong) NSString *isJoin;
@property (nonatomic, strong) NSDictionary *userTravle;
@property (nonatomic, strong) NSString *currCityID;
@property (nonatomic, assign) CLLocationCoordinate2D currPoin;
@property (nonatomic, assign) CLLocationCoordinate2D userStralocation;
@property (nonatomic, assign) CLLocationCoordinate2D severLocation;
@property (nonatomic, assign) CLLocationCoordinate2D currentDriverlocation;
@property (nonatomic, assign) CLLocationCoordinate2D lastDriverlocation;
@property (nonatomic, assign) BOOL isSelectEnd;
@property (nonatomic, assign) BOOL isShowTaxiMess;
@property (nonatomic, assign) BOOL isRet;

@property (nonatomic, strong) NSString *payMoney;
@property (nonatomic, strong) NSString *payOrder;


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
/**
 * 起点所在的位置信息
 */
@property (nonatomic, strong) BMKReverseGeoCodeResult *startingPoint;
//@property (nonatomic, assign) NSInteger lineColor;
@end

@implementation YBTaxiViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    _locService.delegate = self;
    _geoCodeSearch.delegate = self;
    _routeSearch.delegate = self;
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    [dict setObject:[YBTooler getTheUserId:self.view] forKey:@"userid"];
    dict[@"traveltypefid"] = @"2";
    
    [YBRequest postWithURL:TaxiTraveling MutableDict:dict success:^(id dataArray) {        self.isShowTaxiMess = NO;
        self.taxiSysNum = dataArray[@"SysNo"];
        
        self.currCity = dataArray[@"StartCity"];
        self.currCityID = dataArray[@"StartCityId"];
        CLLocationCoordinate2D strPt = CLLocationCoordinate2DMake([dataArray[@"StartLat"] doubleValue],[dataArray[@"StartLng"] doubleValue]);
        CLLocationCoordinate2D endPt = CLLocationCoordinate2DMake([dataArray[@"EndLat"] doubleValue],[dataArray[@"EndLng"] doubleValue]);
        self.severLocation = strPt;
        [self openMapViewStartCityName:self.currCity startPT:strPt endCityName:self.currCity endPT:endPt];
        if (self.choosebackView) {
            [self.choosebackView removeFromSuperview];
        }
        self.choosebackView = [[UIView alloc] init];
        [self.view addSubview:self.choosebackView];
        
        [self.choosebackView  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(10);
            make.right.equalTo(self.view.mas_right).offset(-10);
            make.bottom.equalTo(self.view.mas_bottom).offset(-10);
            make.height.offset(200);
        }];
        self.userTravle = dataArray;
        [self addCancelTraveView];
        self.payMoney = [NSString stringWithFormat:@"%@",dataArray[@"PayMoney"]];
        self.payOrder = [NSString stringWithFormat:@"%@",dataArray[@"OrderNo"]];
        NSLog(@"viewWillAppear - %@ - %@",self.payMoney,dataArray[@"OrderNo"]);

        if (self.payMoney.length > 1) {
            [self.cancelView userNeedToPayWith:self.payOrder andMoney:self.payMoney];
        } else {
            [self getDriverCurrentLocation];
        }
    } failure:^(id dataArray) {
        
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
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
    _mapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_mapView];
    [self selfLoction];
    [self jinXiangBin];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taxiNotification:)name:@"TaxiNotigication" object:nil];
    
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
    driveRouteSearchOption.drivingPolicy = BMK_DRIVING_DIS_FIRST;
    driveRouteSearchOption.from = start;
    driveRouteSearchOption.to = end;
    
    BOOL flag = [_routeSearch drivingSearch:driveRouteSearchOption];
    if (flag) {
        YBLog(@"查询成功");
        self.locnImageView.hidden = YES;
        if (self.isShowTaxiMess) {
            [self showTaxiDetails];
        }
    }
    else {
        YBLog(@"查询失败");
    }
//    NSLog(@"self.startingPointDict - %@",self.startingPointDict[@"Name"]);
}

- (void)onGetDrivingRouteResult:(BMKRouteSearch *)searcher result:(BMKDrivingRouteResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        if (result.routes.count > 0) {
            
            _pointArr = [NSMutableArray array];
            _count = 0;
            
            NSMutableArray *array = [NSMutableArray arrayWithArray:result.routes];
            if (array) {
                BMKDrivingRouteLine *planLine = [array firstObject];
                //在此处理正常结果
                int i = 0;
                //收集轨迹点
                for (int j = 0; j < planLine.steps.count; j++) {
                    BMKDrivingStep* transitStep = [planLine.steps objectAtIndex:j];
                    int k=0;
                    for(k=0;k<transitStep.pointsCount;k++) {
                        CLLocationCoordinate2D pt = BMKCoordinateForMapPoint(transitStep.points[k]);
                        MapPointModel *model = [[MapPointModel alloc]init];
                        model.lat = pt.latitude;
                        model.lon = pt.longitude;
                        if (k>0) {
                            CLLocationCoordinate2D lastPt = BMKCoordinateForMapPoint(transitStep.points[k-1]);
                            model.angle = [BMKGetTool getAngleSPt:lastPt endPt:pt];
                        }
                        [_pointArr addObject:model];
                        i++;
                    }
                }
                //计算轨迹点之间的距离
                for (int i = 0; i<_pointArr.count; i++) {
                    if (i<_pointArr.count-1) {
                        MapPointModel *model = _pointArr[i];
                        MapPointModel *model1 = _pointArr[i+1];
                        CLLocationCoordinate2D pt;
                        pt.latitude = model.lat;
                        pt.longitude = model.lon;
                        float distance = [BMKGetTool getDistanceLat:model1.lat Lng:model1.lon pt:pt];
                        model1.distance = distance;
                        
                    }
                }
                [self moveAnnotionV];
            }
        }
        
        BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
        self.routeLine = result.routes[0];
        // 计算路线方案中的路段数目
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i == 0 ){
                
                if (self.straItem) {
                    [_mapView removeAnnotation:self.straItem];
                }
                self.straItem = [[RouteAnnotation alloc]init];
                self.straItem.coordinate = plan.starting.location;
                self.straItem.title = @"起点";
                self.straItem.type = 0;
                [self.mapView addAnnotation:self.straItem]; // 添加起点标注
            }
            if(i == size-1){
                if (self.endItem) {
                    [_mapView removeAnnotation:self.endItem];
                }
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
    [self routeOfLine];
    NSLog(@"self.startingPointDict = %@",self.startingPointDict[@"Name"]);
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
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];//初始化反编码请求
    reverseGeocodeSearchOption.reverseGeoPoint = carLocation;//设置反编码的店为pt
    BOOL flag =   [self.geoCodeSearch reverseGeoCode:reverseGeocodeSearchOption];
    if (flag) {
        YBLog(@"定位搜索成功");
    }
    else {
        [MBProgressHUD showError:@"位置搜索失败" toView:self.view];
    }
    self.currPoin = carLocation;
    
    //调用发地址编码方法，让其在代理方法onGetReverseGeoCodeResult中输出
//    [_geoCodeSearch reverseGeoCode:option];
    NSLog(@"地点改变");
}

#pragma mark 返回地理反编码
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    
    if (result) {
        if (self.isSelectEnd) {
            
        } else {
            self.currCity = result.addressDetail.city;
            self.currCityID = result.cityCode;
            NSLog(@"地理编码");
            
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
            self.startingPoint = result;
        }
        
        NSLog(@"self.startingPointDict - %@",self.startingPointDict[@"Name"]);
        [_searchView.startingPoint setTitle:result.address forState:UIControlStateNormal];
    } else {
        NSLog(@"找不到");
    }
    
}

//生成对应的气泡时候触发的方法
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
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
    } else if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        static NSString* annoId = @"Anno";
        BMKAnnotationView *markView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annoId];
        _markView = markView;
        return markView;
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

- (void)mapViewDidFinishLoading:(BMKMapView *)mapView
{
    
}


#pragma mark -- 小车移动
- (void)startRouteSearch
{
    self.isSelectEnd = YES;
    [self openMapViewStartCityName:self.currCity startPT:self.currentDriverlocation endCityName:self.currCity endPT:self.severLocation];
    
    if (_annotationPoint) {
        [self.mapView removeAnnotation:_annotationPoint];
        [self.view.layer removeAllAnimations];
    }
    _annotationPoint = [[BMKPointAnnotation alloc]init];
    _annotationPoint.coordinate = self.currentDriverlocation;
    [self.mapView addAnnotation:_annotationPoint];

//    BMKGetTool *search = [[BMKGetTool alloc]init];//路线检索
//    [search searchStartPt:self.currentDriverlocation endPt:self.severLocation];
}
#pragma mark -------
- (void)moveAnnotionV
{
    CGFloat angle = [BMKGetTool getAngleSPt:self.lastDriverlocation endPt:self.currentDriverlocation];
    UIImage * pinImage = [UIImage imageNamed:@"car2"];
    if (_count >=_pointArr.count) {
        
    } else {
        
        NSLog(@"_pointArr - %ld - %ld",_pointArr.count,_count);
        MapPointModel *model = _pointArr[_count];
        [UIView animateWithDuration:5 animations:^{
            
            if ([_mapView.annotations containsObject:_annotationPoint]) {
                CLLocationCoordinate2D coor;
                coor.latitude = self.currentDriverlocation.latitude;
                coor.longitude = self.currentDriverlocation.longitude;
                _annotationPoint.coordinate = coor;
                
                _markView.image = [pinImage imageRotatedByAngle:angle];
//                if (model.angle) {
//                    _markView.image = [pinImage imageRotatedByAngle:model.angle];
//                }else{
//                    if (_count>0) {
//                        MapPointModel *model = _pointArr[_count-1];
//                    }
//                }
            }
            
        } completion:^(BOOL finished) {
            _count++;
            
            if (_count == _pointArr.count-1) {
                return;
            }
//            [self moveAnnotionV];
        }];
    }
//    [self mapViewFitPolyLine:self.polyLine];
}

//#pragma mark -- 返回各种点的标注图
//- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
//{
//    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
//        static NSString* annoId = @"Anno";
//        BMKAnnotationView *markView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annoId];
//        _markView = markView;
//        return markView;
//    }
//    return nil;
//}


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

- (void)selfLoction
{
    [_locService startUserLocationService];
    _locService.delegate = self;
    //启动LocationService
    _mapView.zoomLevel = 14.1;
    _mapView.showsUserLocation = YES;//是否显示小蓝点，no不显示，我们下面要自定义的
    _mapView.userTrackingMode = BMKUserTrackingModeNone;
    //定位
    
    [_mapView removeAnnotation:_pointAnnotation];
}

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
    self.userStralocation = CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
    NSLog(@"定位");
}


- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    NSLog(@"heading is %@",userLocation.heading);
}



















- (void)jinXiangBin
{
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
    NSLog(@"self.startingPointDict - %@",self.startingPointDict[@"Name"]);
}
#pragma mark  终点
- (void)popViewControllerPassTheValue:(NSDictionary *)value
{
    self.endPointDict = value;//终点信息字典复制
//    self.startingPointDict = value;
    //终点位置显示
    NSString *progress = [NSString stringWithFormat:@"%@·%@",self.endPointDict[@"City"],self.endPointDict[@"Name"]];
    [_searchView.endButton setTitle:progress forState:UIControlStateNormal];
    
    //终点位置经纬度
    CLLocationCoordinate2D endPt = CLLocationCoordinate2DMake([self.endPointDict[@"Lat"] doubleValue],[self.endPointDict[@"Lng"] doubleValue]);
    self.isSelectEnd = YES;
    self.isShowTaxiMess = YES;
    [self openMapViewStartCityName:self.currCity startPT:self.currPoin endCityName:self.currCity endPT:endPt];
}
#pragma mark 出租车要求
- (void)showTaxiDetails
{
    if (self.choosebackView) {
        [self.choosebackView removeFromSuperview];
    }
    self.choosebackView = [[UIView alloc] init];
    [self.view addSubview:self.choosebackView];
    
    [self.choosebackView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
        make.height.offset(200);
    }];
    
    self.chooseView = [[YBTaxiChooseView alloc] initWithFrame:CGRectMake(0, 0, self.choosebackView .width, self.choosebackView .height)];
    self.chooseView.delegate = self;
    [self.choosebackView  addSubview:self.chooseView];
    
}
#pragma mark 点击事件
- (void)didselectBtn:(NSInteger)types
{
    switch (types) {
        case 1:
            NSLog(@"重新预约");
            [self againForMap];
            break;
        case 2:
            NSLog(@"拼车");
            self.chooseView.jointBtn.selected = self.isSeletJoin = YES;
            self.chooseView.anJointBtn.selected = NO;
            self.isJoin = @"true";
            break;
        case 3:
            NSLog(@"不拼车");
            self.isSeletJoin = NO;
            self.chooseView.jointBtn.selected = self.isSeletJoin = NO;
            self.chooseView.anJointBtn.selected = YES;
            self.isJoin = @"false";
            break;
        case 4:
            NSLog(@"呼叫出租车");
            [self savingUserTraveList];
            break;
        case 5:
        {
            YBForMessageViewController *message = [[YBForMessageViewController alloc] init];
            __weak __typeof(self)wself = self;
            message.sendMessage = ^(NSString *message) {
                wself.sendMessage = message;
                NSLog(@"%@",message);
            };
            [self.navigationController pushViewController:message animated:YES];
            NSLog(@"行程备注");
        }
            break;
        case 6:
            self.chooseView.isCome.selected = !self.chooseView.isCome.selected;

            if (self.chooseView.isCome.selected) {
                self.isCome = @"true";
            } else {
                self.isCome = @"false";
            }
            NSLog(@"打表来接");
            break;
            
        default:
            break;
    }
}
#pragma mark 呼叫出租车
- (void)savingUserTraveList
{
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    [dict setObject:[YBTooler getTheUserId:self.view] forKey:@"userid"];
    dict[@"traveltypefid"] = @"2";
    //起点信息
    [dict setObject:self.startingPointDict[@"Lng"] forKey:@"startlng"];
    [dict setObject:self.startingPointDict[@"Lat"] forKey:@"startlat"];
    [dict setObject:self.startingPointDict[@"City"] forKey:@"startcity"];
    [dict setObject:self.startingPointDict[@"Name"] forKey:@"startaddress"];
    [dict setObject:self.startingPointDict[@"CityId"] forKey:@"startcityid"];
    NSLog(@"self.startingPointDict - %@",self.startingPointDict[@"Name"]);
    //终点信息
    [dict setObject:self.endPointDict[@"Lng"] forKey:@"endlng"];
    [dict setObject:self.endPointDict[@"Lat"] forKey:@"endlat"];
    [dict setObject:self.endPointDict[@"City"] forKey:@"endcity"];
    [dict setObject:self.endPointDict[@"Name"] forKey:@"endaddress"];
    [dict setObject:self.endPointDict[@"District"] forKey:@"endroad"];//街道名称
    [dict setObject:[NSString stringWithFormat:@"%d",self.routeLine.distance] forKey:@"mileage"];
    [dict setObject:self.endPointDict[@"CityId"] forKey:@"endcityid"];
    dict[@"note"] = self.sendMessage;
    dict[@"isbymetercome"] = self.isCome;
    dict[@"isjoin"] = self.isJoin;
    self.severLocation =  CLLocationCoordinate2DMake([self.startingPointDict[@"Lat"] doubleValue],[self.startingPointDict[@"Lng"] doubleValue]);
//    NSLog(@"taxi -  %@",dict);
    [YBRequest postWithURL:TaxiTravel MutableDict:dict success:^(id dataArray) {
        NSLog(@"taxi -  %@",dataArray[@"SysNo"]);
        self.taxiSysNum = dataArray[@"SysNo"];
        NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
        [dict setObject:[YBTooler getTheUserId:self.view] forKey:@"userid"];
        dict[@"traveltypefid"] = @"2";
        
        [YBRequest postWithURL:TaxiTraveling MutableDict:dict success:^(id dataArray) {
            NSLog(@"dataArray - --%@",dataArray);
            self.userTravle = dataArray;
            [self addCancelTraveView];
            
//            [self openMapViewStartCityName:self.currCity startPT:self.currentDriverlocation endCityName:self.currCity endPT:self.currPoin];
        } failure:^(id dataArray) {
            
        }];
    } failure:^(id dataArray) {

    }];
}

#pragma mark - 价格计算
- (void)routeOfLine
{
    [self priceLinePlanning:self.routeLine];
}

- (void)priceLinePlanning:(BMKDrivingRouteLine *)text {
    NSString *URLStr = TaxiMoney;
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    [dict setObject:[NSString stringWithFormat:@"%d",text.distance] forKey:@"mileage"];
    [dict setObject:self.currCityID forKey:@"startcityid"];
    [dict setObject:@"false" forKey:@"isjoin"];
    
    [YBRequest postWithURL:URLStr MutableDict:dict success:^(id dataArray) {
        YBLog(@"TravelCost- %@",dataArray);
        [self.chooseView.jointBtn setTitle:[NSString stringWithFormat:@"拼车 %@",dataArray[@"TravelCost"]] forState:UIControlStateNormal];
        //            self.amountMoney.numberStr = dataArray[@"TravelCost"];
    } failure:^(id dataArray) {
        
    }];
}

#pragma mark 重新预约
- (void)againForMap
{
    self.isRet = NO;
    self.isSelectEnd = NO;
    if (self.choosebackView) {
        [self.choosebackView removeFromSuperview];
    }
    if (self.chooseView) {
        [self.chooseView removeFromSuperview];
    }
    if (self.polyLine) {
        self.locnImageView.hidden = NO;
        [_mapView removeOverlay:self.polyLine];
    }
    if (self.straItem) {
        [_mapView removeAnnotation:self.straItem];
        [_mapView removeAnnotation:self.endItem];
    }
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

#pragma mark 取消行程
- (void)addCancelTraveView
{
//    [self.chooseView removeFromSuperview];
    
    self.isRet = NO;
    self.cancelView = [[YBCancelTraveView alloc] initWithFrame:CGRectMake(0, 0, self.choosebackView.width, self.choosebackView.height)];
    
//    NSLog(@"self.userTravle - %@",self.userTravle);
    
    [self.cancelView showDetailWith:self.userTravle];
    __weak __typeof(self)wself = self;
    self.cancelView.cancelBlock = ^(NSString *message) {
        [wself traveCancel];
    };
    [self.choosebackView addSubview:self.cancelView];
}

- (void)traveCancel
{
    self.isShowTaxiMess = NO;
    [self.mapView removeAnnotation:_annotationPoint];
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    [dict setObject:[YBTooler getTheUserId:self.view] forKey:@"userid"];
    dict[@"travelsysno"] = self.taxiSysNum;
    [YBRequest postWithURL:travelinfocancelPath MutableDict:dict success:^(id dataArray) {
        NSLog(@"cencel - %@",dataArray);
//        [self.choosebackView removeFromSuperview];
        [self againForMap];
    } failure:^(id dataArray) {

    }];
    /*
        [PPNetworkHelper setResponseSerializer:PPResponseSerializerHTTP];
        [PPNetworkHelper POST:travelinfocancelPath parameters:dict success:^(id responseObject) {

            NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)str,CFSTR(""),CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
            NSLog(@"upload is succse :%@",decodedString);

        } failure:^(NSError *error) {
            NSLog(@"faile - :%@",error);
        }];
     */
}


#pragma mark 单子的状态
- (void)taxiNotification:(NSNotification *)notification{
    
    YBTaxiStepModel *model = notification.userInfo[@"TaxiNotigication"];

    Travelinfo *travelinModel = [Travelinfo yy_modelWithJSON:model.travelinfo];
    
    self.payMoney = travelinModel.PayMoney;
    
    NSLog(@"========== getMessage - %@",travelinModel.PayMoney);
    NSString *taxiType = [NSString stringWithFormat:@"%@",model.content];
//    NSString *taxiState = [NSString stringWithFormat:@"%@",model.op];
    if ([taxiType isEqualToString:@"操作信息"]) {
        NSString *taxiState = [NSString stringWithFormat:@"%@",model.op];
        if ([taxiState isEqualToString:@"PassengerInvite"]) {
            
        } else if ([taxiState isEqualToString:@"PassengerInvite"]) {
            
        } else if ([taxiState isEqualToString:@"BindPassenger"]) {
            [self actionSheetWith:@"司机已接单" andMessage:@"司机已经接单,请准备好与之同行."];
            self.isRet = YES;
            self.isShowTaxiMess = NO;
            [self getDriverCurrentLocation];
        } else if ([taxiState isEqualToString:@"ArriveToStart"]) {
            [self actionSheetWith:@"司机到达乘客上车点" andMessage:@"司机到达乘客上车点,请准备好与之同行."];
        } else if ([taxiState isEqualToString:@"PassangerGetOn"]) {
            [self actionSheetWith:@"司机已确认乘客上车" andMessage:@"司机已确认乘客上车,请准备好与之同行."];
        } else if ([taxiState isEqualToString:@"PassangerArriveToEnd"]) {
            [self actionSheetWith:@"司机已确认到达目的地" andMessage:@"司机已确认到达目的地,请带好行李物品."];
            [self.cancelView userNeedToPayWith:self.payOrder andMoney:self.payMoney];
            self.isRet = NO;
        } else if ([taxiState isEqualToString:@"PassangerPay"]) {
            self.isRet = NO;
            [self actionSheetWith:@"乘客付款" andMessage:@"乘客已确认付款"];
        } else if ([taxiState isEqualToString:@"DriverTravelCancel"]) {
            self.isRet = NO;
            [self actionSheetWith:@"司机取消行程" andMessage:@"司机取消行程,请注意查看."];
        } else if ([taxiState isEqualToString:@"PassengerTravelCancel"]) {
            self.isRet = NO;
            [self actionSheetWith:@"乘客取消行程" andMessage:@"乘客取消行程,请注意查看."];
        }
    } else {
        
    }
}

- (void)actionSheetWith:(NSString *)title andMessage:(NSString *)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark 付款----
- (void)choosePayType
{
    
}

#pragma mark 获取司机的位置
- (void)getDriverCurrentLocation
{
    _pointArr = [NSMutableArray arrayWithCapacity:0];
    _count = 0;
    [self driverLocation];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{

        while (self.isRet) {

            [NSThread sleepForTimeInterval:10];

            [self driverLocation];

            NSLog(@"***每20秒输出一次这段文字***");
            if (self.isRet) {
                
            }
        };
    });

}

- (void)driverLocation
{
    if (self.isRet) {
        NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
        [dict setObject:[YBTooler getTheUserId:self.view] forKey:@"userid"];
        
        [YBRequest postWithURL:TaxiDriveCurrentLocation MutableDict:dict success:^(id dataArray) {
            if (self.currentDriverlocation.latitude) {
                self.lastDriverlocation = self.currentDriverlocation;
            }
            self.currentDriverlocation =  CLLocationCoordinate2DMake([dataArray[@"Lat"] doubleValue], [dataArray[@"Lng"] doubleValue]);
            
            if (dataArray[@"Lat"]) {
                [self startRouteSearch];
            }
        } failure:^(id dataArray) {
            
        }];
    }
}

- (void)driverButtonAction:(UIButton *)sender {
    YBTaxiDriverViewController *driver = [[YBTaxiDriverViewController alloc] init];
    driver.currLocation = self.currPoin;
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

