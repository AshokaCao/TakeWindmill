//
//  YBRegisteredTaxiVC.m
//  TakeWindmill
//
//  Created by HUSHOUHUA华 on 2017/11/18.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBRegisteredTaxiVC.h"
#import "YBInformationVC.h"

@interface YBRegisteredTaxiVC ()

@end

@implementation YBRegisteredTaxiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"注册";
    [self setUI];
    [self requestData];
}
-(void)requestData{
    
}
-(void)setUI{
    WEAK_SELF;
    UILabel * label = [[UILabel alloc]init];
    label.text = @"提交认证资料后就可以开始接单啦";
    label.textColor = kTextGreyColor;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kpadding*2);
        make.centerX.equalTo(weakSelf.view);
    }];
    
    UILabel *msg = [[UILabel alloc]init];
    msg.text = @"-- 请在填写前准备好以下证件 --";
    msg.textColor = kTextGreyColor;
    [self.view addSubview:msg];
    [msg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(kpadding*2);
        make.centerX.equalTo(weakSelf.view);
    }];
    
    UIImageView * imageV = [[UIImageView alloc]init];
    [imageV sd_setImageWithURL:[NSURL URLWithString:DownloadPhoto(@"bankcard")] placeholderImage:nil];
    [self.view addSubview:imageV];
    
    UIImageView * imageV1 = [[UIImageView alloc]init];
     [imageV1 sd_setImageWithURL:[NSURL URLWithString:DownloadPhoto(@"drivecard")] placeholderImage:nil];
    [self.view addSubview:imageV1];
    NSMutableArray * arrayView = [NSMutableArray array];
    for (int i =0; i<2; i++) {
        UILabel *label = [[UILabel alloc]init];
          label.textAlignment = NSTextAlignmentCenter;
        if (i==0) {
            label.text = @"身份证";
        }else{
            label.text = @"行驶证";
        }
        [self.view addSubview:label];
        [arrayView addObject:label];
    }
    
    CGFloat padding = 30;//269  182
    [@[imageV,imageV1] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:padding leadSpacing:padding tailSpacing:padding];
    [@[imageV,imageV1]  mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.equalTo(msg.mas_bottom).offset(kpadding*2);
      make.height.mas_equalTo(100);
    }];
    [arrayView mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:padding leadSpacing:padding tailSpacing:padding];
    [arrayView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageV1.mas_bottom).offset(kpadding);
    }];
    
    UIImageView * imageV2 = [[UIImageView alloc]init];
     [imageV2 sd_setImageWithURL:[NSURL URLWithString:DownloadPhoto(@"identcard")] placeholderImage:nil];
    [self.view addSubview:imageV2];
    
    UIImageView * imageV3 = [[UIImageView alloc]init];
     [imageV3 sd_setImageWithURL:[NSURL URLWithString:DownloadPhoto(@"servicecard")] placeholderImage:nil];
    [self.view addSubview:imageV3];
    
    
    [@[imageV2,imageV3] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:padding leadSpacing:padding tailSpacing:padding];
    [@[imageV2,imageV3]  mas_makeConstraints:^(MASConstraintMaker *make) {
        UILabel * lb = arrayView[0];
        make.top.equalTo(lb.mas_bottom).offset(kpadding);
        make.height.mas_equalTo(100);
    }];
    
    [arrayView removeAllObjects];
    for (int i =0; i<2; i++) {
        UILabel *label = [[UILabel alloc]init];
        label.textAlignment = NSTextAlignmentCenter;
        if (i==0) {
            label.text = @"监督卡";
        }else{
            label.text = @"从业资格证";
        }
        [self.view addSubview:label];
        [arrayView addObject:label];
    }
    [arrayView mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:padding leadSpacing:padding tailSpacing:padding];
    [arrayView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageV2.mas_bottom).offset(kpadding);
    }];
    
    UIButton *nextStepBtn = [[UIButton alloc]init];
    [nextStepBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextStepBtn setBackgroundColor:BtnBlueColor];
    nextStepBtn.layer.cornerRadius = 5;
    [nextStepBtn addTarget:self action:@selector(nextStepBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextStepBtn];
    [nextStepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.width.mas_equalTo(YBWidth-30);
        make.height.mas_equalTo(40);
        make.bottom.equalTo(self.view).offset(-30);
    }];
}
//下一步
-(void)nextStepBtnTap:(UIButton *)sender{
     NSString *userID = [YBUserDefaults valueForKey:_userId];
    if (!userID.length) {
        [MBProgressHUD showError:@"请先登录" toView:self.view];
        return;
    }
    YBInformationVC * VC= [[YBInformationVC alloc]init];
    [self.navigationController pushViewController:VC animated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
