//
//  YBLoverCommentViewController.m
//  TakeWindmill
//
//  Created by AshokaCao on 2017/11/22.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBLoverCommentViewController.h"
#import "YBCommentTableViewCell.h"
#import "YBCommentModels.h"

@interface YBLoverCommentViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *loverCommentTableView;
@property (nonatomic, strong) NSMutableArray *commentArray;

@end

@implementation YBLoverCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"爱心评论";
    [self getLoverCommentData];
//    commentCell
    self.loverCommentTableView.rowHeight = 86;
    [self.loverCommentTableView registerNib:[UINib nibWithNibName:@"YBCommentTableViewCell" bundle:nil] forCellReuseIdentifier:@"commentCell"];
    self.loverCommentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.loverCommentTableView.tableFooterView = [UIView new];
}

- (void)getLoverCommentData
{
    self.commentArray = [NSMutableArray array];
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    dict[@"publicwelfaresysno"] = self.sysNum;
    [YBRequest postWithURL:DonationCommTable MutableDict:dict success:^(id dataArray) {
        NSDictionary *dic = dataArray;
        NSDictionary *newsDic = [NSDictionary changeType:dic];
        for (NSDictionary *diction in newsDic[@"ContributeCommentList"]) {
            YBCommentModels *model = [YBCommentModels new];
            [model setValuesForKeysWithDictionary:diction];
            [self.commentArray addObject:model];
        }
        [self.loverCommentTableView reloadData];
        NSLog(@"lover - %@",dataArray);
    } failure:^(id dataArray) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    YBCommentModels *model = self.commentArray[indexPath.row];
    [cell showDetailsWithModel:model];
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
