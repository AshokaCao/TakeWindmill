//
//  YBAddressSearchSelectionVC.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/15.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBAddressSearchSelectionVC.h"
#import "YBOnTheTrainVC.h"
#import "YBCitySelectionVC.h"
#import "YBAddressSearchVC.h"

#import "YBAddressSearchCell.h"
#import "YBSearchColumnView.h"

//家和地址

@interface YBheadView : UIView

@property (nonatomic, assign) CGFloat viewH;
@property (nonatomic, assign) CGFloat viewW;

/**
 * 设置家
 */
@property (nonatomic, strong) YBBaseView *houseView;

/**
 * 设置公司
 */
@property (nonatomic, strong) YBBaseView *companyView;

/**
 * 设置常用1
 */
@property (nonatomic, strong) YBBaseView *regular1View;

/**
 * 设置常用2
 */
@property (nonatomic, strong) YBBaseView *regular2View;

/**
 * 横线
 */
@property (nonatomic, strong) UIView *horizontalLine;

/**
 * 竖线
 */
@property (nonatomic, strong) UIView *verticalLine;

/**
 * 布局设置
 */
- (void)viewFrame;
@end

@implementation YBheadView

- (YBBaseView *)houseView
{
    if (!_houseView) {
        //家地址
        _houseView = [[YBBaseView alloc] initWithFrame:CGRectMake(10, 10, _viewW, _viewH)];
        _houseView.CanClick = YES;
        _houseView.CanPressLong = YES;
        [_houseView upAndDownImage:[UIImage imageNamed:@"jia"] imageSize:CGSizeMake(10, 10) imageBacColor:nil LabelTitle:@"家" titleFont:14 titleColor:[UIColor blackColor] subTitle:@"请设置家的地址" subTitleFont:12 subtitleColor:[UIColor lightGrayColor]];
        [self addSubview:_houseView];
    }
    return _houseView;
}

- (YBBaseView *)companyView
{
    if (!_companyView) {
        //公司地址
        _companyView = [[YBBaseView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_houseView.frame) + 20, 10, _viewW, _viewH)];
        _companyView.CanClick = YES;
        _companyView.CanPressLong = YES;
        [_companyView upAndDownImage:[UIImage imageNamed:@"gongsi"] imageSize:CGSizeMake(10, 10) imageBacColor:nil LabelTitle:@"公司" titleFont:14 titleColor:[UIColor blackColor] subTitle:@"请设置公司的地址" subTitleFont:12 subtitleColor:[UIColor lightGrayColor]];
        [self addSubview:_companyView];
    }
    return _companyView;
}

- (YBBaseView *)regular1View
{
    if (!_regular1View) {
        //常用1地址
        _regular1View = [[YBBaseView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_houseView.frame) + 20, _viewW, _viewH)];
        _regular1View.CanClick = YES;
        _regular1View.CanPressLong = YES;
        [_regular1View upAndDownImage:[UIImage imageNamed:@"常用路线"] imageSize:CGSizeMake(10, 10) imageBacColor:nil LabelTitle:@"常用1" titleFont:14 titleColor:[UIColor blackColor] subTitle:@"常用地址1" subTitleFont:12 subtitleColor:[UIColor lightGrayColor]];
        [self addSubview:_regular1View];
    }
    return _regular1View;
}

- (YBBaseView *)regular2View
{
    if (!_regular2View) {
        //常用2地址
        _regular2View = [[YBBaseView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.regular1View.frame) + 20, CGRectGetMaxY(_houseView.frame) + 20, _viewW, _viewH)];
        _regular2View.CanClick = YES;
        _regular2View.CanPressLong = YES;
        [_regular2View upAndDownImage:[UIImage imageNamed:@"常用路线"] imageSize:CGSizeMake(10, 10) imageBacColor:nil LabelTitle:@"常用2" titleFont:14 titleColor:[UIColor blackColor] subTitle:@"常用地址2" subTitleFont:12 subtitleColor:[UIColor lightGrayColor]];
        [self addSubview:_regular2View];
    }
    return _regular2View;
}

- (UIView *)horizontalLine
{
    if (!_horizontalLine) {
        //竖线
        _horizontalLine =  [[UIView alloc] init];
        _horizontalLine.backgroundColor = LineLightColor;
        [self addSubview:_horizontalLine];
    }
    return _horizontalLine;
}

- (UIView *)verticalLine
{
    if (!_verticalLine) {
        //横线
        _verticalLine =  [[UIView alloc] init];
        _verticalLine.backgroundColor = LineLightColor;
        [self addSubview:_verticalLine];
    }
    return _verticalLine;
}

- (void)viewFrame
{
    _viewH                  = self.frame.size.height / 2 - 20;
    _viewW                  = self.frame.size.width / 2 - 20;
    self.horizontalLine.frame   = CGRectMake(CGRectGetMaxX(self.houseView.frame) + 10, 0, 1, self.frame.size.height);
    self.verticalLine.frame     = CGRectMake(0, CGRectGetMaxY(self.companyView.frame) + 10, self.frame.size.width, 1);
    [self regular1View];
    [self regular2View];
}


