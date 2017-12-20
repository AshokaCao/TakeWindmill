//
//  YBAutomaticSynchronizationVC.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/9/14.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBAutomaticSynchronizationVC.h"

@interface YBASTitleView : UIView

@property (nonatomic, weak) UILabel *contentLabel;

@property (nonatomic, weak) UIButton *errorButton;

@end

@implementation YBASTitleView

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        UILabel *contentLabel  = [[UILabel alloc] init];
        contentLabel.text      = @"已经为你设置最佳条件,可根据个人:偏好修改";
        contentLabel.font      = YBFont(12);
        contentLabel.textColor = [UIColor whiteColor];
        [self addSubview:contentLabel];
        
        _contentLabel = contentLabel;
    }
    return _contentLabel;
}

- (UIButton *)errorButton
{
    if (!_errorButton) {
        UIButton *errorButton = [[UIButton alloc] init];
        [errorButton setImage:[UIImage imageNamed:@"错号"] forState:UIControlStateNormal];
        [self addSubview:errorButton];
        
        _errorButton = errorButton;
    }
    return _errorButton;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.contentLabel.frame = CGRectMake(10, 0, self.frame.size.width - 50, self.frame.size.height);
    self.errorButton.frame  = CGRectMake(CGRectGetMaxX(self.contentLabel.frame) + 10, 15, self.frame.size.height - 30, self.frame.size.height - 30);
}

@end



@interface YBAutomaticSynchronizationVC ()

/**
 * title试图
 */
@property (nonatomic, weak) YBASTitleView *titleView;

/**
 * 出发时间
 */
@property (nonatomic, weak) UILabel *departureTime;

/**
 * 最早时间
 */
@property (nonatomic, weak) UIView *earliestTimeView;

/**
 * 最晚时间
 */
@property (nonatomic, weak) UIView *latestTimeView;

/**
 * 顺路程度
 */
@property (nonatomic, weak) UILabel *incidentallyLabel;
/**
 * 顺路程度
 */
@property (nonatomic, weak) UILabel *alongTheWayLabel;

/**
 * 愿提供座位数
 */
@property (nonatomic, weak) UILabel *numberSeatsLabel;

/**
 * 愿提供座位数
 */
@property (nonatomic, weak) UIButton *openButton;
@end

@implementation YBAutomaticSynchronizationVC

#pragma mark - lazy

- (UIButton *)openButton
{
    if (!_openButton) {
        UIButton *openButton          = [[UIButton alloc] init];
        openButton.layer.cornerRadius = 5;
        openButton.titleLabel.font    = YBFont(14);
        [openButton setTitle:@"立即开启" forState:UIControlStateNormal];
        [openButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [openButton setBackgroundColor:BtnBlueColor];
        [self.view addSubview:openButton];
        _openButton = openButton;
    }
    return _openButton;
}

- (UILabel *)numberSeatsLabel
{
    if (!_numberSeatsLabel) {
        UILabel *numberSeatsLabel      = [[UILabel alloc] init];
        numberSeatsLabel.text          = @"愿提供的座位数";
        numberSeatsLabel.font          = YBFont(16);
        numberSeatsLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:numberSeatsLabel];
        
        _numberSeatsLabel = numberSeatsLabel;
    }
    return _numberSeatsLabel;
}

- (UILabel *)alongTheWayLabel
{
    if (!_alongTheWayLabel) {
        UILabel *alongTheWayLabel       = [[UILabel alloc] init];
        alongTheWayLabel.textColor      = [UIColor lightGrayColor];
        alongTheWayLabel.attributedText = [YBTooler stringSetsTwoColorsLabel:@"至少花5分钟绕路接送乘客（时间仅供参考）" Second:@"5分钟" Colour:BtnBlueColor];
        alongTheWayLabel.font           = YBFont(12);
        alongTheWayLabel.textAlignment  = NSTextAlignmentCenter;
        [self.view addSubview:alongTheWayLabel];
        _alongTheWayLabel = alongTheWayLabel;
    }
    return _alongTheWayLabel;
}

- (UILabel *)incidentallyLabel
{
    if (!_incidentallyLabel) {
        UILabel *incidentallyLabel      = [[UILabel alloc] init];
        incidentallyLabel.text          = @"顺路程度";
        incidentallyLabel.font          = YBFont(16);
        incidentallyLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:incidentallyLabel];
        _incidentallyLabel = incidentallyLabel;
    }
    return _incidentallyLabel;
}

