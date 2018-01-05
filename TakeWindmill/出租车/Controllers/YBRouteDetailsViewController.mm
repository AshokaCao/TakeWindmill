//
//  YBRouteDetailsViewController.m
//  TakeWindmill
//
//  Created by AshokaCao on 2017/12/5.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBRouteDetailsViewController.h"
#import "YBPassengerTableViewCell.h"

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

@interface YBRouteDetailsViewController () <UITableViewDelegate, UITableViewDataSource, BMKMapViewDelegate, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate, BMKPoiSearchDelegate, BMKRouteSearchDelegate, YBPassengerTableViewCellDelegate>
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UITableView *passengerTableView;
@property (nonatomic, strong) NSMutableArray *strokeArray;

@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) BMKLocationService *locService;
@property (nonatomic, strong) BMKGeoCodeSearch *geoCodeSearch;
@property (nonatomic, strong) BMKAnnotationView *mapAnnoView;
@property (nonatomic, strong) BMKPointAnnotation *pointAnnotation;
@property (nonatomic, strong) BMKPoiSearch *poiSearch;
@property (nonatomic, strong) BMKRouteSearch *routeSearch;
@property (nonatomic, assign) CLLocationCoordinate2D currLocation;;

@property (nonatomic, strong) NSString *payMoney;

@end

@implementation YBRouteDetailsViewController

- (UITableView *)passengerTableView
{
    if (!_passengerTableView) {
        _passengerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, YBWidth , 240) style:UITableViewStylePlain];
        _passengerTableView.delegate = self;
        _passengerTableView.dataSource = self;
        _passengerTableView.rowHeight         = 240;
        //        _passengerTableView.separatorStyle    = UITableViewCellEditingStyleNone;
        _passengerTableView.backgroundColor   = LightGreyColor;
        _passengerTableView.bounces = NO;
    }
    return _passengerTableView;
}

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
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.title = @"行程详情";
    _locService = [[BMKLocationService alloc]init];
    _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    _mapAnnoView = [[BMKAnnotationView alloc] init];
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 200)];
    [self.view addSubview:_mapView];
    [self selfLoction];
    
    [self.passengerTableView registerClass:[YBPassengerTableViewCell class] forCellReuseIdentifier:@"YBPassengerTableViewCell"];
    [self passengerDetails];
    [self addBottomView];
    [self.bottomView addSubview:self.passengerTableView];
}

- (void)addBottomView
{
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, YBHeight - 300, YBWidth, 300)];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomView];
    
}

