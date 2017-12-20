//
//  YBNavigationController.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/7.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBNavigationController.h"

@interface YBNavigationController ()

@end

@implementation YBNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;

}

/**
 * 这个方法是为了，后台进入前台，导航栏的位置会改变
 */
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
//    self.navigationBar.frame = CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 44);
}

@end
