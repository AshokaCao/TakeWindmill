//
//  YBGroupHelpCell.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/11/28.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBGroupHelpModel.h"
@interface YBGroupHelpCell : UITableViewCell
@property(nonatomic,strong) UIImageView *check;
@property(nonatomic,strong) UIImageView *icon;
@property(nonatomic,strong) UILabel *nickName;
@property(nonatomic,strong) UILabel *carNumber;

@property(nonatomic,strong) UserInfoList *userInfoList;
@end
