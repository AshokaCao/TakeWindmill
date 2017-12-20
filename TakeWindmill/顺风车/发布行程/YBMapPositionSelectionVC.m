//
//  YBMapPositionSelectionVC.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/15.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBMapPositionSelectionVC.h"
#import "YBOnTheTrainVC.h"
#import "YBOwnerTravelVC.h"
#import "YBAddressSearchSelectionVC.h"
#import "YBAddressSearchSelectionVC.h"

#import "YBSearchColumnView.h"
#import "YBWaitingView.h"

@interface YBMapPositionSelectionVC ()<BMKGeoCodeSearchDelegate>

@property (nonatomic, strong) UIView * locAtionView;
//中心点图片
@property (nonatomic, strong) UIImageView * locnImageView;
//我的位置语义化信息
@property (nonatomic, strong) UILabel *positionLabel;
//子标题详细位置
@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) BMKGeoCodeSearch *codSearch;

/**
 * 显示地图中心点位置
 */
@property (nonatomic, weak) UIView *specificLocationView;

/**
 * 起点所在的位置信息
 */
@property (nonatomic, strong) BMKReverseGeoCodeResult *startingPoint;


@end

@implementation YBMapPositionSelectionVC

- (UIView *)specificLocationView {
    if (!_specificLocationView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(self.Positioning.frame) + 20 , YBWidth - 20, 80)];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        _specificLocationView = view;

    }
    return _specificLocationView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    //搜索框
    [self searchView];
    
    //具体位置
    [self viewControlsUI];
    
    [self createLocationSignImage];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.codSearch.delegate = nil;

}

- (void)createLocationSignImage{
    
    self.codSearch.delegate = self;
    
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

- (void)viewControlsUI {
    
    CGFloat imageW = 15;
    
    //标题
    NSString *str = @"我的位置";
    self.positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + imageW + 10, 0, self.specificLocationView.frame.size.width - 100, 40)];
    self.positionLabel.font = YBFont(14);
    self.positionLabel.numberOfLines = 0;
    self.positionLabel.text = str;
    [self.specificLocationView addSubview:self.positionLabel];
    
    CGRect rect = [str boundingRectWithSize:CGSizeMake(self.positionLabel.frame.size.width, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: YBFont(14)} context:nil];
    
    self.positionLabel.frame = CGRectMake(20 + imageW + 10, 20, self.positionLabel.frame.size.width ,rect.size.height);
    
    //子标题
    NSString *subStr = @"中国";
    _subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.positionLabel.frame.origin.x + 10, CGRectGetMaxY(self.positionLabel.frame), self.positionLabel.frame.size.width, 40)];
    _subTitleLabel.font = YBFont(12);
    _subTitleLabel.numberOfLines = 0;
    _subTitleLabel.text = subStr;
    _subTitleLabel.textColor = [UIColor lightGrayColor];
    [self.specificLocationView addSubview:_subTitleLabel];
    CGRect subRect = [subStr boundingRectWithSize:CGSizeMake(self.positionLabel.frame.size.width, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: YBFont(12)} context:nil];
    _subTitleLabel.frame = CGRectMake(self.positionLabel.frame.origin.x, CGRectGetMaxY(self.positionLabel.frame), self.positionLabel.frame.size.width, subRect.size.height);
    
    //计算view的动态高度
    self.specificLocationView.frame = CGRectMake(10,CGRectGetMaxY(self.Positioning.frame) + 20 , YBWidth - 20, CGRectGetMaxY(_subTitleLabel.frame) + 20);
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, self.specificLocationView.frame.size.height / 2 - 10, imageW, imageW + 5)];
    imageView.image = [UIImage imageNamed:@"起点图标"];
    [self.specificLocationView addSubview:imageView];

    
    //确定按钮
    YBBaseButton *okButton = [YBBaseButton buttonWithFrame:CGRectMake(CGRectGetMaxX(_subTitleLabel.frame), 0, self.specificLocationView.frame.size.width - CGRectGetMaxX(self.positionLabel.frame), self.specificLocationView.frame.size.height) Strtitle:@"确定" titleColor:[UIColor grayColor] titleFont:14 textAlignment:NSTextAlignmentCenter image:nil BackgroundColor:nil cornerRadius:0];
    [okButton addTarget:self action:@selector(okButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.specificLocationView addSubview:okButton];    

}

- (void)searchView {
    
    //搜索
    YBSearchColumnView *searchView = [[YBSearchColumnView alloc] initWithFrame:CGRectMake(0, 0, YBWidth, 64)];
    searchView.isEnter             = NO;
    searchView.cityStr             = self.cityName;
    [searchView.cancelButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchView];

    //选择城市
    searchView.seleCityButtonBlock = ^(UIButton *sender) {
        YBAddressSearchSelectionVC *city = [[YBAddressSearchSelectionVC alloc] init];
        city.cityname = self.startingPoint.addressDetail.city;
        city.typesOf  = @"起点";
        [self presentViewController:city animated:YES completion:nil];
    };

    searchView.addressButtonBlock = ^(UIButton *sender) {
        YBAddressSearchSelectionVC *selec = [[YBAddressSearchSelectionVC alloc] init];
        selec.cityname = self.startingPoint.addressDetail.city;
        selec.typesOf  = @"起点";
        [self presentViewController:selec animated:YES completion:nil];
    };
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    
    CGPoint touchPoint = self.locAtionView.center;
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];//这里touchMapCoordinate就是该点的经纬度了
    
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];//初始化反编码请求
    reverseGeocodeSearchOption.reverseGeoPoint = touchMapCoordinate;//设置反编码的店为pt
    BOOL flag =   [self.geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if (flag) {
        YBLog(@"定位搜索成功");
    }
    else {
        [MBProgressHUD showError:@"位置搜索失败" toView:self.view];
    }
}

-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    self.startingPoint = result;
    self.positionLabel.text =  result.sematicDescription;
    self.subTitleLabel.text = result.address;    
}

- (void)okButtonAction:(UIButton *)sender {

    if (self.startingPoint) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(popVCPassTheValue:)]) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:self.startingPoint.cityCode forKey:@"CityId"];//城市id
            [dict setObject:[NSString stringWithFormat:@"%f",self.startingPoint.location.longitude ] forKey:@"Lng"];//
            [dict setObject:[NSString stringWithFormat:@"%f",self.startingPoint.location.latitude ] forKey:@"Lat"];//
            [dict setObject:self.startingPoint.address forKey:@"Address"];//地址名称
            [dict setObject:self.startingPoint.addressDetail.district forKey:@"District"];//所在区域
            [dict setObject:self.startingPoint.sematicDescription forKey:@"Name"];
            [dict setObject:self.startingPoint.addressDetail.city forKey:@"City"];

            [self.delegate popVCPassTheValue:dict];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)backAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
