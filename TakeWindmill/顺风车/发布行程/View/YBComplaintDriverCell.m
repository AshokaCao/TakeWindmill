//
//  YBComplaintDriverCell.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/11/7.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBComplaintDriverCell.h"

@interface YBComplaintDriverCell ()

/**
 * 内容
 */
@property (nonatomic, weak) UILabel *titleLabel;

/**
 * 选中按钮图片
 */
@property (nonatomic, weak) UIImageView *checkedImageView;

/**
 * 下划线
 */
@property (nonatomic, weak) UIView *lienView;

@end

@implementation YBComplaintDriverCell

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, YBWidth - 50, 50)];
        titleLabel.font     = YBFont(16);
        [self addSubview:titleLabel];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

- (UIImageView *)checkedImageView
{
    if(!_checkedImageView){
        UIImageView *checkedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame),15 , 20, 20)];
        [self addSubview:checkedImageView];
        _checkedImageView = checkedImageView;
    }
    return _checkedImageView;
}

- (UIView *)lienView
{
    if (!_lienView) {
        UIView *line         = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.titleLabel.frame), YBWidth - 20, 1)];
        line.backgroundColor = [UIColor grayColor];
        [self addSubview:line];
        _lienView = line;
    }
    return _lienView;
}

- (UITextField *)reasonText
{
    if (!_reasonText) {
        UITextField *reasonText     = [[UITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.lienView.frame) + 5, YBWidth - 20, 50)];
        reasonText.borderStyle      = UITextBorderStyleRoundedRect;
        reasonText.placeholder      = @"描述更多详细内容(选填)";
        reasonText.font             = [UIFont fontWithName:@"Arial" size:15.0f];
        reasonText.backgroundColor  = LineLightColor;
        [self addSubview:reasonText];
        _reasonText = reasonText;
    }
    return _reasonText;
}

#pragma mark - 未选中状态
- (void)uncheckedStatus:(NSString *)str
{
    self.titleLabel.text        = str;
    self.lienView.hidden        = YES;
    self.reasonText.hidden      = YES;
    self.checkedImageView.image = [UIImage imageNamed:@"未选择"];
}

- (void)selectedState:(NSString *)str
{
    self.titleLabel.text        = str;
    self.lienView.hidden        = NO;
    self.reasonText.hidden      = NO;
    self.checkedImageView.image = [UIImage imageNamed:@"打钩图标"];
}

@end
