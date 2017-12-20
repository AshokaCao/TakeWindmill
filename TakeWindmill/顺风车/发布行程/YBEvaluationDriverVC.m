//
//  YBEvaluationDriverVC.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/11/9.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBEvaluationDriverVC.h"

#import "XHStarRateView.h"
#import "YBWaitingView.h"

@interface YBEvaluationDriverVC ()<XHStarRateViewDelegate>

/**
 * 司机信息
 */
@property (nonatomic, weak) YBOwnerInformationView *titleView;

/**
 * 车费清单
 */
@property (nonatomic, weak) UIButton *fareListButton;

/**
 * 车费
 */
@property (nonatomic, weak) UILabel *priceLabel;

/**
 * 分割线
 */
@property (nonatomic, weak) UIView *line;

/**
 * 评分
 */
@property (nonatomic, strong) XHStarRateView *scoreView;

/**
 * 评分语
 */
@property (nonatomic, weak) UITextField *othersTxet;

/**
 * 匿名提交
 */
@property (nonatomic, weak) UIButton *submitButton;

/**
 * 按钮数组
 */
@property (nonatomic, strong) YBEvaluationButtonView *evaluationView;

/**
 * 评价选择按钮数组
 */
@property (nonatomic, strong) NSArray *evaluationArray;

/**
 * 评星
 */
@property (nonatomic, assign) CGFloat star;
@end

@implementation YBEvaluationDriverVC

#pragma mark - lazy
- (YBEvaluationButtonView *)evaluationView
{
    if (!_evaluationView) {
        _evaluationView = [[YBEvaluationButtonView alloc] init];
        [self.view addSubview:_evaluationView];
    }
    return _evaluationView;
}

- (YBOwnerInformationView *)titleView
{
    if (!_titleView) {
        YBOwnerInformationView *titleView = [[YBOwnerInformationView alloc] init];
        titleView.backgroundColor = LightGreyColor;
        [self.view addSubview:titleView];
        _titleView = titleView;
    }
    return _titleView;
}

- (UIButton *)fareListButton
{
    if (!_fareListButton) {
        UIButton *fareListButton                    = [[UIButton alloc] init];
        fareListButton.titleLabel.font              = YBFont(15);
        fareListButton.contentHorizontalAlignment   = UIControlContentHorizontalAlignmentLeft;
        [fareListButton setTitle:@"车费清单(根据实际里程、时长)" forState:UIControlStateNormal];
        [fareListButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.view addSubview:fareListButton];
        _fareListButton = fareListButton;
    }
    return _fareListButton;
}

- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        UILabel *priceLabel = [[UILabel alloc] init];
        priceLabel.font     = YBFont(16);
        [self.view addSubview:priceLabel];
        _priceLabel         = priceLabel;
    }
    return _priceLabel;
}

- (UIView *)line
{
    if (!_line) {
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = LightGreyColor;
        [self.view addSubview:line];
        _line = line;
    }
    return _line;
}

- (XHStarRateView *)scoreView
{
    if (!_scoreView) {
        XHStarRateView *rateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(YBWidth / 4, CGRectGetMaxY(self.line.frame) + 20 , YBWidth / 2, 40)];
        rateView.rateStyle       = WholeStar;
        rateView.delegate        = self;
        [self.view addSubview:rateView];
        _scoreView = rateView;
    }
    return _scoreView;
}

- (UITextField *)othersTxet
{
    if (!_othersTxet) {
        UITextField *others     = [[UITextField alloc] init];
        others.borderStyle      = UITextBorderStyleRoundedRect;
        others.placeholder      = @"其他想说的(将匿名并延迟告知司机)";
        others.font             = [UIFont fontWithName:@"Arial" size:14.0f];
        others.backgroundColor  = LineLightColor;
        [self.view addSubview:others];
        _othersTxet = others;
    }
    return _othersTxet;
}

