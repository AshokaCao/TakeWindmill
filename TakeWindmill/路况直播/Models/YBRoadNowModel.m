//
//  YBRoadNowModel.m
//  TakeWindmill
//
//  Created by AshokaCao on 2017/10/25.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBRoadNowModel.h"
#import <UIKit/UIKit.h>

extern const CGFloat contentLabelFontSize;
extern const CGFloat maxContentLabelHeight;

@implementation YBRoadNowModel

@synthesize shouldShowMoreButton = _shouldShowMoreButton;
@synthesize intro = _intro;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

+ (instancetype)modelWithDic:(NSDictionary *)dic
{
    YBRoadNowModel *model = [[YBRoadNowModel alloc] init];
    [model setValuesForKeysWithDictionary:dic];
    
    return model;
}

- (void)setIntro:(NSString *)intro
{
    _intro = intro;
}

- (NSString *)intro
{
    CGFloat contentW = [UIScreen mainScreen].bounds.size.width - 70;
    CGRect textRect = [_intro boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:contentLabelFontSize]} context:nil];
    if (textRect.size.height > maxContentLabelHeight) {
        _shouldShowMoreButton = YES;
    } else {
        _shouldShowMoreButton = NO;
    }
    
    return _intro;
}

- (void)setIsOpening:(BOOL)isOpening
{
    if (!_shouldShowMoreButton) {
        _isOpening = NO;
    } else {
        _isOpening = isOpening;
    }
}

-(NSMutableArray<NSString *> *)images{
    if (!_images) {
        self.images = [NSMutableArray array];
    }
    return _images;
}

@end
