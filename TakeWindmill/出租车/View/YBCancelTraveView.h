//
//  YBCancelTraveView.h
//  TakeWindmill
//
//  Created by AshokaCao on 2017/12/20.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CancelTravle)(NSString *message);
@interface YBCancelTraveView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *userHeaderImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *starLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (nonatomic, copy) CancelTravle cancelBlock;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *wechatPayBtn;
@property (weak, nonatomic) IBOutlet UIButton *aliPayBtn;

@property (nonatomic, strong) NSString *orderNum;
@property (nonatomic, strong) NSString *needPayNum;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

- (void)userNeedToPayWith:(NSString *)orderNum andMoney:(NSString *)money;

- (void)showDetailWith:(NSDictionary *)diction;

@end
