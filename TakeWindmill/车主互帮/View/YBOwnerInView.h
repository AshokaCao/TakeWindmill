//
//  YBOwnerInView.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/16.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBOwnerInView : UIView

@property (weak, nonatomic) UIView *OwnerView;
@property (weak, nonatomic) UILabel *nameLabel;
@property (weak, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) UILabel *licensePlate;
@property (weak, nonatomic) UILabel *modelsLabel;
@property (weak, nonatomic) YBBaseButton *phoneButton;
@property (weak, nonatomic) YBBaseButton *SMSButton;

@end