@end

typedef struct Coordinate2D{
    CLLocationDegrees _latitude;
    CLLocationDegrees _longitude;
}Coordinate2D;

@interface YBAddressSearchSelectionVC ()<UITableViewDelegate,UITableViewDataSource,BMKGeoCodeSearchDelegate,YBCitySelectionVCDelegate>

@property (nonatomic, weak) UITableView *addresstableView;

/**
 * 家和公司
 */
@property (nonatomic, strong) YBheadView *headView;

/**
 * 搜索栏
 */
@property (nonatomic, strong) YBSearchColumnView *searchView;

/**
 * 反地理编码
 */
@property (nonatomic, strong) BMKGeoCodeSearch *geocodesearch;

/**
 * 选中数组
 */
@property (nonatomic, strong) NSMutableDictionary *searchArray;

/**
 * 返回数据展示数组
 */
@property (nonatomic, strong) NSMutableArray *searchDict;

/**
 *  家和公司地址存储
 */
@property (nonatomic, strong) NSArray *addressArray;

@end

@implementation YBAddressSearchSelectionVC

#pragma mark - lazy
- (YBheadView *)headView {
    if (!_headView) {
        _headView = [[YBheadView alloc] initWithFrame:CGRectMake(0, 0, YBWidth - 20, 120)];
        [_headView viewFrame];
        
        __weak typeof(self) weakSelf = self;
        //点击家
        _headView.houseView.selectBlock = ^(YBBaseView *view) {
            if ([view.subLabel.text isEqualToString:@"请设置家的地址"]) {
                [weakSelf setHomeOrCompanyTypeFID:@"1"];
            }
            else {
                [weakSelf chooseHhomeOrCompany:1];
            }
        };
        //点击公司
        _headView.companyView.selectBlock = ^(YBBaseView *view) {
            if ([view.subLabel.text isEqualToString:@"请设置公司的地址"]) {
                [weakSelf setHomeOrCompanyTypeFID:@"2"];
            }
            else {
                [weakSelf chooseHhomeOrCompany:2];
            }
        };
        //点击常用1
        _headView.regular1View.selectBlock = ^(YBBaseView *view) {
            if ([view.subLabel.text isEqualToString:@"常用地址1"]) {
                [weakSelf setHomeOrCompanyTypeFID:@"3"];
            }
            else {
                [weakSelf chooseHhomeOrCompany:3];
            }
        };
        //点击常用2
        _headView.regular2View.selectBlock = ^(YBBaseView *view) {
            if ([view.subLabel.text isEqualToString:@"常用地址2"]) {
                [weakSelf setHomeOrCompanyTypeFID:@"4"];
            }
            else {
                [weakSelf chooseHhomeOrCompany:4];
            }
        };
    }
    return _headView;
}

- (UITableView *)addresstableView {
    if (!_addresstableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 74, YBWidth - 20, YBHeight - 10) style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.rowHeight = 60;
        [self.view addSubview:tableView];
        
        _addresstableView = tableView;
    }
    return _addresstableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //搜索框
    [self searchViewinit];
    //初始化检索对象
    _geocodesearch =[[BMKGeoCodeSearch alloc]init];
    _geocodesearch.delegate = self;

    self.searchArray = [NSMutableDictionary dictionary];
    self.searchDict = [NSMutableArray array];
    
    //在线建议检索
    [self onlineAdvice:self.cityname];
    
//    [self choosePassengers:self.typesOf];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //家和公司地址
    [self homeownerOfficialSite];
}

- (void)dealloc {
    _geocodesearch.delegate = nil;
}

#pragma mark - 设置家和公司
- (void)setHomeOrCompanyTypeFID:(NSString *)typeFID
{
    YBAddressSearchVC *addressSearch = [[YBAddressSearchVC alloc] init];
    addressSearch.cityname           = self.searchView.cityButton.titleLabel.text;
    addressSearch.TypeFID            = typeFID;
    [self presentViewController:addressSearch animated:YES completion:nil];
}

