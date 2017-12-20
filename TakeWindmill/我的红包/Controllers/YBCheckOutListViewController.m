//
//  YBCheckOutListViewController.m
//  TakeWindmill
//
//  Created by AshokaCao on 2017/11/10.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBCheckOutListViewController.h"
#import "YBUserListModel.h"
#import "YBRedEnvelopesCell.h"

@interface YBCheckOutListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *chectOutTableView;
@property (nonatomic, strong) NSMutableArray *inOrOutArray;

@end

@implementation YBCheckOutListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"交易记录";
    
    [self getIncomeListAction];
    self.chectOutTableView.tableFooterView = [UIView new];
    // Do any additional setup after loading the view from its nib.
}

- (void)getIncomeListAction
{
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    NSString *userID = [YBUserDefaults valueForKey:_userId];
    dict[@"userid"] = userID;
    self.inOrOutArray = [NSMutableArray array];
    [YBRequest postWithURL:IncomeList MutableDict:dict success:^(id dataArray) {
        //        NSLog(@"dataArray - IncomeListNew - %@",dataArray);
        NSDictionary *dic = dataArray;
        for (NSDictionary *diction in dic[@"IncomeInfoList"]) {
            NSLog(@"diction - %@",diction);
            YBUserListModel *model = [YBUserListModel new];
            [model setValuesForKeysWithDictionary:diction];
            [self.inOrOutArray addObject:model];
        }
        [self.chectOutTableView reloadData];
    } failure:^(id dataArray) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.inOrOutArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YBRedEnvelopesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBRedEnvelopesCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YBRedEnvelopesCell" owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    YBUserListModel *model = self.inOrOutArray[indexPath.row];
    [cell setListMessageWithModel:model];
    //    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
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
