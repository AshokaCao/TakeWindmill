//
//  YBTaxiChooseView.m
//  TakeWindmill
//
//  Created by AshokaCao on 2017/12/13.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBTaxiChooseView.h"

@implementation YBTaxiChooseView


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:@"YBTaxiChooseView" owner:self options:nil] lastObject];
    if (self) {
        self.frame = frame;
    }
    return self;
}

- (IBAction)againAction:(id)sender {
    [self.delegate didselectBtn:1];
}

- (IBAction)jointAction:(UIButton *)sender {
    [self.delegate didselectBtn:2];
}
- (IBAction)anJoinAction:(UIButton *)sender {
    [self.delegate didselectBtn:3];
}
- (IBAction)callTaxiAction:(UIButton *)sender {
    [self.delegate didselectBtn:4];
}
- (IBAction)routeMessageAction:(UIButton *)sender {
    [self.delegate didselectBtn:5];
}
- (IBAction)watchAction:(UIButton *)sender {
    [self.delegate didselectBtn:6];
}

@end
