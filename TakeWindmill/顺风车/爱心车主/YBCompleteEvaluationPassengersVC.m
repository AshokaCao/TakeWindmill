//
//  YBCompleteEvaluationPassengersVC.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/9/21.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBCompleteEvaluationPassengersVC.h"

#import "YBWaitingView.h"
#import "XHStarRateView.h"

@interface YBCompleteEvaluationPassengersVC ()<XHStarRateViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;
/**
 * 乘客的信息
 */
@property (nonatomic, weak) YBOwnerInformationView *mationView;

/**
 * 几个button
 */
@property (nonatomic, weak) YBMoreBottomView *bottomView;

/**
 * 价格
 */
@property (nonatomic, weak) UILabel *orderPriceLabel;

/**
 * 明细
 */
@property (nonatomic, weak) UIButton *detailsButton;

/**
 * 提示
 */
@property (nonatomic, weak) UILabel *promptLabel;

/**
 * 他对我的评价
 */
@property (nonatomic, strong) XHStarRateView *hisEvaluation;

/**
 * 我他的评价
 */
@property (nonatomic, strong) XHStarRateView *myComment;

@end

@implementation YBCompleteEvaluationPassengersVC

- (UILabel *)promptLabel
{
    if (!_promptLabel) {
        UILabel *prompt = [[UILabel alloc] init];
        prompt.font = YBFont(12);
        prompt.text = @"车费已到账,请在“钱包”-“余额”中查看";
        prompt.textColor = [UIColor grayColor];
        prompt.textAlignment = NSTextAlignmentCenter;
        [self.scrollView addSubview:prompt];
        _promptLabel = prompt;
    }
    return _promptLabel;
}

- (UIButton *)detailsButton
{
    if (!_detailsButton) {
        CGFloat btnW = 70;
        UIButton *btn = [[UIButton alloc] init];
        btn.titleLabel.font = YBFont(13);
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -btnW *0.1, 0,  btnW *0.1)];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(5, btnW *0.75, 5, - btnW *0.85)];
        [btn setTitle:@"查看明细" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"箭头图标"] forState:UIControlStateNormal];
        [self.scrollView addSubview:btn];
        _detailsButton = btn;
    }
    return _detailsButton;
}
- (YBMoreBottomView *)bottomView
{
    if (!_bottomView) {
        YBMoreBottomView *button = [[YBMoreBottomView alloc] init];
        button.backgroundColor   = [UIColor whiteColor];
        [self.scrollView addSubview:button];
        _bottomView = button;
    }
    return _bottomView;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, YBWidth, YBHeight)];
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
        [matin completeTheEvaluationOfPassengers];
        [matin completeTheEvaluationOfPassengersDict:nil];
        [self.scrollView addSubview:matin];
        
        _mationView = matin;
    }
    return _mationView;
}

- (UILabel *)orderPriceLabel
{
    if (!_orderPriceLabel) {
        UILabel *orderPriceLabel = [[UILabel alloc] init];
        orderPriceLabel.textAlignment = NSTextAlignmentCenter;
        NSString *orderStr = @"37.5元";
        NSMutableAttributedString *order = [YBTooler changeLabelWithText:orderStr frontTextFont:25 Subscript:0 TextLength:orderStr.length - 1 BehindTxetFont:14 Subscript:orderStr.length - 1 TextLength:1];
        [orderPriceLabel setAttributedText:order];
        [self.scrollView addSubview:orderPriceLabel];
        
        _orderPriceLabel = orderPriceLabel;
    }
    return _orderPriceLabel;
}

- (XHStarRateView *)hisEvaluation
{
    if (!_hisEvaluation) {
        XHStarRateView *rateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(YBWidth / 4, CGRectGetMaxY(self.promptLabel.frame) + 40, YBWidth / 2, 40)];
        rateView.rateStyle       = WholeStar;
        rateView.delegate        = self;
        rateView.userInteractionEnabled = NO;
        [self.scrollView addSubview:rateView];
        
        _hisEvaluation = rateView;
    }
    return _hisEvaluation;
}

