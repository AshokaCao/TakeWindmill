//
//  YBCarpoolOrdersVC.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/10.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBCarpoolOrdersVC.h"
#import "YBCarpoolTableViewCell.h"

@interface YBCarpoolOrdersVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *carpoolTableView;

@end

@implementation YBCarpoolOrdersVC

#pragma mark - lazy
- (UITableView *)carpoolTableView {
    if (!_carpoolTableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, YBWidth, YBHeight)];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = LightGreyColor;
        tableView.rowHeight = 141;
        [self.view addSubview:tableView];
        _carpoolTableView = tableView;
    }
    return _carpoolTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self carpoolView];
}

- (void)carpoolView {
    self.title = @"拼车接单";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self carpoolTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YBCarpoolTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBCarpoolTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YBCarpoolTableViewCell" owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