- (void)passengerDetails
{
    //    TaxiStrokeTable
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    NSString *userID = [YBUserDefaults valueForKey:_userId];
    dict[@"userid"] = userID;
    self.strokeArray = [NSMutableArray array];
    [YBRequest postWithURL:TaxiStrokeTable MutableDict:dict success:^(id dataArray) {
        NSLog(@"TaxiStrokeTable - %@",dataArray);
        NSDictionary *dict = dataArray;
        NSDictionary *newDic = [NSDictionary changeType:dict];
        for (NSDictionary *diction in newDic[@"TravelInfoList"]) {
            YBTaxiStrokeModel *model = [YBTaxiStrokeModel new];
            [model setValuesForKeysWithDictionary:diction];
            [self.strokeArray addObject:model];
        }
        [self whichWayToChoose];
        [self.passengerTableView reloadData];
    } failure:^(id dataArray) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.strokeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBPassengerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBPassengerTableViewCell"];
    YBTaxiStrokeModel *model = self.strokeArray[indexPath.row];
    [cell showDetailsWith:model];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark 消息 电话 状态
- (void)didselectTaxiTralveBtn:(NSInteger)sender andYBPassengerTableViewCell:(YBPassengerTableViewCell *)cell
{
    NSArray *titleArray = @[@"到达上车点",@"乘客已上车",@"到达目的地",@"待支付"];
    NSIndexPath *path = [self.passengerTableView indexPathForCell:cell];
    YBTaxiStrokeModel *model = self.strokeArray[path.row];
    NSString *drivType = model.Stat;
    int driTy = [drivType intValue] + 1;
    
    
    if (driTy == 3) {
        // 使用一个变量接收自定义的输入框对象 以便于在其他位置调用
        
        __block UITextField *tf = nil;
        
        [LEEAlert alert].config
        .LeeTitle(@"输入金额")
        .LeeContent(@"打车费用")
        .LeeAddTextField(^(UITextField *textField) {
            
            // 这里可以进行自定义的设置
            
            textField.placeholder = @"输入框";
            
            textField.textColor = [UIColor darkGrayColor];
            
            tf = textField; //赋值
        })
        .LeeAction(@"好的", ^{
            self.payMoney = tf.text;
            [tf resignFirstResponder];
            NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
            dict[@"travelsysno"] = model.SysNo;
            dict[@"steptype"] = [NSString stringWithFormat:@"%d",[drivType intValue] + 1];
            dict[@"currentlng"] = [NSString stringWithFormat:@"%f",self.currLocation.longitude];
            dict[@"currentlat"] = [NSString stringWithFormat:@"%f",self.currLocation.latitude];
            dict[@"paymoney"] = self.payMoney;
            
            [cell.drvBtn setTitle:titleArray[driTy] forState:UIControlStateNormal];
            
            [YBRequest postWithURL:TaxiUpload MutableDict:dict success:^(id dataArray) {
                NSLog(@"self.currLocation. - %@",dataArray);
                [self passengerDetails];
                [self.passengerTableView reloadData];
            } failure:^(id dataArray) {
                
            }];
            cell.drvBtn.enabled = NO;
        })
        .LeeCancelAction(@"取消", nil) // 点击事件的Block如果不需要可以传nil
        .LeeShow();
    } else {
        NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
        dict[@"travelsysno"] = model.SysNo;
        dict[@"steptype"] = [NSString stringWithFormat:@"%d",[drivType intValue] + 1];
        dict[@"currentlng"] = [NSString stringWithFormat:@"%f",self.currLocation.longitude];
        dict[@"currentlat"] = [NSString stringWithFormat:@"%f",self.currLocation.latitude];
        
        
        [cell.drvBtn setTitle:titleArray[driTy] forState:UIControlStateNormal];
        
        [YBRequest postWithURL:TaxiUpload MutableDict:dict success:^(id dataArray) {
            NSLog(@"self.currLocation. - %@",dataArray);
            [self passengerDetails];
            [self.passengerTableView reloadData];
        } failure:^(id dataArray) {
            
        }];
        cell.drvBtn.enabled = YES;
    }
}

- (void)upLoadDriverCurrentLocation
{
//    switch (sender) {
//        case 1:
//
//            break;
//        case 2:
//
//            break;
//        case 3:
//        {
//            NSIndexPath *path = [self.passengerTableView indexPathForCell:cell];
//            YBTaxiStrokeModel *model = self.strokeArray[path.row];
//            NSString *drivType = model.Stat;
//            int driTy = [drivType intValue] + 1;
//            NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
//            dict[@"travelsysno"] = model.SysNo;
//            dict[@"steptype"] = [NSString stringWithFormat:@"%d",[drivType intValue] + 1];
//            dict[@"currentlng"] = [NSString stringWithFormat:@"%f",self.currLocation.longitude];
//            dict[@"currentlat"] = [NSString stringWithFormat:@"%f",self.currLocation.latitude];
//            //            dict[@"paymoney"] =
//
//            [cell.drvBtn setTitle:titleArray[driTy] forState:UIControlStateNormal];
//
//            [YBRequest postWithURL:TaxiUpload MutableDict:dict success:^(id dataArray) {
//                NSLog(@"self.currLocation. - %@",dataArray);
//                [self passengerDetails];
//                [self.passengerTableView reloadData];
//            } failure:^(id dataArray) {
//
//            }];
//        }
//            break;
//
//        default:
//            break;
//    }
}






- (void)whichWayToChoose {
    _routeSearch = [[BMKRouteSearch alloc] init];
    _routeSearch.delegate = self;
    
//    CLLocationCoordinate2D start = CLLocationCoordinate2DMake(30.778262, 120.755138);
    CLLocationCoordinate2D end = CLLocationCoordinate2DMake(30.769583, 120.755489);
    NSMutableArray *starCoordinate = [NSMutableArray array];
//    NSMutableArray *endCoordinate = [NSMutableArray array];
    
    NSMutableDictionary *dict = [YBUserDefaults valueForKey:@"currentLocation"];
    NSMutableDictionary *currDict = [YBTooler dictinitWithMD5];
    currDict[@"userid"] = dict[@"userid"];
    currDict[@"currentlng"] = [NSString stringWithFormat:@"%@",dict[@"lng"]];
    currDict[@"currentlat"] = [NSString stringWithFormat:@"%@",dict[@"lat"]];
    // 司机所在位置
    BMKMapPoint point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake([dict[@"lat"] floatValue], [dict[@"lng"] floatValue]));
    CLLocationCoordinate2D straPoin = CLLocationCoordinate2DMake([dict[@"lat"] floatValue], [dict[@"lng"] floatValue]);
    if (self.strokeArray.count > 1) {
        for (int  i = 0; i< self.strokeArray.count - 1; i++) {
            for (int j = i + 1; j< self.strokeArray.count; j++) {
                
                YBTaxiStrokeModel *modelI = self.strokeArray[i];
                BMKMapPoint startPoint1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake([modelI.StartLat doubleValue],[modelI.StartLng doubleValue]));
                CLLocationDistance distance1 = BMKMetersBetweenMapPoints(point1,startPoint1);
                //            CGFloat dis = distance;
                NSNumber *straNum1 = [NSNumber numberWithFloat:distance1];
                
                
                YBTaxiStrokeModel *modelJ = self.strokeArray[j];
                BMKMapPoint startPoint2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake([modelJ.StartLat doubleValue],[modelJ.StartLng doubleValue]));
                CLLocationDistance distance2 = BMKMetersBetweenMapPoints(point1,startPoint2);
                //            CGFloat dis = distance;
                NSNumber *straNum2 = [NSNumber numberWithFloat:distance2];
                NSComparisonResult resNum = [straNum1 compare:straNum2];
                if (resNum == NSOrderedDescending) {
                    //交换
                    [self.strokeArray exchangeObjectAtIndex:i withObjectAtIndex:j];
                }
            }
        }
        for (int  i = 0; i< self.strokeArray.count; i++) {
            YBTaxiStrokeModel *modelI = self.strokeArray[i];
            CLLocationCoordinate2D startPoint1 = CLLocationCoordinate2DMake([modelI.StartLat doubleValue],[modelI.StartLng doubleValue]);
            BMKPlanNode* wayPointItem1             = [[BMKPlanNode alloc]init];
            wayPointItem1.pt                       = startPoint1;
            [starCoordinate addObject:wayPointItem1];
        }
        //        BMKPlanNode* wayPointItem1             = [[BMKPlanNode alloc]init];
        ////        wayPointItem1.cityName                 = passDict[@"StartCity"];
        //        wayPointItem1.pt                       = start2;
        //        [array addObject:wayPointItem1];
        [self openMapViewStartCityName:@"嘉兴市" startPT:straPoin endCityName:@"嘉兴市" endPT:end andWayArray:starCoordinate];
    } else {
        YBTaxiStrokeModel *modelI = self.strokeArray[0];
        CLLocationCoordinate2D passStr = CLLocationCoordinate2DMake([modelI.StartLat doubleValue],[modelI.StartLng doubleValue]);
        CLLocationCoordinate2D end = CLLocationCoordinate2DMake([modelI.EndLat doubleValue],[modelI.EndLng doubleValue]);
        NSString *staCityName = modelI.StatName;
        NSString *endCityName = modelI.EndCity;
        
        BMKPlanNode* wayPointItem1             = [[BMKPlanNode alloc]init];
        wayPointItem1.pt                       = passStr;
        [starCoordinate addObject:wayPointItem1];
        [self openMapViewStartCityName:staCityName startPT:straPoin endCityName:endCityName endPT:end andWayArray:starCoordinate];
    }
}

