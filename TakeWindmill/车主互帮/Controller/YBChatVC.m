//
//  YBChatVC.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/11/24.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBChatVC.h"
#import "YBHelpMessageCell.h"
#import "YBHelpInfoVC.h"

@interface YBChatVC ()

@end

@implementation YBChatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
    [self registerClass:[YBHelpMessageCell class] forMessageClass:[YBHelpMessage class]];

}
#pragma mark override
- (void)didTapMessageCell:(RCMessageModel *)model {
    [super didTapMessageCell:model];
    if ([model.content isKindOfClass:[YBHelpMessage class]]) {
        YBHelpInfoVC * vc = [[YBHelpInfoVC alloc]init];
        [self.navigationController pushViewController:vc animated:NO];
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
