//
//  YBAddressSearchVC.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/11/2.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBAddressSearchVC.h"
#import "YBCitySelectionVC.h"

#import "YBSearchColumnView.h"
#import "YBAddressSearchCell.h"

@interface YBAddressSearchVC ()<YBCitySelectionVCDelegate,BMKGeoCodeSearchDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *addresstableView;

/**
 * 搜索栏
 */
@property (nonatomic, strong) YBSearchColumnView *searchView;

/**
 * 反地理编码
 */
@property (nonatomic, strong) BMKGeoCodeSearch *geocodesearch;

/**
 * 返回数据展示数组
 */
@property (nonatomic, strong) NSMutableArray *searchDict;

/**
 * 选中数组
 */
@property (nonatomic, strong) NSDictionary *searchArray;

@end

@implementation YBAddressSearchVC

#pragma mark - lazy
- (YBSearchColumnView *)searchView
{
    if (!_searchView) {
        _searchView = [[YBSearchColumnView alloc] initWithFrame:CGRectMake(0, 0, YBWidth, 64)];
        [self.view addSubview:_searchView];
    }
    return _searchView;
}

- (UITableView *)addresstableView {
    if (!_addresstableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 74, YBWidth - 20, YBHeight - 10) style:UITableViewStylePlain];
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
    
    self.searchArray = [NSDictionary dictionary];
    self.searchDict = [NSMutableArray array];
    
    //在线建议检索
    [self onlineAdvice:self.cityname];
}

- (void)dealloc {
    _geocodesearch.delegate = nil;
}

#pragma mark - 搜索栏
- (void)searchViewinit {
    
    self.view.backgroundColor = LightGreyColor;
    //搜索
    self.searchView.cityStr = self.cityname;
    
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

#pragma mark - 关键字搜索
- (void)onlineAdvice:(NSString *)str {
    
    NSString *urlStr = suggestionSearchPath;
    NSMutableDictionary *mutableDict = [YBTooler dictinitWithMD5];
    [mutableDict setObject:str forKey:@"keyword"];//关键字
    [mutableDict setObject:self.cityname forKey:@"region"];//区域
    
    [YBRequest postWithURL:urlStr MutableDict:mutableDict View:self.addresstableView success:^(id dataArray) {
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

#pragma mark - 城市选择代理
- (void)popViewControllerPassTheValueDict:(NSDictionary *)dict
{
    [self.searchView.cityButton  setTitle:dict[@"city"] forState:UIControlStateNormal];
    self.cityname = dict[@"city"];
    [self onlineAdvice:dict[@"city"]];
}

- (void)backAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
    YBLog(@"%@",self.searchDict[indexPath.row]);
    [self uploadAddressInformation:self.searchDict[indexPath.row]];
}

#pragma mark - 上传地址信息
- (void)uploadAddressInformation:(NSDictionary *)dict
{
    //获取家和公司位置
    NSString *urlStr = commonaddresssavePath;
    NSMutableDictionary *mutableDict = [YBTooler dictinitWithMD5];
    [mutableDict setObject:[YBTooler getTheUserId:self.view] forKey:@"userid"];//用户Id
    [mutableDict setObject:dict[@"Lng"] forKey:@"lng"];//经度
    [mutableDict setObject:dict[@"Lat"]  forKey:@"lat"];//纬度
    [mutableDict setObject:dict[@"CityId"] forKey:@"cityid"];//城市id
    [mutableDict setObject:dict[@"City"] forKey:@"city"];//城市
    [mutableDict setObject:dict[@"Name"] forKey:@"address"];//地址
    [mutableDict setObject:self.TypeFID forKey:@"typefid"];//1-家，2-公司，3-常用1，4-常用2

    [YBRequest postWithURL:urlStr MutableDict:mutableDict success:^(id dataArray) {
        YBLog(@"%@",dataArray);
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(id dataArray) {
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
