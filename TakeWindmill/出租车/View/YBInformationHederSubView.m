//
//  YBInformationHederSubView.m
//  TakeWindmill
//
//  Created by HUSHOUHUA华 on 2017/11/20.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBInformationHederSubView.h"
@interface YBInformationHederSubView()
{
}
@end
@implementation YBInformationHederSubView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    //self.backgroundColor = [UIColor redColor];
    if (self) {
        [self setUI];
    }
    return self;
}
-(void)setUI{
    WEAK_SELF;
    CGFloat font = 12;
    
    UILabel * ins = [[UILabel alloc]init];
    ins.text = @"1";
    ins.font = YBFont(font);
    ins.textAlignment = NSTextAlignmentCenter;
    ins.textColor = kTextGreyColor;
    ins.clipsToBounds = YES;
    ins.layer.cornerRadius = 10;
    ins.layer.borderWidth = 1;
    ins.layer.borderColor = kTextGreyColor.CGColor;
    [weakSelf addSubview:ins];
    [ins mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    weakSelf.number = ins;
    
    ins = [[UILabel alloc]init];
    ins.text = @"公司信息";
    ins.font = YBFont(font);
    ins.textAlignment = NSTextAlignmentCenter;
    ins.textColor = kTextGreyColor;
    [weakSelf addSubview:ins];
    [ins mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.number.mas_bottom);
        make.centerX.equalTo(weakSelf);
    }];
    weakSelf.text = ins;
    
}
-(void)configColor{
    self.number.textColor = [UIColor whiteColor];
    self.number.backgroundColor = BtnBlueColor;
    self.layer.borderColor = BtnBlueColor.CGColor;
    self.text.textColor = BtnBlueColor;
}


@end
