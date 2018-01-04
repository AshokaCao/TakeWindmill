//
//  YBSetPasswordVC.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/21.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBSetPasswordVC : UIViewController

/**
 * 手机号
 */
@property (nonatomic, copy) NSString *phoneStr;
/**
 * 验证码
 */
@property (nonatomic, copy) NSString *verifyCode;

/**
 * 手机号
 */
@property (nonatomic, copy) NSString *typeStr;




@property (nonatomic, copy) NSString *commendcode;//邀请码


@end
