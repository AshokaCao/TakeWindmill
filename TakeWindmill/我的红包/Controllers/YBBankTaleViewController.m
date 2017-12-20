//
//  YBBankTaleViewController.m
//  TakeWindmill
//
//  Created by AshokaCao on 2017/11/8.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBBankTaleViewController.h"
#import "YBCardTableViewCell.h"
#import "YBBankCardViewController.h"

@interface YBBankTaleViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *bankCardTableView;
@property (nonatomic, strong) NSMutableArray *cardArray;

@end

@implementation YBBankTaleViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getBankCardList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"银行卡列表";
    // Do any additional setup after loading the view from its nib.
    [self.bankCardTableView registerNib:[UINib nibWithNibName:@"YBCardTableViewCell" bundle:nil] forCellReuseIdentifier:@"cardCell"];
    self.bankCardTableView.tableFooterView = [UIView new];
    self.bankCardTableView.rowHeight = 60;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStyleDone target:self action:@selector(addBankCard)];
}

- (void)getBankCardList
{
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    NSString *userID = [YBUserDefaults valueForKey:_userId];
    dict[@"userid"] = userID;
    self.cardArray = [NSMutableArray array];
    [YBRequest postWithURL:BankCard MutableDict:dict success:^(id dataArray) {
        NSLog(@"dataArray - %@",dataArray);
        NSDictionary *cardDic = dataArray;
        NSDictionary *newDict = [NSDictionary changeType:cardDic];
        for (NSDictionary *diction in newDict[@"BankCardInfoList"]) {
            YBUserListModel *model = [YBUserListModel new];
            [model setValuesForKeysWithDictionary:diction];
            [self.cardArray addObject:model];
        }
        if (self.cardArray.count <= 0) {
            [self addNoBankCardTable];
        }
        [self.bankCardTableView reloadData];
    } failure:^(id dataArray) {
        
    }];
}

- (void)addNoBankCardTable
{
    UIView *nothing = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBWidth, 400)];
    UIImageView *noImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, YBWidth - 40, 150)];
    noImage.userInteractionEnabled = YES;
    noImage.image = [UIImage imageNamed:@"compose_pic_add"];
    [nothing addSubview:noImage];
    
    
    [self.view addSubview:nothing];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addBankCard)];
    [noImage addGestureRecognizer:tap];
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

- (void)addBankCard
{
    YBBankCardViewController *bank = [YBBankCardViewController new];
    [self.navigationController pushViewController:bank animated:YES];
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
