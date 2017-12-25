//
//  YBNearPassTableViewCell.h
//  TakeWindmill
//
//  Created by AshokaCao on 2017/12/22.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBTaxiStrokeModel.h"

@class YBNearPassTableViewCell;

@protocol YBNearPassTableViewCellDelegate <NSObject>

- (void)didselectYBPassengerTableViewCell:(YBNearPassTableViewCell *)cell;

@end
@interface YBNearPassTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userHeaderImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *starLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
//@property (nonatomic, copy) CancelTravle cancelBlock;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (nonatomic, assign) id<YBNearPassTableViewCellDelegate> delegate;

- (void)showDetailWith:(YBTaxiStrokeModel *)diction;
@end
