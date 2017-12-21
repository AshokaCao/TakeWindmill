//
//  YBPassengerTableViewCell.h
//  TakeWindmill
//
//  Created by AshokaCao on 2017/12/6.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBTaxiStrokeModel.h"
@class YBPassengerTableViewCell;

@protocol YBPassengerTableViewCellDelegate <NSObject>

- (void)didselectTaxiTralveBtn:(NSInteger )sender andYBPassengerTableViewCell:(YBPassengerTableViewCell *)cell;

@end

@interface YBPassengerTableViewCell : UITableViewCell
@property (nonatomic, strong) YBTaxiStrokeModel *routeModel;
@property (nonatomic, strong) UIImageView *timeImageView;
@property (nonatomic, strong) UIImageView *beginImageView;
@property (nonatomic, strong) UIImageView *toImageView;
@property (nonatomic, strong) UIImageView *endImageView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *beginLabel;
@property (nonatomic, strong) UILabel *endLabel;
@property (nonatomic, strong) UIImageView *userHeaderImage;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, assign) id<YBPassengerTableViewCellDelegate> delegate;

- (void)showDetailsWith:(YBTaxiStrokeModel *)model;

@end
