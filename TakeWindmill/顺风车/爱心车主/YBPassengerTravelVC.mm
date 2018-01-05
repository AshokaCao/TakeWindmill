//
//  YBPassengerTravelVC.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/9/5.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBPassengerTravelVC.h"
#import "YBPassengerCanBeBuiltVC.h"
#import "YBEvaluationPassengersVC.h"
#import "YBDriverPassengerTravelVCViewController.h"

#import "YBWaitingView.h"
#import "YBThanksFee.h"
#import "YBThanksTheFee.h"
#import "RouteAnnotation.h"

@interface YBPassengerTravelVC ()<BMKRouteSearchDelegate> {
    UIButton *passengerButton;
}

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
@property (nonatomic, strong) UIView *navigationView;

@property (nonatomic, strong) UIView *navV;

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
        _navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBWidth / 2, 44)];

        passengerButton  = [UIButton new];
        passengerButton.layer.cornerRadius = 15;
//        passengerButton.imageView.layer.borderColor  = BtnBlueColor.CGColor;
//        passengerButton.imageView.layer.borderWidth  = 1;
        passengerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
        [passengerButton setImage:[UIImage imageNamed:@"headimg.gif"] forState:UIControlStateNormal];
        [_navigationView addSubview:passengerButton];
        
        [passengerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_navigationView).with.offset(20);
            make.top.equalTo(_navigationView);
            make.size.mas_equalTo(CGSizeMake(34, 34));
        }];
        
        UILabel *passengerLabel = [UILabel new];
        passengerLabel.text     = @"乘客一";
        passengerLabel.font     = YBFont(10);
        passengerLabel.textColor = [UIColor lightGrayColor];
        [_navigationView addSubview:passengerLabel];
        
        [passengerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(passengerButton.mas_bottom);
            make.bottom.equalTo(_navigationView.mas_bottom);
            make.left.equalTo(passengerButton.mas_left);
            make.width.equalTo(passengerButton);
        }];
        

        UIButton *add = [UIButton new];
        add.layer.borderColor  = LineLightColor.CGColor;
        add.layer.cornerRadius = 17;
        add.layer.borderWidth  = 1;
        [add setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        [add addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_navigationView addSubview:add];
        [add mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(passengerButton.mas_right).with.offset(20);
            make.top.equalTo(passengerButton.mas_top);
            make.size.equalTo(passengerButton);
        }];
        
        UILabel *addLabel = [UILabel new];
        addLabel.text     = @"可拼乘客";
        addLabel.font     = YBFont(10);
        addLabel.textColor = [UIColor lightGrayColor];
        [_navigationView addSubview:addLabel];
        
        [addLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(add.mas_bottom);
            make.bottom.equalTo(_navigationView.mas_bottom);
            make.left.equalTo(passengerButton.mas_right).with.offset(17);
//            make.width.mas_equalTo(50);
        }];
    }
    return _navigationView;
}

