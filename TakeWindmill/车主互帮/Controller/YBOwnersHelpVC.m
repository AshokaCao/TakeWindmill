//
//  YBOwnersHelpVC.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/16.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBOwnersHelpVC.h"
#import "YBTextField.h"
//#import "YBEvaluationViewController.h"

#import "YBGroupHelpVC.h"
#import "YBSystemHelpViewController.h"
#import "YBHelpInfoVC.h"
#import "YBOwnersHelpAlertView.h"

@interface YBOwnersHelpVC ()<UITextFieldDelegate>
{
    
}

@property (nonatomic, strong) YBTextField *textField;

@property (nonatomic, strong) NSMutableArray *serviceArray;
@property (nonatomic, assign) NSInteger counts;

/**
 * 定位功能
 */
@property (nonatomic, strong) BMKLocationService *locService;

/**
 * 起点位置信息
 */
@property (nonatomic, strong) BMKReverseGeoCodeResult *startingPoint;

@end


@implementation YBOwnersHelpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"车主互帮";
    self.view.backgroundColor = [UIColor whiteColor];
    self.serviceArray = [NSMutableArray array];
    
    //搜索
    [self searchView];
    [self setupBtn];
    
    self.mapView.zoomLevel = 16;
    self.counts = 0;
    
}
- (void)serviceLoctionData
{
    NSMutableDictionary *parm = [YBTooler dictinitWithMD5];
    //NSString *userID = [YBUserDefaults valueForKey:_userId];
    //CurrentLng：当前经度，CurrentLat：当前纬度
    parm[@"currentlng"] = [NSString stringWithFormat:@"%f",self.startingPoint.location.longitude];
    parm[@"currentlat"] = [NSString stringWithFormat:@"%f",self.startingPoint.location.latitude];
    
    //YBLog(@"startingPoint==%f,%f",self.startingPoint.location.longitude,self.startingPoint.location.latitude);
    
    WEAK_SELF;
    [YBRequest postWithURL:DriverhelpDriverhelpnearbydriverlist MutableDict:parm success:^(id dataArray) {
        //YBLog(@"dataArray==%@",dataArray);
        YBGroupHelpModel *model = [YBGroupHelpModel yy_modelWithJSON:dataArray];
        [weakSelf.serviceArray removeAllObjects];
        [weakSelf.serviceArray addObjectsFromArray:model.UserInfoList];
        [weakSelf addPointAnnotation];
        
    } failure:^(id dataArray) {
        //YBLog(@"failureDataArray==%@",dataArray);
        [MBProgressHUD showError:dataArray[@"ErrorMessage"] toView:weakSelf.view];
    }];
    
}
- (void)addPointAnnotation {
    
    NSMutableArray *loctionArray = [NSMutableArray array];
    for (int i = 0; i < self.serviceArray.count; i++) {
        UserInfoList *model = self.serviceArray[i];
        // 添加一个PointAnnotation
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = [model.CurrentLat floatValue];
        coor.longitude = [model.CurrentLng floatValue];
        annotation.title = [NSString stringWithFormat:@"%d",i];
        annotation.coordinate = coor;
        [loctionArray addObject:annotation];
    }
    [self.mapView addAnnotations:loctionArray];
    
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
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"reuseIdentifier"];
        //newAnnotationView.pinColor = BMKPinAnnotationColorRed;
        //newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        newAnnotationView.image = [UIImage imageNamed:@"红色小车"];
        return newAnnotationView;
    }
    
    return nil;
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view;
{
    if ([view.annotation isKindOfClass:[BMKPointAnnotation class]]) {
        NSLog(@"view - - %@",view.annotation.title);
        int num = [[NSString stringWithFormat:@"%@",view.annotation.title] intValue];
        UserInfoList *model = self.serviceArray[num];
        
        YBOwnersHelpAlertView *alert = [[YBOwnersHelpAlertView alloc] init];
        alert.VC = self;
        alert.userInfoList = model;
        [self.view addSubview:alert];
    }
    [mapView deselectAnnotation:view.annotation animated:NO];
}

