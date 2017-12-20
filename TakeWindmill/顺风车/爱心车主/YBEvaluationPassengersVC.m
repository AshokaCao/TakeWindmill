//
//  YBEvaluationPassengersVC.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/9/21.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBEvaluationPassengersVC.h"
#import "YBCompleteEvaluationPassengersVC.h"

#import "YBWaitingView.h"
#import "XHStarRateView.h"

@interface YBEvaluationPassengersVC ()<XHStarRateViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;

/**
 * 乘客的信息
 */
@property (nonatomic, weak) YBOwnerInformationView *mationView;

/**
 * 乘客的信息
 */
@property (nonatomic, strong) XHStarRateView *rateView;

/**
 * 提交
 */
@property (nonatomic, strong) UIButton *submitButton;

@end

@implementation YBEvaluationPassengersVC

- (UIButton *)submitButton
{
    if (!_submitButton) {
        UIButton *submitButton = [[UIButton alloc] init];
        submitButton.titleLabel.font = YBFont(14);
        submitButton.layer.cornerRadius = 5;
        [submitButton setBackgroundColor:BtnBlueColor];
        [submitButton setTitle:@"提  交" forState:UIControlStateNormal];
        [submitButton addTarget:self action:@selector(submitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:submitButton];
        
        _submitButton = submitButton;
    }
    return _submitButton;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 10, YBWidth, YBHeight)];
        scrollView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:scrollView];
        _scrollView = scrollView;
    }
    return _scrollView;
}

- (YBOwnerInformationView *)mationView
{
    if (!_mationView) {
        YBOwnerInformationView *matin = [[YBOwnerInformationView alloc] initWithFrame:CGRectMake(10, 10, YBWidth - 20, 60)];
        [matin evaluatioOfPassengers];
        [matin evaluatioOfPassengersDict:nil];
        [self.scrollView addSubview:matin];
        
        _mationView = matin;
    }
    return _mationView;
}

- (XHStarRateView *) rateView
{
    if (!_rateView) {
        XHStarRateView *rateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(YBWidth / 4, CGRectGetMaxY(self.mationView.frame) + 40, YBWidth / 2, 40)];
        rateView.rateStyle       = WholeStar;
        rateView.delegate        = self;
        rateView.currentScore    = 0;
        [self.scrollView addSubview:rateView];
        
        _rateView = rateView;
    }
    return _rateView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //搭建界面
    [self interfaceToBuild];
    
}

- (void)interfaceToBuild
{
    self.title = @"评价乘客";
    self.view.backgroundColor = LightGreyColor;
    [self mationView];

    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(self.mationView.frame) + 20, YBWidth - 60, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.scrollView addSubview:line];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(YBWidth / 2 - 50, CGRectGetMaxY(self.mationView.frame) + 15, 100, 10)];
    label.font = YBFont(11);
    label.text = @"描述我对ta的印象";
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:label];
    
    //评星
    [self rateView];
//    self.rateView.userInteractionEnabled = NO;
    
    NSArray *array = @[@"成熟性感",@"这个美女不一般",@"美女",@"摄影达人",@"一辈子的武才人",@"话痨",@"晚上约么",@"Duang~Duang"];
    CGFloat btnWith = 0.0;
    NSInteger row   = 0;
    NSInteger col   = 0;
    for (int i = 0; i < array.count; i ++) {
        
        CGFloat buttonW = [YBTooler calculateTheStringWidth:array[i] font:12] + 20;
        
        UIButton *btn                   = [[UIButton alloc] init];
        //row > 0 && col == 0
        CGFloat with = btnWith + col * 10 + 60 + buttonW;
        if (with > YBWidth) {
            btnWith = 0;
            col = 0;
            row++;
        }
        btn.frame = CGRectMake(btnWith + col * 10 + 30, row * (30 + 10) + CGRectGetMaxY(self.rateView.frame) + 20, buttonW, 30);
        btnWith += buttonW;
        col ++;
        btn.tag                         = i;
        btn.titleLabel.font             = YBFont(12);
        btn.titleLabel.textAlignment    = NSTextAlignmentCenter;
        btn.layer.cornerRadius          = 5;
        btn.layer.borderWidth           = 1;
        btn.layer.borderColor           = [UIColor lightGrayColor].CGColor;
        [btn setTitle:array[i] forState:UIControlStateNormal];
        [btn setTitleColor:BtnOrangeColor forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(impressionLabelAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:btn];
    }
    
    self.submitButton.frame = CGRectMake(10, self.scrollView.frame.size.height - 60, YBWidth - 20, 40);
}

- (void)submitButtonAction:(UIButton *)sender
{
    YBCompleteEvaluationPassengersVC *complete = [[YBCompleteEvaluationPassengersVC alloc] init];
    [self.navigationController pushViewController:complete animated:YES];
}

#pragma mark - 印象标签
- (void)impressionLabelAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        sender.layer.borderColor = BtnOrangeColor.CGColor;
    }
    else {
        sender.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
}

-(void)starRateView:(XHStarRateView *)starRateView currentScore:(CGFloat)currentScore{
    NSLog(@"%ld----  %f",starRateView.tag,currentScore);
}


@end
