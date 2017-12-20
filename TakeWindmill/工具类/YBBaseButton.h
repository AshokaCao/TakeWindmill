//
//  YBBaseButton.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/12.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBBaseButton : UIButton

/**
 * 文字类型按钮
 @param frame 位置
 @param title 文字
 @param titleColor 文字颜色
 @param font 文字大小
 @param textAlignment 文字位置
 @param image 图片
 @param backgroundColor 背景颜色
 @param cornerRadius 圆角
 @return 返回一个按钮
 */
+ (instancetype)buttonWithFrame:(CGRect)frame Strtitle:(NSString *)title titleColor:(UIColor *)titleColor  titleFont:(CGFloat)font textAlignment:(NSTextAlignment)textAlignment image:(UIImage *)image BackgroundColor:(UIColor *)backgroundColor cornerRadius:(CGFloat)cornerRadius;

- (void)buttonWithFrame:(CGRect)frame Strtitle:(NSString *)title titleColor:(UIColor *)titleColor  titleFont:(CGFloat)font textAlignment:(NSTextAlignment)textAlignment image:(UIImage *)image BackgroundColor:(UIColor *)backgroundColor cornerRadius:(CGFloat)cornerRadius;


/**
 *图片类型按钮
 @param frame 位置
 @param image 图片
 @param backgroundColor 背景颜色
 @param cornerRadius 圆角
 @param setBackgroundImage 背景图片
 @return 返回按钮
 */
+ (instancetype)imageButtonWithFrame:(CGRect)frame image:(UIImage *)image BackgroundColor:(UIColor *)backgroundColor cornerRadius:(CGFloat)cornerRadius setBackgroundImage:(UIImage *)setBackgroundImage;

- (void)imageButtonWithFrame:(CGRect)frame image:(UIImage *)image BackgroundColor:(UIColor *)backgroundColor cornerRadius:(CGFloat)cornerRadius setBackgroundImage:(UIImage *)setBackgroundImage;

@end
