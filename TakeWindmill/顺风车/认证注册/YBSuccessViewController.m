//
//  YBSuccessViewController.m
//  TakeWindmill
//
//  Created by HUSHOUHUA华 on 2017/11/17.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBSuccessViewController.h"

@interface YBSuccessViewController ()

@end

@implementation YBSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title =@"认证成功";
    UIImageView * imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"打钩图标"]];
    [self.view addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.centerX.equalTo(self.view);
    }];
    
    UILabel * label = [[UILabel alloc]init];
    label.text = @"您的资料已提交成功,请耐心等待审核!";
    label.textColor = BtnGreenColor;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageV.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
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
