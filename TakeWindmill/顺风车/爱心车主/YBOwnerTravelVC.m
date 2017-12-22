//
//  YBOwnerTravelVC.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/9/9.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBOwnerTravelVC.h"
#import "YBCitySelectionVC.h"
#import "YBLookingPassengersrVC.h"
#import "YBMapPositionSelectionVC.h"
#import "YBAddressSearchSelectionVC.h"

#import "YBOwnerTravelView.h"
#import "YBTravelTime.h"
#import "SelectedListView.h"

@interface YBOwnerTravelVC ()<BMKRouteSearchDelegate,YBAddressSearchSelectionVCDelegate,YBCitySelectionVCDelegate>

/**
 * 中心点图片
 */
@property (nonatomic, strong) UIImageView * locnImageView;

/**
 * 搜索view
 */
@property (nonatomic, weak) YBOwnerTravelView *travelView;

/**
 * 发布按钮
 */
@property (nonatomic, weak) UIButton *confirmBtn;

/**
 * 起点位置信息
 */
@property (nonatomic, strong) NSDictionary *startingPointDict;

/**
 * 终点位置信息
 */
@property (nonatomic, strong) NSDictionary *endPointDict;

/**
 * 线路规划
 */
@property (nonatomic, strong) BMKRouteSearch *routeSearch;

/**
 * 搜索
 */
@property (nonatomic, strong) BMKGeoCodeSearch *codSearch;

/**
 * 座位数量
 */
@property (nonatomic, strong) NSString *seatsNumber;

/**
 * 出发时间
 */
@property (nonatomic, strong) NSString *departureTime;
//行程公里
@property (nonatomic, assign) int travelMeters;

@end

@implementation YBOwnerTravelVC

#pragma mark - lazy
- (UIImageView *)locnImageView
{
    if (!_locnImageView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"定位图标"];
        [self.view addSubview:imageView];
        _locnImageView = imageView;
    }
    return _locnImageView;
}


- (YBOwnerTravelView *)travelView
{
    if (!_travelView) {
        YBOwnerTravelView *travelView = [[YBOwnerTravelView alloc] init];
        [self.view addSubview:travelView];
        _travelView = travelView;
    }
    return _travelView;
}

- (UIButton *)confirmBtn
{
    if (!_confirmBtn) {
        UIButton *confirmBtn          = [[UIButton alloc] init];
        confirmBtn.layer.cornerRadius = 5;
        confirmBtn.titleLabel.font    = YBFont(15);
        [confirmBtn setBackgroundColor:BtnBlueColor];
        [confirmBtn setTitle:@"确认发布" forState:UIControlStateNormal];
        [confirmBtn addTarget:self action:@selector(lookingForPassengers:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:confirmBtn];
        _confirmBtn = confirmBtn;
    }
    return _confirmBtn;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化View
    [self scrollViewUI];
    //通知
    [self notificationCenter];
    //显示地图中心点
    [self createLocationSignImage:self.mapView.centerCoordinate];   
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"passengerSide_pointSelection" object:nil];
    self.routeSearch.delegate = nil;
    self.codSearch.delegate = nil;
}

- (void)notificationCenter
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTheStartingPoint:) name:@"passengerSide_pointSelection" object:nil];
}

- (void)createLocationSignImage:(CLLocationCoordinate2D)pt
{
    self.codSearch.delegate = self;
    
    //把当前定位的经纬度换算为了View上的坐标
    CGPoint point = [self.mapView convertCoordinate:pt toPointToView:self.mapView];
    
    //当解析出现错误的时候，会出现超出屏幕的情况，一种是大于了屏幕，一种是小于了屏幕
    if(point.x > YBWidth || point.x < YBWidth/5){
        point.x = YBWidth / 2;
        point.y = (YBHeight + 64) / 2 ;
    }
    self.locnImageView.center = point;
    [self.locnImageView setFrame:CGRectMake( point.x - 10, point.y - 29, 20, 29)];
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    MKCoordinateRegion region;
    CLLocationCoordinate2D centerCoordinate = mapView.region.center;
    region.center = centerCoordinate;
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];//初始化反编码请求
    reverseGeocodeSearchOption.reverseGeoPoint = centerCoordinate;//设置反编码的店为pt
    BOOL flag =   [self.geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if (flag) {
        YBLog(@"定位搜索成功");
    }
}

