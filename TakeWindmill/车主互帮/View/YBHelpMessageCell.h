//
//  YBHelpMessageCell.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/12/2.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface YBHelpMessageCell : RCMessageCell
/*!
 文本内容的Label
 */
@property(strong, nonatomic) UILabel *textLabel;

@property(strong, nonatomic) UIView *line;
@property(strong, nonatomic) UILabel *helpMessage;
@property(strong, nonatomic) UILabel *state;

/*!
 背景View
 */
@property(nonatomic, strong) UIImageView *bubbleBackgroundView;

/*!
 根据消息内容获取显示的尺寸
 
 @param message 消息内容
 
 @return 显示的View尺寸
 */
+ (CGSize)getBubbleBackgroundViewSize:(YBHelpMessage *)message;
@end
