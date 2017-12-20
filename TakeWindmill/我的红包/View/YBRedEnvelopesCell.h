//
//  YBRedEnvelopesCell.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/10.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBUserListModel.h"

@interface YBRedEnvelopesCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (nonatomic, strong) YBUserListModel *model;

- (void)setListMessageWithModel:(YBUserListModel *)model;

@end
