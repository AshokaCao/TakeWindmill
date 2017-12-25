//
//  YBPublishedTripCell.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/10/18.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBPublishedTripCell.h"

@interface YBPublishedTripCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *startingPointLabel;
@property (weak, nonatomic) IBOutlet UILabel *endPointLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation YBPublishedTripCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor            = [UIColor clearColor];
    self.bgView.layer.cornerRadius  = 5;
}

#pragma mark - 乘客端_已发布订单
- (void)passengerTerminal_Published:(NSDictionary *)strokeDict
{
    
}

- (void)setStrokeDict:(NSDictionary *)strokeDict
{
    NSArray *timeArray           = [strokeDict[@"SetoutTimeStr"] componentsSeparatedByString:@"+"];
    self.typeLabel.text          = @"寻找司机";
    self.timeLabel.text          = [NSString stringWithFormat:@"%@ %@",timeArray[0],timeArray[1]];
    self.endPointLabel.text      = strokeDict[@"EndAddress"];
    self.startingPointLabel.text = strokeDict[@"StartAddress"];
}

#pragma mark - 司机端_已发布订单
- (void)driver_PublishedOrders:(NSDictionary *)driverDict
{
    NSArray *timeArray           = [driverDict[@"SetoutTimeStr"] componentsSeparatedByString:@"+"];
    self.typeLabel.text          = @"寻找乘客";
    self.timeLabel.text          = [NSString stringWithFormat:@"%@ %@",timeArray[0],timeArray[1]];
    self.endPointLabel.text      = driverDict[@"EndAddress"];
    self.startingPointLabel.text = driverDict[@"StartAddress"];
}

#pragma mark - 司机端_我的订单
- (void)driver_MyOrder:(NSDictionary *)orderDict
{
    NSArray *timeArray           = [orderDict[@"SetoutTimeStr"] componentsSeparatedByString:@"+"];
    self.typeLabel.text          = @"寻找乘客";
    self.timeLabel.text          = [NSString stringWithFormat:@"%@ %@",timeArray[0],timeArray[1]];
    self.endPointLabel.text      = orderDict[@"EndAddress"];
    self.startingPointLabel.text = orderDict[@"StartAddress"];
}

@end
