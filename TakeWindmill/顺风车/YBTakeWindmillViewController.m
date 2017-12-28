//
//  YBTakeWindmillViewController.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/9.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBTakeWindmillViewController.h"
#import "YBOnTheTrainVC.h"
#import "YBOwnerTravelVC.h"
#import "YBCommonRouteVC.h"
#import "YBWaitingOrdersVC.h"
#import "YBManagementRouteVC.h"
#import "YBNearbyPassengersVC.h"
#import "YBLookingPassengersrVC.h"
#import "YBCertifiedViewController.h"
#import "YBRegisteredViewController.h"

#import "YBUserListModel.h"

#import "YBAboutButton.h"
#import "YBTakeWindmollView.h"
#import "YBDriverTableView.h"
#import "YBPassengerTableView.h"

#define itemCount 2

@interface YBTakeWindmillViewController ()<UIScrollViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>

/**
 * 头部试图
 */
@property (nonatomic, strong) YBTakeWindmollView *titleView;

/**
 *
 */
@property (nonatomic, weak) UIScrollView *scrollView;

/**
 * 乘客端
 */
@property (nonatomic, weak) YBPassengerTableView *takeTableView;

/**
 * 司机端
 */
@property (nonatomic, weak) YBDriverTableView *driverTableView;

/**
 * 定位功能
 */
@property (nonatomic, strong) BMKLocationService *locService;

/**
 * 反地理编码
 */
@property (nonatomic, strong) BMKGeoCodeSearch *geocodesearch;

///@brife 当前选中页数
@property (nonatomic, assign) NSInteger currentPage;

//城市id
@property (nonatomic, copy) NSString *cityId;

@end

@implementation YBTakeWindmillViewController

#pragma mark - lzay
- (YBDriverTableView *)driverTableView
{
    if (!_driverTableView) {//司机
        YBDriverTableView *tableView   = [[YBDriverTableView alloc] initWithFrame:CGRectMake(YBWidth, 1, YBWidth, self.scrollView.frame.size.height) style:UITableViewStyleGrouped];
        tableView.isDriverNotCompleted = 1;
        [self.scrollView addSubview:tableView];
        
        _driverTableView = tableView;
    }
    return _driverTableView;
}

- (YBPassengerTableView *)takeTableView
{
    if (!_takeTableView) {//乘客
        YBPassengerTableView *tableView = [[YBPassengerTableView alloc] initWithFrame:CGRectMake(0, 1, YBWidth, self.scrollView.frame.size.height) style:UITableViewStyleGrouped];
        tableView.isPassengerNotCompleted = 1;
        [self.scrollView addSubview:tableView];

        _takeTableView = tableView;
    }
    return _takeTableView;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        UIScrollView *scrollView                    = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleView.frame), YBWidth, YBHeight - CGRectGetMaxY(self.titleView.frame))];
        scrollView.delegate                         = self;
        scrollView.pagingEnabled                    = YES;
        scrollView.backgroundColor                  = LightGreyColor;
        scrollView.showsVerticalScrollIndicator     = NO;
        scrollView.showsHorizontalScrollIndicator   = NO;
        scrollView.contentSize                      = CGSizeMake(YBWidth * itemCount, 0);
        [self.view addSubview:scrollView];
        _scrollView              = scrollView;
    }
    return _scrollView;
}

