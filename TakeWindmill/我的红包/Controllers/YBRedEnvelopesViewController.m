//
//  YBRedEnvelopesViewController.m
//  TakeWindmill
//
//  Created by AshokaCao on 2017/11/8.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBRedEnvelopesViewController.h"
#import "YBCheckOutListViewController.h"
#import "YBCheckOutViewController.h"
#import "YBRedEnvelopesCell.h"
#import "YBUserListModel.h"

#import "YBUserInfoVC.h"

@interface YBRedEnvelopesViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *topBackView;
@property (weak, nonatomic) IBOutlet UILabel *lastMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileNumberLabel;
@property (weak, nonatomic) IBOutlet UITableView *redTableView;
@property (nonatomic, strong) YBUserListModel *userModel;
@property (nonatomic, strong) NSMutableArray *inOrOutArray;
@property (nonatomic, strong) NSString *lastMoney;

@end

@implementation YBRedEnvelopesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的红包";
    self.view.backgroundColor = LightGreyColor;
    // Do any additional setup after loading the view from its nib.
    [self getUserListAction];
    [self getIncomeListAction];
    self.redTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


- (void)getUserListAction
{
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    NSString *userID = [YBUserDefaults valueForKey:_userId];
    dict[@"userid"] = userID;
    //    NSLog(@"dict - %@",dict);
    
    [YBRequest postWithURL:UserList MutableDict:dict success:^(id dataArray) {
        NSLog(@"dataArray - %@",dataArray);
        NSDictionary *dic = dataArray;
        NSDictionary *newDic = [NSDictionary changeType:dic];
        self.userModel = [YBUserListModel modelWithDic:newDic];
//        dispatch_sync(dispatch_get_main_queue(), ^{
        self.nickNameLabel.text = self.userModel.NickName;
        self.mobileNumberLabel.text = self.userModel.Mobile;
        NSLog(@"AccountMoney - %@",self.userModel.AccountMoney);
        NSString *lastMoney = [NSString stringWithFormat:@"%@",self.userModel.AccountMoney];
        if ([lastMoney isEqualToString:@"0"]) {
            self.lastMoneyLabel.text = self.lastMoney = @"￥ 0.0";
        } else {
            self.lastMoneyLabel.text = [NSString stringWithFormat:@"￥ %@",self.userModel.AccountMoney];
            self.lastMoney = [NSString stringWithFormat:@"%@",self.userModel.AccountMoney];
        }
//        });
    } failure:^(id dataArray) {
        
    }];
}

- (void)getIncomeListAction
{
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    NSString *userID = [YBUserDefaults valueForKey:_userId];
    dict[@"userid"] = userID;
    self.inOrOutArray = [NSMutableArray array];
    [YBRequest postWithURL:IncomeListNew MutableDict:dict success:^(id dataArray) {
        //        NSLog(@"dataArray - IncomeListNew - %@",dataArray);
        NSDictionary *dic = dataArray;
        for (NSDictionary *diction in dic[@"IncomeInfoList"]) {
            NSLog(@"diction - %@",diction);
            YBUserListModel *model = [YBUserListModel new];
            [model setValuesForKeysWithDictionary:diction];
            [self.inOrOutArray addObject:model];
        }
        [self.redTableView reloadData];
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
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    
    UIView *heaView = [[UIView alloc] initWithFrame:CGRectMake(0, 5 , YBWidth, 40)];
    heaView.backgroundColor = [UIColor whiteColor];
    [view addSubview:heaView];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 20, 20)];
    image.image = [UIImage imageNamed:@"收入明细"];
    [heaView addSubview:image];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(image.frame) +10, 10, 100, 20)];
    label.text = @"收入明细";
    label.textColor = [UIColor grayColor];
    [heaView addSubview:label];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(label.frame) + 10, YBWidth - 40, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [heaView addSubview:lineView];
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    UIButton *grouButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, YBWidth - 20, 20)];
    [grouButton setTitle:@"点击查看更多" forState:UIControlStateNormal];
    [grouButton addTarget:self action:@selector(moreMessage) forControlEvents:UIControlEventTouchUpInside];
    grouButton.titleLabel.font = YBFont(14);
    [grouButton setTitleColor:BtnBlueColor forState:UIControlStateNormal];
    [view addSubview:grouButton];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 40;
}

- (IBAction)checkOutAction:(UIButton *)sender {
    YBCheckOutViewController *check = [[YBCheckOutViewController alloc] init];
    check.lastMoneyStr = self.lastMoney;
    [self.navigationController pushViewController:check animated:YES];
}
- (IBAction)settingAction:(UIButton *)sender {
    YBUserInfoVC *chect = [YBUserInfoVC new];
    [self.navigationController pushViewController:chect animated:YES];
}

- (void)moreMessage
{
    YBCheckOutListViewController *chect = [YBCheckOutListViewController new];
    [self.navigationController pushViewController:chect animated:YES];
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
