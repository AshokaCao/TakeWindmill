//
//  YBSetPasswordVC.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/21.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBSetPasswordVC.h"

#import "FXAnimationField.h"

@interface YBSetPasswordVC ()<UITextFieldDelegate>

@property (nonatomic, strong) FXAnimationField *phoneText;

@property (nonatomic, strong) NSDictionary *typeDict;

@end

@implementation YBSetPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置密码";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *regImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"密码"]];
    regImage.frame = CGRectMake(YBWidth / 2 - 20, 104, 40, 80);
    [self.view addSubview:regImage];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(regImage.frame) + 10, YBWidth, 40)];
    if ([self.typeStr isEqualToString:@"注册"]) {
        label.text = @"设置登录密码";
    }else {
        label.text = @"重置登录密码";
    }
    label.font = YBFont(22);
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame), YBWidth, 20)];
    label1.text = @"密码由8-16位英文字母、数字或字符串组合";
    label1.textColor = [UIColor grayColor];
    label1.font = YBFont(14);
    label1.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label1];
    
    self.phoneText = [[FXAnimationField alloc] initWithFrame:CGRectMake(YBWidth / 5, CGRectGetMaxY(label1.frame) + 20, YBWidth / 5 * 3, 30)];
    self.phoneText.textFiled.borderStyle =  UITextBorderStyleNone;
    self.phoneText.textFiled.delegate = self;
    self.phoneText.textFiled.secureTextEntry = YES;
    self.phoneText.placeholderFont = [UIFont systemFontOfSize:15];
//    self.phoneText.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.phoneText];
    [self.phoneText.textFiled becomeFirstResponder];
    
    UIButton *nextStep = [[UIButton alloc] initWithFrame:CGRectMake(YBWidth / 3, CGRectGetMaxY(self.phoneText.frame) + 10, YBWidth / 3, 30)];
    [nextStep setTitle:@"下一步" forState:UIControlStateNormal];
    [nextStep setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [nextStep addTarget:self action:@selector(nextStepAction:) forControlEvents:UIControlEventTouchUpInside];
    nextStep.titleLabel.textAlignment = NSTextAlignmentCenter;
    nextStep.titleLabel.font = YBFont(16);
    [self.view addSubview:nextStep];


}

- (void)nextStepAction:(UIButton *)sender
{
    if (_phoneText.textFiled.text.length >= 8 && _phoneText.textFiled.text.length <= 16) {
        if ([self checkPassWord]) {
            
            NSString *URLStr;
            NSString *titleStr;
            NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
            [dict setObject:_phoneText.textFiled.text  forKey:@"userpwd"];
            [dict setObject:self.phoneStr  forKey:@"mobile"];
            [dict setObject:self.verifyCode forKey:@"verifycode"];
            
            if ([self.typeStr isEqualToString:@"注册"]) {
                URLStr = [NSString stringWithFormat:@"%@",RegisterPath];
                titleStr = @"注册成功";
            }
            else {
                URLStr = [NSString stringWithFormat:@"%@",userpwdresetPath];
                titleStr = @"重置密码成功";
            }
            [YBRequest postWithURL:URLStr MutableDict:dict View:self.view success:^(id dataArray) {
                YBLog(@"%@",dataArray);
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:titleStr preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [YBUserDefaults setObject:self.phoneStr forKey:accountNumber];
                    [YBUserDefaults setBool:YES forKey:isLogin];
                    [YBUserDefaults setObject:dataArray[@"UserId"] forKey:_userId];
                    [YBUserDefaults synchronize];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
            } failure:^(id dataArray) {
                [MBProgressHUD showError:dataArray[@"ErrorMessage"] toView:self.view];
            }];
        }
        else {
            [MBProgressHUD showTitleToView:self.view postion:NHHUDPostionCenten title:@"密码过于简单请重新设置!"];
        }
        return;
    }
    else if (_phoneText.textFiled.text.length > 16) {
        [MBProgressHUD showError:@"密码过长，请重新设置" toView:self.view];
        return;
    }
    
    [MBProgressHUD showError:@"请设置8-16位英文字母、数字或字符串组合的密码" toView:self.view];
}

-(BOOL)checkPassWord
{
    //6-20位数字和字母组成
    NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([pred evaluateWithObject:_phoneText.textFiled.text]) {
        return YES ;
    }else
        return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
