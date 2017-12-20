//
//  YBInformationCell.h
//  TakeWindmill
//
//  Created by HUSHOUHUA华 on 2017/11/20.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBInformationCell : UITableViewCell
@property (nonatomic,strong) UILabel * text;
@property (nonatomic,strong) UITextField * textField;
@property (nonatomic,strong) UIImageView * imageV;//箭头

@property (nonatomic,strong) UIButton * btnAZ;
@property (nonatomic,strong) UIButton * btnCity;
@end
