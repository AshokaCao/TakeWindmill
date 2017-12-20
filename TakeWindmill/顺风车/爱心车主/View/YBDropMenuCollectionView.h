//
//  YBDropMenuCollectionView.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/9/13.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBDropMenuCollectionView;
@protocol YBDropMenuCollectionViewDelegate <NSObject>

-(void)dropMenuCollectionView:(YBDropMenuCollectionView *)view didSelectName:(NSString *)str;

@end

@interface YBDropMenuCollectionView : UIView
/** 箭头变化 */
@property (nonatomic, strong) UIView *arrowView;

@property (nonatomic, weak) id<YBDropMenuCollectionViewDelegate> delegate;

/**
 控件设置
 
 @param view 提供控件 位置信息
 @param tableNum 显示TableView数量
 @param arr 使用数据
 */
-(void)creatMenuCollectionViewY:(CGFloat)viewY withShowCollectionNum:(NSInteger)tableNum withData:(NSArray *)arr;

/** 视图消失 */
- (void)dismiss;

@end
