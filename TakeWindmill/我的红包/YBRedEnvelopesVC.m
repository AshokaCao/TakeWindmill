//
//  YBRedEnvelopesVC.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/10.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBRedEnvelopesVC.h"
#import "YBRedEnvelopesView.h"
#import "YBRedEnvelopesCell.h"

@interface YBRedEnvelopesVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *redEnvelopesTableView;

@property (nonatomic, strong) YBRedEnvelopesView *headView;

@end

@implementation YBRedEnvelopesVC

#pragma mark - lazy
- (UITableView *)redEnvelopesTableView {
    if (!_redEnvelopesTableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, YBWidth, YBHeight )];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = LightGreyColor;
        tableView.rowHeight = 30;
        [self.view addSubview:tableView];
        _redEnvelopesTableView = tableView;
    }
    return _redEnvelopesTableView;
}

- (YBRedEnvelopesView *)headView {
    if (!_headView) {
        _headView = [[[NSBundle mainBundle] loadNibNamed:@"YBRedEnvelopesView" owner:nil options:nil] firstObject];
        _headView.frame = CGRectMake(0, 0, YBWidth, 200);
//        [self.view addSubview:_headView];
    }
    return _headView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"我的红包";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = LightGreyColor;
    self.redEnvelopesTableView.tableHeaderView = self.headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    
    UIView *heaView = [[UIView alloc] initWithFrame:CGRectMake(0, 5 , YBWidth, 40)];
    heaView.backgroundColor = [UIColor whiteColor];
    [view addSubview:heaView];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 20, 20)];
    image.image = [UIImage imageNamed:@"收入明细"];
    [heaView addSubview:image];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(image.frame) +10, 10, 100, 20)];
    label.text = @"收入明细";
    label.textColor = [UIColor grayColor];
    [heaView addSubview:label];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(label.frame) + 10, YBWidth - 40, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [heaView addSubview:lineView];
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    UIButton *grouButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, YBWidth - 20, 20)];
    [grouButton setTitle:@"点击查看更多" forState:UIControlStateNormal];
    grouButton.titleLabel.font = YBFont(14);
    [grouButton setTitleColor:BtnBlueColor forState:UIControlStateNormal];
    [view addSubview:grouButton];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YBRedEnvelopesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBRedEnvelopesCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YBRedEnvelopesCell" owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