- (UIButton *)submitButton
{
    if (!_submitButton) {
        UIButton *submitButton = [[UIButton alloc] init];
        submitButton.layer.cornerRadius = 5;
        [submitButton setBackgroundColor:BtnBlueColor];
        [submitButton setTitle:@"匿名提交" forState:UIControlStateNormal];
        [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [submitButton addTarget:self action:@selector(submitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:submitButton];
        _submitButton = submitButton;
    }
    return _submitButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //界面搭建
    [self InterfaceToBuild];
}

#pragma makr - 界面搭建
- (void)InterfaceToBuild
{
    self.title = @"评价";
    self.view.backgroundColor = [UIColor whiteColor];
    
    YBLog(@"%@",self.driverDict);
    //司机信息
    self.titleView.frame = CGRectMake(0, 0, YBWidth, 80);
    [self.titleView evaluationDriverDict:self.driverDict];
    
    //车费清单
    self.fareListButton.frame   = CGRectMake(20, CGRectGetMaxY(self.titleView.frame) + 10, YBWidth * 2 / 3, 40);
    //价格
    self.priceLabel.frame       = CGRectMake(YBWidth - 60, CGRectGetMaxY(self.titleView.frame) + 10, 40, 40);
    self.priceLabel.text        = @"70元";
    //下划线
    self.line.frame             = CGRectMake(20, CGRectGetMaxY(self.fareListButton.frame) + 5, YBWidth - 40, 1);
    //评星
    self.scoreView.currentScore = 0.0;
    //其他评价
    self.othersTxet.frame       = CGRectMake(40, CGRectGetMaxY(self.scoreView.frame) + 40, YBWidth - 80, 40);
    //匿名评价
    self.submitButton.frame     = CGRectMake(10, CGRectGetMaxY(self.othersTxet.frame) + 15, YBWidth - 20, 40);
    
}

#pragma mark - 选择评星
- (void)afterTheStarRatingArray:(NSArray *)array
{
    //评级按钮数组
    self.evaluationView.frame   = CGRectMake(0, CGRectGetMaxY(self.scoreView.frame), YBWidth, 100);
    [self.evaluationView evaluationButtonIsDisplayed:array];
    
    //其他评价
    self.othersTxet.frame       = CGRectMake(30, CGRectGetMaxY(self.evaluationView.frame) + 10, YBWidth - 60, 40);
    //匿名评价
    self.submitButton.frame     = CGRectMake(10, CGRectGetMaxY(self.othersTxet.frame) + 15, YBWidth - 20, 40);
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
    }];
}

#pragma mark - 匿名提交
- (void)submitButtonAction:(UIButton *)sender
{
    NSString *urlStr = travelcommentsavePath;
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    [dict setObject:self.driverDict[@"SysNo"] forKey:@"travelsysno"];//行程SysNo
    [dict setObject:[YBTooler getTheUserId:self.view] forKey:@"userid"];//用户Id
    [dict setObject:@"1" forKey:@"typefid"];//评论类型，1-乘客，2-司机
    [dict setObject:[NSString stringWithFormat:@"%f",self.star] forKey:@"star"]; //星级
    NSString *tempString = [NSString stringWithFormat:@"%@,%@",[self.evaluationView.selectArray componentsJoinedByString:@","],self.othersTxet.text];//分隔符逗号
    [dict setObject:tempString forKey:@"comment"];//评论内容

    [YBRequest postWithURL:urlStr MutableDict:dict View:self.view success:^(id dataArray) {
        YBLog(@"%@",dataArray);
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"评价成功!感谢您的参与和评价！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        [alertVC addAction:action];
        [self presentViewController:alertVC animated:YES completion:nil];
    } failure:^(id dataArray) {
    }];
}

#pragma maerk - 代理
-(void)starRateView:(XHStarRateView *)starRateView currentScore:(CGFloat)currentScore
{
    NSLog(@"%ld----  %f",starRateView.tag,currentScore);
    self.star = currentScore;
    if (currentScore  == 5) {//好评
        [self commentContentPostType:@"9"];
    }
    else {//不好评
        [self commentContentPostType:@"10"];
    }
}

@end