#pragma mark - 初始化UI
- (void)scrollViewUI
{
    self.title = @"发布行程";
    self.travelView.frame = CGRectMake(10, 10, YBWidth - 20, 140);
    self.confirmBtn.frame = CGRectMake(10, YBHeight - 50, YBWidth - 20, 40);
    
    //点击了终点
    self.travelView.endPoint.selectBlock = ^(YBBaseView *view) {
//        if (self.travelView.oneWayButton.selected) {
            YBAddressSearchSelectionVC *selec = [[YBAddressSearchSelectionVC alloc] init];
            selec.addDelegate                 = self;
            selec.typesOf = @"终点";
            if ([self.travelView.endPoint.label.text isEqualToString:@"你要去哪儿"]) {
                selec.cityname = self.startingPointDict[@"City"];
            }
            else {
                selec.cityname = [self.travelView.endPoint.label.text componentsSeparatedByString:@"·"][0];
            }
            [self presentViewController:selec animated:YES completion:nil];
//        }
//        if (self.travelView.roundTripButton.selected) {
//            YBCitySelectionVC *city = [[YBCitySelectionVC alloc] init];
//            city.isPush             = 1;
//            city.cross_City         = @"跨城";
//            [self presentViewController:city animated:YES completion:nil];
//        }
    };
    
    //点击了几座
    self.travelView.seatView.selectBlock = ^(YBBaseView *view) {
        [self numberPeopleAction:view];
    };
    
    //点击了时间
    self.travelView.timeView.selectBlock = ^(YBBaseView *view) {
        [self TravelTime:view];
    };
}

- (void)popViewControllerPassTheValueDict:(NSDictionary *)value
{
    YBAddressSearchSelectionVC *selec = [[YBAddressSearchSelectionVC alloc] init];
    selec.addDelegate                 = self;
    selec.typesOf                     = @"终点";
    selec.cityname                    = value[@"city"] ;
    [self presentViewController:selec animated:YES completion:nil];
    
}

//#pragma  makr - 起点代理
//- (void)popVCPassTheValue:(NSDictionary *)value
//{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        self.startingPointDict = value;
//
//        [self.travelView.startPoint initLabelStr:[NSString stringWithFormat:@"%@·%@",self.startingPointDict[@"City"],self.startingPointDict[@"Name"]]];
//        if ([self.travelView.endPoint.label.text isEqualToString:@"你要去哪儿"]) {
//            [MBProgressHUD showError:@"请输入终点位置" toView:self.view];
//            return ;
//        }
//    });
//}
//
#pragma mark - 终点位置位置
- (void)setTheStartingPoint:(NSNotification *)notificatin {

    dispatch_async(dispatch_get_main_queue(), ^{

        self.endPointDict = [notificatin.userInfo objectForKey:@"startingPoint"];
        NSString *progress = [NSString stringWithFormat:@"%@·%@",self.endPointDict[@"City"],self.endPointDict[@"Name"]];
        [self.travelView.endPoint initLabelStr:progress];
        
        //没选择起点
        if ([self.travelView.endPoint.label.text isEqualToString:@"你现在哪儿"]) {
            [MBProgressHUD showError:@"请输入起点位置" toView:self.view];
            return ;
        }
        //跳转时间
        if ([self.travelView.timeView.label.text isEqualToString:@"出发时间"]) {
            [self TravelTime:nil];
            return ;
        }

    });
}

#pragma mark - 终点代理
- (void)popViewControllerPassTheValue:(NSDictionary *)value
{
    if ([self.travelView.startPoint.label.text isEqualToString:@"你在哪儿"]) {
        [MBProgressHUD showError:@"请选择起点位置" toView:self.view];
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _routeSearch            = [[BMKRouteSearch alloc]init];
        _routeSearch.delegate   = self;
        self.endPointDict = value;
        NSString *progress = [NSString stringWithFormat:@"%@·%@",self.endPointDict[@"City"],self.endPointDict[@"Name"]];
        [self.travelView.endPoint initLabelStr:progress];
        [self openMapViewStartCity:self.startingPointDict[@"City"] StartLat:self.startingPointDict[@"Lat"] StartLng:self.startingPointDict[@"Lng"] EndCity:self.endPointDict[@"City"] EndLat:self.endPointDict[@"Lat"] EndLng:self.endPointDict[@"Lng"]];
        
        //没选择起点
        if ([self.travelView.endPoint.label.text isEqualToString:@"你现在哪儿"]) {
            [MBProgressHUD showError:@"请输入起点位置" toView:self.view];
            return ;
        }
        //跳转时间
        if ([self.travelView.timeView.label.text isEqualToString:@"出发时间"]) {
            [self TravelTime:nil];
            return ;
        }
    });
}

