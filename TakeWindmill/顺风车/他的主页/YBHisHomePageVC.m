//
//  YBHisHomePageVC.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/9/23.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBHisHomePageVC.h"

@interface YBHisHomePageVC ()

/**
 * 底部View
 */
@property (nonatomic, weak) UIView *bottomView;

@end

@implementation YBHisHomePageVC

- (UIView *)bottomView
{
    if (!_bottomView) {
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, YBHeight - 40, YBWidth, 40)];
        [self.view addSubview:bottomView];
        
        //关注
        UIButton *attention = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, YBWidth / 2, bottomView.frame.size.height)];
        [attention setTitle:@"关注" forState:UIControlStateNormal];
        [attention setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [attention setImage:[UIImage imageNamed:@"公益行动图标"] forState:UIControlStateNormal];
        [bottomView addSubview:attention];
        //竖线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(attention.frame), 5, 1, bottomView.frame.size.height - 10)];
        line.backgroundColor = LineLightColor;
        [bottomView addSubview:line];
        //消息
        UIButton *news = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(line.frame), 0, YBWidth / 2, bottomView.frame.size.height)];
        [news setTitle:@"消息" forState:UIControlStateNormal];
        [news setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [news setImage:[UIImage imageNamed:@"消息中心"] forState:UIControlStateNormal];
        [bottomView addSubview:news];
        _bottomView = bottomView;
    }
    return _bottomView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Ta的主页";
    self.view.backgroundColor = LineLightColor;
    self.bottomView.backgroundColor = [UIColor whiteColor];
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
