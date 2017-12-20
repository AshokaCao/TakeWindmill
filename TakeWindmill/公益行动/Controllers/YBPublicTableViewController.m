//
//  YBPublicTableViewController.m
//  TakeWindmill
//
//  Created by AshokaCao on 2017/11/23.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBPublicTableViewController.h"
#import "YBPublicDetailsViewController.h"
#import "YBPublicWelfareCell.h"
#import "YBPublicListTableModel.h"

@interface YBPublicTableViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *publicTableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *topHeaderImageView;
@property (weak, nonatomic) IBOutlet UILabel *loverCountLabel;

@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, strong) NSMutableArray *listTableData;
@end

@implementation YBPublicTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"公益活动";
    [self.publicTableView registerNib:[UINib nibWithNibName:@"YBPublicWelfareCell" bundle:nil] forCellReuseIdentifier:@"YBPublicWelfareCell"];
    self.publicTableView.rowHeight = 101;
    self.publicTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self getTopDetails];
    [self getPublicList];
    // Do any additional setup after loading the view from its nib.
}

- (void)getPublicList
{
    self.listTableData = [NSMutableArray array];
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    dict[@"pageindex"] = [NSString stringWithFormat:@"%ld",self.pageIndex];
    [YBRequest postWithURL:PublicServiceTable MutableDict:dict success:^(id dataArray) {
//        NSLog(@"PublicServiceTable - - %@",dataArray);
        NSDictionary *dic = dataArray;
        NSDictionary *newDic = [NSDictionary changeType:dic];
        for (NSDictionary *diction in newDic[@"PublicWelfareList"]) {
            YBPublicListTableModel *model = [YBPublicListTableModel new];
            [model setValuesForKeysWithDictionary:diction];
            [self.listTableData addObject:model];
        }
        [self.publicTableView reloadData];
    } failure:^(id dataArray) {
        NSLog(@"error %@",dataArray);
    }];
}

- (void)getTopDetails
{
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    [YBRequest postWithURL:PublicTop MutableDict:dict success:^(id dataArray) {
        NSLog(@"PublicServiceTable - - %@",dataArray);
        NSDictionary *dic = dataArray;
        [self.topHeaderImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"MainPicPath"]] placeholderImage:[UIImage imageNamed:@""]];
        self.loverCountLabel.text = [NSString stringWithFormat:@"已有 %@ 份爱心",dic[@"ContributeTotal"]];
//        NSDictionary *newDic = [NSDictionary changeType:dic];
//        for (NSDictionary *diction in newDic[@"PublicWelfareList"]) {
//            YBPublicListTableModel *model = [YBPublicListTableModel new];
//            [model setValuesForKeysWithDictionary:diction];
//            [self.listTableData addObject:model];
//        }
//        [self.publicTableView reloadData];
    } failure:^(id dataArray) {
        NSLog(@"error %@",dataArray);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listTableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBPublicWelfareCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBPublicWelfareCell"];
    YBPublicListTableModel *model = self.listTableData[indexPath.row];
    [cell showDetailsWithModel:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 40)];
    label.text = @"公益项目";
    label.font = YBFont(16);
    [view addSubview:label];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBPublicListTableModel *model = self.listTableData[indexPath.row];
    
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
