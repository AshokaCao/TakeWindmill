//
//  YBTextField.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/10.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBTextField : UITextField


/**
  *简单的封装TextField

 @param frame 位置
 @param style 样式
 @param placeholder 没有文字时显示的提示
 @param font 字体设置
 @param textColor 字体颜色
 @param TextEntry 是否密语
 @param FitWidth 是否自适应
 @param Radius 圆角
 @param borderWidth 边框
 @param borderColor 边框颜色
 @return textField
 */
+ (instancetype)TextFieldFrame:(CGRect)frame Style:(UITextBorderStyle)style placeholder:(NSString *)placeholder Textfont:(UIFont *)font textColor:(UIColor *)textColor TextEntry:(BOOL)TextEntry FitWidth:(BOOL)FitWidth cornerRadius:(CGFloat)Radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

- (void)TextFieldFrame:(CGRect)frame Style:(UITextBorderStyle)style placeholder:(NSString *)placeholder Textfont:(UIFont *)font textColor:(UIColor *)textColor TextEntry:(BOOL)TextEntry FitWidth:(BOOL)FitWidth cornerRadius:(CGFloat)Radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;


/**
 * 左边带View的
 @param placeholder 文字
 @param view view
 */
- (void)LeftWithPicture:(NSString *)placeholder textColor:(UIColor *)textColor view:(UIView *)view ;
@end
