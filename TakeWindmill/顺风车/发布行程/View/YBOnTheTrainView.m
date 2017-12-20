//
//  YBOnTheTrainView.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/14.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBOnTheTrainView.h"
#import "YBAboutButton.h"
//#import "YBCityTimeView.h"


@implementation YBCityTimeView

- (YBBaseView *)startTime
{
    if (!_startTime) {
        YBBaseView *startTime = [[YBBaseView alloc] init];
        [self addSubview:startTime];
        _startTime = startTime;
    }
    return _startTime;
}

- (UIImageView *)arrowIamgeView
{
    if (!_arrowIamgeView) {
        UIImageView *arrowIamgeView = [[UIImageView alloc] init];
        [self addSubview:arrowIamgeView];
        _arrowIamgeView = arrowIamgeView;
    }
    return _arrowIamgeView;
}

- (YBBaseView *)endTime
{
    if (!_endTime) {
        YBBaseView *endTime = [[YBBaseView alloc] init];
        [self addSubview:endTime];
        _endTime = endTime;

    }
    return _endTime;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.startTime.frame = CGRectMake(0, 0,  self.frame.size.width / 2 - 14, self.frame.size.height);
    self.startTime.CanClick = YES;
    self.startTime.CanPressLong = YES;
    [self.startTime aboutViewImage:[UIImage imageNamed:@"时间"] imageFrame:CGSizeMake(10, 10) imageBacColor:nil LabelTitle:@"最早出发时间" titleFont:13 titleColor:[UIColor grayColor] subTitle:nil subTitleFont:0 subtitleColor:nil];
    
    self.arrowIamgeView.frame = CGRectMake(CGRectGetMaxX(self.startTime.frame), self.frame.size.height / 2 - 3, 28, 5);
    self.arrowIamgeView.image = [UIImage imageNamed:@"jiantou"];

    self.endTime.frame = CGRectMake(CGRectGetMaxX(self.arrowIamgeView.frame) , 0,  self.frame.size.width / 2 - 14, self.frame.size.height);
    self.endTime.CanClick = YES;
    self.endTime.CanPressLong = YES;
    [self.endTime aboutViewImage:nil imageFrame:CGSizeMake(0 , 0) imageBacColor:nil LabelTitle:@"最晚出发时间" titleFont:13 titleColor:[UIColor grayColor] subTitle:nil subTitleFont:0 subtitleColor:nil];
 
}
@end

@interface YBOnTheTrainView ()

@property (nonatomic, assign) CGRect viewFrame;

@end

@implementation YBOnTheTrainView

- (YBBaseView *)startingPointView
{
    if (!_startingPointView) {
        //出行起点
        YBBaseView *startingPointView   = [[YBBaseView alloc] init];
        startingPointView.CanPressLong  = YES;
        startingPointView.CanClick      = YES;
        [self addSubview:startingPointView];
        _startingPointView = startingPointView;
    }
    return _startingPointView;
}

- (YBBaseView *)endView
{
    if (!_endView) {
        //出行终点
        YBBaseView *endView     = [[YBBaseView alloc] init];
        endView.CanPressLong    = YES;
        endView.CanClick        = YES;
        [self addSubview:endView];
        _endView = endView;
    }
    return _endView;
}

- (YBBaseView *)timeView
{
    if (!_timeView) {
        //出行时间
        YBBaseView *timeView    = [[YBBaseView alloc] init];
        timeView.CanPressLong   = YES;
        timeView.CanClick       = YES;
        [self addSubview:timeView];
        _timeView = timeView;
    }
    return _timeView;
}

- (YBCityTimeView *)cityTimeView
{
    if (!_cityTimeView) {
        //跨城出行时间
        YBCityTimeView *cityTimeView = [[YBCityTimeView alloc] init];
        [self addSubview:cityTimeView];
        _cityTimeView = cityTimeView;
    }
    return _cityTimeView;
}

- (YBBaseView *)numberpeopleView
{
    if (!_numberpeopleView) {
        //出行人数
        YBBaseView *numberpeopleView    = [[YBBaseView alloc] init];
        numberpeopleView.CanPressLong   = YES;
        numberpeopleView.CanClick       = YES;
        [self addSubview:numberpeopleView];
        _numberpeopleView = numberpeopleView;
    }
    return _numberpeopleView;
}

- (YBBaseView *)fightView
{
    if (!_fightView) {
        //感谢费
        YBBaseView *fightView = [[YBBaseView alloc] init];
        fightView.CanPressLong = YES;
        fightView.CanClick = YES;
        [self addSubview:fightView];
        _fightView = fightView;
    }
    return _fightView;
}

