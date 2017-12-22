//
//  YBMyPublicWelfareVC.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/18.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBMyPublicWelfareVC.h"

#include "YBPublicWelfareView.h"

@interface YBMyPublicWelfareVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *myTableView;

@property (nonatomic, strong) YBPublicWelfareView *headView;
@end

@implementation YBMyPublicWelfareVC

#pragma mark - lazy
- (UITableView *)myTableView {
    if (!_myTableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, YBWidth, YBHeight ) style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview:tableView];
        _myTableView = tableView;
    }
    return _myTableView;
}

- (YBPublicWelfareView *)headView
{
    if (!_headView) {
        _headView = [[[NSBundle mainBundle] loadNibNamed:@"YBPublicWelfareView" owner:nil options:nil] firstObject];
        _headView.frame = CGRectMake(0, 0, YBWidth, 155);
    }
    return _headView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"我的公益";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.myTableView.tableHeaderView = self.headView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headimg.gif"]];
    imageView.frame = CGRectMake(20, 10, 40, 40);
    [view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 10, 10, 100, 40)];
    label.text = @"花花神";
    label.font = YBFont(16);
    [view addSubview:label];
    
    UILabel *typeLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame) + 10, 10, 100, 40)];
    typeLable.text = @"花花神";
    typeLable.font = YBFont(14);
    [view addSubview:typeLable];

    UILabel *monyLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(typeLable.frame) + 10, 10, 100, 40)];
    monyLabel.text = @"255.55元";
    monyLabel.font = YBFont(18);
    [view addSubview:monyLabel];

    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = @"123213";
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
