//
//  YBCarServicesVC.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/12.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBCarServicesVC.h"
#import "YBCar4sShopVC.h"
#import "YBServiceModels.h"
#import "YB4SListViewController.h"

@interface YBCarServicesVC ()
@property (nonatomic, strong) NSMutableArray *serviceArray;
@property (nonatomic, assign) NSInteger counts;
@end

@implementation YBCarServicesVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"汽车服务";
    self.view.backgroundColor = [UIColor whiteColor];
    self.mapView.zoomLevel = 16;
    self.counts = 0;
}

- (void)serviceLoctionData
{
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    dict[@"currentlat"] = [NSString stringWithFormat:@"%f",self.startingPoint.location.latitude];
    dict[@"currentlng"] = [NSString stringWithFormat:@"%f",self.startingPoint.location.longitude];
    NSLog(@"坐标 %@",dict);
    self.serviceArray = [NSMutableArray array];
    [YBRequest postWithURL:CarService MutableDict:dict success:^(id dataArray) {
        NSLog(@"dataArray - %@",dataArray);
        NSDictionary *dict = dataArray;
        NSDictionary *newDic = [NSDictionary changeType:dict];
        for (NSDictionary *diction in newDic[@"VehicleShopInfoList"]) {
            YBServiceModels *model = [YBServiceModels new];
            [model setValuesForKeysWithDictionary:diction];
            [self.serviceArray addObject:model];
        }
        [self addPointAnnotation];
    } failure:^(id dataArray) {
        
    }];
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    if (userLocation.location) {//定位成功 关闭定位
        //更新位置数据
        [self.mapView updateLocationData:userLocation];
        //获取用户的坐标
        self.mapView.centerCoordinate = userLocation.location.coordinate;
        //展示定位
        self.mapView.showsUserLocation = YES;
        
        BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];//初始化反编码请求
        reverseGeocodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;//设置反编码的店为pt
        
        BOOL flag =   [self.geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
        if (flag) {
            YBLog(@"定位成功%f",reverseGeocodeSearchOption.reverseGeoPoint.latitude);
            [self.locService stopUserLocationService];
        }else {
            [MBProgressHUD showError:@"定位失败" toView:self.view];
        }
        return;
    }
    [MBProgressHUD showError:@"定位失败" toView:self.view];
}

#pragma mark - 起点信息
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (result.sematicDescription) {
        self.startingPoint = result;
        if (self.counts == 0) {
            [self serviceLoctionData];
        }
        self.counts ++;
    }
}

- (void)addPointAnnotation {
    
    NSMutableArray *loctionArray = [NSMutableArray array];
    for (int i = 0; i < self.serviceArray.count; i++) {
        YBServiceModels *model = self.serviceArray[i];
        // 添加一个PointAnnotation
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = [model.ShopLat floatValue];
        coor.longitude = [model.ShopLng floatValue];
        annotation.title = [NSString stringWithFormat:@"%d",i];
        annotation.coordinate = coor;
        [loctionArray addObject:annotation];
    }
    
    [self.mapView addAnnotations:loctionArray];
    
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        //        newAnnotationView.pinColor = BMKPinAnnotationColorRed;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        newAnnotationView.image = [UIImage imageNamed:@"附近乘客"];
        return newAnnotationView;
    }
    return nil;
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view;
{
    if ([view.annotation isKindOfClass:[BMKPointAnnotation class]]) {
        YB4SListViewController *car = [[YB4SListViewController alloc] init];
        NSLog(@"view - - %@",view.annotation.title);
        int num = [[NSString stringWithFormat:@"%@",view.annotation.title] intValue];
        YBServiceModels *model = self.serviceArray[num];
        car.shopModel = model;
        [self.navigationController pushViewController:car animated:YES];
    }
    [mapView deselectAnnotation:view.annotation animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

