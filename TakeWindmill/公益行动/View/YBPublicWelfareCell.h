//
//  YBPublicWelfareCell.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/18.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBPublicListTableModel.h"

@interface YBPublicWelfareCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *publicImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progView;
@property (weak, nonatomic) IBOutlet UILabel *loverCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *targetLabel;
@property (weak, nonatomic) IBOutlet UILabel *proporLabel;

- (void)showDetailsWithModel:(YBPublicListTableModel *)model;

@end
