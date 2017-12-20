//
//  YBVerificationCodeVC.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/21.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBSetPasswordVC.h"
#import "YBVerificationCodeVC.h"

#import "MQVerCodeInputView.h"

@interface YBVerificationCodeVC ()

@property (nonatomic, strong) NSDictionary *typeDict;

@property (nonatomic, assign) NSInteger count;

//@property (nonatomic, assign) BOOL enabled;

@property (nonatomic, strong) UIButton *SMSButton;

@property (nonatomic, strong) NSTimer *time;


@end

@implementation YBVerificationCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"验证码";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *regImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"注册验证码"]];
    regImage.frame = CGRectMake(YBWidth / 2 - 20, 104, 40, 80);
    [self.view addSubview:regImage];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(regImage.frame) + 10, YBWidth, 40)];
    label.text = @"输入验证码";
    label.font = YBFont(22);
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame), YBWidth, 20)];
    label1.text = [NSString stringWithFormat:@"%@",self.phoneStr];
    label1.textColor = [UIColor grayColor];
    label1.font = YBFont(14);
    label1.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label1];
    
    _SMSButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _SMSButton.frame = CGRectMake(YBWidth - 100, CGRectGetMaxY(label.frame) - 5, 60,30);
    _SMSButton.layer.cornerRadius = 3.0;
    _SMSButton.clipsToBounds = YES;
    _SMSButton.titleLabel.font = [UIFont systemFontOfSize:10];
    _SMSButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _SMSButton.layer.borderWidth = 1.0;
    [_SMSButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_SMSButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_SMSButton addTarget:self action:@selector(codeBtnVerification:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_SMSButton];

    [self timeFailBeginFrom:60];  // 倒计时60s

    MQVerCodeInputView *verView = [[MQVerCodeInputView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_SMSButton.frame) + 20 , YBWidth / 1.5 , 50)];
    verView.maxLenght = 4;//最大长度
    verView.keyBoardType = UIKeyboardTypeNumberPad;
    [verView mq_verCodeViewWithMaxLenght];
    verView.block = ^(NSString *text){
        
        if (text.length == 4) {
            
            NSString *URLStr = [NSString stringWithFormat:@"%@",CheckregisterverifyPath];
            NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
            [dict setObject:text  forKey:@"verifycode"];
            [dict setObject:self.phoneStr  forKey:@"mobile"];

            [YBRequest postWithURL:URLStr MutableDict:dict View:self.view success:^(id dataArray) {
                self.typeDict = dataArray;
                YBSetPasswordVC *ver = [[YBSetPasswordVC alloc] init];
                ver.phoneStr = self.phoneStr;
                ver.typeStr = self.typeStr;
                ver.verifyCode = text;
                [self.navigationController pushViewController:ver animated:YES];
            } failure:^(id dataArray) {
                [MBProgressHUD showError:dataArray[@"ErrorMessage"] toView:self.view];
            }];
        }
    };
    verView.center = self.view.center;
    [self.view addSubview:verView];
}

// 获取验证码点击事件
- (void)codeBtnVerification:(UIButton *)sender {
    
    NSString *str = [NSString stringWithFormat:@"%@",SendverifymessagePath];
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    [dict setObject:self.phoneStr forKey:@"mobile"];
    
    [YBRequest postWithURL:str MutableDict:dict View:self.view success:^(id dataArray) {
        [self timeFailBeginFrom:60];  // 倒计时60s
    } failure:^(id dataArray) {
        [MBProgressHUD showError:dataArray[@"ErrorMessage"] toView:self.view];
    }];
}

- (void)timeFailBeginFrom:(NSInteger)timeCount {
    
    self.count = timeCount;
    // 加1个计时器
    self.time = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
}

- (void)timerFired {
    if (self.count != 1) {
        self.count -= 1;
        self.SMSButton.selected = NO;
        [self.SMSButton setTitle:[NSString stringWithFormat:@"剩余%ld秒", self.count] forState:UIControlStateNormal];
    } else {
        
        self.SMSButton.selected = YES;
        [self.SMSButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.time invalidate];
    }
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
