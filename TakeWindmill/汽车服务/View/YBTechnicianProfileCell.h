//
//  YBTechnicianProfileCell.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/18.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBServiceModels.h"
#import "YBTechnicianModel.h"

@interface YBTechnicianProfileCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *workerTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *workingDaysLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *callHimeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *userHeaderImageView;
@property (weak, nonatomic) IBOutlet UILabel *easyInstall;
@property (weak, nonatomic) IBOutlet UILabel *workerNameLabel;

- (void)showListWIthModel:(YBTechnicianModel *)model;

@end
