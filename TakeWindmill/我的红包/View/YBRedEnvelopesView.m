//
//  YBRedEnvelopesView.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/10.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBRedEnvelopesView.h"

@interface YBRedEnvelopesView ()


@end

@implementation YBRedEnvelopesView

- (void)awakeFromNib {
    [super awakeFromNib];
    NSLog(@"----- %@",self.lastMoney);
//    if ([self.lastMoney isEqualToString:@"0"]) {
//        self.moneyLabel.text = @"￥ 0.0";
//    } else {
//        self.moneyLabel.text = [NSString stringWithFormat:@"￥ %@",self.lastMoney];
//    }
//    [self.moneyLabel setAttributedText:[self changeLabelWithText:self.moneyLabel.text]];
    self.withdrawButton.layer.cornerRadius = 5;
    self.withdrawButton.layer.borderWidth = 1;
    self.withdrawButton.layer.borderColor = [UIColor blackColor].CGColor;
}

- (NSMutableAttributedString*)changeLabelWithText:(NSString*)needText {
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:needText];
    UIFont *font = [UIFont systemFontOfSize:22];
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(1,3)];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(3,needText.length-3)];
    
    return attrString;
}
- (IBAction)withdrawAction:(UIButton *)sender {
}
- (IBAction)settingAction:(UIButton *)sender {
}

@end