//头部试图
- (YBTakeWindmollView *)titleView
{
    if (!_titleView) {
        _titleView = [[YBTakeWindmollView alloc] initWithFrame:CGRectMake(0, 0, YBWidth, 40)];
        [self.view addSubview:_titleView];
        
        __weak typeof(self) weakSelf = self;
        _titleView.buttonBlok = ^(UIButton *sender) {
            [weakSelf updateDataPageNumber:sender.tag];
        };
    }
    return _titleView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化
    [self initControllerView];
    
    [self getUserListAction];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //刷新数据和界面
    [self updateDataPageNumber:self.currentPage];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _locService.delegate = nil;
    _geocodesearch.delegate = nil; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

- (void)initControllerView {
    
    self.title = @"顺风车";
    self.titleView.scrollView   = self.scrollView;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //默认为乘客
    _currentPage = 0;
    //开启定位
    [self initWithlocService];
    //乘客端行程信息
    [self passengerDidNotCompleteTheTrip];

}

- (void)initWithlocService
{
    //开启定位
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
}

- (void)getUserListAction
{
    WEAK_SELF;
    
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    NSString *userID = [YBUserDefaults valueForKey:_userId];
    dict[@"userid"] = userID;
    
    [YBRequest postWithURL:UserList MutableDict:dict success:^(id dataArray) {
//        NSLog(@"dataArray - %@",dataArray);
        NSDictionary *dic = dataArray;
        NSDictionary *newDic = [NSDictionary changeType:dic];
        YBUserListModel *userModel = [YBUserListModel modelWithDic:newDic];
        
        weakSelf.driverTableView.nameStr = userModel.NickName;
        weakSelf.takeTableView.nameStr = userModel.NickName;
    } failure:^(id dataArray) {
        YBLog(@"请求个人信息失败%@",dataArray);
    }];
}

- (void)parallelDataRequest
{
    //创建信号量
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    //创建全局并行
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    //请求一
    dispatch_group_async(group, queue, ^{
        //是否有未完成行程
        [self driverDidNotCompleteTheTrip:semaphore];
    });
    //请求二
    dispatch_group_async(group, queue, ^{
        //附近乘客
        [self nearbyPassengersSearch:semaphore];
    });
    //请求三
    dispatch_group_async(group, queue, ^{
        //跨城乘客
        [self passengersAcrossTheCity:semaphore];
    });
    //请求四
    dispatch_group_async(group, queue, ^{
        //常用路线 travelinfocommonlistPath
        [self driverSide_CommonRoute:semaphore];
    });
    //请求五
    dispatch_group_async(group, queue, ^{
        [self driver_MyOrder:semaphore];
    });
    //总
    dispatch_group_notify(group, queue, ^{
        // 四个请求对应四次信号等待
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        //在这里 进行请求后的方法，回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.driverTableView reloadData];
        });
    });
}

#pragma mark - 判断乘客是否有未完成行程
- (void)passengerDidNotCompleteTheTrip
{
    //环保乘客判断是否有未完成行程
    NSString *urlStr = travelinfodetailinprogressPath;
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    [dict setObject:[YBTooler getTheUserId:self.view] forKey:@"userid"];
    [dict setObject:@"1" forKey:@"traveltypefid"];
    [YBRequest postWithURL:urlStr MutableDict:dict success:^(id dataArray) {
//        YBLog(@"乘客未完成行程%@",dataArray);
        self.takeTableView.isPassengerNotCompleted = 2;
        self.takeTableView.passengerDict = dataArray;
        [self.takeTableView reloadData];
    } failure:^(id dataArray) {
//        YBLog(@"乘客未完成行程%@",dataArray);
        self.takeTableView.isPassengerNotCompleted = 1;
        [self.takeTableView reloadData];
    }];
    [self.takeTableView reloadData];
}

#pragma mark -判断车主是否有未完成行程
- (void)driverDidNotCompleteTheTrip:(id)semaphore
{
    //爱心车主
    NSString *urlStr1           = travelinfodriverdetailinprogressPath;
    NSMutableDictionary *dict1  = [YBTooler dictinitWithMD5];
    [dict1 setObject:[YBTooler getTheUserId:self.view] forKey:@"userid"];
    [YBRequest postWithURL:urlStr1 MutableDict:dict1 success:^(id dataArray) {
        YBLog(@"司机未完成行程%@",dataArray);
        self.driverTableView.isDriverNotCompleted = 2;
        self.driverTableView.driverDict = dataArray;
        dispatch_semaphore_signal(semaphore);
    } failure:^(id dataArray) {
        YBLog(@"司机未完成行程%@",dataArray);
        self.driverTableView.isDriverNotCompleted = 1;
        dispatch_semaphore_signal(semaphore);
    }];
}

#pragma mark -判断车主是否有我的行程
- (void)driver_MyOrder:(id)semaphore
{
    WEAK_SELF;
    //爱心车主
    NSString *urlStr1           = passengertravelinfolistbydriverPath;
    NSMutableDictionary *dict1  = [YBTooler dictinitWithMD5];
    [dict1 setObject:[YBTooler getTheUserId:self.view] forKey:@"userid"];
    
    [YBRequest postWithURL:urlStr1 MutableDict:dict1 success:^(id dataArray) {
        YBLog(@"司机我的行程%@",dataArray);
        weakSelf.driverTableView.myOrderArray = dataArray[@"TravelInfoList"];
        dispatch_semaphore_signal(semaphore);
    } failure:^(id dataArray) {
        YBLog(@"司机我的行程%@",dataArray);
        dispatch_semaphore_signal(semaphore);
    }];
}

