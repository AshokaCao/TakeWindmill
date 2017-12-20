//
//  YBTooler.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/15.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBTooler : NSObject

/**
 * 设置View 的阴影
 */
+ (void)setTheControlShadow:(UIView *)sender;


/**
 * 设置两种字符串
 @param needText 字符串
 @param titleFont 前面字体大小
 @param subscript 字体开始的下标
 @param length 字体长度
 @param subFont 后面字体的大小
 @param sub 下标
 @param leng 长度
 @return NSMutableAttributedString
 */
+ (NSMutableAttributedString *)changeLabelWithText:(NSString*)needText frontTextFont:(CGFloat)titleFont Subscript:(CGFloat)subscript TextLength:(CGFloat)length BehindTxetFont:(CGFloat)subFont Subscript:(CGFloat)sub TextLength:(CGFloat)leng;
+ (NSMutableAttributedString *)changeLabelWithText:(NSString*)needText;

/**
 * 设置三种字体
 @param all 字体内容
 @param oneFont 第一种字体大小
 @param oneSubscript 第一种字体下标
 @param oneLength 第一种字体长度
 @param twoFont 第2种字体大小
 @param twosub 第2种字体下标
 @param twoLeng 第2种字体长度
 @param threeFont 第3种字体大小
 @param threesub 第3种字体下标
 @param threeLeng 第3种字体长度
 @return 
 */
+ (NSMutableAttributedString *)labelThreeFontsAllWords:(NSString*)all oneFont:(CGFloat)oneFont oneSubscript:(CGFloat)oneSubscript oneLength:(CGFloat)oneLength twoFont:(CGFloat)twoFont twoSubscript:(CGFloat)twosub twoLength:(CGFloat)twoLeng threeFont:(CGFloat)threeFont threeSubscript:(CGFloat)threesub threeLength:(CGFloat)threeLeng;

/**
 * 获取发送服务器的dict
 @return NSMutableDictionary
 */
+ (NSMutableDictionary *)dictinitWithMD5;


/**
 * 解析字符串
 @param str 字符串
 @return NSString
 */
+ (NSString*)URLDecodedString:(NSString*)str;

/**
 * 获取唯一标示符UUID
 @return NSString
 */
+ (NSString *)uuid;

/**
 * 根据宽度计算高度
 @param str 字符串
 @param with 宽度
 @param font 字体大小
 @return 返回高度
 */
+ (CGFloat)accordingToTheWidthOfTheCalculationOfHigh:(NSString *)str with:(CGFloat)with font:(CGFloat)font;

/**
 * 计算字符串宽度
 @param str 字符串
 @param font 字体大小
 @return 返回宽度
 */
+ (CGFloat)calculateTheStringWidth:(NSString *)str font:(CGFloat)font;


/**
 * 获取用户id
 @param view
 @return
 */
+ (NSString *)getTheUserId:(UIView *)view;

/**
 * 字符串设置两种颜色
 @param label 字符串
 @param second 颜色字符
 @param color 颜色
 @return
 */
+ (NSMutableAttributedString *)stringSetsTwoColorsLabel:(NSString *)label Second:(NSString *)second Colour:(UIColor *)color;


/**
 * 旋转
 @param button 需要旋转的btn
 */
+ (void)buttonEdgeInsets:(UIButton *)button;

/**
 * 点击拨打电话
 @param Number 电话
 @param view 显示View
 */
+ (void)dialThePhoneNumber:(NSString *)Number displayView:(UIView *)view;

@end
