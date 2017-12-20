//
//  YBSystemHelpViewController.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/16.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBSystemHelpViewController.h"
#import "YBTextField.h"

@interface YBSystemHelpViewController ()

@end

@implementation YBSystemHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"系统帮忙";
    
    YBTextField *startingPoint = [[YBTextField alloc] initWithFrame:CGRectMake(10, 10, YBWidth / 2.5, 30)];
    [startingPoint LeftWithPicture:@"请输入起点" textColor:[UIColor lightGrayColor] view:[self viewSearchStr:@"路径"]];
    [self.view addSubview:startingPoint];
    
    YBTextField *destination = [[YBTextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(startingPoint.frame) + 10, YBWidth / 2.5, 30)];
    [destination LeftWithPicture:@"请输入终点" textColor:[UIColor lightGrayColor] view:[self viewSearchStr:@"路径"]];
    [self.view addSubview:destination];

    YBTextField *Claim = [[YBTextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(destination.frame) + 10, YBWidth / 2, 30)];
    [Claim LeftWithPicture:@"全程避让，给予绿色通道" textColor:[UIColor lightGrayColor] view:[self viewSearchStr:@"要求"]];
    [self.view addSubview:Claim];

    YBTextField *other = [[YBTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(Claim.frame) + 10, CGRectGetMaxY(destination.frame) + 10, YBWidth / 4, 30)];
    [other LeftWithPicture:@"其他要求" textColor:[UIColor lightGrayColor] view:nil];
    [self.view addSubview:other];
    
}

- (UIView *)viewSearchStr:(NSString *)str {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    view.backgroundColor = BtnBlueColor;
    
    UILabel *label = [[UILabel alloc] initWithFrame:view.bounds];
    label.text = str;
    label.font = YBFont(16);
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    return view;
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
