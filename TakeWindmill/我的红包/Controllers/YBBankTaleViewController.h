//
//  YBBankTaleViewController.h
//  TakeWindmill
//
//  Created by AshokaCao on 2017/11/8.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBUserListModel.h"

typedef void(^SelectedCardModel)(YBUserListModel *model);
@interface YBBankTaleViewController : UIViewController

@property (nonatomic, copy) SelectedCardModel selectedBlock;

@end
