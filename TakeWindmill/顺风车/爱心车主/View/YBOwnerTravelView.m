//
//  YBOwnerTravelView.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/9/9.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBOwnerTravelView.h"

@interface YBOwnerTravelView ()

@end

@implementation YBOwnerTravelView

#pragma mark - lazy
- (UIButton *)oneWayButton
{
    if (!_oneWayButton) {
        UIButton *oneWayButton       = [[UIButton alloc] init];
        oneWayButton.titleLabel.font = YBFont(14);
        oneWayButton.selected        = YES;
        [oneWayButton setBackgroundColor:[UIColor whiteColor]];
        [oneWayButton setTitle:@"单程" forState:UIControlStateNormal];
        [oneWayButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [oneWayButton setTitleColor:BtnBlueColor forState:UIControlStateSelected];
        [oneWayButton addTarget:self action:@selector(oneWayButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:oneWayButton];
        
        _oneWayButton = oneWayButton;
    }
    return _oneWayButton;
}

- (UIButton *)roundTripButton
{
    if (!_roundTripButton) {
        UIButton *roundTripButton = [[UIButton alloc] init];
        roundTripButton.selected  = NO;
        roundTripButton.titleLabel.font = YBFont(14);
        [roundTripButton setBackgroundColor:[UIColor whiteColor]];
        [roundTripButton setTitle:@"跨城" forState:UIControlStateNormal];
        [roundTripButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [roundTripButton setTitleColor:BtnBlueColor forState:UIControlStateSelected];
        [roundTripButton addTarget:self action:@selector(roundTriButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:roundTripButton];
        
        _roundTripButton = roundTripButton;
    }
    return _roundTripButton;
}

- (UIView *)line
{
    if (!_line) {
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = BtnBlueColor;
        [self addSubview:line];
        
        _line = line;
    }
    return _line;
}

- (YBBaseView *)startPoint
{
    if (!_startPoint) {
        YBBaseView *startPoint  = [[YBBaseView alloc] init];
        startPoint.CanClick     = YES;
        startPoint.CanPressLong = YES;
        [self addSubview:startPoint];
        _startPoint = startPoint;
    }
    return _startPoint;
}

- (YBBaseView *)endPoint
{
    if (!_endPoint) {
        YBBaseView *endPoint  = [[YBBaseView alloc] init];
        endPoint.CanClick     = YES;
        endPoint.CanPressLong = YES;
        [self addSubview:endPoint];
        _endPoint = endPoint;
    }
    return _endPoint;
}

- (YBBaseView *)seatView
{
    if (!_seatView) {
        YBBaseView *seatView  = [[YBBaseView alloc] init];
        seatView.CanClick     = YES;
        seatView.CanPressLong = YES;
        [self addSubview:seatView];
        _seatView = seatView;
    }
    return _seatView;
}

- (YBBaseView *)timeView
{
    if (!_timeView) {
        YBBaseView *timeView  = [[YBBaseView alloc] init];
        timeView.CanClick     = YES;
        timeView.CanPressLong = YES;
        [self addSubview:timeView];
        _timeView = timeView;
    }
    return _timeView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat viewW = self.frame.size.width;
    CGFloat viewH = self.frame.size.height / 4;
   
    self.backgroundColor       = LineLightColor;
    self.oneWayButton.frame    = CGRectMake(0, 0, viewW / 2, viewH);
    self.roundTripButton.frame = CGRectMake(CGRectGetMaxX(self.oneWayButton.frame), 0, viewW / 2, viewH);
    self.line.frame            = CGRectMake(0, CGRectGetMaxY(self.oneWayButton.frame) - 1, viewW / 2, 3);
    self.startPoint.frame      = CGRectMake(0, CGRectGetMaxY(self.oneWayButton.frame) + 2, viewW, viewH);
    self.endPoint.frame        = CGRectMake(0, CGRectGetMaxY(self.startPoint.frame) + 1, viewW, viewH);
    self.seatView.frame        = CGRectMake(0, CGRectGetMaxY(self.endPoint.frame) + 1, viewW / 2, viewH);
    self.timeView.frame        = CGRectMake(CGRectGetMaxX(self.seatView.frame), CGRectGetMaxY(self.endPoint.frame) + 1, viewW / 2, viewH);
    
    
    [self.startPoint aboutViewImage:nil imageFrame:CGSizeMake(0, 0) imageBacColor:BtnGreenColor LabelTitle:@"你现在哪儿" titleFont:14 titleColor:[UIColor lightGrayColor] subTitle:nil subTitleFont:0 subtitleColor:nil];
    [self.endPoint aboutViewImage:nil imageFrame:CGSizeMake(0, 0) imageBacColor:BtnBlueColor LabelTitle:@"你要去哪儿" titleFont:14 titleColor:BtnBlueColor subTitle:nil subTitleFont:0 subtitleColor:nil];
    [self.seatView aboutViewImage:[UIImage imageNamed:@"是否拼座"] imageFrame:CGSizeMake(10, 10) imageBacColor:nil LabelTitle:@"选择座位" titleFont:14 titleColor:[UIColor lightGrayColor] subTitle:nil subTitleFont:0 subtitleColor:nil];
    self.seatView.label.textAlignment = NSTextAlignmentCenter;
    [self.timeView aboutViewImage:[UIImage imageNamed:@"时间"] imageFrame:CGSizeMake(10, 10) imageBacColor:nil LabelTitle:@"出发时间" titleFont:14 titleColor:[UIColor lightGrayColor] subTitle:nil subTitleFont:0 subtitleColor:nil];
    self.timeView.label.textAlignment = NSTextAlignmentCenter;

}

- (void)oneWayButtonAction:(UIButton *)sender
{
    sender.selected                 = YES;
    self.roundTripButton.selected   = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.line.frame                 = CGRectMake(sender.origin.x, CGRectGetMaxY(sender.frame) - 1, sender.frame.size.width, 3);
    }];
}

- (void)roundTriButtonAction:(UIButton *)sender
{
    sender.selected                 = YES;
    self.oneWayButton.selected      = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.line.frame                 = CGRectMake(sender.origin.x, CGRectGetMaxY(sender.frame) - 1, sender.frame.size.width, 3);
    }];
}
@end

//*************************************************正在寻找乘客(司机端)*************************************************//
@interface YBLookingView ()

@end

@implementation YBLookingView



@end
