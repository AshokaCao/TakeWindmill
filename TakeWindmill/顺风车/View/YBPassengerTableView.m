//
//  YBPassengerTableView.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/11/14.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBPassengerTableView.h"
#import "YBTakeWindmollView.h"
#import "YBPublishedTripCell.h"
#import "YBFindTableViewCell.h"

#import "YBOnTheTrainVC.h"
#import "YBWaitingOrdersVC.h"
#import "YBRegisteredViewController.h"

@interface YBPassengerTableView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) YBTakeHeadView *takeHeadView;

@end

@implementation YBPassengerTableView

- (YBTakeHeadView *)takeHeadView
{
    if (!_takeHeadView) {
        YBTakeHeadView *takeHeadView = [[YBTakeHeadView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width , 140)];
        
        takeHeadView.nameStr         = @"***";
        _takeHeadView                = takeHeadView;
//        环保乘客
        self.dictArray = @[@{@"icon":@"成为车主",@"name":@"成为车主",@"subtitle":@"顺路接人平摊油费"}];
        __weak __typeof__(self) weakSelf = self;
        self.takeHeadView.selectButtonBlock = ^(id sender) {
            if (weakSelf.isPassengerNotCompleted == 2) {
                [MBProgressHUD showError:@"尚有未完成的行程" toView:weakSelf];
                return ;
            }
            YBOnTheTrainVC *onthe = [[YBOnTheTrainVC alloc] init];
            //使用方法：
            [[weakSelf viewController].navigationController pushViewController:onthe animated:YES];
        };
    }
    return _takeHeadView;
}


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style]) {
        self.tag                = 0;
        self.delegate           = self;
        self.rowHeight          = 40;
        self.dataSource         = self;
        self.separatorStyle     = UITableViewCellSeparatorStyleNone;
        self.tableHeaderView    = self.takeHeadView;
    }
    return self;
}

- (void)setNameStr:(NSString *)nameStr
{
    self.takeHeadView.nameStr = nameStr;
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.isPassengerNotCompleted;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.isPassengerNotCompleted == 2 && section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBWidth, 40)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 20)];
        label.font = YBFont(15);
        label.text = @"已发布行程";
        [view addSubview:label];
        return view;
    }
    else {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBWidth, 40)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 20)];
        label.font = YBFont(15);
        label.text = @"发现";
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
    if (indexPath.section == 0 && self.isPassengerNotCompleted == 2) {//已有发布行程
        YBPublishedTripCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBPublishedTripCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"YBPublishedTripCell" owner:self options:nil] firstObject];
        }
        tableView.rowHeight = 70;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.strokeDict = self.passengerDict;
        return cell;
    }
    YBFindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBFindTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YBFindTableViewCell" owner:self options:nil] firstObject];
    }
    cell.backgroundColor = [UIColor clearColor];
    tableView.rowHeight = 40;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.dictArray[indexPath.row][@"icon"]]];
    cell.nameLabel.text = self.dictArray[indexPath.row][@"name"];
    cell.titleLabel.text = self.dictArray[indexPath.row][@"subtitle"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isPassengerNotCompleted == 2 && indexPath.section == 0) {
        YBWaitingOrdersVC *wang = [[YBWaitingOrdersVC alloc] init];
        wang.travelSysNo        = self.passengerDict[@"SysNo"];
        [[self viewController].navigationController pushViewController:wang animated:YES];
    }
    else {
        YBRegisteredViewController *registerd = [[YBRegisteredViewController alloc] init];
        [[self viewController].navigationController pushViewController:registerd animated:YES];
    }
}

//获取View所在的Viewcontroller方法
- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
@end
