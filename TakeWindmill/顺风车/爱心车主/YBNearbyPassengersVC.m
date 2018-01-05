//
//  YBNearbyPassengersVC.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/9/4.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBNearbyPassengersVC.h"
#import "YBCitySelectionVC.h"
#import "YBPassengerTravelVC.h"

#import "YBNearbyCell.h"

@interface YBNearbyPassengersVC ()<UITableViewDelegate,UITableViewDataSource,BMKLocationServiceDelegate>

/**
 * 排序
 */
@property (nonatomic, strong) YBNearbyTitleView *titleView;
/**
 *
 */
@property (nonatomic, weak) UITableView *nearbyTableView;

/**
 * 底部
 */
@property (nonatomic, weak) UIView *footView;

/**
 * 定位功能
 */
@property (nonatomic, strong) BMKLocationService *locService;

/**
 * 全部目的地
 */
@property (nonatomic, strong) NSArray *destinationArray;

/**
 * 乘客信息
 */
@property (nonatomic, strong) NSMutableArray *informationArray;


@end

@implementation YBNearbyPassengersVC

#pragma mark - lazy
- (YBNearbyTitleView *)titleView
{
    if (!_titleView) {
        _titleView                  = [[YBNearbyTitleView alloc] initWithFrame:CGRectMake(0, 0, YBWidth, 40)];
        _titleView.isTypes          = self.isTypes;
        _titleView.leftBtnStr       = self.description ? @"全部目的地" : self.description;
        _titleView.backgroundColor  = LightGreyColor;
        if (self.isTypes == 0) {
            self.title                  = @"附近乘客";
//            _titleView.leftBtnBlock = ^(UIButton *sender) {
//                YBCitySelectionVC *city = [[YBCitySelectionVC alloc] init];
//                city.isPush = 1;
//                [weakSelf presentViewController:city animated:YES completion:nil];
//            };
        }
        else {
            self.title                  = @"跨城乘客";
            _titleView.NumberPassengers = @"987位乘客计划出行";
        }
    }
    return _titleView;
}



- (UITableView *)nearbyTableView
{
    if (!_nearbyTableView) {
        UITableView *tableView      = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, YBWidth , YBHeight - self.footView.frame.size.height) style:UITableViewStylePlain];
        tableView.delegate          = self;
        tableView.dataSource        = self;
        tableView.rowHeight         = 200;
        tableView.separatorStyle    = UITableViewCellEditingStyleNone;
        tableView.backgroundColor   = LightGreyColor;
        [self.view addSubview:tableView];
        
        _nearbyTableView = tableView;
    }
    return _nearbyTableView;
}

- (UIView *)footView
{
    if (!_footView) {
        UIView *footView    = [[UIView alloc] initWithFrame:CGRectMake(0, YBHeight - 60, YBWidth, 60)];
        [self.view addSubview:footView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, YBWidth / 1.5, 20)];
        titleLabel.text = @"找单太麻烦？发布行程寻找顺路乘客";
        titleLabel.font = YBFont(12);
        [footView addSubview:titleLabel];
        
        UIButton *releaseBtn            = [[UIButton alloc] initWithFrame:CGRectMake(YBWidth - 80, 15, 60, 30)];
        releaseBtn.titleLabel.font      = YBFont(12);
        releaseBtn.layer.cornerRadius   = 5;
        [releaseBtn setTitle:@"发布行程" forState:UIControlStateNormal];
        [releaseBtn setBackgroundColor:BtnBlueColor];
        [footView addSubview:releaseBtn];
        
        _footView = footView;
    }
    return _footView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注册通知
    [self registrationNotice];
    //开启定位
    [self initWithlocService];

    self.view.backgroundColor       = LightGreyColor;
    self.footView.backgroundColor   = [UIColor whiteColor];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 全部目的地
- (void)PassengersStreet
{
    NSString *urlStr;
    NSMutableDictionary *dict         = [YBTooler dictinitWithMD5];
    
    CLLocationCoordinate2D coordinate = self.locService.userLocation.location.coordinate;
    [dict setObject:[NSString stringWithFormat:@"%f",coordinate.longitude] forKey:@"currentlng"];//当前经度
    [dict setObject:[NSString stringWithFormat:@"%f",coordinate.latitude] forKey:@"currentlat"];//当前纬度
    if (self.isTypes == 0) {//市内
        urlStr = passengernearbystatlistPath;
    }
    else {//跨城
        urlStr = passengeroverareastatlistPath;
        [dict setObject:[YBTooler getTheUserId:self.view] forKey:@"userid"];
    }
    
    [YBRequest postWithURL:urlStr MutableDict:dict success:^(id dataArray) {
//        YBLog(@"%@",dataArray);
        self.titleView.leftArray = dataArray[@"PassengerNearByStatList"];
    } failure:^(id dataArray) {
//        YBLog(@"%@",dataArray);
    }];
}

#pragma mark - 乘客信息
- (void)passengerInformationCityId:(NSString *)cityId
{
    NSString *urlStr;
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    if (self.isTypes == 0) {//市内
        urlStr = passengernearbydriverlistPath;
        CLLocationCoordinate2D coordinate = self.locService.userLocation.location.coordinate;
        [dict setObject:[NSString stringWithFormat:@"%f",coordinate.longitude] forKey:@"currentlng"];//当前经度
        [dict setObject:[NSString stringWithFormat:@"%f",coordinate.latitude] forKey:@"currentlat"];//当前纬度
    }
    else {//跨城
        urlStr = passengeroverareadriverlistPath;
        [dict setObject:cityId forKey:@"currentcityid"];
    }
    [YBRequest postWithURL:urlStr MutableDict:dict success:^(id dataArray) {
        YBLog(@"%@",dataArray);
        self.informationArray = dataArray[@"TravelInfoList"];
        self.titleView.NumberPassengers = [NSString stringWithFormat:@"%lu位乘客计划出行",self.informationArray.count];
        [self.nearbyTableView reloadData];
    } failure:^(id dataArray) {
        //        YBLog(@"乘客未完成行程%@",dataArray);
    }];
}

#pragma mark - 开始定位
- (void)initWithlocService
{
    //开启定位
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
}

#pragma mark - 注册通知
- (void)registrationNotice
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(positioningTheCity:) name:@"PositioningTheCity" object:nil];
}

- (void)positioningTheCity:(NSNotification *)user {
    YBLog(@"%@",[user.userInfo objectForKey:@"city"]);
    self.titleView.leftBtnStr = [user.userInfo objectForKey:@"city"];
}

#pragma mark - 代理实现
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.informationArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.titleView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strID = @"YBNearbyCell";
    YBNearbyCell *cell  = [tableView dequeueReusableCellWithIdentifier:strID];
    if (!cell) {
        cell = [[YBNearbyCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:strID];
    }
    cell.detailsDict    = self.informationArray[indexPath.row];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YBPassengerTravelVC *passeng = [[YBPassengerTravelVC alloc] init];
    passeng.TravelSysNo          = self.informationArray[indexPath.row][@"SysNo"];
    [self.navigationController pushViewController:passeng animated:YES];
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    if (userLocation.location) {//定位成功 关闭定位
        [self.locService stopUserLocationService];
        //全部目的地
        [self PassengersStreet];
        //乘客信息请求
        [self passengerInformationCityId:self.cityId];
    }
    else {
        [MBProgressHUD showError:@"定位失败" toView:self.view];
        [self initWithlocService];
    }
}

@end
