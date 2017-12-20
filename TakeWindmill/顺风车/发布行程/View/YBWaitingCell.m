//
//  YBWaitingCell.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/15.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBWaitingCell.h"
#import "YBWaitingView.h"

@implementation YBWaitingCell

- (void)layoutSubviews {
    [super layoutSubviews];
    
    YBWaitingView *waiting = [[YBWaitingView alloc] initWithFrame:CGRectMake(5, 5, YBWidth - 10, self.contentView.frame.size.height - 10)];
    waiting.backgroundColor = [UIColor whiteColor];
//    waiting.hidePhone = NO;
//    waiting.hideSMS = NO;
//    [waiting inviteColleagues:nil];
    [YBTooler setTheControlShadow:waiting];
    [self.contentView addSubview:waiting];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
