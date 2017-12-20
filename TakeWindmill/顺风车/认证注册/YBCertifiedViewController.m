//
//  YBCertifiedViewController.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/9.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBCertifiedViewController.h"
#import "YBRegisteredViewController.h"

@interface YBCertifiedViewController ()

@property (weak, nonatomic) IBOutlet UIButton *certifiedButton;
@property (strong, nonatomic) IBOutlet UIView *imageView;

@end

@implementation YBCertifiedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"成为车主";
    //导航栏不透明
//    self.navigationController.navigationBar.translucent = NO;
    self.certifiedButton.layer.cornerRadius = 5.0;
    self.view = _imageView;
    
    [self.certifiedButton addTarget:self action:@selector(certifiedButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)certifiedButtonAction:(UIButton *)sender {
    YBRegisteredViewController *registered = [[YBRegisteredViewController alloc] init];
    [self.navigationController pushViewController:registered animated:NO];
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
