//
//  YBAboutButton.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/9.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBAboutButton.h"

#define kTitleRatio 0.9

@implementation YBAboutButton

+ (instancetype)buttonWithType:(UIButtonType)buttonType frame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor titleFont:(CGFloat)font textAlignment:(NSTextAlignment)textAlignment  image:(UIImage *)image imageViewContentMode:(UIViewContentMode)imageViewContentMode handler:(AboutButton)handler{
    //button的类型
    YBAboutButton *button = [super buttonWithType:buttonType];
    //button的frame
    button.frame = frame;
    //文字居中
    button.titleLabel.textAlignment = textAlignment;
    //文字大小
    button.titleLabel.font = [UIFont systemFontOfSize:font];
    //文字颜色
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    //图片填充的内容模式
    button.imageView.contentMode = imageViewContentMode;
    //button的title
    [button setTitle:title forState:UIControlStateNormal];
    //button的image
    [button setImage:image forState:UIControlStateNormal];
    //button的点击事件
    button.aboutBtn = handler;
    [button addTarget:button action:@selector(handleButton:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)buttonWithtitle:(NSString *)title titleColor:(UIColor *)titleColor titleFont:(CGFloat)font textAlignment:(NSTextAlignment)textAlignment  image:(UIImage *)image handler:(AboutButton)handler {

    //文字居中
    self.titleLabel.textAlignment = textAlignment;
    //文字大小
    self.titleLabel.font = [UIFont systemFontOfSize:font];
    //文字颜色
    [self setTitleColor:titleColor forState:UIControlStateNormal];
    //图片填充的内容模式
    self.imageView.contentMode = UIViewContentModeScaleToFill;
    //button的title
    [self setTitle:title forState:UIControlStateNormal];
    //button的image
    [self setImage:image forState:UIControlStateNormal];
    //button的点击事件
    self.aboutBtn = handler;
    [self addTarget:self action:@selector(handleButton:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - handleButton
- (void)handleButton:(UIButton *)sender{
    if (self.aboutBtn) {
        self.aboutBtn(sender);
    }
}

//#pragma mark - 调整内部ImageView的frame --
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat imageHeight = contentRect.size.height / 4;
    CGFloat imageWidth = contentRect.size.width * (1 - kTitleRatio) ;
    CGFloat imageX = contentRect.size.width * kTitleRatio - 5;
    CGFloat imageY = (contentRect.size.height - imageHeight) / 2;
    return CGRectMake(imageX, imageY, imageWidth , imageHeight);
}
#pragma mark - 调整内部UIlable的frame
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat titleX = 0;
    CGFloat titleHeight = contentRect.size.height;
    CGFloat titleY = 0;
    CGFloat titleWidth = contentRect.size.width * kTitleRatio - 5;
    return CGRectMake(titleX, titleY, titleWidth, titleHeight );
}


@end
