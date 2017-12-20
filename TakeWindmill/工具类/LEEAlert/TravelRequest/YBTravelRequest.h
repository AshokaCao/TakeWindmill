//
//  YBTravelRequest.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/23.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectConfirmBlock)(NSMutableArray *array);

@interface YBTravelRequest : UIView

@property (nonatomic, strong) selectConfirmBlock selectedConfirmBlock;

@property (nonatomic, strong) NSMutableArray *subscriptArray;

@end