- (void)openMapViewStartCity:(NSString *)startCity StartLat:(NSString *)StartLat StartLng:(NSString *)StartLng EndCity:(NSString *)endCity  EndLat:(NSString *)EndLat EndLng:(NSString *)EndLng
{
    //发起检索
    //起点
    BMKPlanNode* start        = [[BMKPlanNode alloc]init] ;
    start.cityName            = startCity;
    CLLocationCoordinate2D pt = CLLocationCoordinate2DMake([StartLat doubleValue],[StartLng doubleValue]);
    start.pt                  = pt;
    //终点
    BMKPlanNode* end             = [[BMKPlanNode alloc]init];
    end.cityName                 = endCity;
    CLLocationCoordinate2D endPt = CLLocationCoordinate2DMake([EndLat doubleValue],[EndLng doubleValue]);
    end.pt                       = endPt;
    
    BMKDrivingRoutePlanOption *driveRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
    driveRouteSearchOption.from                       = start;
    driveRouteSearchOption.to                         = end;
    
    BOOL flag = [self.routeSearch drivingSearch:driveRouteSearchOption];
    if (flag) {
        YBLog(@"线路规划检索成功");
    }
    else{
        YBLog(@"线路规划检索失败");
    }
}

- (void)onGetDrivingRouteResult:(BMKRouteSearch *)searcher result:(BMKDrivingRouteResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {//途经点城市写死
        BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
        
        self.travelMeters = plan.distance;
//        if (result.suggestAddrResult.wayPointCityList) {
//            for (BMKCityListInfo *listInfo in result.suggestAddrResult.wayPointCityList) {
////                YBLog(@"%@",listInfo.city);
//            }
//        }
        NSArray *array = [result.routes[0] wayPoints];
        YBLog(@"%@-------- %ld",array,[result.routes[0] congestionMetres]);
    }
}


