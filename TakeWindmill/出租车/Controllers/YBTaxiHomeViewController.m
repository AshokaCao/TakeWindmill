//
//  YBTaxiHomeViewController.m
//  TakeWindmill
//
//  Created by AshokaCao on 2017/12/4.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBTaxiHomeViewController.h"
#import "YBTaxiStrokeModel.h"
#import "YBTaxiStrokeTableViewCell.h"
#import "YBRouteDetailsViewController.h"
#import "YBNearPassgerViewController.h"

@interface YBTaxiHomeViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *beginBtn;
@property (weak, nonatomic) IBOutlet UIButton *settingBtn;
@property (weak, nonatomic) IBOutlet UITableView *keysTableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIImageView *nomoreImageView;
@property (weak, nonatomic) IBOutlet UILabel *nomoreLabel;
@property (nonatomic, strong) NSMutableArray *strokeArray;

@end

@implementation YBTaxiHomeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.beginBtn.layer.cornerRadius = 80;
    self.beginBtn.layer.masksToBounds = YES;
    
    self.keysTableView.tableFooterView = [UIView new];
    [self.keysTableView registerNib:[UINib nibWithNibName:@"YBTaxiStrokeTableViewCell" bundle:nil] forCellReuseIdentifier:@"YBTaxiStrokeTableViewCell"];
    self.keysTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setStrokeTableDetails];
    
}

- (void)setStrokeTableDetails
{
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    NSString *userID = [YBUserDefaults valueForKey:_userId];
    dict[@"userid"] = userID;
    NSLog(@"坐标 %@",dict);
    self.strokeArray = [NSMutableArray array];
    [YBRequest postWithURL:TaxiStrokeTable MutableDict:dict success:^(id dataArray) {
        NSLog(@"dataArray - %@",dataArray);
        NSDictionary *dict = dataArray;
        NSDictionary *newDic = [NSDictionary changeType:dict];
        for (NSDictionary *diction in newDic[@"TravelInfoList"]) {
            YBTaxiStrokeModel *model = [YBTaxiStrokeModel new];
            [model setValuesForKeysWithDictionary:diction];
            [self.strokeArray addObject:model];
        }
        if (self.strokeArray) {
            self.beginBtn.enabled = NO;
            self.nomoreLabel.hidden = YES;
            self.nomoreImageView.hidden = YES;
            self.beginBtn.backgroundColor = TxetFiedColor;
        } else {
            self.beginBtn.enabled = YES;
            self.nomoreLabel.hidden = NO;
            self.nomoreImageView.hidden = NO;
            self.beginBtn.backgroundColor = BtnBlueColor;
        }
        [self.keysTableView reloadData];
    } failure:^(id dataArray) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.strokeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBTaxiStrokeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBTaxiStrokeTableViewCell"];
    if (!cell) {
        cell = [[YBTaxiStrokeTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"YBTaxiStrokeTableViewCell"];
    }
    YBTaxiStrokeModel *model = self.strokeArray[indexPath.row];
    [cell showDetailsWith:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBTaxiStrokeModel *model = self.strokeArray[indexPath.row];
    NSString *stat = [NSString stringWithFormat:@"%@",model.Stat];
    if ([stat isEqualToString:@"9"]) {
        
    } else {
        YBRouteDetailsViewController *route = [YBRouteDetailsViewController new];
        route.routeModel = model;
        [self.navigationController pushViewController:route animated:YES];
    }
}

- (IBAction)beginAction:(UIButton *)sender {
    NSLog(@"-----------");
    
    self.beginBtn.selected = !self.beginBtn.isSelected;
    if (self.beginBtn.selected) {
        self.beginBtn.backgroundColor = [UIColor orangeColor];
    } else {
        self.beginBtn.backgroundColor = BtnBlueColor;
    }
}
- (IBAction)settingAction:(UIButton *)sender {
    
}
- (IBAction)nearbyAction:(UIButton *)sender {
    YBNearPassgerViewController *near = [[YBNearPassgerViewController alloc] init];
    near.currLocation = self.currLocation;
    [self.navigationController pushViewController:near animated:YES];
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
