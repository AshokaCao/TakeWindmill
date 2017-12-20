//
//  YBBaseView.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/14.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBBaseView;
typedef void(^selectViewBlock)(YBBaseView *view);

@interface YBBaseView : UIView

/**
 * 标题
 */
@property (nonatomic, copy) NSString *mainStr;
@property (nonatomic, weak) UILabel *label;

/**
 * 子标题
 */
@property (nonatomic, copy) NSString *secondaryStr;
@property (nonatomic, weak) UILabel *subLabel;

/**
 * 图片
 */
@property (nonatomic, copy) NSString *imageNameStr;
@property (nonatomic, weak) UIImageView *imageView;

/**
 * 能否点击 默认为NO
 */
@property(nonatomic,getter=isCanClick) BOOL CanClick;

/**
 * 能否长按 默认为NO
 */
@property(nonatomic,getter=isCanClick) BOOL CanPressLong;

/**
 * 点击block
 */
@property (nonatomic, strong) selectViewBlock selectBlock;


/**
 * 设置左右view的各种属性
 @param image 图片
 @param bacColor 图片宽高
 @param bacColor 图片背景颜色
 @param title 文字
 @param titleFont 文字大小
 @param color 文字颜色
 @param subtitle 副标题
 @param subTitleFont 副标题大小
 @param subColor 副标题颜色
 */
- (void)aboutViewImage:(UIImage *)image imageFrame:(CGSize)iamgFrame imageBacColor:(UIColor *)bacColor LabelTitle:(NSString *)title titleFont:(CGFloat)titleFont titleColor:(UIColor *)color subTitle:(NSString *)subtitle subTitleFont:(CGFloat)subTitleFont subtitleColor:(UIColor *)subColor;


/**
 * 设置上下view的属性
 @param image 图片
 @param bacColor 图片宽高
 @param bacColor 图片背景颜色
 @param title 文字
 @param titleFont 文字大小
 @param color 文字颜色
 @param subtitle 副标题
 @param subTitleFont 副标题大小
 @param subColor 副标题颜色
 */
- (void)upAndDownImage:(UIImage *)image imageSize:(CGSize)iamgFrame imageBacColor:(UIColor *)bacColor LabelTitle:(NSString *)title titleFont:(CGFloat)titleFont titleColor:(UIColor *)color subTitle:(NSString *)subtitle subTitleFont:(CGFloat)subTitleFont subtitleColor:(UIColor *)subColor ;

/**
 * 车费价格
 @param isFight 是否拼车
 @param str 价格
 */
- (void)ridePriceisIsFight:(BOOL)isFight priceStr:(NSString *)str;

/**
 * 增加接单率
 */
- (void)increaseTheThankYouYee;

/**
 * 点击view
 @param isSelected 是否选中
 @param success 返回Block
 */
- (void)checkTheStatus:(BOOL)isSelected success:(void (^)(id isSelected))success;
/**
 * 点击事件回调方法
 @param block self
 */
- (void)tapGestureAction:(selectViewBlock)block;

- (void)initLabelStr:(NSString *)str;

/**
 * 获取价格数
 */
- (NSString *)getTheNumberOfPrices;

@end

