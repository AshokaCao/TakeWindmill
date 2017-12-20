//
//  YBMyPubTableViewCell.h
//  TakeWindmill
//
//  Created by AshokaCao on 2017/11/28.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBMineDonationsModel.h"

@interface YBMyPubTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UILabel *titlesLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

- (void)showDetailsWithModel:(YBMineDonationsModel *)model;

@end
