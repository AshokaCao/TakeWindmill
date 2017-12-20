//
//  YBAddressSearchCell.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/25.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBAddressSearchCell.h"


@interface YBAddressSearchCell ()

@property (nonatomic, weak) YBBaseView *view;

@end

@implementation YBAddressSearchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        YBBaseView *view = [[YBBaseView alloc] init];
        [self.contentView addSubview:view];
        self.view = view;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.view.frame = CGRectMake(10, 10, YBWidth - 40, 40);
    [self.view upAndDownImage:nil imageSize:CGSizeMake(10, 10) imageBacColor:[UIColor lightGrayColor] LabelTitle:self.detailedDict[@"Name"] titleFont:14 titleColor:[UIColor blackColor] subTitle:self.detailedDict[@"Address"] subTitleFont:12 subtitleColor:[UIColor lightGrayColor]];
    
}
@end
