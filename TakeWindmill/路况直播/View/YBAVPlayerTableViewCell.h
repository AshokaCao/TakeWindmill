//
//  YBAVPlayerTableViewCell.h
//  TakeWindmill
//
//  Created by AshokaCao on 2017/10/27.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDTimeLineCellModel.h"

@interface YBAVPlayerTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstCase;
@property (weak, nonatomic) IBOutlet UILabel *secondCase;
@property (weak, nonatomic) IBOutlet UILabel *thredCase;
@property (weak, nonatomic) IBOutlet UILabel *foursCase;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *videoImage;
@property (weak, nonatomic) IBOutlet UILabel *timesLine;

/** model */
@property (nonatomic, strong) SDTimeLineCellModel *model;
@property (nonatomic, strong) UIButton *playBtn;
/** 播放按钮block */
@property (nonatomic, copy  ) void(^playBlock)(UIButton *);
@end