#pragma mark - 发起线路规划
- (void)openMapViewStartCityName:(NSString *)cityName startPT:(CLLocationCoordinate2D)startPt endCityName:(NSString *)city endPT:(CLLocationCoordinate2D)endPt andWayArray:(NSMutableArray *)array
{
    //发起检索
    BMKPlanNode* start = [[BMKPlanNode alloc]init] ;
    //    start.cityName = cityName;
    start.pt = startPt;
    
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    //    end.cityName = city;
    end.pt = endPt;
    
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

- (void)onGetTransitRouteResult:(BMKRouteSearch *)searcher result:(BMKTransitRouteResult *)result errorCode:(BMKSearchErrorCode)error {
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        BMKTransitRouteLine* plan = (BMKTransitRouteLine*)[result.routes objectAtIndex:0];
        NSLog(@"juli is == %d公里", plan.distance / 1000);
        NSInteger size = [plan.steps count];
        NSLog(@"size == %ld", (long)size);
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKTransitStep *tansitStep = [plan.steps objectAtIndex:i];
            if (i == 0 ) {
                RouteAnnotation *item = [[RouteAnnotation alloc] init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; //添加起点标注
            } else if (i == size - 1) {
                RouteAnnotation *item = [[RouteAnnotation alloc] init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item];
            }
            RouteAnnotation *item = [[RouteAnnotation alloc] init];
            item.coordinate = tansitStep.entrace.location; //路段入口信息
            item.title = tansitStep.instruction; //路程换成说明
            item.type = 3;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += tansitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts]; //文件后缀名改为mm
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKTransitStep *transitStep = [plan.steps objectAtIndex:j];
            int k = 0;
            for (k = 0; k < transitStep.pointsCount; k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
        }
        //通过points构建BMKPolyline
        BMKPolyline *polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; //添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        //当路线起终点有歧义时通，获取建议检索起终点
        //result.routeAddrResult
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}

- (void)onGetDrivingRouteResult:(BMKRouteSearch *)searcher result:(BMKDrivingRouteResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        
        BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i == 0 ){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [self.mapView addAnnotation:item]; // 添加起点标注
            }
            if(i == size-1){
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

- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode {
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        for (int i = 0; i < poiResult.poiInfoList.count; i++) {
            BMKPoiInfo *info = [poiResult.poiInfoList objectAtIndex:i];
            NSLog(@"地址：%@", info.name);
        }
    }
}
//
//- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
//    
//    CLLocationCoordinate2D carLocation = [_mapView convertPoint:self.view.center toCoordinateFromView:self.view];
//    BMKReverseGeoCodeOption *option = [[BMKReverseGeoCodeOption alloc] init];
//    option.reverseGeoPoint = CLLocationCoordinate2DMake(carLocation.latitude, carLocation.longitude);
//    NSLog(@"%f - %f", option.reverseGeoPoint.latitude, option.reverseGeoPoint.longitude);
//    //调用发地址编码方法，让其在代理方法onGetReverseGeoCodeResult中输出
//    [_geoCodeSearch reverseGeoCode:option];
//    
//    
//}

//返回地理反编码
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    if (result) {
        NSLog(@"%@ - %@ - %@ - %@ - %@", result.addressDetail.province, result.addressDetail.city, result.addressDetail.streetName, result.address, result.businessCircle);
        //把result.poiList存储到数组中，然后在tableView中显示出来
        
    } else {
        NSLog(@"找不到");
    }
}

