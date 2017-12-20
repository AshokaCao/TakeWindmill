//
//  YBCheckOutViewController.m
//  TakeWindmill
//
//  Created by AshokaCao on 2017/11/8.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBCheckOutViewController.h"
#import "YBBankCardViewController.h"
#import "YBBankTaleViewController.h"
#import "YBUserListModel.h"
#import "YBTipViewController.h"

@interface YBCheckOutViewController ()
@property (weak, nonatomic) IBOutlet UIView *bankCardView;
@property (weak, nonatomic) IBOutlet UIView *checkMoneyView;
@property (weak, nonatomic) IBOutlet UITextField *checkNumText;
@property (weak, nonatomic) IBOutlet UILabel *canusedMoney;
@property (weak, nonatomic) IBOutlet UIImageView *bankImageView;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (nonatomic, strong) YBUserListModel *bankModel;
@property (nonatomic, strong) NSString *bankNum;
@property (nonatomic, strong) NSString *bankID;
@property (nonatomic, strong) NSString *checkMoney;

@end

@implementation YBCheckOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现";
    self.canusedMoney.text = [NSString stringWithFormat:@"可用余额%@元",self.lastMoneyStr];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseBankCard)];
    [self.bankCardView addGestureRecognizer:tap];
    NSString *name = self.bankModel.BankName;
    if (name != nil) {
        [self getBankListWithModel:self.bankModel];
    } else {
        self.bankNameLabel.text = @"请选择银行卡";
    }
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)checkOutAllMoneyAction:(UIButton *)sender {
    self.checkNumText.text = self.lastMoneyStr;
}
- (IBAction)shureAction:(UIButton *)sender {
//    534656456456
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    NSString *userID = [YBUserDefaults valueForKey:_userId];
    dict[@"userid"] = userID;
    dict[@"bankcardcode"] = self.bankNum;
    dict[@"withdrawmoney"] = self.checkNumText.text;
    dict[@"bankfid"] = self.bankID;
    [YBRequest postWithURL:CheckOutMoney MutableDict:dict success:^(id dataArray) {
        NSLog(@"dataArray - %@",dataArray);
        NSDictionary *dic = dataArray;
        if (dic[@"HasError"]) {
            NSLog(@"-------");
            YBTipViewController *view = [YBTipViewController new];
            [self presentViewController:view animated:YES completion:^{
                
            }];
        } else {
            NSLog(@"0000000");
        }
    } failure:^(id dataArray) {

    }];
}

- (void)chooseBankCard
{
    YBBankTaleViewController *table = [YBBankTaleViewController new];
    [table setSelectedBlock:^(YBUserListModel *model) {
        NSLog(@"-----------");
        self.bankModel = model;
        [self getBankListWithModel:model];
    }];
    [self.navigationController pushViewController:table animated:YES];
}

- (void)getBankListWithModel:(YBUserListModel *)model
{
    [self.bankImageView sd_setImageWithURL:[NSURL URLWithString:model.PicUrl] placeholderImage:[UIImage imageNamed:@""]];
    self.bankNameLabel.text = model.BankName;
    self.bankNum = model.CardCode;
    self.bankID = model.BankFID;
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
