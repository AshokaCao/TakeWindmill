//
//  YBTextField.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/10.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBTextField.h"

@interface YBTextField ()
@end

@implementation YBTextField

+ (instancetype)TextFieldFrame:(CGRect)frame Style:(UITextBorderStyle)style placeholder:(NSString *)placeholder Textfont:(UIFont *)font textColor:(UIColor *)textColor TextEntry:(BOOL)TextEntry FitWidth:(BOOL)FitWidth cornerRadius:(CGFloat)Radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    YBTextField *textfield = [[YBTextField alloc] initWithFrame:frame];
    textfield.borderStyle = style;
    textfield.placeholder = placeholder;
    textfield.font = font;
    textfield.textAlignment = NSTextAlignmentCenter;
    textfield.textColor = textColor;
    textfield.secureTextEntry = TextEntry;
    textfield.adjustsFontSizeToFitWidth = FitWidth;
    textfield.layer.cornerRadius = Radius;
    textfield.layer.borderWidth = borderWidth;
//    textfield.delegate = self;
    textfield.returnKeyType = UIReturnKeyDone;//变为搜索按钮
    textfield.layer.borderColor = borderColor.CGColor;
    return textfield;
}

- (void)TextFieldFrame:(CGRect)frame Style:(UITextBorderStyle)style placeholder:(NSString *)placeholder Textfont:(UIFont *)font textColor:(UIColor *)textColor TextEntry:(BOOL)TextEntry FitWidth:(BOOL)FitWidth cornerRadius:(CGFloat)Radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    
    self.frame = frame;
    self.borderStyle = style;
    self.placeholder = placeholder;
    self.font = font;
//    self.textAlignment = NSTextAlignmentCenter;
    self.textColor = textColor;
    self.secureTextEntry = TextEntry;
    self.adjustsFontSizeToFitWidth = FitWidth;
    self.layer.cornerRadius = Radius;
    self.layer.borderWidth = borderWidth;
    self.returnKeyType = UIReturnKeyDone;//变为搜索按钮
    self.layer.borderColor = borderColor.CGColor;
//    self.delegate = self;
}


- (void)LeftWithPicture:(NSString *)placeholder textColor:(UIColor *)textColor view:(UIView *)view {

    self.borderStyle = UITextBorderStyleRoundedRect;
    self.placeholder = placeholder;
    self.textColor = textColor;
    self.font = YBFont(14);
    self.leftViewMode = UITextFieldViewModeAlways;
    self.leftView = view;
    [self sizeToFit];
}


@end
