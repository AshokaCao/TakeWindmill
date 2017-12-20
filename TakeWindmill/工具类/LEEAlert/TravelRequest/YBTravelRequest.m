//
//  YBTravelRequest.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/23.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBTravelRequest.h"

@interface YBTravelRequest ()

@property (weak, nonatomic)  YBBaseView *titleView;

@property (weak, nonatomic)  UIButton *claimButton;

@property (weak, nonatomic)  UIButton *claimButton1;

@property (weak, nonatomic)  UIButton *claimButton2;

@property (weak, nonatomic)  UIButton *confirmButton;

@end

@implementation YBTravelRequest

- (NSMutableArray *)subscriptArray
{
    if (!_subscriptArray) {
        _subscriptArray = [NSMutableArray array];
    }
    return _subscriptArray;
}

- (YBBaseView *)titleView
{
    if (!_titleView) {
        YBBaseView *titleView = [[YBBaseView alloc] init];
        [self addSubview:titleView];
        
        _titleView = titleView;
    }
    return _titleView;
}

- (UIButton *)claimButton
{
    if (!_claimButton) {
        UIButton *claimButton = [[UIButton alloc] init];
        claimButton.tag = 1;
        claimButton.layer.cornerRadius = 2;
        claimButton.layer.borderWidth = 1;
        claimButton.titleLabel.font = YBFont(12);
        claimButton.layer.borderColor = [UIColor grayColor].CGColor;
        [claimButton setTitle:@"有宠物" forState:UIControlStateNormal];
        [claimButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [claimButton setTitleColor:BtnOrangeColor forState:UIControlStateSelected];
        [claimButton addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:claimButton];
        
        _claimButton = claimButton;
    }
    return _claimButton;
}

- (UIButton *)claimButton1
{
    if (!_claimButton1) {
        UIButton *claimButton1 = [[UIButton alloc] init];
        claimButton1.tag = 2;
        claimButton1.layer.cornerRadius = 2;
        claimButton1.layer.borderWidth = 1;
        claimButton1.titleLabel.font = YBFont(12);
        claimButton1.layer.borderColor = [UIColor grayColor].CGColor;
        [claimButton1 setTitle:@"有大件行李" forState:UIControlStateNormal];
        [claimButton1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [claimButton1 setTitleColor:BtnOrangeColor forState:UIControlStateSelected];
        [claimButton1 addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:claimButton1];
        _claimButton1 = claimButton1;
    }
    return _claimButton1;
}

- (UIButton *)claimButton2
{
    if (!_claimButton2) {
        UIButton *claimButton2 = [[UIButton alloc] init];
        claimButton2.tag = 3;
        claimButton2.layer.cornerRadius = 2;
        claimButton2.layer.borderWidth = 1;
        claimButton2.titleLabel.font = YBFont(12);
        claimButton2.titleLabel.numberOfLines=0;
        claimButton2.layer.borderColor = [UIColor grayColor].CGColor;
        [claimButton2 setTitle:@"需要走高速,高速费用由我承担" forState:UIControlStateNormal];
        [claimButton2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [claimButton2 setTitleColor:BtnOrangeColor forState:UIControlStateSelected];
        [claimButton2 addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:claimButton2];
        _claimButton2 = claimButton2;
    }
    return _claimButton2;
}

- (UIButton *)confirmButton
{
    if (!_confirmButton) {
        
        UIButton *confirmButton = [[UIButton alloc] init];
        confirmButton.titleLabel.font = YBFont(12);
        [confirmButton setTitle:@"无特殊需求" forState:UIControlStateNormal];
        [confirmButton setBackgroundColor:BtnBlueColor];
        [confirmButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:confirmButton];
        _confirmButton = confirmButton;
    }
    return _confirmButton;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleView.frame     = CGRectMake(10, 10, YBWidth - 20, 20);
    self.claimButton.frame   = CGRectMake(20, CGRectGetMaxY(self.titleView.frame) + 20, 60, 30);
    self.claimButton1.frame  = CGRectMake(CGRectGetMaxX(_claimButton.frame) + 10, CGRectGetMaxY(self.titleView.frame) + 20, 80, 30);
    self.claimButton2.frame  = CGRectMake(CGRectGetMaxX(_claimButton1.frame) + 10, CGRectGetMaxY(self.titleView.frame) + 20, 170, 30);
    self.confirmButton.frame = CGRectMake(10, CGRectGetMaxY(self.claimButton2.frame) + 20, YBWidth - 20, 40);
    
    [self.titleView aboutViewImage:nil imageFrame:CGSizeMake(10, 10) imageBacColor:[UIColor grayColor] LabelTitle:@"填写下列信息,方便车主与你沟通,减少行程纠纷" titleFont:12 titleColor:[UIColor grayColor] subTitle:nil subTitleFont:0 subtitleColor:nil];
    [self judgmentSelected];
}

- (void)judgmentSelected
{
    if (self.subscriptArray.count != 0) {
        [_confirmButton setTitle:@"确认添加" forState:UIControlStateNormal];

        for (NSString *index in self.subscriptArray) {
            NSInteger tag = [index integerValue];
            switch (tag) {
                case 1:
                    self.claimButton.selected = YES;
                    self.claimButton.layer.borderColor = BtnOrangeColor.CGColor;
                    break;
                case 2:
                    self.claimButton1.selected = YES;
                    self.claimButton1.layer.borderColor = BtnOrangeColor.CGColor;
                    break;
                case 3:
                    self.claimButton2.selected = YES;
                    self.claimButton2.layer.borderColor = BtnOrangeColor.CGColor;
                    break;
                    
                default:
                    break;
            }
        }
    }
}

- (void)confirmAction:(UIButton *)sender
{
    
    if (_selectedConfirmBlock) {
        _selectedConfirmBlock(self.subscriptArray);
    }
}

- (void)selectAction:(UIButton *)sender
{
    [_confirmButton setTitle:@"确认添加" forState:UIControlStateNormal];
    sender.selected = !sender.selected;
    if (sender.selected) {
        [_subscriptArray addObject:[NSString stringWithFormat:@"%ld",sender.tag]];
        sender.layer.borderColor = BtnOrangeColor.CGColor;
    }else {
        for (NSString *str in self.subscriptArray) {
            if ([str isEqualToString:[NSString stringWithFormat:@"%ld",sender.tag]]) {
                [self.subscriptArray removeObject:str];
                sender.layer.borderColor = [UIColor grayColor].CGColor;
                return;
            }
        }
    }

}


@end
