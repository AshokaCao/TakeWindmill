//
//  YBCommentTableViewCell.h
//  TakeWindmill
//
//  Created by AshokaCao on 2017/11/22.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBCommentModels.h"

@interface YBCommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userHeaderImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

- (void)showDetailsWithModel:(YBCommentModels *)model;

@end
