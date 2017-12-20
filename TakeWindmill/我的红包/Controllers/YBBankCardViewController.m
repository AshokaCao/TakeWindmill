//
//  YBBankCardViewController.m
//  TakeWindmill
//
//  Created by AshokaCao on 2017/11/8.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBBankCardViewController.h"
#import "YBChooseBankViewController.h"
#import "YBUserListModel.h"
#import "YBTipViewController.h"

@interface YBBankCardViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nickNameText;
@property (weak, nonatomic) IBOutlet UITextField *cardNumText;
@property (weak, nonatomic) IBOutlet UITextField *moblieNumText;
@property (weak, nonatomic) IBOutlet UITextField *bankNameText;
@property (weak, nonatomic) IBOutlet UIButton *chooseBankBtn;
@property (nonatomic, strong) YBUserListModel *model;
@property (nonatomic, strong) NSString *bankFID;

@end

@implementation YBBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
}
- (IBAction)nextAction:(UIButton *)sender {
    
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    NSString *userID = [YBUserDefaults valueForKey:_userId];
    dict[@"userid"] = userID;
    dict[@"cardcode"] = self.cardNumText.text;
    dict[@"bankfid"] = self.model.FID;
    
    [YBRequest postWithURL:BankData MutableDict:dict success:^(id dataArray) {
        NSLog(@"dataArray - %@",dataArray);
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(id dataArray) {

    }];
}
- (IBAction)chooseBankAction:(UIButton *)sender {
    YBChooseBankViewController *choose = [YBChooseBankViewController new];
    choose.selectedBlock = ^(YBUserListModel *model) {
        self.model = model;
        self.bankFID = [NSString stringWithFormat:@"%@",model.FID];
        NSLog(@"error - %@",self.bankFID);
        [self.chooseBankBtn setTitle:model.BankName forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:choose animated:YES];
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