#pragma mark - 乘车几座
- (void)numberPeopleAction:(YBBaseView *)sender {
    
    SelectedListView *view = [[SelectedListView alloc] initWithFrame:CGRectMake(0, 0, YBWidth, 0) style:UITableViewStylePlain];
    view.isSingle = YES;
    view.array = @[[[SelectedListModel alloc] initWithSid:0 Title:@"1座"] ,
                   [[SelectedListModel alloc] initWithSid:1 Title:@"2座"] ,
                   [[SelectedListModel alloc] initWithSid:2 Title:@"3座"] ,
                   [[SelectedListModel alloc] initWithSid:3 Title:@"4座"]];
    view.selectedBlock = ^(NSArray<SelectedListModel *> *array) {
        
        [LEEAlert closeWithCompletionBlock:^{
            
            if ([self.travelView.endPoint.label.text isEqualToString:@"你要去哪儿"]) {
                [MBProgressHUD showError:@"请先选择出行终点" toView:self.view];
                return ;
            }
            
            SelectedListModel *model                   = array[0];
            self.travelView.seatView.label.text = model.title;
            self.seatsNumber = [NSString stringWithFormat:@"%ld", model.sid + 1];//座位数量
    }];
        
    };
    [LEEAlert actionsheet].config
    .LeeTitle(@"愿提供的座位数")
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


#pragma mark - 出发时间
- (void)TravelTime:(UIView *)view {
    
    if ([self.travelView.startPoint.label.text isEqualToString:@"你在哪儿"] || [self.travelView.endPoint.label.text isEqualToString:@"你要去哪儿"]) {
        [MBProgressHUD showError:@"请先选择起点与终点" toView:self.view];
        return;
    }
    
    YBTravelTime *time  = [[YBTravelTime alloc] initWithFrame:CGRectMake(0, 0, YBWidth, 260)];
    time.leftButtonStr  = @"返回";
    time.rightButtonStr = @"确定";
    time.deadStr        = @"出发时间";
    time.isHideBottom   = YES;
    
    time.selectBlock = ^(NSDictionary *dict) {
        [LEEAlert closeWithCompletionBlock:^{
            self.departureTime = dict[@"standardTime"];
            [self.travelView.timeView initLabelStr:dict[@"displayTime"]];
            
            //跳转作为
            if ([self.travelView.seatView.label.text isEqualToString:@"选择座位"]) {
                [self numberPeopleAction:nil];
                return ;
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

#pragma mark - 确认发布//保存行程
- (void)lookingForPassengers:(UIButton *)sender
{

    if (![self.travelView.seatView.label.text isEqualToString:@"选择座位"] && ![self.travelView.timeView.label.text isEqualToString:@"出发时间"] && ![self.travelView.startPoint.label.text isEqualToString:@"你在哪儿"] && ![self.travelView.endPoint.label.text isEqualToString:@"你要去哪儿"]) {
        
        NSString *urlStr = travelinfodriversavePath;
        NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
        [dict setObject:[YBTooler getTheUserId:self.view] forKey:@"userid"];//用户id
        [dict setObject:@"1" forKey:@"traveltypefid"];//行程类型 1-顺风车 2-出租车
        [dict setObject:self.startingPointDict[@"Lng"] forKey:@"startlng"];//起点经度
        [dict setObject:self.startingPointDict[@"Lat"] forKey:@"startlat"];//起点维度
        [dict setObject:self.startingPointDict[@"CityId"] forKey:@"startcityid"];//起点城市的id
        [dict setObject:self.startingPointDict[@"City"] forKey:@"startcity"];//起点城市
        [dict setObject:self.startingPointDict[@"Name"] forKey:@"startaddress"];//起点地址
        [dict setObject:self.endPointDict[@"Lng"] forKey:@"endlng"];//终点经度
        [dict setObject:self.endPointDict[@"Lat"] forKey:@"endlat"];//终点纬度
        [dict setObject:self.endPointDict[@"CityId"] forKey:@"endcityid"];//终点城市的id
        [dict setObject:self.endPointDict[@"City"] forKey:@"endcity"];//终点城市
        [dict setObject:self.endPointDict[@"Name"]  forKey:@"endaddress"];//终点地址
        [dict setObject:self.seatsNumber forKey:@"seatnumber"];//座位数量
        [dict setObject:self.departureTime forKey:@"setouttime"];//出发时间
        [dict setObject:@"杭州市" forKey:@"passcitys"];//途径城市写死了
        
        [YBRequest postWithURL:urlStr MutableDict:dict success:^(id dataArray) {
            YBLookingPassengersrVC *looking = [[YBLookingPassengersrVC alloc] init];
            looking.strokeSysNo             = dataArray[@"SysNo"];
            [self.navigationController pushViewController:looking animated:YES];
        } failure:^(id dataArray) {
            YBLog(@"%@",dataArray);
        }];
    }
    else{
        [MBProgressHUD showError:@"请填写完整的行程！" toView:self.view];
    }
}

#pragma mark - delegate
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (result.sematicDescription) {
      
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:result.cityCode forKey:@"CityId"];//城市id
        [dict setObject:[NSString stringWithFormat:@"%f",result.location.longitude ] forKey:@"Lng"];//
        [dict setObject:[NSString stringWithFormat:@"%f",result.location.latitude ] forKey:@"Lat"];//
        [dict setObject:result.address forKey:@"Address"];//地址名称
        [dict setObject:result.addressDetail.district forKey:@"District"];//所在区域
        NSArray *nameStr = [result.sematicDescription componentsSeparatedByString:@","];
        [dict setObject:nameStr[0] forKey:@"Name"];
        [dict setObject:result.addressDetail.city forKey:@"City"];
        self.startingPointDict = dict;
        
        NSString *str = [NSString stringWithFormat:@"%@·%@",dict[@"City"],dict[@"Name"]];
        [self.travelView.startPoint initLabelStr:str];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
