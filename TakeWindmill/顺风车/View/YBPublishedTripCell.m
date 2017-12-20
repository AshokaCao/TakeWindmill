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

- (void)setStrokeDict:(NSDictionary *)strokeDict
{
    NSArray *timeArray           = [strokeDict[@"SetoutTimeStr"] componentsSeparatedByString:@"+"];
    self.typeLabel.text          = @"寻找司机";
    self.timeLabel.text          = [NSString stringWithFormat:@"%@ %@",timeArray[0],timeArray[1]];
    self.endPointLabel.text      = strokeDict[@"EndAddress"];
    self.startingPointLabel.text = strokeDict[@"StartAddress"];
}

- (void)setDriverTripDic:(NSDictionary *)driverTripDic
{
    NSArray *timeArray           = [driverTripDic[@"SetoutTimeStr"] componentsSeparatedByString:@"+"];
    self.typeLabel.text          = @"寻找乘客";
    self.timeLabel.text          = [NSString stringWithFormat:@"%@ %@",timeArray[0],timeArray[1]];
    self.endPointLabel.text      = driverTripDic[@"EndAddress"];
    self.startingPointLabel.text = driverTripDic[@"StartAddress"];
}

@end