#pragma mark - 选择以保存家和地址
- (void)chooseHhomeOrCompany:(int)type
{
    for (NSMutableDictionary *addDict in self.addressArray) {
        if ([addDict[@"TypeFID"] intValue] == type) {
//            YBLog(@"%@",addDict);
            self.searchArray = addDict;
            [self.searchArray setObject:addDict[@"Address"] forKey:@"Name"];
            [self.searchArray setObject:addDict[@"Address"] forKey:@"District"];

            if ([self.typesOf isEqualToString:@"终点"]) {
                if (self.addDelegate && [self.addDelegate respondsToSelector:@selector(popViewControllerPassTheValue:)]) {
                    [self.addDelegate popViewControllerPassTheValue:self.searchArray];
                }
                [self dismissViewControllerAnimated:YES completion:nil];
                return;
            }else {//起点
//                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    }
}

#pragma mark - 获取家和公司地址信息
- (void)homeownerOfficialSite
{
    //设置头部试图
    self.addresstableView.tableHeaderView = self.headView;
    //获取家和公司位置
    NSString *urlStr = commonaddresslistPath;
    NSMutableDictionary *mutableDict = [YBTooler dictinitWithMD5];
    [mutableDict setObject:[YBTooler getTheUserId:self.view] forKey:@"userid"];//关键字
    
    [YBRequest postWithURL:urlStr MutableDict:mutableDict success:^(id dataArray) {
//        YBLog(@"%@",dataArray);
        if ([dataArray[@"CommonAddressList"] count] != 0) {// 如果没有设置返回为空
            self.addressArray = dataArray[@"CommonAddressList"];
            //填充label
            [self clickTheStorageAddress];
        }
    } failure:^(id dataArray) {
    }];
}

#pragma Mark - 填充家和公司地址
- (void)clickTheStorageAddress
{
    for (NSDictionary *addDict in self.addressArray) {
        switch ([addDict[@"TypeFID"] intValue]) {
            case 1://家
                _headView.houseView.subLabel.text = addDict[@"Address"];
                break;
            case 2://公司
                _headView.companyView.subLabel.text = addDict[@"Address"];
                break;
            case 3://常用1
                _headView.regular1View.subLabel.text = addDict[@"Address"];
                break;
            case 4://常用2
                _headView.regular2View.subLabel.text = addDict[@"Address"];
                break;
            default:
                break;
        }
    }
}

#pragma mark - 关键字检索搜索
- (void)onlineAdvice:(NSString *)str {
    NSString *urlStr = suggestionSearchPath;
    NSMutableDictionary *mutableDict = [YBTooler dictinitWithMD5];
    [mutableDict setObject:str forKey:@"keyword"];//关键字
    [mutableDict setObject:str forKey:@"region"];//区域
    
    [YBRequest postWithURL:urlStr MutableDict:mutableDict View:self.addresstableView success:^(id dataArray) {
//        YBLog(@"关键字检索成功返回数据:%@",dataArray);
        //在此处理正常结果
        if (self.searchDict) {
            [self.searchDict removeAllObjects];
        }
        self.searchDict = dataArray[@"SuggestionList"];
        [self.addresstableView reloadData];
    } failure:^(id dataArray) {
        YBLog(@"搜索失败");
    }];
}

#pragma mark - 搜索栏
- (void)searchViewinit {
    
    self.view.backgroundColor = LightGreyColor;
    //搜索
    self.searchView = [[YBSearchColumnView alloc] initWithFrame:CGRectMake(0, 0, YBWidth, 64)];
    self.searchView.cityStr = self.cityname;
    [self.view addSubview:self.searchView];
    
    __weak __typeof__(self) weakSelf = self;
    //选择城市
    self.searchView.seleCityButtonBlock = ^(UIButton *sender) {
        
        YBCitySelectionVC *city = [[YBCitySelectionVC alloc] init];
        city.cityDelegate       = weakSelf;
        [weakSelf presentViewController:city animated:NO completion:nil];
    };
    
    //输入要去的地方
    self.searchView.isEnter = YES;
    self.searchView.contentTextBlock = ^(UITextField *text) {
        if (![text.text isEqualToString:@""]) {
            [weakSelf onlineAdvice:text.text];
        }
    };

    [self.searchView.cancelButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [YBTooler setTheControlShadow:self.searchView];
    
}

- (void)choosePassengers:(NSString *)type
{
//    if ([self.typesOf isEqualToString:@"城市"]) {//城市选择
//        sleep(0.5);
//        YBCitySelectionVC *city = [[YBCitySelectionVC alloc] init];
//        city.isPush             = 1;
//        [self presentViewController:city animated:NO completion:nil];
//    }
}


- (void)backAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 代理方法
- (void)popViewControllerPassTheValueDict:(NSDictionary *)dict
{
    [self.searchView.cityButton  setTitle:dict[@"city"] forState:UIControlStateNormal];
    self.cityname = dict[@"city"];
    [self onlineAdvice:dict[@"city"]];
}

#pragma mark - tabelViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchDict.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YBAddressSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBAddressSearchCell"];
    if (!cell) {
        cell = [[YBAddressSearchCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"YBAddressSearchCell"];
    }
    cell.detailedDict = self.searchDict[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //点击地址搜索
    self.searchArray = self.searchDict[indexPath.row];
    if ([self.typesOf isEqualToString:@"终点"]) {
        if (self.addDelegate && [self.addDelegate respondsToSelector:@selector(popViewControllerPassTheValue:)]) {
            [self.addDelegate popViewControllerPassTheValue:self.searchDict[indexPath.row]];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"passengerSide_pointSelection" object:nil userInfo:@{@"startingPoint":self.searchDict[indexPath.row]}];
    }];
}




@end
