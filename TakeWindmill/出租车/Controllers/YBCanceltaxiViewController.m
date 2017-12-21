//
//  YBCanceltaxiViewController.m
//  TakeWindmill
//
//  Created by AshokaCao on 2017/12/20.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBCanceltaxiViewController.h"
#import "YBChooseCauseTableViewCell.h"

@interface YBCanceltaxiViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *cancelTableView;
@property (nonatomic, strong) NSArray *causeArray;

@end

@implementation YBCanceltaxiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.causeArray = @[@"行程有变,不需用车",@"平台派单太远",@"发错订单",@"尝试多次,联系不上司机",@"司机以各种理由不来接我",@"司机要求加价或现金交易",@"车辆信息与订单显示不符"];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.causeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@""];
    
    
    return cell;
}

- (IBAction)commitAction:(UIButton *)sender {
    
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
