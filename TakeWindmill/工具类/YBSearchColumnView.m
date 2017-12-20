//
//  YBSearchView.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/15.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBSearchColumnView.h"
#import "YBTextField.h"

@interface YBSearchColumnView ()<UITextFieldDelegate>

@end

@implementation YBSearchColumnView

//当前位置
- (YBAboutButton *)cityButton
{
    if (!_cityButton) {
        YBAboutButton *cityButton = [[YBAboutButton alloc] init];
        [self addSubview:cityButton];
        
        _cityButton = cityButton;
    }
    return _cityButton;
}

//位置输入
- (UIButton *)addressButton
{
    if (!_addressButton) {
        UIButton *addressButton = [[UIButton alloc] init];
        [self addSubview:addressButton];
        _addressButton = addressButton;
    }
    return _addressButton;
}

//取消按钮
- (YBBaseButton *)cancelButton
{
    if (!_cancelButton) {
        YBBaseButton *cancelButton = [[YBBaseButton alloc] init];
        [self addSubview:cancelButton];
        _cancelButton = cancelButton;
    }
    return _cancelButton;
}

//位置输入
- (YBTextField *)addressText
{
    if (!_addressText) {
        YBTextField *addressText = [[YBTextField alloc] init];
        [self addSubview:addressText];
        _addressText = addressText;
    }
    return _addressText;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor whiteColor];
    
    //当前位置
    self.cityButton.frame = CGRectMake(0, 29, 80, 30);
    [self.cityButton buttonWithtitle:self.cityStr titleColor:[UIColor grayColor] titleFont:14 textAlignment:NSTextAlignmentCenter image:[UIImage imageNamed:@"下角"] handler:nil];
    [self.cityButton addTarget:self action:@selector(cityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.cityButton.frame), 30, 1, 20)];
    line.backgroundColor = LightGreyColor;
    [self addSubview:line];
    
    UIView *line1 = [[UIView alloc] init];

    if (self.isEnter) {
        //地址输入
        [self.addressText TextFieldFrame:CGRectMake(CGRectGetMaxX(line.frame) + 10, 29, YBWidth - 70 - self.cityButton.frame.size.width, 30) Style:UITextBorderStyleNone placeholder:@"你要去哪儿" Textfont:YBFont(14) textColor:[UIColor blackColor] TextEntry:NO FitWidth:YES cornerRadius:0 borderWidth:0 borderColor:nil];
        self.addressText.delegate = self;
        [self.addressText addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
        
        line1.frame = CGRectMake(CGRectGetMaxX(self.addressText.frame), 30, 1, 20);
    }
    else {
        self.addressButton.frame = CGRectMake(CGRectGetMaxX(line.frame) + 10, 29, YBWidth - 70 - self.cityButton.frame.size.width, 30);
        self.addressButton.titleLabel.font = YBFont(14);
        self.addressButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.addressButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [self.addressButton setTitle:@"你要去哪儿" forState:UIControlStateNormal];
        [self.addressButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.addressButton addTarget:self action:@selector(addressButtonAction:) forControlEvents:UIControlEventTouchUpInside];

        line1.frame = CGRectMake(CGRectGetMaxX(self.addressButton.frame), 30, 1, 20);
    }

    line1.backgroundColor = LightGreyColor;
    [self addSubview:line1];
    
    //取消按钮
    [self.cancelButton buttonWithFrame:CGRectMake(CGRectGetMaxX(line1.frame), 29, 60, 30) Strtitle:@"取消" titleColor:[UIColor lightGrayColor] titleFont:14 textAlignment:NSTextAlignmentCenter image:nil BackgroundColor:nil cornerRadius:0];
   }

- (void)cityButtonAction:(UIButton *)sender {
    if (_seleCityButtonBlock) {
        _seleCityButtonBlock(sender);
    }
}

- (void)addressButtonAction:(UIButton *)sender {
    if (_addressButtonBlock) {
        _addressButtonBlock(sender);
    }

}
- (void)valueChanged:(UITextField *)text {
    if (_contentTextBlock) {
        _contentTextBlock(text);
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (_addressBlock) {
        _addressBlock(textField);
    }
    return YES;
}


@end
