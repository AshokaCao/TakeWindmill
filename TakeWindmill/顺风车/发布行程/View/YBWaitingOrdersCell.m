//
//  YBWaitingOrdersCell.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/31.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBWaitingOrdersCell.h"
#import "YBWaitingView.h"
@interface YBWaitingOrdersCell ()

@end

@implementation YBWaitingOrdersCell

- (YBWaitingView *)bgView
{
    if (!_bgView) {
        YBWaitingView *bgView = [[YBWaitingView alloc] init];
        //给bgView边框设置阴影
        bgView.layer.shadowOffset = CGSizeMake(1,1);
        bgView.layer.shadowOpacity = 0.1;
        bgView.layer.shadowColor = [UIColor grayColor].CGColor;
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        _bgView = bgView;
    }
    return _bgView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = [UIColor clearColor];
    self.bgView.frame = CGRectMake(10, 10, self.frame.size.width - 20, self.frame.size.height - 30);
    [self.bgView waitingTheOwnerOrdersCell:self.detailsDict];
}

@end