- (UIView *)latestTimeView
{
    if (!_latestTimeView) {
        UIView *latestTimeView            = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.earliestTimeView.frame) + 20, self.earliestTimeView.frame.origin.y, YBWidth / 2 - 40, 60)];
        latestTimeView.layer.cornerRadius = 5;
        latestTimeView.layer.borderWidth  = 1;
        latestTimeView.layer.borderColor  = [UIColor lightGrayColor].CGColor;
        [self.view addSubview:latestTimeView];
        
        UILabel *label      = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, latestTimeView.frame.size.width, latestTimeView.frame.size.height / 2)];
        label.text          = @"最晚";
        label.font          = YBFont(14);
        label.textAlignment = NSTextAlignmentCenter;
        [latestTimeView addSubview:label];
        
        UILabel *label1      = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame), latestTimeView.frame.size.width, latestTimeView.frame.size.height / 2)];
        label1.text          = @"今天 11:00";
        label1.font          = YBFont(14);
        label1.textColor     = BtnBlueColor;
        label1.textAlignment = NSTextAlignmentCenter;
        [latestTimeView addSubview:label1];
        
        _latestTimeView = latestTimeView;
    }
    return _latestTimeView;
}

- (UIView *)earliestTimeView
{
    if (!_earliestTimeView) {
        UIView *earliestTimeView            = [[UIView alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(self.departureTime.frame) + 20, YBWidth / 2 - 40, 60)];
        earliestTimeView.layer.cornerRadius = 5;
        earliestTimeView.layer.borderWidth  = 1;
        earliestTimeView.layer.borderColor  = [UIColor lightGrayColor].CGColor;
        [self.view addSubview:earliestTimeView];

        UILabel *label      = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, earliestTimeView.frame.size.width, earliestTimeView.frame.size.height / 2)];
        label.text          = @"最早";
        label.font          = YBFont(14);
        label.textAlignment = NSTextAlignmentCenter;
        [earliestTimeView addSubview:label];
        
        UILabel *label1      = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame), earliestTimeView.frame.size.width, earliestTimeView.frame.size.height / 2)];
        label1.text          = @"今天 11:00";
        label1.font          = YBFont(14);
        label1.textColor     = BtnBlueColor;
        label1.textAlignment = NSTextAlignmentCenter;
        [earliestTimeView addSubview:label1];
        
        _earliestTimeView = earliestTimeView;

    }
    return _earliestTimeView;
}

- (UILabel *)departureTime
{
    if (!_departureTime) {
        UILabel *departureTime      = [[UILabel alloc] init];
        departureTime.text          = @"出发时间";
        departureTime.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:departureTime];
        
        _departureTime = departureTime;
    }
    return _departureTime;
}

- (YBASTitleView *)titleView
{
    if (!_titleView) {
        YBASTitleView *titleView = [[YBASTitleView alloc] initWithFrame:CGRectMake(0, 0, YBWidth, 40)];
        [self.view addSubview:titleView];
        _titleView = titleView;
    }
    return _titleView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //界面搭建
    [self interfaceToBuild];
}

- (void)interfaceToBuild
{
    self.title                     = @"自动同步";
    self.view.backgroundColor      = [UIColor whiteColor];
    //头部试图
    self.titleView.backgroundColor = BtnBlueColor;
    //
    self.departureTime.frame = CGRectMake(0, CGRectGetMaxY(self.titleView.frame) + 10, YBWidth, 50);
    [self earliestTimeView];
    [self latestTimeView];
    self.incidentallyLabel.frame = CGRectMake(0, CGRectGetMaxY(self.latestTimeView.frame) + 20, YBWidth, 40);
    self.alongTheWayLabel.frame = CGRectMake(0, CGRectGetMaxY(self.incidentallyLabel.frame), YBWidth, 20);
    
    NSArray *itemArray = @[@"80%",@"85%",@"90%",@"其他>"];
     CGFloat btnW = (YBWidth - 70) / 4;
    for (int i = 0; i < itemArray.count; i ++) {
        
        UIButton *btn = [[UIButton alloc] init];
        btn.frame = CGRectMake(20 + i * btnW + i * 10,CGRectGetMaxY(self.alongTheWayLabel.frame) + 10, btnW, 25);
        btn.titleLabel.font = YBFont(14);
        btn.layer.cornerRadius = 2;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [UIColor grayColor].CGColor;
        btn.tag = i;
        
        [btn setTitle:itemArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setTitleColor:BtnOrangeColor forState:UIControlStateSelected];
//        [btn addTarget:self action:@selector(selectBtnBlock:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
    self.numberSeatsLabel.frame = CGRectMake(0, CGRectGetMaxY(self.alongTheWayLabel.frame) + 60, YBWidth, 40);

    NSArray *seatArray = @[@"1座",@"2座",@"3座",@"4座"];
    for (int i = 0; i < seatArray.count; i ++) {
        
        UIButton *btn = [[UIButton alloc] init];
        btn.frame = CGRectMake(20 + i * btnW + i * 10,CGRectGetMaxY(self.numberSeatsLabel.frame) + 10, btnW, 25);
        btn.titleLabel.font = YBFont(14);
        btn.layer.cornerRadius = 2;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [UIColor grayColor].CGColor;
        btn.tag = i;
        
        [btn setTitle:seatArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setTitleColor:BtnOrangeColor forState:UIControlStateSelected];
        //        [btn addTarget:self action:@selector(selectBtnBlock:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
    self.openButton.frame =  CGRectMake(10, CGRectGetMaxY(self.numberSeatsLabel.frame) + 80, YBWidth - 20, 40);
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