- (YBWaitingView *)waitingView
{
    if (!_waitingView) {
        YBWaitingView *waiting  = [[YBWaitingView alloc] initWithFrame:CGRectMake(5, YBHeight - 240, YBWidth - 10, 220)];
        waiting.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:waiting];
        
        WEAK_SELF;
        __weak __typeof__(waiting) waitingS = waiting;
        waiting.clickeBlock = ^(UIButton *sender) {
            if (sender.tag == 2 || sender.tag == 3) {
                [waitingS passengerTravel_ConfirmPeer:sender.tag];
                sender.tag ++;
            }
            else if (sender.tag == 4){
                YBEvaluationPassengersVC *ebalu = [[YBEvaluationPassengersVC alloc] init];
                [self.navigationController pushViewController:ebalu animated:YES];
            }
            else if (sender.tag == 0){//点击确认同行
                NSArray *timeArray = [self.passengerDict[@"SetoutTimeStr"] componentsSeparatedByString:@"+"];
                NSString *messageStr = [NSString stringWithFormat:@"乘客 %@ %@ 出发,是否确认?",timeArray[0],timeArray[1]];
                
                [LEEAlert alert].config
                .LeeTitle(@"提示")
                .LeeContent(messageStr)
                .LeeCancelAction(@"取消", ^{
                    // 取消点击事件Block
                })
                .LeeAction(@"确认同行", ^{
                    // 确认点击事件Block
                    sender.tag ++;
                    [weakSelf confirmCounterpartsPost];
                    [waitingS passengerTravel_ConfirmPeer:sender.tag];
                })
                .LeeShow();
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
    
    self.navigationItem.titleView = self.navigationView;
    //请求乘客行程信息
    [self networkRequestPassengerTravel];
    //请求司机信息
    [self networkRequest];
    
}

- (void)dealloc
{
    _routeSearch.delegate = nil;
}

#pragma mark - 可拼乘客
- (void)addButtonAction:(UIButton *)sender {
    YBPassengerCanBeBuiltVC *passenger = [[YBPassengerCanBeBuiltVC alloc] init];
    passenger.strokeSysNo              = self.driverDict[@"SysNo"];
    passenger.travelSysNo              = self.passengerDict[@"SysNo"];
    [self.navigationController pushViewController:passenger animated:YES];
}

#pragma mark - 给乘客打电话
- (void)phoneButtonActoin:(UIButton *)sender {
    [YBTooler dialThePhoneNumber:_passengerDict[@"Mobile"] displayView:self.view];
}

#pragma mark - 点击确认同行
- (void)confirmCounterpartsPost
{
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    [dict setObject:self.TravelSysNo forKey:@"travelsysno"];
    [dict setObject:[YBTooler getTheUserId:self.view] forKey:@"userid"];
    
    [YBRequest postWithURL:drivertravelbindpassengerPath MutableDict:dict View:self.waitingView success:^(id dataArray) {
        YBLog(@"点击确认同行%@",dataArray);
        YBDriverPassengerTravelVCViewController *driver = [[YBDriverPassengerTravelVCViewController alloc] init];
        driver.SysNo = self.driverDict[@"SysNo"];
        [self.navigationController pushViewController:driver animated:YES];
    } failure:^(id dataArray) {
        YBLog(@"%@",dataArray);
    }];
}

#pragma mark - 邀请乘客行程信息
- (void)networkRequestPassengerTravel
{
    WEAK_SELF;
    _passengerDict = [NSDictionary dictionary];
    
    NSString *urlStr          = travelinfodetailbysysnoPath;
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    [dict setObject:self.TravelSysNo forKey:@"travelsysno"];
    [dict setObject:[YBTooler getTheUserId:self.view] forKey:@"userid"];
    
    [YBRequest postWithURL:urlStr MutableDict:dict View:self.waitingView success:^(id dataArray) {
        YBLog(@"乘客行程信息%@",dataArray);
        _passengerDict = dataArray;
        [passengerButton.imageView sd_setImageWithURL:[NSURL URLWithString:_passengerDict[@"HeadImgUrl"]] placeholderImage:[UIImage imageNamed:@"headimg.gif"]];
        //显示乘客信息
        [weakSelf.waitingView driverPassengerTravel:_passengerDict];
        if ([_passengerDict[@"StatName"] isEqualToString:@"行程已发"]) {
            [weakSelf.waitingView passengerTravel_ConfirmPeer:0];
        }
        if ([_passengerDict[@"StatName"] isEqualToString:@"司机已到达乘客上车点"]) {
            [weakSelf.waitingView passengerTravel_ConfirmPeer:1];
        }
        if ([_passengerDict[@"StatName"] isEqualToString:@"乘客已上车"]) {
            [weakSelf.waitingView passengerTravel_ConfirmPeer:2];
        }
        if ([_passengerDict[@"StatName"] isEqualToString:@"乘客已到达目的地"]) {
            [weakSelf.waitingView passengerTravel_ConfirmPeer:3];
        }
        if ([_passengerDict[@"StatName"] isEqualToString:@"行程已完结"]) {
            [weakSelf.waitingView passengerTravel_ConfirmPeer:4];
        }
        if ([_passengerDict[@"StatName"] isEqualToString:@"行程已取消"]) {
            [weakSelf.waitingView passengerTravel_ConfirmPeer:-1];
        }
        
    } failure:^(id dataArray) {
        YBLog(@"%@",dataArray);
    }];
    
    
}

#pragma mark - 司机行程
- (void)networkRequest
{
    [self DriversTripDcit:nil PassengerDict:nil];
    
    NSString *urlStr          = travelinfodriverdetailPath;
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    [dict setObject:self.SysNo forKey:@"travelsysno"];
    [dict setObject:[YBTooler getTheUserId:self.view] forKey:@"userid"];
    
    [YBRequest postWithURL:urlStr MutableDict:dict success:^(id dataArray) {
        YBLog(@"司机行程信息%@",dataArray);
        self.driverDict = dataArray;
        //订单详情
//        [self.waitingView inviteColleagues:dataArray];
        [self DriversTripDcit:dataArray PassengerDict:self.passengerDict];
    } failure:^(id dataArray) {
        YBLog(@"%@",dataArray);
        
    }];
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

