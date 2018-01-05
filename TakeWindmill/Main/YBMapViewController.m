//
//  YBMapViewController.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/15.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBMapViewController.h"

@interface YBMapViewController ()

@end

@implementation YBMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //初始化地图开启定位
    [self initMapView];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    
    //开启反地理编码
    _geocodesearch = [[BMKGeoCodeSearch alloc] init];
    _geocodesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    self.mapView.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    
    _mapView.delegate = nil; // 不用时，置nil
    _geocodesearch.delegate = nil;

}

- (void)positioningButton:(UIButton *)btn {
    
    if (self.positionUserLocation.location) {//位置不为空
        //获取用户的坐标
        self.mapView.centerCoordinate = self.positionUserLocation.location.coordinate;
        //展示定位
        self.mapView.showsUserLocation = YES;
    }else {
        //开启定位
        [self.locationService startUserLocationService];
    }
    //比例尺级别
    _mapView.zoomLevel = 18;
}


- (void)initMapView {
    //初始化地图
    _mapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
    //添加地图至view
    self.view = self.mapView;
    self.mapView.delegate = self;
    //开启定位
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//定位模式
    //比例尺
    _mapView.showMapScaleBar = YES;
    //比例尺级别
    _mapView.zoomLevel = 18;
    
    //初始化启动定位
    self.locationService = [[BMKLocationService alloc] init];
    //设置代理
    self.locationService.delegate = self;
    //开启定位
    [self.locationService startUserLocationService];
    
    //定位按钮
    self.Positioning = [YBBaseButton imageButtonWithFrame:CGRectMake(10, self.view.bounds.size.height - 140, 25, 25) image:nil BackgroundColor:[UIColor whiteColor] cornerRadius:0 setBackgroundImage:[UIImage imageNamed:@"中心定位"]];
    [self.Positioning addTarget:self action:@selector(positioningButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.Positioning];
    
    if (self.navigationController) {
        self.navigationController.navigationBar.translucent = NO;
        self.Positioning.frame = CGRectMake(10, self.view.bounds.size.height - 164, 25, 25);
    }
    
}


/**
 * 用户位置更新后，会调用此函数
 * @param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    
    if (userLocation.location) {//定位成功 关闭定位
        //更新位置数据
        [self.mapView updateLocationData:userLocation];
        //获取用户的坐标
        self.mapView.centerCoordinate = userLocation.location.coordinate;
        self.positionUserLocation = userLocation;
        //展示定位
//        self.mapView.showsUserLocation = YES;

        BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];//初始化反编码请求
        reverseGeocodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;//设置反编码的店为pt
        BOOL flag =   [self.geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
        if (flag) {
//            YBLog(@"定位成功");
            [self.locationService stopUserLocationService];
        }else {
            [MBProgressHUD showError:@"定位失败" toView:self.view];
        }
        return;
    }
    [MBProgressHUD showError:@"定位失败" toView:self.view];
}


//-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
//{
//    
//    self.geoCodeResult = result;
//    NSLog(@"address:%@----%@-----%@-------%@------%@------%@------",result.addressDetail,result.address,result.businessCircle,result.sematicDescription,result.cityCode,result.poiList);
//    
//    
//    //addressDetail:     层次化地址信息
//    
//    //address:    地址名称
//    
//    //businessCircle:  商圈名称
//    
//    // location:  地址坐标
//    
//    //  poiList:   地址周边POI信息，成员类型为BMKPoiInfo
//}



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
