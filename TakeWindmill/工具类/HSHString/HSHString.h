//
//  HSHString.h
//  RZECM
//
//  Created by HSH on 15/5/12.
//  Copyright © 2015年 runsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tools.h"

@interface HSHString : NSObject

#pragma mark -  json转换
+(id)getObjectFromJsonString:(NSString *)jsonString;
+(NSString *)getJsonStringFromObject:(id)object;

#pragma mark -  NSDate互转NSString
+(NSDate *)NSStringToDate:(NSString *)dateString;
+(NSDate *)NSStringToDate:(NSString *)dateString withFormat:(NSString *)formatestr;
+(NSString *)NSDateToString:(NSDate *)dateFromString withFormat:(NSString *)formatestr;

#pragma mark -  判断字符串是否为空,为空的话返回 “” （一般用于保存字典时）
+(NSString *)IsNotNull:(NSString*)string;
+(BOOL) isBlankString:(id)string;
+(NSString *)toString:(NSUInteger)uinteger;
//去除空格
+(NSString *)removeSpaces:(NSString *)string;
+(void)copy:(NSString *)string;
+(NSString *)paste;


#pragma mark - 如何通过一个整型的变量来控制数值保留的小数点位数。以往我们通类似@"%.2f"来指定保留2位小数位，现在我想通过一个变量来控制保留的位数
+(NSString *)newFloat:(float)value withNumber:(int)numberOfPlace;


#pragma mark - 使用subString去除float后面无效的0
+(NSString *)changeFloatWithString:(NSString *)stringFloat;

#pragma mark - 去除float后面无效的0
+(NSString *)changeFloatWithFloat:(CGFloat)floatValue;


#pragma mark -  手机号码验证
+(BOOL) isValidateMobile:(NSString *)mobile;

#pragma mark -  阿里云压缩图片
+(NSURL*)UrlWithStringForImage:(NSString*)string;
+(NSString*)removeYaSuoAttribute:(NSString*)string;

#pragma mark - 字符串类型判断
+ (BOOL)isPureInt:(NSString*)string;
+ (BOOL)isPureFloat:(NSString*)string;

#pragma mark -  计算内容文本的高度方法
+ (CGFloat)HeightForText:(NSString *)text withSizeOfLabelFont:(CGFloat)font withWidthOfContent:(CGFloat)contentWidth;

#pragma mark -  计算字符串长度
+ (CGFloat)WidthForString:(NSString *)text withSizeOfFont:(CGFloat)font;

#pragma mark -   计算cell的高度
+(CGFloat)theHeightOfString:(NSString*)str width:(CGFloat)width fontSize:(CGFloat)fontSize;

#pragma mark ============================================

#pragma mark 时间戳转NSString
+(NSString *)timeWithTimeIntervalString:(NSString *)timeIntervalStr;
+(NSString *)timeWithTimeIntervalString:(NSString *)timeIntervalStr withFormat:(NSString *)formatestr;
//自定义 
+(NSString *)timeWithStr:(NSString *)timeString;

#pragma mark NSDate转化为时间戳
+(NSString *)timeIntervalWithNSDate:(NSDate *)date;

#pragma mark -  计算两个时间相差多少秒
+(NSInteger)getSecondsWithBeginDate:(NSString*)currentDateString  AndEndDate:(NSString*)tomDateString;

#pragma mark - 根据出生日期获取年龄
+ (NSInteger)ageWithDateOfBirth:(NSDate *)date;

#pragma mark - 根据经纬度计算两个位置之间的距离
+(double)distanceBetweenOrderBylat1:(double)lat1 lat2:(double)lat2 lng1:(double)lng1 lng2:(double)lng2;

#pragma mark ============================================

#pragma mark - 实现富文本（不同颜色字体、xxxx等）
+(NSMutableAttributedString *)strAttribute:(NSString *)str andColor:(UIColor *)color startIndex:(NSUInteger)index;
+(NSMutableAttributedString *)strAttribute:(NSString *)str andColor:(UIColor *)color startStr:(NSString *)startStr endStr:(NSString *)endStr;
//下划线
+(NSMutableAttributedString *)strAttributeLine:(NSString *)str;

#pragma mark - 截取字符串
+(NSString *)strSubSting:(NSString *)str startStr:(NSString *)startStr endStr:(NSString *)endStr;

#pragma mark - 截取字符串 为两段并返回一个数组
+(NSArray *)strSubSting:(NSString *)str withStr:(NSString *)withStr;

#pragma mark - 截取字符串 到某个字符串
+(NSString *)strSubSting:(NSString *)str toStr:(NSString *)toStr;

+(NSString *)strSubSting:(NSString *)str ToIndex:(NSInteger)index;




#pragma mark - 一个个截取  
+(NSMutableArray *)strSubSting:(NSString *)str withCount:(int)count;

#pragma mark - 根据Date计算星期几
+(NSString *)weekDayWithDate:(NSDate *)date;

#pragma mark - 根据year month day 计算星期几
+(NSString *)weekDayWithYear:(NSString *)year month:(NSString *)month day:(NSString *)day;

#pragma mark - 16进制色值转化为RGB返回UIColor类型对象
+(UIColor *)colorWithHexString:(NSString *)color;

#pragma mark - 计算公式为：font=pt=px*72/96=px*3/4
+(CGFloat)fontSizeWithPx:(CGFloat)px;

#pragma mark
+(UIFont *)fontWithPx:(CGFloat)px;

#pragma mark
+ (NSString *)getDeviceVersionInfo;
#pragma mark - 当前版本
+ (NSString *)getAppCurVersion;
/**
 比较两个版本号的大小
 @param v1 第一个版本号
 @param v2 第二个版本号
 @return 版本号相等,返回0; v1小于v2,返回-1; 否则返回1.
 */
+(NSInteger)compareVersion:(NSString *)v1 to:(NSString *)v2;



#pragma mark  获取SDImageCach缓存,getSize直接获取
+(void)findAllImageCache;// 转换大小
+(NSString *)fileSizeWithInterge:(NSInteger)size;

/**
 *  将普通字符串转换成base64字符串
 */
+(NSDictionary *)customerParm:(NSDictionary *)parm;

+(CAShapeLayer *)maskLayerView:(UIView *)view cornerRadii:(CGSize)cornerRadii;

@end
