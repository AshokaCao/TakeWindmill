//
//  YBLogInViewController.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/21.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBLogInViewController.h"
#import "YBRegisteredVC.h"

#import "FXAnimationField.h"

@interface YBLogInViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) FXAnimationField *emailAnimationField;

@property (strong, nonatomic) FXAnimationField *passwordAnimationField;

@property (nonatomic, weak) YBBaseButton *logInButton;

@property (nonatomic, weak) YBBaseButton *forgetPassword;

@property (nonatomic, weak) NSDictionary *typeDict;

@end

@implementation YBLogInViewController

#pragma mark - lzay
- (FXAnimationField *)emailAnimationField {
    if (!_emailAnimationField) {
        _emailAnimationField = [[FXAnimationField alloc] initWithFrame:CGRectMake(10, 36, YBWidth - 20, 30)];
        _emailAnimationField.textFiled.borderStyle =  UITextBorderStyleNone;
        _emailAnimationField.textFiled.delegate = self;
        _emailAnimationField.textFiled.tag = 0;
        _emailAnimationField.placeholderColor = [UIColor lightGrayColor];
        _emailAnimationField.placeStr = @"请输入手机号码";
        _emailAnimationField.textFiled.keyboardType = UIKeyboardTypeNumberPad;
        _emailAnimationField.placeholderFont = [UIFont systemFontOfSize:15];

        _emailAnimationField.animationType = FXAnimationTypeUp;
    }
    return _emailAnimationField;
}

- (FXAnimationField *)passwordAnimationField {
    if (!_passwordAnimationField) {
        _passwordAnimationField = [[FXAnimationField alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.emailAnimationField.frame) + 30, YBWidth - 20, 30)];
        _passwordAnimationField.textFiled.borderStyle =  UITextBorderStyleNone;
        _passwordAnimationField.textFiled.delegate = self;
        _passwordAnimationField.textFiled.tag = 1;
        _passwordAnimationField.placeholderColor = [UIColor lightGrayColor];
        _passwordAnimationField.placeStr = @"请输入密码";
        _passwordAnimationField.textFiled.secureTextEntry = YES;
        _passwordAnimationField.textFiled.clearsOnBeginEditing = YES;
        _passwordAnimationField.placeholderFont = [UIFont systemFontOfSize:15];
        _passwordAnimationField.animationType = FXAnimationTypeUp;
    }
    return _passwordAnimationField;
    
}

- (YBBaseButton *)logInButton {
    if (!_logInButton) {
        YBBaseButton *btn = [YBBaseButton buttonWithFrame:CGRectMake(10, CGRectGetMaxY(self.passwordAnimationField.frame) + 30, YBWidth - 20, 40) Strtitle:@"登录" titleColor:[UIColor whiteColor] titleFont:15 textAlignment:NSTextAlignmentCenter image:nil BackgroundColor:BtnBlueColor cornerRadius:5];
        [btn addTarget:self action:@selector(loginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        _logInButton = btn;
    }
    return _logInButton;
}

- (YBBaseButton *)forgetPassword {
    if (!_forgetPassword) {
        YBBaseButton *btn = [YBBaseButton buttonWithFrame:CGRectMake(YBWidth - 80, CGRectGetMaxY(self.logInButton.frame) + 20, 70 ,20) Strtitle:@"忘记密码?" titleColor:[UIColor blackColor] titleFont:14 textAlignment:NSTextAlignmentCenter image:nil BackgroundColor:nil cornerRadius:0];
        [btn addTarget:self action:@selector(rigButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        _forgetPassword = btn;
    }
    return _forgetPassword;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *rigButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    rigButton.titleLabel.font = YBFont(14);
    [rigButton setTitle:@"注册" forState:UIControlStateNormal];
    [rigButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rigButton addTarget:self action:@selector(rigButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rigButton];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"登录";
    
    [self.view addSubview:self.emailAnimationField];
    [self.view addSubview:self.passwordAnimationField];
    [self logInButton];
    [self forgetPassword];
}

- (void)rigButtonAction:(UIButton *)btn
{
    YBRegisteredVC *registered = [[YBRegisteredVC alloc] init];
    registered.typeStr = btn.titleLabel.text;
    [self.navigationController pushViewController:registered animated:YES];
}

- (void)loginButtonAction:(UIButton *)sender
{
    if (self.emailAnimationField.textFiled.text && self.emailAnimationField.textFiled.text.length == 11) {
//        if (!self.passwordAnimationField.textFiled.text || self.passwordAnimationField.textFiled.text.length < 8 || self.passwordAnimationField.textFiled.text.length > 16) {
//            [MBProgressHUD showError:@"请输入正确格式的密码！" toView:self.view];
//            return;
//        }
        [self loginAccount:self.emailAnimationField.textFiled.text userpwd:self.passwordAnimationField.textFiled.text];
        return;
    }
    [MBProgressHUD showError:@"请输入正确手机号！" toView:self.view];
}

- (void)loginAccount:(NSString *)account userpwd:(NSString *)pwd {
    NSString *URLStr = [NSString stringWithFormat:@"%@",LoginPath];
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    [dict setObject:account  forKey:@"mobile"];
    [dict setObject:pwd  forKey:@"userpwd"];
    
    [YBRequest postWithURL:URLStr MutableDict:dict View:self.view success:^(id dataArray) {
        YBLog(@"%@",dataArray);
//        self.typeDict = dataArray;
        [YBUserDefaults setObject:account forKey:accountNumber];
        [YBUserDefaults setBool:YES forKey:isLogin];
        [YBUserDefaults setObject:dataArray[@"UserId"] forKey:_userId];
        [YBUserDefaults synchronize];
        
        //
        [[RCDataManager shareManager] loginRongCloudWithUserInfo:nil withToken:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];

    } failure:^(id dataArray) {
        YBLog(@"------%@",dataArray);
        [MBProgressHUD showError:dataArray[@"ErrorMessage"] toView:self.view];
    }];
}

#pragma mark -delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 0) {
        self.passwordAnimationField.textFiled.text = nil;
    }
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField //将要结束编辑
{
    if (textField.tag == 0) {
        if (11 > textField.text.length || textField.text.length > 11) {
            [MBProgressHUD showError:@"请输入正确的手机号" toView:self.view];
        }
    }
    return YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
