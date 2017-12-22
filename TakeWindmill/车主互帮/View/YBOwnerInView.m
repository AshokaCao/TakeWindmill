//
//  YBOwnerInformationView.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/16.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBOwnerInView.h"

@implementation YBOwnerInView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UIView *OwnerView = [[UIView alloc] init];
        [self addSubview:OwnerView];
        self.OwnerView = OwnerView;
        
        UILabel *nameLabel = [[UILabel alloc] init];
        self.nameLabel = nameLabel;
        [self.OwnerView addSubview:nameLabel];

        UIImageView *imageView = [[UIImageView alloc] init];
        self.imageView = imageView;
        [self.OwnerView addSubview:imageView];
        
        UILabel *licensePlate = [[UILabel alloc] init];
        self.licensePlate = licensePlate;
        [self addSubview:licensePlate];
        
        UILabel *modelsLabel = [[UILabel alloc] init];
        self.modelsLabel = modelsLabel;
        [self addSubview:modelsLabel];
        
        YBBaseButton *phoneButton = [[YBBaseButton alloc] init];
        self.phoneButton = phoneButton;
        [self addSubview:phoneButton];
        
        YBBaseButton *SMSButton = [[YBBaseButton alloc] init];
        self.SMSButton = SMSButton;
        [self addSubview:SMSButton];
        
        [self YBlayoutSubviews];
        
    }
    return self;
}

- (void)YBlayoutSubviews {
    //[super layoutSubviews];
    
    self.backgroundColor = [UIColor whiteColor];
    
    CGFloat viewW = self.frame.size.width;
    CGFloat viewH = self.frame.size.height;
    CGFloat interval = 5;
    
    self.OwnerView.frame = CGRectMake(0, 0,viewW / 3,viewH);
//    self.OwnerView.backgroundColor = [];
    
    self.imageView.frame = CGRectMake(0, 0,viewH, viewH);
    self.imageView.layer.cornerRadius = viewH/2;
    self.imageView.clipsToBounds = YES;
    self.imageView.image = [UIImage imageNamed:@"headimg.gif"];
    
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + interval, 0, self.OwnerView.frame.size.width - viewH - interval, viewH);
    self.nameLabel.text = @"李师傅";
    self.nameLabel.font = YBFont(12);
//    self.nameLabel.textColor = [UIColor whiteColor];
    
    self.licensePlate.frame = CGRectMake(CGRectGetMaxX(self.OwnerView.frame) + interval, 0, viewW / 3, viewH / 2);
    self.licensePlate.text = @"浙A88888";
    self.licensePlate.font = YBFont(12);

    self.modelsLabel.frame = CGRectMake(CGRectGetMaxX(self.OwnerView.frame) + interval, viewH / 2, viewW / 3, viewH / 2);
    self.modelsLabel.text = @"黑色奔驰S600";
    self.modelsLabel.font = YBFont(12);

    self.SMSButton.frame = CGRectMake(CGRectGetMaxX(self.modelsLabel.frame) + interval,interval, viewH - 10, viewH - 10);
    [self.SMSButton setBackgroundImage:[UIImage imageNamed:@"短信"] forState:UIControlStateNormal];
    self.phoneButton.frame = CGRectMake(CGRectGetMaxX(self.SMSButton.frame) + 15, interval, viewH - 10, viewH - 10);
    [self.phoneButton setBackgroundImage:[UIImage imageNamed:@"电话"] forState:UIControlStateNormal];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor redColor];
    
}

@end
