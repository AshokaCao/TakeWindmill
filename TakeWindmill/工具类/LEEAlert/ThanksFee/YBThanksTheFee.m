//
//  YBThanksTheFee.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/23.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBThanksTheFee.h"

@interface YBThanksTheFee ()

@property (nonatomic, weak) UILabel *monyLabel;

@property (nonatomic, weak) UILabel *yuanLabel;

@property (nonatomic, weak) UIView *lineView;

@end

@implementation YBThanksTheFee

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UILabel *monyLabel = [[UILabel alloc] init];
        [self addSubview:monyLabel];
        self.monyLabel = monyLabel;
        
        UITextField *monyText = [[UITextField alloc] init];
        [self addSubview:monyText];
        self.monyText = monyText;
        
        UILabel *yuanLabel = [[UILabel alloc] init];
        [self addSubview:yuanLabel];
        self.yuanLabel = yuanLabel;
        
        UIView *lineView = [[UIView alloc] init];
        [self addSubview:lineView];
        self.lineView = lineView;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.monyLabel.frame = CGRectMake(20, 10, 40, 30);
    self.monyLabel.text = @"金额";
    self.monyLabel.textColor = [UIColor grayColor];
    
    self.monyText.frame = CGRectMake(CGRectGetMaxX(self.monyLabel.frame), 10, YBWidth - 160, 30);
    self.monyText.borderStyle = UITextBorderStyleNone;
    self.monyText.textAlignment = NSTextAlignmentCenter;
    self.monyText.placeholder = @"0-200";
    self.monyText.textColor = [UIColor grayColor];
    self.monyText.keyboardType = UIKeyboardTypeNumberPad;

    
    self.yuanLabel.frame = CGRectMake(CGRectGetMaxX(self.monyText.frame), 10, 40, 30);
    self.yuanLabel.text = @"元";
    self.yuanLabel.textColor = [UIColor grayColor];
    self.yuanLabel.textAlignment = NSTextAlignmentRight;
    
    self.lineView.frame = CGRectMake(20, CGRectGetMaxY(self.monyText.frame), YBWidth - 80, 1);
    self.lineView.backgroundColor = BtnBlueColor;

}

@end
