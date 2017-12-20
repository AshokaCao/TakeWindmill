//
//  YBTaxiStrokeTableViewCell.h
//  TakeWindmill
//
//  Created by AshokaCao on 2017/12/4.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBTaxiStrokeModel.h"

@interface YBTaxiStrokeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (nonatomic, strong) YBTaxiStrokeModel *model;

- (void)showDetailsWith:(YBTaxiStrokeModel *)model;

@end
