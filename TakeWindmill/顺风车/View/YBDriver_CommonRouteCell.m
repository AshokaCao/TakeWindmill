//
//  YBDriver_CommonRouteCell.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/12/5.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBDriver_CommonRouteCell.h"

@interface YBDriver_CommonRouteCell ()

/**
 * 备注
 */
@property (nonatomic, weak) UILabel *remarksLabel;

/**
 * 时间
 */
@property (nonatomic, weak) UILabel *timeLabel;

/**
 * 起点
 */
@property (nonatomic, weak) UILabel *starPointLabel;

/**
 * 箭头
 */
@property (nonatomic, weak) UIImageView *arrowIamge;

/**
 * 终点
 */
@property (nonatomic, weak) UILabel *endPointLabel;

@end


@implementation YBDriver_CommonRouteCell

- (UILabel *)remarksLabel
{
    if (!_remarksLabel) {
        UILabel *label           = [[UILabel alloc] init];
        label.font               = YBFont(13);
        label.textAlignment      = NSTextAlignmentCenter;
        label.backgroundColor    = [UIColor grayColor];
        label.textColor          = [UIColor whiteColor];
        label.layer.cornerRadius  = 3;
        label.layer.masksToBounds = YES;
        [self addSubview:label];
        _remarksLabel = label;
    }
    return _remarksLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        UILabel *time      = [[UILabel alloc] init];
        time.font          = YBFont(13);
        time.textAlignment = NSTextAlignmentCenter;
        [self addSubview:time];
        _timeLabel = time;
    }
    return _timeLabel;
}

- (UILabel *)starPointLabel
{
    if (!_starPointLabel) {
        UILabel *star      = [[UILabel alloc] init];
        star.font          = YBFont(14);
        star.textColor     = [UIColor grayColor];
        star.textAlignment = NSTextAlignmentCenter;
        [self addSubview:star];
        _starPointLabel = star;
    }
    return _starPointLabel;
}

- (UIImageView *)arrowIamge
{
    if (!_arrowIamge) {
        UIImageView *arrow = [[UIImageView alloc] init];
        arrow.image        = [UIImage imageNamed:@"jiantou001"];
        [self addSubview:arrow];
        _arrowIamge = arrow;
    }
    return _arrowIamge;
}

- (UILabel *)endPointLabel
{
    if (!_endPointLabel) {
        UILabel *end      = [[UILabel alloc] init];
        end.font          = YBFont(14);
        end.textColor     = [UIColor grayColor];
        end.textAlignment = NSTextAlignmentCenter;
        [self addSubview:end];
        _endPointLabel = end;
    }
    return _endPointLabel;
}

- (void)driver_CommonRoute:(NSDictionary *)dict
{
    //备注
    CGFloat remarksW = [YBTooler calculateTheStringWidth:dict[@"Note"] font:13];
    self.remarksLabel.frame = CGRectMake(10, 10, remarksW + 5, 20);
    self.remarksLabel.text  = dict[@"Note"];
    //时间
    CGFloat timeW   = [YBTooler calculateTheStringWidth:dict[@"SetoutTime"] font:13];
    self.timeLabel.frame = CGRectMake(CGRectGetMaxX(self.remarksLabel.frame) + 5, 10, timeW, 20);
    self.timeLabel.text  = dict[@"SetoutTime"];
    //起点
    CGFloat stareW   = [YBTooler calculateTheStringWidth:dict[@"StartAddress"] font:14];
    self.starPointLabel.frame = CGRectMake(10, CGRectGetMaxY(self.remarksLabel.frame) + 5 , stareW, 20);
    self.starPointLabel.text  = dict[@"StartAddress"];
    //箭头
    self.arrowIamge.frame = CGRectMake(CGRectGetMaxX(self.starPointLabel.frame) + 5,self.starPointLabel.frame.origin.y + 8, 10, 3);
    
    //终点
    CGFloat endW   = [YBTooler calculateTheStringWidth:dict[@"EndAddress"] font:14];
    self.endPointLabel.frame = CGRectMake(CGRectGetMaxX(self.arrowIamge.frame) + 5,CGRectGetMaxY(self.remarksLabel.frame) + 5, endW, 20);
    self.endPointLabel.text  = dict[@"EndAddress"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
