//
//  YBThanksFee.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/23.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBThanksFee.h"

@interface YBThanksFee ()

@property (nonatomic, strong) NSMutableArray *itemArray;

@end

@implementation YBThanksFee

- (UIButton *)determineBtn
{
    if (!_determineBtn) {
        UIButton *determineBtn = [[UIButton alloc] init];
        determineBtn.titleLabel.font = YBFont(15);
        [determineBtn setTitle:@"确定" forState:UIControlStateNormal];
        [determineBtn addTarget:self action:@selector(determineAction:) forControlEvents:UIControlEventTouchUpInside];
        [determineBtn setBackgroundColor:BtnBlueColor];
        [self addSubview:determineBtn];
        
        _determineBtn = determineBtn;
    }
    return _determineBtn;
}

- (UIButton *)selectedBtn
{
    if (!_selectedBtn) {
        UIButton *selectedBtn = [[UIButton alloc] init];
        [self addSubview:selectedBtn];
        _selectedBtn = selectedBtn;
    }
    return _selectedBtn;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _itemArray = [NSMutableArray array];
        for (int i = 0; i < 4; i ++) {
            UIButton *btn = [[UIButton alloc] init];
            [self addSubview:btn];
            [_itemArray addObject:btn];
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat btnW = (YBWidth - 70) / 4;
    
    for (int i = 0; i < _itemArray.count; i ++) {
        
        UIButton *btn = _itemArray[i];
        btn.frame = CGRectMake(20 + i * btnW + i * 10, 20, btnW, 40);
        btn.titleLabel.font = YBFont(14);
        btn.layer.cornerRadius = 2;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [UIColor grayColor].CGColor;
        btn.tag = i;
        
        [btn setTitle:_moneyArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setTitleColor:BtnOrangeColor forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(selectBtnBlock:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.determineBtn.frame = CGRectMake(10, 80, YBWidth - 20, 40);

    
}

- (void)determineAction:(UIButton *)sender
{
    if (_selectDetermine) {
        _selectDetermine(sender);
    }
}

- (void)selectBtnBlock:(UIButton *)sender
{
    if (sender != self.selectedBtn) {
        self.selectedBtn.selected = NO;
        self.selectedBtn.layer.borderColor = [UIColor grayColor].CGColor;
        
        [sender.layer setBorderColor:BtnOrangeColor.CGColor];
        sender.selected = YES;
        self.selectedBtn = sender;
    }else{
        self.selectedBtn.selected = YES;
        self.selectedBtn.layer.borderColor = BtnOrangeColor.CGColor;
    }
    
    if (sender.tag == 3) {
        if (_selectedBlock) {
            _selectedBlock(sender);
        }
    }
}

@end
