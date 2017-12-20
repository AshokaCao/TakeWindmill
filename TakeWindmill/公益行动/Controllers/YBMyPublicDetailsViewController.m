//
//  YBMyPublicDetailsViewController.m
//  TakeWindmill
//
//  Created by AshokaCao on 2017/11/23.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBMyPublicDetailsViewController.h"
#import "YBMineDonationsModel.h"
#import "YBMyPubTableViewCell.h"
#import "YBPublicDetailsViewController.h"

@interface YBMyPublicDetailsViewController ()
@property (nonatomic, strong) NSMutableArray *mineArray;
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UITableView *myPublicTableView;

@end

@implementation YBMyPublicDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的公益";
    [self.myPublicTableView registerNib:[UINib nibWithNibName:@"YBMyPubTableViewCell" bundle:nil] forCellReuseIdentifier:@"YBMyPubTableViewCell"];
    self.myPublicTableView.rowHeight = 80;
    self.myPublicTableView.tableFooterView = [UIView new];
    [self getuserPublicDetails];
    // Do any additional setup after loading the view from its nib.
}

- (void)getuserPublicDetails
{
    self.mineArray = [NSMutableArray array];
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    NSString *userID = [YBUserDefaults valueForKey:_userId];
    dict[@"userid"] = userID;
    NSLog(@"dict - %@",dict);
    [YBRequest postWithURL:MyPublicTable MutableDict:dict success:^(id dataArray) {
        NSDictionary *dic = dataArray;
        NSDictionary *newsDic = [NSDictionary changeType:dic];
        for (NSDictionary *diction in newsDic[@"PublicWelfareList"]) {
            YBMineDonationsModel *model = [YBMineDonationsModel new];
            [model setValuesForKeysWithDictionary:diction];
            [self.mineArray addObject:model];
        }
        [self.myPublicTableView reloadData];
        NSLog(@"lover - %@",dataArray);
    } failure:^(id dataArray) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mineArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBMyPubTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBMyPubTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    YBMineDonationsModel *model = self.mineArray[indexPath.row];
    [cell showDetailsWithModel:model];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBMineDonationsModel *model = self.mineArray[indexPath.row];
    
    YBPublicDetailsViewController *details = [YBPublicDetailsViewController new];
    details.sysNum = model.SysNo;
    [self.navigationController pushViewController:details animated:YES];
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
