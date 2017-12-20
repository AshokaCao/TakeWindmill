//
//  YBChooseBankViewController.m
//  TakeWindmill
//
//  Created by AshokaCao on 2017/11/9.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBChooseBankViewController.h"
#import "YBCardTableViewCell.h"

@interface YBChooseBankViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *bankTableView;
@property (nonatomic, strong) NSMutableArray *cardArray;

@end

@implementation YBChooseBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.bankTableView registerNib:[UINib nibWithNibName:@"YBCardTableViewCell" bundle:nil] forCellReuseIdentifier:@"cardCell"];
    self.bankTableView.tableFooterView = [UIView new];
    self.bankTableView.rowHeight = 60;
    
    self.cardArray = [NSMutableArray array];
    
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    [YBRequest postWithURL:TestUrl MutableDict:dict success:^(id dataArray) {
        
        NSDictionary *cardDic = dataArray;
        NSDictionary *newDict = [NSDictionary changeType:cardDic];
        for (NSDictionary *diction in newDict[@"BaseBankInfoList"]) {
            YBUserListModel *model = [YBUserListModel new];
            [model setValuesForKeysWithDictionary:diction];
            [self.cardArray addObject:model];
            
        }
        NSLog(@" - %@",cardDic);
        [self.bankTableView reloadData];
    } failure:^(id dataArray) {
        
    }];
    // Do any additional setup after loading the view from its nib.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cardArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cardCell"];
    YBUserListModel *model = self.cardArray[indexPath.row];
    
    cell.bankNameLabel.text = model.BankName;
    [cell.bankLogoImage sd_setImageWithURL:[NSURL URLWithString:model.PicUrl] placeholderImage:[UIImage imageNamed:@""]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBUserListModel *model = self.cardArray[indexPath.row];
    self.selectedBlock(model);
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
