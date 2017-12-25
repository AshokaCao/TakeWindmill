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

- (UIView *)addTitleViewStr:(NSString *)str
{
    UIView *view    = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBWidth, 40)];
    
    UILabel *label  = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 20)];
    label.font      = YBFont(15);
    label.text      = str;
    [view addSubview:label];
    
    if ([str isEqualToString:@"常用路线"]) {
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
    }
    return view;
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sect = 2;//发现和常用路线
    if (self.driverDict) sect ++;//有未完成行程
    if (self.myOrderArray.count != 0) sect ++;//我的行程
    return sect;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isDriverNotCompleted == 2) {//有未完成行程
        if (self.myOrderArray.count != 0) {//有我的行程
            if (section == 0) return 1;
            if (section == 1) return self.myOrderArray.count;
            if (section == 2) return 2;
            if (section == 3) return self.commonRoute.count;
        }
        else {
            if (section == 0) return 1;
            if (section == 1) return 2;
            if (section == 2) return self.commonRoute.count;
        }
    }
    if (section == 0) return 2;
    else return self.commonRoute.count > 0 ? self.commonRoute.count : 1 ;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.isDriverNotCompleted == 2) { //有未完成行程
        if (self.myOrderArray.count != 0) {//有我的行程
            if (section == 0) return [self addTitleViewStr:@"已发布行程"];
            if (section == 1) return [self addTitleViewStr:@"我的行程"];
            if (section == 2) return [self addTitleViewStr:@"发现"];
            else              return [self addTitleViewStr:@"常用路线"];
        }
        else {
            if (section == 0) return [self addTitleViewStr:@"已发布行程"];
            if (section == 1) return [self addTitleViewStr:@"发现"];
            else              return [self addTitleViewStr:@"常用路线"];
        }
    }
    else {
        if (section == 0) return [self addTitleViewStr:@"发现"];
        else              return [self addTitleViewStr:@"常用路线"];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isDriverNotCompleted == 2 && indexPath.section == 0) { // 未完成行程
        
        YBPublishedTripCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBPublishedTripCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"YBPublishedTripCell" owner:self options:nil] firstObject];
        }
        tableView.rowHeight = 70;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell driver_PublishedOrders:self.driverDict];
        return cell;
    }
    if (self.isDriverNotCompleted == 2 && indexPath.section == 1 && self.myOrderArray) { // 我的订单
        
        YBPublishedTripCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBPublishedTripCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"YBPublishedTripCell" owner:self options:nil] firstObject];
        }
        tableView.rowHeight = 70;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell driver_MyOrder:self.myOrderArray[indexPath.row]];
        return cell;
    }
    if (indexPath.section == self.isDriverNotCompleted){ // 常用路线
        
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
