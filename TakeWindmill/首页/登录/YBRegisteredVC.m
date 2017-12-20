//
//  YBRegisteredViewController.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/21.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBRegisteredVC.h"
#import "YBVerificationCodeVC.h"

#import "FXAnimationField.h"

@interface YBRegisteredVC ()<UITextFieldDelegate>

@property (nonatomic, strong) FXAnimationField *phoneText;

@property (nonatomic, strong) NSDictionary *typeDict;


@end

@implementation YBRegisteredVC

- (void)viewDidLoad {
    [super viewDidLoad];

    //注册键盘弹出通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //注册键盘隐藏通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    if ([self.typeStr isEqualToString:@"注册"]) {
        self.title = @"注册";
    }else {
        self.title = @"重置密码";
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.typeDict = [NSDictionary dictionary];
    
    UIImageView *regImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"注册图标"]];
    regImage.frame = CGRectMake(YBWidth / 2 - 20, 40    , 40, 80);
    [self.view addSubview:regImage];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(regImage.frame) + 10, YBWidth, 40)];
    label.text = @"输入手机号";
    label.font = YBFont(22);
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame), YBWidth, 20)];
    label1.text = @"为方便司机联系你，请输入手机号";
    label1.font = YBFont(14);
    label1.textColor = [UIColor grayColor];
    label1.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label1];
    
    self.phoneText = [[FXAnimationField alloc] initWithFrame:CGRectMake(YBWidth / 5, CGRectGetMaxY(label1.frame) + 20, YBWidth / 5 * 3, 30)];
    self.phoneText.textFiled.borderStyle =  UITextBorderStyleNone;
    self.phoneText.textFiled.delegate = self;
    self.phoneText.textFiled.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneText.placeholderFont = [UIFont systemFontOfSize:15];
    self.phoneText.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.phoneText];
    [self.phoneText.textFiled becomeFirstResponder];

    UIButton *nextStep = [[UIButton alloc] initWithFrame:CGRectMake(YBWidth / 3, CGRectGetMaxY(self.phoneText.frame) + 10, YBWidth / 3, 30)];
    [nextStep setTitle:@"下一步" forState:UIControlStateNormal];
    [nextStep setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if ([self.typeStr isEqualToString:@"注册"]) {
        [nextStep addTarget:self action:@selector(nextStepAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        [nextStep addTarget:self action:@selector(resetPassword:) forControlEvents:UIControlEventTouchUpInside];
    }
    nextStep.titleLabel.textAlignment = NSTextAlignmentCenter;
    nextStep.titleLabel.font = YBFont(16);
    [self.view addSubview:nextStep];
}

- (void)nextStepAction:(UIButton *)sender
{
    NSString *str = [NSString stringWithFormat:@"%@",CheckuserPath];
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    [dict setObject:self.phoneText.textFiled.text forKey:@"mobile"];
    
    [YBRequest postWithURL:str MutableDict:dict View:self.view success:^(id dataArray) {
        self.typeDict = dataArray;
        YBLog(@"%@",dataArray);
        NSString *str = [NSString stringWithFormat:@"%@",SendverifymessagePath];
        NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
        [dict setObject:self.phoneText.textFiled.text forKey:@"mobile"];
        
        [YBRequest postWithURL:str MutableDict:dict View:self.view success:^(id dataArray) {
            YBLog(@"%@",dataArray);
            YBVerificationCodeVC *ver = [[YBVerificationCodeVC alloc] init];
            ver.phoneStr = self.phoneText.textFiled.text;
            ver.typeStr = self.typeStr;
            [self.navigationController pushViewController:ver animated:YES];
        } failure:^(id dataArray) {
            [MBProgressHUD showError:dataArray[@"ErrorMessage"] toView:self.view];
        }];

    } failure:^(id dataArray) {
        [MBProgressHUD showError:dataArray[@"ErrorMessage"] toView:self.view];
    }];

}

- (void)resetPassword:(UIButton *)sender
{
    NSString *str = [NSString stringWithFormat:@"%@",updatepwdcheckuserPath];
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    [dict setObject:self.phoneText.textFiled.text forKey:@"mobile"];
    
    [YBRequest postWithURL:str MutableDict:dict View:self.view success:^(id dataArray) {
        self.typeDict = dataArray;
        NSString *str = [NSString stringWithFormat:@"%@",SendverifymessagePath];
        NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
        [dict setObject:self.phoneText.textFiled.text forKey:@"mobile"];
        
        [YBRequest postWithURL:str MutableDict:dict View:self.view success:^(id dataArray) {
            YBVerificationCodeVC *ver = [[YBVerificationCodeVC alloc] init];
            ver.phoneStr = self.phoneText.textFiled.text;
            ver.typeStr = self.typeStr;
            [self.navigationController pushViewController:ver animated:YES];
        } failure:^(id dataArray) {
            [MBProgressHUD showError:dataArray[@"ErrorMessage"] toView:self.view];
        }];
        
    } failure:^(id dataArray) {
        [MBProgressHUD showError:dataArray[@"ErrorMessage"] toView:self.view];
    }];
    
}

//键盘弹出后将视图向上移动
-(void)keyboardWillShow:(NSNotification *)note
{
    NSDictionary *info = [note userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    //目标视图UITextField
    CGRect frame = self.phoneText.frame;
    int y = frame.origin.y + frame.size.height - (self.view.frame.size.height - keyboardSize.height);
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    if(y > 0)
    {
        self.view.frame = CGRectMake(0, -100, self.view.frame.size.width, self.view.frame.size.height);
    }
    [UIView commitAnimations];
}

//键盘隐藏后将视图恢复到原始状态
-(void)keyboardWillHide:(NSNotification *)note
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