- (void)selfLoction
{
    _locService.delegate = self;
    //启动LocationService
    
    _mapView.zoomLevel = 14.1;
    _mapView.showsUserLocation = NO;//是否显示小蓝点，no不显示，我们下面要自定义的
    _mapView.userTrackingMode = BMKUserTrackingModeNone;
    //定位
    [_locService startUserLocationService];
    
//    [_mapView removeAnnotation:_pointAnnotation];
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
        return [self getRouteAnnotationView:mapView viewForAnnotation:annotation];
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
                view.image = [UIImage imageNamed:@"icon_nav_start.png"];
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
                view.image = [UIImage imageNamed:@"icon_nav_end.png"];
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
    _mapView.showsUserLocation = NO;//显示用户位置
    [_mapView updateLocationData:userLocation];
    //    _mapView.centerCoordinate = userLocation.location.coordinate; //让地图的中心位置在这里
    [_locService stopUserLocationService];
#pragma mark  添加大头针气泡
    _pointAnnotation = [[BMKPointAnnotation alloc] init];
    _pointAnnotation.coordinate = userLocation.location.coordinate;
    //    _pointAnnotation.title = @"我在这个地方";
    //    _pointAnnotation.subtitle = @"你在哪呢";
    [_mapView addAnnotation:_pointAnnotation];
    [_mapView selectAnnotation:_pointAnnotation animated:YES];
}


- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    NSLog(@"heading is %@",userLocation.heading);
}











- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

