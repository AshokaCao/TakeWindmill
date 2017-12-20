//
//  YBTaxiViewController.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/11.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBTaxiViewController.h"
#import "YBSearchView.h"
#import "YBTaxiDriverViewController.h"
#import "YBDriverSideTaxiVC.h"
#import "YBRegisteredTaxiVC.h"

@interface YBTaxiViewController ()
//搜索框
@property (nonatomic, strong) YBSearchView *searchView;

@end

@implementation YBTaxiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"出租车";
    
    //    __weak __typeof(self)wself = self;
    //    _searchView.selectBlock = ^(UIButton *sender) {
    ////        YBLocationSearchVC *selec = [[YBLocationSearchVC alloc] initWithNibName:@"YBLocationSearchVC" bundle:nil];
    ////        [wself presentViewController:selec animated:YES completion:nil];
    //    };
    
    //扫一扫
    UIButton *scanButton = [[UIButton alloc] initWithFrame:CGRectMake(YBWidth - 30, 30, 30, 30)];
    [scanButton setBackgroundImage:[UIImage imageNamed:@"扫码图标"] forState:UIControlStateNormal];
    [scanButton setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:scanButton];
    
    //切换司机端
    YBBaseButton *driverButton = [YBBaseButton buttonWithFrame:CGRectMake(YBWidth - 70, CGRectGetMaxY(scanButton.frame) + 20, 70, 25) Strtitle:@"切换司机端" titleColor:[UIColor whiteColor] titleFont:12 textAlignment:NSTextAlignmentCenter image:nil BackgroundColor:BtnBlueColor cornerRadius:3];
    [driverButton addTarget:self action:@selector(driverButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:driverButton];
    
    YBBaseButton *registerBtn = [YBBaseButton buttonWithFrame:CGRectMake(YBWidth - 70, CGRectGetMaxY(driverButton.frame) + 20, 70, 25) Strtitle:@"注册出租车" titleColor:[UIColor whiteColor] titleFont:12 textAlignment:NSTextAlignmentCenter image:nil BackgroundColor:BtnBlueColor cornerRadius:3];
    [registerBtn addTarget:self action:@selector(registerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
    //现在预约
    UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(10, YBHeight - 190, 80, 30)];
    statusView.backgroundColor = LightGreyColor;
    statusView.layer.cornerRadius = 15;
    [self.view addSubview:statusView];
    //现在
    UIButton *nowButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    nowButton.layer.cornerRadius = 15;
    nowButton.titleLabel.font = YBFont(14);
    [nowButton setTitle:@"现在" forState:UIControlStateNormal];
    [nowButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [nowButton setBackgroundColor:[UIColor whiteColor]];
    [statusView addSubview:nowButton];
    
    //现在
    UIButton *reservationButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 0, 40, 30)];
    reservationButton.layer.cornerRadius = 10;
    reservationButton.titleLabel.font = YBFont(14);
    [reservationButton setTitle:@"预约" forState:UIControlStateNormal];
    [reservationButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [statusView addSubview:reservationButton];
    
    _searchView = [[YBSearchView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(statusView.frame) + 20, YBWidth - 20, 100)];
    [self.view addSubview:_searchView];
    
}

- (void)driverButtonAction:(UIButton *)sender {
    YBTaxiDriverViewController *driver = [[YBTaxiDriverViewController alloc] init];
    [self.navigationController pushViewController:driver animated:YES];
}
- (void)registerBtnAction:(UIButton *)sender {
    YBRegisteredTaxiVC *vc = [[YBRegisteredTaxiVC alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end