- (XHStarRateView *)myComment
{
    if (!_myComment) {
        XHStarRateView *rateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(YBWidth / 4, CGRectGetMaxY(self.promptLabel.frame) + 140, YBWidth / 2, 40)];
        rateView.rateStyle       = WholeStar;
        rateView.delegate        = self;
        rateView.userInteractionEnabled = NO;
        [self.scrollView addSubview:rateView];
        
        _myComment = rateView;
    }
    return _myComment;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    //搭建界面
    [self interfaceToBuild];
}

- (void)interfaceToBuild
{
    self.title = @"已完成";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self mationView];
    self.bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.mationView.frame) + 5, YBWidth, 40);
    [self.bottomView PassengerTravelButtonsArray:@[@"导航",@"需要帮助",@"免单",@"更多"]];

    self.orderPriceLabel.frame = CGRectMake(YBWidth / 2- 50, CGRectGetMaxY(self.bottomView.frame) + 25, 100, 40);
    self.detailsButton.frame = CGRectMake(YBWidth / 2 - 35, CGRectGetMaxY(self.orderPriceLabel.frame), 70, 20);
    self.promptLabel.frame = CGRectMake(0, CGRectGetMaxY(self.detailsButton.frame) + 10, YBWidth , 20);

    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(self.promptLabel.frame) + 20, YBWidth - 80, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.scrollView addSubview:line];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(YBWidth / 2 - 40 , line.frame.origin.y - 5, 80, 10)];
    label.font = YBFont(11);
    label.text = @"他对我的评价";
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:label];
    
    //星星
    self.hisEvaluation.currentScore = 5;
    
    NSArray *array = @[@"绅士格调",@"正能量传递着",@"聊得很开心"];
    CGFloat btnWith = 0.0;
    NSInteger row   = 0;
    NSInteger col   = 0;
    NSInteger interval = 40;
    for (int i = 0; i < array.count; i ++) {
        
        CGFloat buttonW = [YBTooler calculateTheStringWidth:array[i] font:12] + 40;
        
        UIButton *btn                   = [[UIButton alloc] init];
        //row > 0 && col == 0
        CGFloat with = btnWith + col * 10 + interval * 2 + buttonW;
        if (with > YBWidth) {
            btnWith = 0;
            col = 0;
            row++;
        }
        btn.frame = CGRectMake(btnWith + col * 10 + interval, row * (30 + 10) + CGRectGetMaxY(self.hisEvaluation.frame) + 10, buttonW, 30);
        btnWith += buttonW;
        col ++;
        btn.tag                         = i;
        btn.titleLabel.font             = YBFont(12);
        btn.titleLabel.textAlignment    = NSTextAlignmentCenter;
        btn.layer.borderWidth           = 1;
        btn.layer.borderColor           = LineLightColor.CGColor;
        [btn setTitle:array[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.scrollView addSubview:btn];
    }

    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(40, row * (30 + 10) + CGRectGetMaxY(self.hisEvaluation.frame) + 70, YBWidth - 80, 1)];
    line1.backgroundColor = [UIColor lightGrayColor];
    [self.scrollView addSubview:line1];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(YBWidth / 2 - 40 , line1.frame.origin.y - 5, 80, 10)];
    label1.font = YBFont(11);
    label1.text = @"我对他的评价";
    label1.textColor = [UIColor lightGrayColor];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:label1];

    self.myComment.frame = CGRectMake(YBWidth / 4, CGRectGetMaxY(label1.frame) + 20, YBWidth / 2, 40);
    self.myComment.currentScore = 5;
    
    self.scrollView.contentSize = CGSizeMake(YBWidth, CGRectGetMaxY([[self.scrollView subviews] lastObject].frame) + 20);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
