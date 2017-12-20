//
//  YBAboutButton.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/9.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AboutButton)(UIButton *sender);

@interface YBAboutButton : UIButton

@property (nonatomic,strong)AboutButton aboutBtn;


/**
 * 设置左右按钮
 @param buttonType <#buttonType description#>
 @param frame <#frame description#>
 @param title <#title description#>
 @param titleColor <#titleColor description#>
 @param font <#font description#>
 @param textAlignment <#textAlignment description#>
 @param image <#image description#>
 @param imageViewContentMode <#imageViewContentMode description#>
 @param handler <#handler description#>
 @return <#return value description#>
 */
+ (instancetype)buttonWithType:(UIButtonType)buttonType frame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor titleFont:(CGFloat)font textAlignment:(NSTextAlignment)textAlignment  image:(UIImage *)image imageViewContentMode:(UIViewContentMode)imageViewContentMode handler:(AboutButton)handler;

- (void)buttonWithtitle:(NSString *)title titleColor:(UIColor *)titleColor titleFont:(CGFloat)font textAlignment:(NSTextAlignment)textAlignment  image:(UIImage *)image handler:(AboutButton)handler ;

@end
