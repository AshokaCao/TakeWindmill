//
//  YBForMessageViewController.h
//  TakeWindmill
//
//  Created by AshokaCao on 2017/12/16.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UserMessage)(NSString *message);
@interface YBForMessageViewController : UIViewController

@property (nonatomic, copy) UserMessage sendMessage;

@end
