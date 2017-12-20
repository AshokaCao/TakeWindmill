//
//  YBNearbyCell.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/9/4.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^iconImageView)(UITapGestureRecognizer *gest);

@interface YBNearbyCell : UITableViewCell

@property (nonatomic, strong) iconImageView iconImageView;

@property (nonatomic, strong) NSDictionary *detailsDict;

@end













//************************************************下拉菜单************************************************************//
//左边按钮
typedef void(^leftBtnClickBlock)(NSString *btnStr);
//右边按钮
typedef void(^rightBtnClickBlock)(NSString *btnStr);

@interface YBNearbyTitleView : UIView

/**
 * 市内 or 跨城
 */
@property (nonatomic, assign) NSInteger isTypes;

/**
 * 乘客人数
 */
@property (nonatomic, copy) NSString *NumberPassengers;

/**
 * 左边按钮文字
 */
@property (nonatomic, copy) NSString *leftBtnStr;

/**
 * 右边按钮文字
 */
@property (nonatomic, copy) NSString *rightBtnStr;

/**
 * 左边数据
 */
@property (nonatomic, strong) NSArray *leftArray;

/**
 * 右边数据
 */
@property (nonatomic, strong) NSArray *rightArray;

/**
 * 点击左边按钮
 */
@property (nonatomic, strong) leftBtnClickBlock leftBtnBlock;

/**
 * 点击右边按钮
 */
@property (nonatomic, strong) rightBtnClickBlock rightBtnBlock;

/**
 * 隐藏左边按钮
 * 默认为NO
 */
@property (nonatomic, assign) BOOL isLeftBtnHinde;

/**
 * 隐藏右边按钮
 * 默认为NO
 */
@property (nonatomic, assign) BOOL isRightBtnHinde;

@end

//************************************************排序View************************************************************//
