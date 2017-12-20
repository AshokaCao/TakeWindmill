//
//  YBChooseBankViewController.h
//  TakeWindmill
//
//  Created by AshokaCao on 2017/11/9.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBUserListModel.h"

typedef void(^SelectedBankModel)(YBUserListModel *model);
@interface YBChooseBankViewController : UIViewController

@property (nonatomic, copy) SelectedBankModel selectedBlock;
@end