- (YBBaseView *)claimView
{
    if (!_claimView) {
        //出行要求
        YBBaseView *claimView = [[YBBaseView alloc] init];
        claimView.CanPressLong = YES;
        claimView.CanClick = YES;
        [self addSubview:claimView];
        _claimView = claimView;
    }
    return _claimView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat viewH = (self.frame.size.height - 3) / 4;
    CGFloat viewW = self.frame.size.width;
    
    self.startingPointView.frame = CGRectMake(0,0,viewW,viewH);
    CGSize size = CGSizeMake(10, 10);
    [self.startingPointView aboutViewImage:nil imageFrame:size imageBacColor:BtnGreenColor LabelTitle:@"你在哪儿" titleFont:14 titleColor:[UIColor blackColor] subTitle:nil subTitleFont:0 subtitleColor:nil];
    //下划线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.startingPointView.frame), self.frame.size.width - 20, 1)];
    line.backgroundColor = LineLightColor;
    [self addSubview:line];
    
    //出行终点
    self.endView.frame = CGRectMake(0, CGRectGetMaxY(line.frame), viewW, viewH);
    [self.endView aboutViewImage:nil imageFrame:size imageBacColor:BtnOrangeColor LabelTitle:@"你要去哪儿" titleFont:14 titleColor:BtnOrangeColor subTitle:nil subTitleFont:0 subtitleColor:nil];
    //下划线1
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.endView.frame), self.frame.size.width - 20, 1)];
    line1.backgroundColor = LineLightColor;
    [self addSubview:line1];
    
    //跨城时间
    self.cityTimeView.frame = CGRectMake(0, CGRectGetMaxY(line1.frame), self.frame.size.width, (self.frame.size.height - 3) / 4);
    self.cityTimeView.hidden = YES;
    
    //出行时间
    self.timeView.frame = CGRectMake(0, CGRectGetMaxY(line1.frame), self.frame.size.width, (self.frame.size.height - 3) / 4);
    [self.timeView aboutViewImage:[UIImage imageNamed:@"时间"] imageFrame:size imageBacColor:nil LabelTitle:@"出发时间" titleFont:14 titleColor:[UIColor grayColor] subTitle:nil subTitleFont:0 subtitleColor:nil];
    self.cityTimeView.hidden = YES;
    //下划线2
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.timeView.frame), self.frame.size.width - 20, 1)];
    line2.backgroundColor = LineLightColor;
    [self addSubview:line2];
    
    //出行人数
    self.numberpeopleView.frame = CGRectMake(0,CGRectGetMaxY(line2.frame), self.timeView.frame.size.width / 3 - 1 , (self.frame.size.height - 3) / 4);
    [self.numberpeopleView aboutViewImage:[UIImage imageNamed:@"人数"] imageFrame:size imageBacColor:nil LabelTitle:@"乘车人数" titleFont:14 titleColor:[UIColor grayColor] subTitle:nil subTitleFont:0 subtitleColor:nil];
    //下划线3
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.numberpeopleView.frame), CGRectGetMaxY(self.timeView.frame) + 10 , 1, 20)];
    line3.backgroundColor = LineLightColor;
    [self addSubview:line3];
    
    //感谢费
    self.fightView.frame = CGRectMake(CGRectGetMaxX(line3.frame),  CGRectGetMaxY(self.timeView.frame), self.timeView.frame.size.width / 3 - 1, (self.frame.size.height - 3) / 4);
    [self.fightView aboutViewImage:[UIImage imageNamed:@"感谢费-1"] imageFrame:size imageBacColor:nil LabelTitle:@"感谢费" titleFont:14 titleColor:[UIColor grayColor] subTitle:nil subTitleFont:0 subtitleColor:nil];
    //下划线4
    UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.fightView.frame), CGRectGetMaxY(self.timeView.frame) + 10, 1,20)];
    line4.backgroundColor = LineLightColor;
    [self addSubview:line4];
    
    //出行要求
    self.claimView.frame = CGRectMake(CGRectGetMaxX(line4.frame),  CGRectGetMaxY(self.timeView.frame), self.timeView.frame.size.width / 3 - 1, (self.frame.size.height - 3) / 4);
    [self.claimView aboutViewImage:[UIImage imageNamed:@"出行要求"] imageFrame:size imageBacColor:nil LabelTitle:@"出行要求" titleFont:14 titleColor:[UIColor grayColor] subTitle:nil subTitleFont:0 subtitleColor:nil];

    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, CGRectGetMaxY(self.claimView.frame) + 5);
}

- (void)CrossTheCity:(BOOL)isCross {

    self.timeView.hidden = isCross;
    self.cityTimeView.hidden = !isCross;
}

@end
