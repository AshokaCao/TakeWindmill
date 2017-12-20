//
//  YBDonationViewController.m
//  TakeWindmill
//
//  Created by AshokaCao on 2017/11/23.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBDonationViewController.h"

@interface YBDonationViewController ()
@property (weak, nonatomic) IBOutlet UIButton *twentyBtn;
@property (weak, nonatomic) IBOutlet UIButton *fiftyBtn;
@property (weak, nonatomic) IBOutlet UIButton *hundredBtn;
@property (weak, nonatomic) IBOutlet UIButton *fiftyHundBtn;
@property (weak, nonatomic) IBOutlet UITextField *customTextField;
@property (nonatomic, strong) NSString *moneyStr;

@end

@implementation YBDonationViewController

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)twentyAction:(UIButton *)sender {
    self.twentyBtn.selected = YES;
    self.fiftyBtn.selected = self.hundredBtn.selected = self.fiftyHundBtn.selected = NO;
    self.moneyStr = @"20";
}
- (IBAction)fiftyAction:(id)sender {
    self.fiftyBtn.selected = YES;
    self.twentyBtn.selected = self.hundredBtn.selected = self.fiftyHundBtn.selected = NO;
    self.moneyStr = @"50";
}
- (IBAction)hundAction:(UIButton *)sender {
    self.hundredBtn.selected = YES;
    self.fiftyBtn.selected = self.twentyBtn.selected = self.fiftyHundBtn.selected = NO;
    self.moneyStr = @"100";
}
- (IBAction)fiftyHyndAction:(UIButton *)sender {
    self.fiftyHundBtn.selected = YES;
    self.fiftyBtn.selected = self.hundredBtn.selected = self.twentyBtn.selected = NO;
    self.moneyStr = @"150";
}
- (IBAction)protocolAction:(UIButton *)sender {
    
}
- (IBAction)donationAction:(UIButton *)sender {
    if (self.moneyStr) {
        
    } else {
        
    }
    
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    dict[@"configtype"] = @"alipay";
    [YBRequest postWithURL:Alipay MutableDict:dict success:^(id dataArray) {
        NSDictionary *diction = dataArray;
        NSDictionary *newsDic = [self dictionWithJson:diction[@"ConfigBody"]];
        NSLog(@"---- %@",newsDic);
    } failure:^(id dataArray) {
        
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (NSDictionary *)dictionWithJson:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
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
