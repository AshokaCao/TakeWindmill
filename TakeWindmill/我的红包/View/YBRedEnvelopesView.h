//
//  YBRedEnvelopesView.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/10.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBRedEnvelopesView : UIView

@property (nonatomic, strong) NSString *lastMoney;

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *phoneNum;
@property (weak, nonatomic) IBOutlet UIImageView *userHeaderImage;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *withdrawButton;
- (NSMutableAttributedString*)changeLabelWithText:(NSString*)needText;
@end
