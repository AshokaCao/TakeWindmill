//
//  YBTakeWindmollHeadView.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/9.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^YBTakeWindmollBlock)(UIButton *sender);

@interface YBTakeWindmollView : UIView

/**
 * 需要改变的view
 */
@property (nonatomic, weak) UIScrollView *scrollView;

/**
 * 点击按钮
 */
@property (nonatomic, strong) YBTakeWindmollBlock buttonBlok;

/**
 * 改变下划线
 */
- (void)changeTheUnderline:(NSUInteger)pageNumber;

@end







//**********************************************************************************************************************//

typedef void(^takeViewButtonBlock)(id sender);

@interface YBTakeHeadView : UIView

@property (nonatomic, copy) NSString *nameStr;

@property (nonatomic, strong) takeViewButtonBlock selectButtonBlock;

@end
