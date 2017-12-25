//
//  YBTaxiDriverViewController.m
//  TakeWindmill
//
//  Created by AshokaCao on 2017/12/3.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBTaxiDriverViewController.h"
#import "YBTaxiMineViewController.h"
#import "YBTaxiHomeViewController.h"
#import "MLMSegmentManager.h"

@interface YBTaxiDriverViewController ()
@property (nonatomic, strong) MLMSegmentHead *segHead;
@property (nonatomic, strong) MLMSegmentScroll *segScroll;

@end

@implementation YBTaxiDriverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self segmentStyle5];
//    LBSegmentControl * segmentControl = [[LBSegmentControl alloc] initStaticTitlesWithFrame:CGRectMake(0, 0, YBWidth, 44)];
//    segmentControl.titles = @[@"我的", @"首页"];
//    segmentControl.viewControllers = @[mineVC, homeVC];
//    segmentControl.titleNormalColor = [UIColor blueColor];
//    segmentControl.titleSelectColor = [UIColor redColor];
//    [segmentControl setBottomViewColor:[UIColor blueColor]];
//    segmentControl.isTitleScale = YES;
//
//    [self.view addSubview:segmentControl];
}
- (void)segmentStyle5 {
    YBTaxiMineViewController * mineVC = [[YBTaxiMineViewController alloc] init];
    YBTaxiHomeViewController * homeVC = [[YBTaxiHomeViewController alloc] init];
    homeVC.currLocation = self.currLocation;
    NSArray *viewVc = @[mineVC,homeVC];
    NSArray *list = @[@"我的", @"首页"];
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44) titles:list headStyle:SegmentHeadStyleLine layoutStyle:MLMSegmentLayoutCenter];
    _segHead.headColor = [UIColor clearColor];
    _segHead.fontScale = .85;
    _segHead.fontSize = 15;
    _segHead.lineScale = .9;
    _segHead.equalSize = YES;
    _segHead.bottomLineHeight = 0;
    
    
    
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) vcOrViews:viewVc];
    _segScroll.loadAll = NO;
    _segScroll.showIndex = 2;
    
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
        self.navigationItem.titleView = _segHead;
        [self.view addSubview:_segScroll];
    }];
}
- (void)getSomeThingTo
{
    
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
