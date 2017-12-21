//
//  YBTaxiChooseView.h
//  TakeWindmill
//
//  Created by AshokaCao on 2017/12/13.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol YBTaxiChooseViewDelegate <NSObject>

- (void)didselectBtn:(NSInteger )types;

@end

@interface YBTaxiChooseView : UIView

@property (weak, nonatomic) IBOutlet UIButton *againBtn;
@property (weak, nonatomic) IBOutlet UIButton *jointBtn;
@property (weak, nonatomic) IBOutlet UIButton *anJointBtn;
@property (weak, nonatomic) IBOutlet UIButton *isCome;
@property (nonatomic, assign) id<YBTaxiChooseViewDelegate> delegate;

@end
