//
//  YBSearchView.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/11.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBSearchView.h"

#define ViewHeight self.bounds.size.height / 4

@interface YBSearchView ()

@property (weak, nonatomic)  UIView *dotsView;

@property (weak, nonatomic)  UIView *dotsView1;

@end

@implementation YBSearchView

- (UIView *)dotsView {
    if (!_dotsView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(25, ViewHeight - 5, 10, 10)];
        view.layer.cornerRadius = 5;
        view.backgroundColor = BtnBlueColor;
        [self addSubview:view];
        _dotsView = view;
    }
    return _dotsView;
}

- (UIView *)dotsView1 {
    if (!_dotsView1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(25, ViewHeight * 3 - 5, 10, 10)];
        view.layer.cornerRadius = 5;
        view.backgroundColor = BtnBlueColor;
        [self addSubview:view];
        _dotsView1 = view;
    }
    return _dotsView1;
}

//起点
- (UIButton *)startingPoint {
    if (!_startingPoint) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.dotsView.frame) + 5, ViewHeight - 10, YBWidth - 80, 20)];
        btn.tag = 10086;
        [btn setTitle:@"在中河大厦附近" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        btn.titleLabel.font = YBFont(15);
        [self addSubview:btn];
        _startingPoint = btn;
    }
    return _startingPoint;
}

//终点
- (UIButton *)endButton {
    if (!_endButton) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.dotsView1.frame) + 5, ViewHeight * 3  - 10 , YBWidth - 80, 20)];
        btn.tag = 10087;
        [btn setTitle:@"你要去哪儿" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        btn.titleLabel.font = YBFont(15);
        [self addSubview:btn];
        _endButton = btn;
    }
    return _endButton;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.layer.shadowOpacity = 0.5;
    self.layer.cornerRadius = 5;
    [self dotsView];
    [self dotsView1];
    self.startingPoint.tag = 1;
    self.endButton.tag = 2;
}

- (void)selectAction:(UIButton *)sender {
    if (_selectBlock) {
        _selectBlock(sender);
    }
}

@end
