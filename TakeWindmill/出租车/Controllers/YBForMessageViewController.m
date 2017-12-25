//
//  YBForMessageViewController.m
//  TakeWindmill
//
//  Created by AshokaCao on 2017/12/16.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBForMessageViewController.h"

@interface YBForMessageViewController ()
@property (weak, nonatomic) IBOutlet UIButton *oneBtn;
@property (weak, nonatomic) IBOutlet UIButton *towBtn;
@property (weak, nonatomic) IBOutlet UIButton *threeBtn;
@property (weak, nonatomic) IBOutlet UIButton *fourBtn;
@property (weak, nonatomic) IBOutlet UIButton *fiveBtn;
@property (weak, nonatomic) IBOutlet UIButton *sixBtn;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (nonatomic, strong) NSString *addTextStr;

@end

@implementation YBForMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"稍话";
    self.addTextStr = @"";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(shureClick:)];
}
- (IBAction)didselectBtn:(UIButton *)sender {
    switch (sender.tag) {
        case 100:
            self.oneBtn.selected = !self.oneBtn.selected;
            if (self.oneBtn.isSelected) {
               self.addTextStr = [self.addTextStr stringByAppendingString:@"马上就走."];
                self.messageTextField.text = self.addTextStr;
            } else {
                NSString *changeStr = self.addTextStr;
                changeStr = [changeStr stringByReplacingOccurrencesOfString:@"马上就走." withString:@""];
                
                NSLog(@"select - %@",changeStr);
                self.addTextStr = changeStr;
                self.messageTextField.text = changeStr;
            }
            NSLog(@"select this button - %@",self.addTextStr);
            break;
        case 101:
        {
            self.towBtn.selected = !self.towBtn.selected;
            if (self.towBtn.selected) {
                self.addTextStr = [self.addTextStr stringByAppendingString:@"愿等15分钟."];
                self.messageTextField.text = self.addTextStr;
            } else {
                NSString *changeStr = self.addTextStr;
                changeStr = [changeStr stringByReplacingOccurrencesOfString:@"愿等15分钟." withString:@""];
                
                NSLog(@"select - %@",changeStr);
                self.addTextStr = changeStr;
                self.messageTextField.text = changeStr;
            }
            NSLog(@"select this button");
        }
            break;
        case 102:
        {
            self.threeBtn.selected = !self.threeBtn.selected;
            if (self.threeBtn.selected) {
                self.addTextStr = [self.addTextStr stringByAppendingString:@"打车往返."];
                self.messageTextField.text = self.addTextStr;
            } else {
                NSString *changeStr = self.addTextStr;
                changeStr = [changeStr stringByReplacingOccurrencesOfString:@"打车往返." withString:@""];
                
                NSLog(@"select - %@",changeStr);
                self.addTextStr = changeStr;
                self.messageTextField.text = changeStr;
            }
            NSLog(@"select this button");
        }
            break;
        case 103:
        {
            self.fourBtn.selected = !self.fourBtn.selected;
            if (self.fourBtn.selected) {
                self.addTextStr = [self.addTextStr stringByAppendingString:@"不爱聊天."];
                self.messageTextField.text = self.addTextStr;
            } else {
                NSString *changeStr = self.addTextStr;
                changeStr = [changeStr stringByReplacingOccurrencesOfString:@"不爱聊天." withString:@""];
                
                NSLog(@"select - %@",changeStr);
                self.addTextStr = changeStr;
                self.messageTextField.text = changeStr;
            }
            NSLog(@"select this button");
        }
            break;
        case 104:
        {
            self.fiveBtn.selected = !self.fiveBtn.selected;
            if (self.fiveBtn.selected) {
                self.addTextStr = [self.addTextStr stringByAppendingString:@"在线支付."];
                self.messageTextField.text = self.addTextStr;
            } else {
                NSString *changeStr = self.addTextStr;
                changeStr = [changeStr stringByReplacingOccurrencesOfString:@"在线支付." withString:@""];
                
                NSLog(@"select - %@",changeStr);
                self.addTextStr = changeStr;
                self.messageTextField.text = changeStr;
            }
            NSLog(@"select this button");
        }
            break;
        case 105:
        {
            self.sixBtn.selected = !self.sixBtn.selected;
            if (self.sixBtn.selected) {
                self.addTextStr = [self.addTextStr stringByAppendingString:@"现金支付."];
                self.messageTextField.text = self.addTextStr;
            } else {
                NSString *changeStr = self.addTextStr;
                changeStr = [changeStr stringByReplacingOccurrencesOfString:@"现金支付." withString:@""];
                
                NSLog(@"select - %@",changeStr);
                self.addTextStr = changeStr;
                self.messageTextField.text = changeStr;
            }
            NSLog(@"select this button");
        }
            break;
            
        default:
            break;
    }
}

- (void)shureClick:(UIBarButtonItem *)item
{
    self.sendMessage(self.addTextStr);
    [self.navigationController popViewControllerAnimated:YES];
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
