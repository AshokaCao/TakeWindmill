//
//  YBCancelTraveView.m
//  TakeWindmill
//
//  Created by AshokaCao on 2017/12/20.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBCancelTraveView.h"

@implementation YBCancelTraveView



- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:@"YBCancelTraveView" owner:self options:nil] lastObject];
    if (self) {
        self.frame = frame;
    }
    return self;
}



- (void)showDetailWith:(NSDictionary *)diction
{
    [self.userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:diction[@"HeadImgUrl"]] placeholderImage:[UIImage imageNamed:@""]];
    self.userNameLabel.text = diction[@"UserName"];
    self.starLabel.text = diction[@"StartAddress"];
    self.endLabel.text = diction[@"EndAddress"];
    NSString *time = [diction[@"SetoutTimeStr"] stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    self.timeLabel.text = time;
    self.moneyLabel.text = [NSString stringWithFormat:@"拼成价%@元",diction[@"TravelCostJoin"]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)cancelTrovleAction:(UIButton *)sender {
    self.cancelBlock(@"yes");
}
- (IBAction)packUPAction:(UIButton *)sender {
}

@end
