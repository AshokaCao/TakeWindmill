//
//  YBTrafficTableViewCell.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/10.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBTrafficTableViewCell.h"

@interface YBTrafficTableViewCell ()

//路况
@property (weak, nonatomic) IBOutlet UIImageView *conditionsImage;
//头像
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
//名字
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//评论
@property (weak, nonatomic) IBOutlet UIButton *commentButton;

@end

@implementation YBTrafficTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    [self.commentButton setImage:[UIImage imageNamed:@"评论"] forState:UIControlStateNormal];
//     [self.commentButton setTitle:@"40" forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
