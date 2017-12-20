//
//  YBMessageViewController.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/8.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBMessageViewController.h"
#import "YBMessageModel.h"
#import "YBMessageTableViewCell.h"

@interface YBMessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *messageTableView;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation YBMessageViewController

#pragma mark - lazy
- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

- (UITableView *)messageTableView {
    if (!_messageTableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, YBWidth, YBHeight)];
        tableView.delegate = self;
        tableView.dataSource = self;
//        tableView.estimatedRowHeight = 100;//很重要保障滑动流畅性
        tableView.rowHeight = 60;
        [self.view addSubview:tableView];
        _messageTableView = tableView;
    }
    return _messageTableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;

    [self initDataUIView];
    
}

- (void)initDataUIView {
    self.title = @"消息";
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *dictArray = @[@{@"nameStr":@"李师傅",@"content":@"申嘉湖高速那个路口",@"icon":@""},@{@"nameStr":@"李师傅",@"content":@"申嘉湖高速那个路口",@"icon":@""},@{@"nameStr":@"李师傅",@"content":@"申嘉湖高速那个路口",@"icon":@""},@{@"nameStr":@"李师傅",@"content":@"申嘉湖高速那个路口",@"icon":@""},@{@"nameStr":@"李师傅",@"content":@"申嘉湖高速那个路口",@"icon":@""},@{@"nameStr":@"李师傅",@"content":@"申嘉湖高速那个路口",@"icon":@""},@{@"nameStr":@"李师傅",@"content":@"申嘉湖高速那个路口",@"icon":@""},@{@"nameStr":@"李师傅",@"content":@"申嘉湖高速那个路口",@"icon":@""},@{@"nameStr":@"李师傅",@"content":@"申嘉湖高速那个路口",@"icon":@""},@{@"nameStr":@"李师傅",@"content":@"申嘉湖高速那个路口",@"icon":@""},@{@"nameStr":@"李师傅",@"content":@"申嘉湖高速那个路口",@"icon":@""},@{@"nameStr":@"李师傅",@"content":@"申嘉湖高速那个路口",@"icon":@""}];
    
    self.dataArray = [YBMessageModel mj_objectArrayWithKeyValuesArray:dictArray];
    
    [self messageTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *tableViewID = @"YBMessageTableViewCell";
    
    YBMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YBMessageTableViewCell" owner:nil options:nil] firstObject];
    }
    cell.model = self.dataArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
