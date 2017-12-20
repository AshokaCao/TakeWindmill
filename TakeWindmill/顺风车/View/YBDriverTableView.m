//
//  YBDriverTableView.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/11/14.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBDriverTableView.h"
#import "YBTakeWindmollView.h"
#import "YBPublishedTripCell.h"
#import "YBFindOwnerCell.h"
#import "YBRouteTableViewCell.h"
#import "YBDriver_CommonRouteCell.h"

#import "YBCommonRouteVC.h"
#import "YBOwnerTravelVC.h"
#import "YBManagementRouteVC.h"
#import "YBNearbyPassengersVC.h"
#import "YBLookingPassengersrVC.h"

@interface YBDriverTableView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) YBTakeHeadView *driverHeadView;

@end

@implementation YBDriverTableView
- (YBTakeHeadView *)driverHeadView
{
    if (!_driverHeadView) {
        YBTakeHeadView *driverHeadView = [[YBTakeHeadView alloc] initWithFrame:CGRectMake(0, 0, YBWidth , 140)];
        driverHeadView.nameStr         = @"木星";
        _driverHeadView = driverHeadView;
        
        
        //爱心车主
        __weak __typeof__(self) weakSelf = self;
        self.driverHeadView.selectButtonBlock = ^(id sender) {
            if (weakSelf.isDriverNotCompleted == 2) {
                [MBProgressHUD showError:@"尚有未完成的行程" toView:weakSelf];
                return ;
            }
            YBOwnerTravelVC *onthe = [[YBOwnerTravelVC alloc] init];
            [[weakSelf viewController].navigationController pushViewController:onthe animated:YES];
        };
    }
    return _driverHeadView;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style]) {
        self.tag             = 1;
        self.delegate        = self;
        self.dataSource      = self;
        self.separatorStyle  = UITableViewCellSeparatorStyleNone;
        self.tableHeaderView = self.driverHeadView;
    }
    return self;
}


- (void)managementBtnAction:(UIButton *)sender
{
    YBManagementRouteVC *manage = [[YBManagementRouteVC alloc] init];
    [[self viewController].navigationController pushViewController:manage animated:YES];
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.isDriverNotCompleted + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger sect = -1;
    if (self.isDriverNotCompleted == 2) {//有未完成行程
        sect ++;
        if (section == sect) return 1;
    }
    if (section == sect + 1) {
        return 2;
    }
    else {
        return self.commonRoute.count > 0 ? self.commonRoute.count : 1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.isDriverNotCompleted == 2  && section == 0) { //发布行程
        UIView *view    = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBWidth, 40)];
        
        UILabel *label  = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 20)];
        label.font      = YBFont(15);
        label.text      = @"已发布行程";
        [view addSubview:label];
        return view;
    }
    else if (section == self.isDriverNotCompleted){ //常用路线
        UIView *view    = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBWidth, 40)];
        
        UILabel *label  = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 20)];
        label.font      = YBFont(15);
        label.text      = @"常用路线";
        [view addSubview:label];
        
        CGFloat btnW = 60;
        UIButton *managementBtn  = [[UIButton alloc] initWithFrame:CGRectMake(YBWidth - btnW - 10, 10, btnW, 20)];
        managementBtn.titleLabel.font = YBFont(13);
        [managementBtn setTitle:@"管理" forState:UIControlStateNormal];
        [managementBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [managementBtn setImage:[UIImage imageNamed:@"箭头"] forState:UIControlStateNormal];
        [managementBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, - managementBtn.imageView.bounds.size.width, 0, managementBtn.imageView.bounds.size.width *0.5)];
        [managementBtn setImageEdgeInsets:UIEdgeInsetsMake(3, managementBtn.titleLabel.bounds.size.width + 20 ,3, 5)];
        [managementBtn addTarget:self action:@selector(managementBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:managementBtn];
        
        return view;
    }
    else { //
        UIView *view    = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBWidth, 40)];
        
        UILabel *label  = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 20)];
        label.font      = YBFont(15);
        label.text      = @"发现";
        [view addSubview:label];
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && self.isDriverNotCompleted == 2) { // 未完成行程
        YBPublishedTripCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBPublishedTripCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"YBPublishedTripCell" owner:self options:nil] firstObject];
        }
        tableView.rowHeight = 70;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.driverTripDic  = self.driverDict;
        return cell;
    }
    else if (indexPath.section == self.isDriverNotCompleted){ //常用路线
        
        if (self.commonRoute.count > 0) {//
            YBDriver_CommonRouteCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YBDriver_CommonRouteCell"];
            if (!cell) {
                cell = [[YBDriver_CommonRouteCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"YBDriver_CommonRouteCell"];
            }
            tableView.rowHeight = 60;
            [cell driver_CommonRoute:self.commonRoute[indexPath.row]];
            return cell;
        }else {
            YBRouteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBRouteTableViewCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"YBRouteTableViewCell" owner:self options:nil] firstObject];
            }
            tableView.rowHeight = 70;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    else { //发现
        YBFindOwnerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBFindOwnerCell"];
        if (!cell) {
            cell = [[YBFindOwnerCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"YBFindOwnerCell"];
        }
        tableView.rowHeight = 120;
        if (indexPath.row == 0) {
            cell.typeStr = @"附近乘客";
            cell.passengerArray = self.passengersNearby;
        }
        else{
            cell.typeStr = @"跨城乘客";
            cell.passengerArray = self.passengersCity;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isDriverNotCompleted == 2 && indexPath.section == 0) {
        YBLookingPassengersrVC *passeng = [[YBLookingPassengersrVC alloc] init];
        passeng.strokeSysNo = self.driverDict[@"SysNo"];
        [[self viewController].navigationController pushViewController:passeng animated:YES];
    }
    else if (indexPath.section == self.isDriverNotCompleted){ //常用路线
        if (self.commonRoute.count == 0) {
            YBCommonRouteVC *common = [[YBCommonRouteVC alloc] init];
            [[self viewController].navigationController pushViewController:common animated:YES];
        }else {
            YBNearbyPassengersVC *nearby = [[YBNearbyPassengersVC alloc] init];
            NSDictionary *dic            = self.commonRoute[indexPath.row];
            nearby.isTypes               = [dic[@"StartCity"] isEqualToString:dic[@"EndCity"]] ? 0 : 1;
            nearby.cityId                = dic[@"StartCityId"];
            nearby.destination           = dic[@"EndAddress"];
            [[self viewController].navigationController pushViewController:nearby animated:YES];
        }
    }
    else {
        YBNearbyPassengersVC *nearby = [[YBNearbyPassengersVC alloc] init];
        nearby.isTypes               = indexPath.row;
        nearby.cityId                = self.cityId;
        [[self viewController].navigationController pushViewController:nearby animated:YES];
    }
}

//获取View所在的Viewcontroller方法
- (UIViewController *)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
