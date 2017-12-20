//
//  FirstAnnotationView.h
//  MapDemo
//
//  Created by rhjt on 16/7/22.
//  Copyright © 2016年 junjie. All rights reserved.
//

//#import <BaiduMapAPI_Map/BaiduMapAPI_Map.h>
#import <BaiduMapAPI_Map/BMKMapView.h>
@interface FirstAnnotationView : BMKAnnotationView
@property (nonatomic, strong) UIImageView *bgView; //点击气泡弹出的背景图
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *bottomLabel;
@end
