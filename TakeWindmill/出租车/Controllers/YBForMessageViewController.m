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
@property (nonatomic, strong) NSMutableString *addTextStr;

@end

@implementation YBForMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"稍话";
    self.addTextStr = [[NSMutableString alloc] initWithString:@"稍话:"];
}
- (IBAction)didselectBtn:(UIButton *)sender {
    switch (sender.tag) {
        case 100:
            self.oneBtn.selected = !self.oneBtn.selected;
            if (self.oneBtn.isSelected) {
                [self.addTextStr appendString:@"马上就走"];
                self.messageTextField.text = self.addTextStr;
            } else {
//                NSString *changeStr = self.addTextStr;
                
                
                NSLog(@"select - %@",self.addTextStr);
                self.messageTextField.text = self.addTextStr;
            }
            NSLog(@"select this button - %@",self.addTextStr);
            break;
        case 101:
        {
            self.towBtn.selected = !self.towBtn.selected;
            if (self.towBtn.selected) {
                
            } else {
                
            }
            NSLog(@"select this button");
        }
            break;
        case 102:
            NSLog(@"select this button");
            break;
        case 103:
            NSLog(@"select this button");
            break;
        case 104:
            NSLog(@"select this button");
            break;
        case 105:
            NSLog(@"select this button");
            break;
            
        default:
            break;
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
