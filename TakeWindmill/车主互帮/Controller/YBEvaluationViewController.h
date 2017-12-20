//
//  YBEvaluationViewController.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/16.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//评价

#import <UIKit/UIKit.h>
#import "YBGroupHelpModel.h"

@interface YBEvaluationViewController : UIViewController

@property(nonatomic,strong)UserInfoList * userInfoList;

@property(nonatomic,assign)BOOL isSend;//（发送者）//（接收者）

@end
