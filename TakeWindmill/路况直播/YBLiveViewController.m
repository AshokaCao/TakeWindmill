//
//  YBLiveViewController.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/12.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBLiveViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface YBLiveViewController ()

@property (nonatomic, strong) MPMoviePlayerViewController *movie;

@end

@implementation YBLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"视频详情";
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
