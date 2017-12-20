//
//  YBManagementCell.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/11.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBManagementCell.h"
#import "YBAboutButton.h"

@interface YBManagementCell ()

@property (weak, nonatomic)  UIView *itemView;
@property (weak, nonatomic)  UILabel *typesLabel;
@property (weak, nonatomic)  UIView *pointView;
@property (weak, nonatomic)  UIView *point2View;
@property (weak, nonatomic)  UILabel *timeLabel;
@property (weak, nonatomic)  UILabel *starLabel;
@property (weak, nonatomic)  UILabel *endLabel;
@property (weak, nonatomic)  UIImageView *arrowImage;
@property (weak, nonatomic)  UIView *line;
@end

@implementation YBManagementCell

- (UIView *)itemView
{
    if (!_itemView) {
        UIView *item            = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width - 20, 100)];
        item.backgroundColor    = [UIColor whiteColor];
        //给bgView边框设置阴影
        item.layer.shadowOffset = CGSizeMake(1,1);
        item.layer.shadowOpacity= 0.1;
        item.layer.shadowColor  = [UIColor grayColor].CGColor;
        [self addSubview:item];
        _itemView = item;
    }
    return _itemView;
}

- (UILabel *)typesLabel
{
    if (!_typesLabel) {
        UILabel *types              = [[UILabel alloc] init];
        types.font                  = YBFont(13);
        types.textColor             = [UIColor whiteColor];
        types.textAlignment         = NSTextAlignmentCenter;
        types.clipsToBounds         = YES;
        types.backgroundColor       = [UIColor grayColor];
        types.layer.cornerRadius    = 3;
        [self.itemView addSubview:types];
        _typesLabel = types;
    }
    return _typesLabel;
}

- (UIView *)pointView
{
    if (!_pointView) {
        UIView *point               = [[UIView alloc] init];
        point.backgroundColor       = BtnBlueColor;
        point.layer.cornerRadius    = 4;
        [self.itemView addSubview:point];
        _pointView = point;
    }
    return _pointView;
}

- (UIView *)point2View
{
    if (!_point2View) {
        UIView *point               = [[UIView alloc] init];
        point.backgroundColor       = BtnGreenColor;
        point.layer.cornerRadius    = 4;
        [self.itemView addSubview:point];
        _point2View = point;
    }
    return _point2View;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        UILabel *time   = [[UILabel alloc] init];
        time.font       = YBFont(14);
        [self.itemView addSubview:time];
        _timeLabel = time;
    }
    return _timeLabel;
}

- (UILabel *)starLabel
{
    if (!_starLabel) {
        UILabel *label  = [[UILabel alloc] init];
        label.font      = YBFont(14);
        label.textColor = [UIColor grayColor];
        [self.itemView addSubview:label];
        _starLabel = label;
    }
    return _starLabel;
}

- (UILabel *)endLabel
{
    if (!_endLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font      = YBFont(14);
        label.textColor = BtnGreenColor;
        [self.itemView addSubview:label];
        _endLabel = label;
    }
    return _endLabel;
}

- (UIImageView *)arrowImage
{
    if (!_arrowImage) {
        UIImageView *imageView  = [[UIImageView alloc] init];
        imageView.image         = [UIImage imageNamed:@"箭头"];
        [self.itemView addSubview:imageView];
        _arrowImage = imageView;
    }
    return _arrowImage;
}

- (UIView *)line
{
    if (!_line) {
        UIView *view         = [[UIView alloc] init];
        view.backgroundColor = LightGreyColor;
        [self.itemView addSubview:view];
        _line = view;
    }
    return _line;
}

- (void)viewFrameUIDict:(NSDictionary *)dict
{
    self.backgroundColor = [UIColor clearColor];
    CGFloat itemW = self.itemView.frame.size.width;
    
    CGFloat typeW = [YBTooler calculateTheStringWidth:dict[@"Note"] font:14];
    self.typesLabel.frame = CGRectMake(15, 10, typeW + 5, 20);
    
    CGFloat timeW = [YBTooler calculateTheStringWidth:dict[@"SetoutTime"] font:14];
    self.timeLabel.frame = CGRectMake(CGRectGetMaxX(self.typesLabel.frame) + 5, 10, timeW, 20);
    self.line.frame     = CGRectMake(5, CGRectGetMaxY(self.typesLabel.frame) + 10, itemW - 10, 1);
    self.pointView.frame = CGRectMake(10, CGRectGetMaxY(self.line.frame) + 13, 8, 8);
    self.point2View.frame = CGRectMake(10, CGRectGetMaxY(self.pointView.frame) + 15, 8, 8);
    self.starLabel.frame = CGRectMake(CGRectGetMaxX(self.pointView.frame) + 5, self.pointView.origin.y - 5, itemW - 30, 20);
    self.endLabel.frame  = CGRectMake(CGRectGetMaxX(self.point2View.frame) + 5, self.point2View.origin.y - 5, itemW - 30, 20);
    self.arrowImage.frame = CGRectMake(itemW - 20, CGRectGetMaxY(self.pointView.frame) - 3, 7, 17);
    
}

- (void)commonRouteData:(NSDictionary *)dict
{
    [self viewFrameUIDict:dict];
    self.typesLabel.text = dict[@"Note"];
    self.timeLabel.text = dict[@"SetoutTime"];
    self.starLabel.text = [NSString stringWithFormat:@"%@·%@",dict[@"StartCity"],dict[@"StartAddress"]];
    self.endLabel.text = [NSString stringWithFormat:@"%@·%@",dict[@"EndCity"],dict[@"EndAddress"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
