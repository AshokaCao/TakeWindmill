//
//  YBOwnersHelpAlertView.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/11/30.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBOwnerInView.h"
#import "YBGroupHelpModel.h"

@protocol YBOwnersHelpAlertViewDelegate <NSObject>

- (void)clickTap:(NSInteger)tag;

@end

@interface YBOwnersHelpAlertView : UIView
//@property (nonatomic ,copy)void (^clikeReturnNumber)(NSInteger num,NSString *text);

@property(nonatomic,weak) UIViewController *VC;
@property (nonatomic, strong)UserInfoList * userInfoList;
@property (nonatomic, weak) id delegate;

/**
 * 求助页面
 */
@property (nonatomic, strong) UITextView *contentText;
@property (nonatomic, strong) YBOwnerInView *owner;
@property (nonatomic, strong) UIButton *helpButton;
@property (nonatomic, strong) UIButton *tohelpButton;
@property (nonatomic, strong) UIButton *nohelpButton;

@end
