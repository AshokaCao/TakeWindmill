//
//  YBRoadTableViewCell.h
//  TakeWindmill
//
//  Created by AshokaCao on 2017/10/25.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBRoadNowModel.h"

@class SDTimeLineCellModel;

@protocol YBRoadTableViewCellDelegate <NSObject>

- (void)didClickLikeButtonInCell:(UITableViewCell *)cell;
- (void)didClickcCommentButtonInCell:(UITableViewCell *)cell;

@end

@interface YBRoadTableViewCell : UITableViewCell

@property (nonatomic, strong) YBRoadNowModel *modelYB;

@property (nonatomic, weak) id<YBRoadTableViewCellDelegate> delegate;

@property (nonatomic, strong) SDTimeLineCellModel *model;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, copy) void (^moreButtonClickedBlock)(NSIndexPath *indexPath);
@end