#pragma mark - 司机附近乘客检索
- (void)nearbyPassengersSearch:(id)semaphore
{
    NSString *urlStr                  = passengernearbystatlistPath;
    NSMutableDictionary *dict         = [YBTooler dictinitWithMD5];
    
    CLLocationCoordinate2D coordinate = self.locService.userLocation.location.coordinate;
    [dict setObject:[NSString stringWithFormat:@"%f",coordinate.longitude] forKey:@"currentlng"];//当前经度
    [dict setObject:[NSString stringWithFormat:@"%f",coordinate.latitude] forKey:@"currentlat"];//当前纬度
    
    [YBRequest postWithURL:urlStr MutableDict:dict success:^(id dataArray) {
//        YBLog(@"%@",dataArray);
        self.driverTableView.passengersNearby = dataArray[@"PassengerNearByStatList"];
        dispatch_semaphore_signal(semaphore);
    } failure:^(id dataArray) {
//        YBLog(@"附近乘客检索%@",dataArray);
        dispatch_semaphore_signal(semaphore);
    }];

}

#pragma mark - 司机跨城乘客检索
- (void)passengersAcrossTheCity:(id)semaphore
{
    NSString *urlStr                  = passengeroverareastatlistPath;
    NSMutableDictionary *dict         = [YBTooler dictinitWithMD5];
    
    [dict setObject:self.cityId forKey:@"currentcityid"];//所在城市的id
    [dict setObject:[YBTooler getTheUserId:self.view] forKey:@"userid"];//司机id
    
    [YBRequest postWithURL:urlStr MutableDict:dict success:^(id dataArray) {
        YBLog(@"%@",dataArray);
        self.driverTableView.passengersCity = dataArray[@"PassengerOverAreaStatList"];
        self.driverTableView.cityId         = self.cityId;
        dispatch_semaphore_signal(semaphore);
    } failure:^(id dataArray) {
//        YBLog(@"跨城乘客检索%@",dataArray);
        dispatch_semaphore_signal(semaphore);
    }];
    
}

#pragma mark - 司机端常用路线
- (void)driverSide_CommonRoute:(id)semaphore
{
    NSString *urlStr                  = commonaddressdriverlistPath;
    NSMutableDictionary *dict         = [YBTooler dictinitWithMD5];
    [dict setObject:[YBTooler getTheUserId:self.view] forKey:@"userid"];//所在城市的id
    
    [YBRequest postWithURL:urlStr MutableDict:dict success:^(id dataArray) {
        YBLog(@"%@",dataArray);
        self.driverTableView.commonRoute = dataArray[@"CommonAddressList"];
        dispatch_semaphore_signal(semaphore);
    } failure:^(id dataArray) {
        YBLog(@"%@",dataArray);
        self.driverTableView.commonRoute = nil;
        dispatch_semaphore_signal(semaphore);
    }];
}


#pragma mark - scrollView滑动
- (void)updateDataPageNumber:(NSUInteger)pageNumber
{
    if (pageNumber == 0) {//乘客页面
        [self passengerDidNotCompleteTheTrip];
    }
    else {//司机页面
        if (self.cityId) {//城市id请求
            //请求司机端界面所有数据
            [self parallelDataRequest];
        }
        else {
            //重新开启定位
            [self initWithlocService];
        }
    }
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    if (userLocation.location) {//定位成功 关闭定位
        [self.locService stopUserLocationService];
        //开启反地理编码
        _geocodesearch = [[BMKGeoCodeSearch alloc] init];
        _geocodesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
        
        BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];//初始化反编码请求
        reverseGeocodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;//设置反编码的店为pt
        BOOL flag =   [self.geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
        if (flag) {
            YBLog(@"搜索成功");
        }
        else {
            [MBProgressHUD showError:@"城市搜索失败" toView:self.view];
        }
    }
    else {
        [MBProgressHUD showError:@"定位失败" toView:self.scrollView];
        [self initWithlocService];
    }
}

#pragma mark --根据scrollView的滚动位置复用tableView，减少内存开支
- (void)updateTableWithPageNumber:(NSUInteger)pageNumber{
    
    [UIView animateWithDuration:0.1 animations:^{
        [self.titleView changeTheUnderline:pageNumber];
    }];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_scrollView]) {
        _currentPage = _scrollView.contentOffset.x / YBWidth;
        [self updateTableWithPageNumber:_currentPage];
        [self updateDataPageNumber:_currentPage];
        return;
    }
}

#pragma mark - 请求城市
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        self.cityId = result.cityCode;
        //请求司机端界面所有数据
        [self parallelDataRequest];
    }
}

@end
