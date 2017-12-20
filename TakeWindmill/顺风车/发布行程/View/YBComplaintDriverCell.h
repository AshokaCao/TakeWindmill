//
//  YBComplaintDriverCell.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/11/7.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBComplaintDriverCell : UITableViewCell
/**
 * 详情(选填)
 */
@property (nonatomic, weak) UITextField *reasonText;

//未选中状态
- (void)uncheckedStatus:(NSString *)str;

/**
 * 选中状态
 @param str 
 */
- (void)selectedState:(NSString *)str;
@end
