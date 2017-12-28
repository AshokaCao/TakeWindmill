//
//  YBNearPassgerViewController.m
//  TakeWindmill
//
//  Created by AshokaCao on 2017/12/22.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBNearPassgerViewController.h"
#import "YBRouteDetailsViewController.h"
#import "YBNearPassTableViewCell.h"
#import "YBTaxiStrokeModel.h"

@interface YBNearPassgerViewController () <UITableViewDelegate, UITableViewDataSource, YBNearPassTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *nearTableView;
@property (nonatomic, strong) NSMutableArray *strokeArray;

@end

@implementation YBNearPassgerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"附近乘客";
    // Do any additional setup after loading the view from its nib.
    self.nearTableView.rowHeight = 180;
    self.nearTableView.tableFooterView = [[UIView alloc] init];
    [self getNearDatails];
    [self.nearTableView registerNib:[UINib nibWithNibName:@"YBNearPassTableViewCell" bundle:nil] forCellReuseIdentifier:@"YBNearPassTableViewCell"];
    self.nearTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
}

- (void)refresh
{
    [self getNearDatails];
    //结束刷新
    [self.nearTableView.mj_header endRefreshing];
}

- (void)getNearDatails
{
    self.strokeArray = [NSMutableArray array];
    NSMutableDictionary *dict = [YBUserDefaults valueForKey:@"currentLocation"];
    NSMutableDictionary *currDict = [YBTooler dictinitWithMD5];
    currDict[@"userid"] = dict[@"userid"];
    currDict[@"currentlng"] = [NSString stringWithFormat:@"%@",dict[@"lng"]];
    currDict[@"currentlat"] = [NSString stringWithFormat:@"%@",dict[@"lat"]];
    NSLog(@"current - dict %@",dict);
    [YBRequest postWithURL:TaxiNear MutableDict:currDict success:^(id dataArray) {
        NSLog(@"current - details %@",dataArray);
        NSDictionary *diction = dataArray;
        for (NSDictionary *taxiDic in diction[@"TravelInfoList"]) {
            YBTaxiStrokeModel *model = [[YBTaxiStrokeModel alloc] init];
            [model setValuesForKeysWithDictionary:taxiDic];
            [self.strokeArray addObject:model];
        }
        [self.nearTableView reloadData];
    } failure:^(id dataArray) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.strokeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBTaxiStrokeModel *model = self.strokeArray[indexPath.row];
    YBNearPassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBNearPassTableViewCell"];
    cell.delegate = self;
    [cell showDetailWith:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark 抢单按钮
- (void)didselectYBPassengerTableViewCell:(YBNearPassTableViewCell *)cell
{
    NSIndexPath *selectPath = [self.nearTableView indexPathForCell:cell];
    YBTaxiStrokeModel *model = self.strokeArray[selectPath.row];
    
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    NSString *userID = [YBUserDefaults valueForKey:_userId];
    dict[@"userid"] = userID;
    dict[@"travelsysno"] = model.SysNo;
    [YBRequest postWithURL:TaxiRob MutableDict:dict success:^(id dataArray) {
        NSLog(@"rod- %@",dataArray);
        NSString *message = [NSString stringWithFormat:@"%@",dataArray[@"HasError"]];
        if ([message isEqualToString:@"0"]) {
            YBRouteDetailsViewController *route = [[YBRouteDetailsViewController alloc] init];
            [self.navigationController pushViewController:route animated:YES];
        }
    } failure:^(id dataArray) {
        
    }];
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
