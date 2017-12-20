//
//  YBMyHelpVC.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/11/28.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBMyHelpVC.h"
#import "YBHelpWithMeCell.h"
#import "YBOwnersHelpAlertView.h"
#import "YBEvaluationViewController.h"

@interface YBMyHelpVC ()<YBOwnersHelpAlertViewDelegate>

@end

@implementation YBMyHelpVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self requstData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)requstData{
    
    NSMutableDictionary *parm = [YBTooler dictinitWithMD5];
    NSString *userID = [YBUserDefaults valueForKey:_userId];
    //UserId：用户Id
    parm[@"userid"] = userID;
   
    WEAK_SELF;
    [YBRequest postWithURL:DriverhelpDriverhelpinfolistbyuserid MutableDict:parm success:^(id dataArray) {
        //YBLog(@"dataArray==%@",dataArray);
        YBGroupHelpModel *model = [YBGroupHelpModel yy_modelWithJSON:dataArray];
        weakSelf.dataArr = [NSMutableArray arrayWithArray:model.DriverHelpInfoList];
        
        [weakSelf.tableView reloadData];
        
    } failure:^(id dataArray) {
        //YBLog(@"failureDataArray==%@",dataArray);
        [MBProgressHUD showError:dataArray[@"ErrorMessage"] toView:weakSelf.view];
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * reuseIdentifier = @"reuseIdentifier";
    YBHelpWithMeCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[YBHelpWithMeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //去掉底部多余的表格线
    [tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    if (indexPath.row<_dataArr.count) {
        UserInfoList * userInfoList = self.dataArr[indexPath.row];
        cell.userInfoList = userInfoList;
    }
    return cell;
}
#pragma mark - 代理方法
//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YBHelpWithMeCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString * state = cell.state.text;
    UserInfoList * userInfoList = self.dataArr[indexPath.row];
    
    if ([state isEqualToString:@"拒绝帮助"] || [state isEqualToString:@"未处理"]) {
        YBOwnersHelpAlertView  *helpView = [[YBOwnersHelpAlertView alloc] init];
        helpView.VC = self;
        helpView.helpButton.hidden = YES;
        helpView.contentText.userInteractionEnabled = NO;
        helpView.userInfoList = userInfoList;
        helpView.contentText.text = userInfoList.Message;
        helpView.contentText.textColor = kTextGreyColor;
        helpView.delegate = self;
        [self.view addSubview:helpView];
    }else if ([state isEqualToString:@"愿意帮助"] || [state isEqualToString:@"完成"]){
         YBEvaluationViewController *eva = [[YBEvaluationViewController alloc]init];
        eva.isSend = YES;
        eva.userInfoList = userInfoList;
        [self.navigationController pushViewController:eva animated:YES];
    }
}
#pragma mark YBOwnersHelpAlertViewDelegate
-(void)clickTap:(NSInteger)tag{
    [self requstData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
