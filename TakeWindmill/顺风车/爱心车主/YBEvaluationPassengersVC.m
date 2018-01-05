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

/**
 * 按钮数组
 */
@property (nonatomic, strong) YBEvaluationButtonView *evaluationView;

/**
 * 可选则的印象
 */
@property (nonatomic, strong) NSArray *evaluationArray;

/**
 * 评星
 */
@property (nonatomic, assign) CGFloat star;

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

- (YBEvaluationButtonView *)evaluationView
{
    if (!_evaluationView) {
        _evaluationView = [[YBEvaluationButtonView alloc] init];
        [self.scrollView addSubview:_evaluationView];
    }
    return _evaluationView;
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
        [matin evaluatioOfPassengersDict:self.passengerDict];
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
    //乘客信息
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
    self.rateView.currentScore = 0.0;
    
    self.submitButton.frame = CGRectMake(10, self.scrollView.frame.size.height - 60, YBWidth - 20, 40);
}

//- (void)submitButtonAction:(UIButton *)sender
//{
//    YBCompleteEvaluationPassengersVC *complete = [[YBCompleteEvaluationPassengersVC alloc] init];
//    [self.navigationController pushViewController:complete animated:YES];
//}

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

- (void)starRateView:(XHStarRateView *)starRateView currentScore:(CGFloat)currentScore{
    NSLog(@"%ld----  %f",starRateView.tag,currentScore);
    
    self.star = currentScore;
    if (currentScore  == 5) {//好评
        [self commentContentPostType:@"11"];
    }
    else {//不好评
        [self commentContentPostType:@"12"];
    }
}

#pragma mark - 评价内容
- (void)commentContentPostType:(NSString *)type
{
    NSString *urlStr = baseinfocommonlistPath;
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    [dict setObject:type forKey:@"typefid"];
    
    [YBRequest postWithURL:urlStr MutableDict:dict success:^(id dataArray) {
        YBLog(@"%@",dataArray);
        self.evaluationArray = dataArray[@"BaseInfoCommonList"];
        [self afterTheStarRatingArray:self.evaluationArray];
    } failure:^(id dataArray) {
        YBLog(@"%@",dataArray);
    }];
}

#pragma mark - 选择评星
- (void)afterTheStarRatingArray:(NSArray *)array
{
    //评级按钮数组
    self.evaluationView.frame   = CGRectMake(0, CGRectGetMaxY(self.rateView.frame), YBWidth, 100);
    [self.evaluationView evaluationButtonIsDisplayed:array];
}


#pragma mark - 匿名提交
- (void)submitButtonAction:(UIButton *)sender
{
    NSString *urlStr = travelcommentsavePath;
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    [dict setObject:self.passengerDict[@"SysNo"] forKey:@"travelsysno"];//行程SysNo
    [dict setObject:[YBTooler getTheUserId:self.view] forKey:@"userid"];//用户Id
    [dict setObject:@"2" forKey:@"typefid"];//评论类型，1-乘客，2-司机
    [dict setObject:[NSString stringWithFormat:@"%f",self.star] forKey:@"star"]; //星级
    
    [YBRequest postWithURL:urlStr MutableDict:dict View:self.scrollView success:^(id dataArray) {
        YBLog(@"%@",dataArray);
        YBCompleteEvaluationPassengersVC *complete = [[YBCompleteEvaluationPassengersVC alloc] init];
        [self.navigationController pushViewController:complete animated:YES];
    } failure:^(id dataArray) {
    }];
}
@end
