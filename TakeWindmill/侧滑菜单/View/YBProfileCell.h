//
//  YBProfileCell.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/8.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBCommenItem;

@interface YBProfileCell : UITableViewCell

/** item */
@property (nonatomic, strong) YBCommenItem *item;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