#pragma mark  UITextField
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self searchTap];
    return YES;
}
-(void)setupBtn{
    YBBaseButton *HelpEachOther = [YBBaseButton buttonWithFrame:CGRectMake(YBWidth - 80, 20, 80, 20) Strtitle:@"求助信息" titleColor:[UIColor whiteColor] titleFont:12 textAlignment:NSTextAlignmentCenter image:nil BackgroundColor:BtnBlueColor cornerRadius:3];
    [HelpEachOther addTarget:self action:@selector(helpEachOtherAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:HelpEachOther];
    
    YBBaseButton *GroupHelp = [YBBaseButton buttonWithFrame:CGRectMake(YBWidth - 80, CGRectGetMaxY(HelpEachOther.frame) + 10, 80, 20) Strtitle:@"群组帮忙" titleColor:[UIColor whiteColor] titleFont:12 textAlignment:NSTextAlignmentCenter image:nil BackgroundColor:BtnBlueColor cornerRadius:3];
    [GroupHelp addTarget:self action:@selector(GroupHelpAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:GroupHelp];
    
    YBBaseButton *SystemHelp = [YBBaseButton buttonWithFrame:CGRectMake(YBWidth - 80, CGRectGetMaxY(GroupHelp.frame) + 10, 80, 20) Strtitle:@"系统帮忙" titleColor:[UIColor whiteColor] titleFont:12 textAlignment:NSTextAlignmentCenter image:nil BackgroundColor:BtnOrangeColor cornerRadius:3];
    [SystemHelp addTarget:self action:@selector(systemHelpAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:SystemHelp];
}
- (void)searchView {
    
    YBTextField *search = [[YBTextField alloc] initWithFrame:CGRectMake(10, 10, YBWidth / 2.5, 30)];
    search.delegate = self;
    search.returnKeyType = UIReturnKeySearch;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    view.backgroundColor = BtnBlueColor;
    
    UILabel *label = [[UILabel alloc] initWithFrame:view.bounds];
    label.text = @"搜索";
    label.font = YBFont(16);
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    [search LeftWithPicture:@"请输入车牌号码" textColor:[UIColor lightGrayColor] view:view];
    [self.view addSubview:search];
    self.textField = search;
    
    UITapGestureRecognizer * tap  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchTap)];
    [view addGestureRecognizer:tap];
}
-(void)searchTap{
    WEAK_SELF;
    [self.view endEditing:YES];//强行关闭键盘
    if (self.textField.text.length == 0) {
        [MBProgressHUD showError:@"请输入车牌号码" toView:weakSelf.view];
        return;
    }

    NSMutableDictionary *parm = [YBTooler dictinitWithMD5];
    parm[@"vehiclenumber"] = self.textField.text;
    self.textField.text = @"";
    
    [YBRequest postWithURL:UserUserinfodetailbyvehiclenumber MutableDict:parm success:^(id dataArray) {
        //YBLog(@"dataArray==%@",dataArray);
        UserInfoList *model = [UserInfoList yy_modelWithJSON:dataArray];
    
        YBOwnersHelpAlertView *alert = [[YBOwnersHelpAlertView alloc] init];
        alert.VC = weakSelf;
        alert.userInfoList = model;
        [weakSelf.view addSubview:alert];
        
    } failure:^(id dataArray) {
        //YBLog(@"failureDataArray==%@",dataArray);
        [MBProgressHUD showError:dataArray[@"ErrorMessage"] toView:weakSelf.view];
    }];
    
}
- (void)helpEachOtherAction:(UIButton *)sender {
    YBHelpInfoVC *vc = [[YBHelpInfoVC alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
}
- (void)GroupHelpAction:(UIButton *)sender {
    NSString *userID = [YBUserDefaults valueForKey:_userId];
    if (!userID.length) {
        [MBProgressHUD showError:@"请先登录" toView:self.view];
        return;
    }
    YBGroupHelpVC *group = [[YBGroupHelpVC alloc] init];
    group.startingPoint = self.startingPoint;
    [self.navigationController pushViewController:group animated:NO];
}

- (void)systemHelpAction:(UIButton *)sender {
    YBSystemHelpViewController *system = [[YBSystemHelpViewController alloc] init];
    [self.navigationController pushViewController:system animated:NO];
}

-(void)dealloc{
    YBLog(@"%s",__func__);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
