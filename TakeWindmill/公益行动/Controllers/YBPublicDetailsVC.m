//
//  YBPublicDetailsVC.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/18.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBPublicDetailsVC.h"
#import "YBPublicListTableModel.h"
#import "YBPublicDetailsView.h"

@interface YBPublicDetailsVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *myTableView;

@property (nonatomic, strong) YBPublicDetailsView *headerView;

@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, strong) NSMutableArray *listTableData;

@property (nonatomic, strong)  YBPublicListTableModel *model;

@property (nonatomic, strong) NSMutableDictionary *newsDic;

@end

@implementation YBPublicDetailsVC

#pragma mark - lazy
- (UITableView *)myTableView
{
    if (!_myTableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, YBWidth, YBHeight) style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 100;
        [self.view addSubview:tableView];
        _myTableView = tableView;
    }
    return _myTableView;
}

- (YBPublicDetailsView *)headerView
{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"YBPublicDetailsView" owner:nil options:nil] firstObject];
        _headerView.frame = CGRectMake(0, 0, YBWidth, 391);
    }
    return _headerView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getPublicList];
    self.title = @"公益详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.pageIndex = 1;
    self.myTableView.tableHeaderView = self.headerView;
    
}

- (void)getPublicList
{
    self.listTableData = [NSMutableArray array];
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    dict[@"sysno"] = @"22";
    [YBRequest postWithURL:PublicList MutableDict:dict success:^(id dataArray) {
        NSDictionary *dict = dataArray;
        YBPublicListTableModel *model = [YBPublicListTableModel new];
        [model setValuesForKeysWithDictionary:dict];
        [self.listTableData addObject:model];
        self.headerView.proportionLabel.text = model.Address;
        self.headerView.purposeMoneyLabel.text = model.ContributeMoney;
        self.headerView.peopleCountLabel.text = model.ContributePeapleNumber;
        self.headerView.userMoneyLabel.text = model.RealContributeMoney;
        [self.myTableView reloadData];
        NSLog(@"PublicList - - %@",dataArray);
    } failure:^(id dataArray) {
        NSLog(@"--- %@",dataArray);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listTableData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    
    UIButton *Donations = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, YBWidth - 40, 40)];
    Donations.layer.cornerRadius = 5;
    [Donations setTitle:@"我要捐款" forState:UIControlStateNormal];
    [Donations setBackgroundColor:BtnBlueColor];
    [view addSubview:Donations];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    
    UIButton *details = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, YBWidth / 2, 60)];
    [details setTitle:@"项目详情" forState:UIControlStateNormal];
    [details setTitleColor:BtnBlueColor forState:UIControlStateNormal];
    [view addSubview:details];
    
    UIButton *Evaluation = [[UIButton alloc] initWithFrame:CGRectMake(YBWidth / 2, 0, YBWidth / 2, 60)];
    [Evaluation setTitle:@"爱心留言" forState:UIControlStateNormal];
    [Evaluation setTitleColor:BtnBlueColor forState:UIControlStateNormal];
    [view addSubview:Evaluation];

    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    YBPublicListTableModel *model = self.listTableData[indexPath.row];
//    NSLog(@"Introduce - %@",model.Introduce);
    cell.textLabel.text = model.Introduce;
    return cell;
}

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
