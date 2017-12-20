//
//  YBBaseButton.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/12.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBBaseButton.h"

@interface YBBaseButton()

@end

@implementation YBBaseButton


+ (instancetype)buttonWithFrame:(CGRect)frame Strtitle:(NSString *)title titleColor:(UIColor *)titleColor  titleFont:(CGFloat)font textAlignment:(NSTextAlignment)textAlignment image:(UIImage *)image BackgroundColor:(UIColor *)backgroundColor cornerRadius:(CGFloat)cornerRadius{

    YBBaseButton *button = [[YBBaseButton alloc] initWithFrame:frame];
    //文字居中
    button.titleLabel.textAlignment = textAlignment;
    //文字大小
    button.titleLabel.font = [UIFont systemFontOfSize:font];
    //文字颜色
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    //按钮背景颜色
    [button setBackgroundColor:backgroundColor];
    //图片填充的内容模式
    button.imageView.contentMode = UIViewContentModeScaleToFill;
    //圆角
    button.layer.cornerRadius = cornerRadius;
    //button的title
    [button setTitle:title forState:UIControlStateNormal];
    //button的image
    [button setImage:image forState:UIControlStateNormal];
    return button;
}

- (void)buttonWithFrame:(CGRect)frame Strtitle:(NSString *)title titleColor:(UIColor *)titleColor  titleFont:(CGFloat)font textAlignment:(NSTextAlignment)textAlignment image:(UIImage *)image BackgroundColor:(UIColor *)backgroundColor cornerRadius:(CGFloat)cornerRadius {
    
    self.frame = frame;
    //文字居中
    self.titleLabel.textAlignment = textAlignment;
    //文字大小
    self.titleLabel.font = [UIFont systemFontOfSize:font];
    //文字颜色
    [self setTitleColor:titleColor forState:UIControlStateNormal];
    //按钮背景颜色
    [self setBackgroundColor:backgroundColor];
    //图片填充的内容模式
    self.imageView.contentMode = UIViewContentModeScaleToFill;
    //圆角
    self.layer.cornerRadius = cornerRadius;
    //button的title
    [self setTitle:title forState:UIControlStateNormal];
    //button的image
    [self setImage:image forState:UIControlStateNormal];

}

+ (instancetype)imageButtonWithFrame:(CGRect)frame image:(UIImage *)image BackgroundColor:(UIColor *)backgroundColor cornerRadius:(CGFloat)cornerRadius setBackgroundImage:(UIImage *)setBackgroundImage{
    
    YBBaseButton *button = [[YBBaseButton alloc] initWithFrame:frame];
    //按钮背景颜色
    [button setBackgroundColor:backgroundColor];
    //图片填充的内容模式
    button.imageView.contentMode = UIViewContentModeScaleToFill;
    //圆角
    button.layer.cornerRadius = cornerRadius;
    //button的image
    [button setImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:setBackgroundImage forState:UIControlStateNormal];
    return button;
}

- (void)imageButtonWithFrame:(CGRect)frame image:(UIImage *)image BackgroundColor:(UIColor *)backgroundColor cornerRadius:(CGFloat)cornerRadius setBackgroundImage:(UIImage *)setBackgroundImage{
    
    YBBaseButton *button = [[YBBaseButton alloc] initWithFrame:frame];
    //按钮背景颜色
    [button setBackgroundColor:backgroundColor];
    //图片填充的内容模式
    button.imageView.contentMode = UIViewContentModeScaleToFill;
    //圆角
    button.layer.cornerRadius = cornerRadius;
    //button的image
    [button setImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:setBackgroundImage forState:UIControlStateNormal];

}

@end
