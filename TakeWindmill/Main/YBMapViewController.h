//
//  YBMapViewController.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/15.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBMapViewController : UIViewController <BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
//基本地图
@property (nonatomic, strong) BMKMapView *mapView;
//定位功能
@property (nonatomic, strong) BMKLocationService *locationService;
//用户位置坐标
@property (nonatomic, strong) BMKUserLocation *positionUserLocation;
//反地理编码
@property (nonatomic, strong) BMKGeoCodeSearch *geocodesearch;
/**
 * 搜索结果
 */
//@property (nonatomic, strong) BMKReverseGeoCodeResult *geoCodeResult;

/**
 * 定位按钮
 */
@property (nonatomic, strong) YBBaseButton *Positioning;

//初始化定位地图
- (void)initMapView;

@end
