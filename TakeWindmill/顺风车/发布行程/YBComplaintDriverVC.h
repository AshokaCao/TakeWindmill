//
//  YBComplaintDriverVC.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/11/7.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComplaintTitleView : UIView

/**
 * 行程投诉信息
 @param dict 司机行程
 */
- (void)itineraryComplaints:(NSDictionary *)dict;

@end

@interface YBComplaintDriverVC : UIViewController

@property (nonatomic ,strong) NSDictionary *driverDict;

@end
