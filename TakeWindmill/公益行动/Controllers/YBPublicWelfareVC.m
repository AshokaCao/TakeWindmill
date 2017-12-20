//
//  YBPublicWelfareVC.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/18.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBPublicWelfareVC.h"
#import "YBPublicDetailsVC.h"
#import "YBPublicListTableModel.h"
#import "YBPublicWelfareCell.h"

@interface YBPublicWelfareVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *myTableView;

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, strong) NSMutableArray *listTableData;

@end

@implementation YBPublicWelfareVC

#pragma mark - lazy
- (UITableView *)myTableView {
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

- (UIView *)headerView {
    if (!_headerView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBWidth , 200)];
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:view.frame];
        image.image = [UIImage imageNamed:@"首页4_01"];
        [view addSubview:image];
        _headerView = view;
    }
    return _headerView;
}

- (NSMutableArray *)listTableData
{
    if (!_listTableData) {
        _listTableData = [NSMutableArray array];
    }
    return _listTableData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageIndex = 1;
    self.title = @"公益行动";
    self.view.backgroundColor = [UIColor whiteColor];
    self.myTableView.tableHeaderView = self.headerView;
}

- (void)getPublicList
{
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    dict[@"pageindex"] = [NSString stringWithFormat:@"%ld",self.pageIndex];
    [YBRequest postWithURL:PublicServiceTable MutableDict:dict success:^(id dataArray) {
        NSLog(@"PublicServiceTable - - %@",dataArray);
        NSDictionary *dic = dataArray;
        NSDictionary *newDic = [NSDictionary changeType:dic];
        for (NSDictionary *diction in newDic[@"PublicWelfareList"]) {
            YBPublicListTableModel *model = [YBPublicListTableModel new];
            [model setValuesForKeysWithDictionary:diction];
            [self.listTableData addObject:model];
        }
    } failure:^(id dataArray) {
        NSLog(@"error %@",dataArray);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 40)];
    label.text = @"公益项目";
    label.font = YBFont(16);
    [view addSubview:label];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(YBWidth / 2, 10, YBWidth / 2 -10, 20)];
    textField.placeholder = @"查询公益项目";
//    [textField setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
    textField.layer.cornerRadius = 20;
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"搜索"]];
    image.frame = CGRectMake(3, 3, 14, 14);
    textField.leftView = image;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    [view addSubview:textField];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBPublicWelfareCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBPublicWelfareCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YBPublicWelfareCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YBPublicDetailsVC *public = [[YBPublicDetailsVC alloc] init];
    [self.navigationController pushViewController:public animated:YES];
}

@end
