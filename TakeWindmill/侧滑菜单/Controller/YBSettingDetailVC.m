//
//  YBSettingDetailVC.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/12/12.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBSettingDetailVC.h"
#import "YBInformationCell.h"

@interface YBSettingDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *identityTabView;

@end

@implementation YBSettingDetailVC

-(UITableView *)identityTabView
{
    if (_identityTabView == nil) {
        _identityTabView = [[UITableView alloc]init];
        _identityTabView.backgroundColor = LightGreyColor;
        _identityTabView.showsVerticalScrollIndicator = NO;
        _identityTabView.showsHorizontalScrollIndicator = NO;
        _identityTabView.scrollEnabled = NO;
        _identityTabView.delegate = self;
        _identityTabView.dataSource = self;
        [self.view addSubview:_identityTabView];
    }
    return _identityTabView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUI];
}
-(void)setUI{
    [self.view addSubview:self.identityTabView];
    [self.identityTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}
#pragma mark - 数据源方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_isAccount) {
        return 2;
    }else if (_isAbout){
        return 2;
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_isAccount) {
        if (section == 0) {
            return 1;
        }else{
            return 3;
        }
    }else if (_isAbout){
        if (section == 0) {
            return 2;
        }
    }
    return  0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSString *cellIndentifier = [NSString stringWithFormat:@"cell%ld%ld",indexPath.section,indexPath.row];
    static NSString * cellIndentifier = @"cellIndentifier";
    YBInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[YBInformationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    //去掉底部多余的表格线
    [tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    NSArray * dataArr = [NSArray arrayWithObjects:@"", nil];
    
    if (_isAccount) {
        if (indexPath.section == 0) {
             dataArr = [NSArray arrayWithObjects:@"修改手机号", nil];
            
            NSString * account= [YBUserDefaults objectForKey:accountNumber];
            cell.textField.text = account;
        }else{
               dataArr = [NSArray arrayWithObjects:@"实名认证",@"密码设置",@"注销账号", nil];
            if (indexPath.row == 0) {
                 cell.textField.text = @"已认证";
            }
        }
    }else if (_isAbout){
       dataArr = [NSArray arrayWithObjects:@"版本介绍",@"联系我们", nil];
    }
    
    cell.text.text = dataArr[indexPath.row];
    cell.text.textColor = kTextBackColor;
    cell.textField.userInteractionEnabled = NO;
    
    
    return cell;
}
#pragma mark - 代理方法
//行高
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 80;
//}

//头部高度
static CGFloat headerH = 20;
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.identityTabView) {
        return headerH;
    }
    return CGFLOAT_MIN;
}

//底部视图高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.001;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == self.identityTabView) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YBWidth, headerH)];
        view.backgroundColor = LightGreyColor;
        return view;
    }
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (tableView == self.identityTabView) {
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YBWidth, 30)];
        view.backgroundColor = LightGreyColor;
        
        UILabel *label = [[UILabel alloc]init];
        label.textColor = kTextGreyColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"该车通过审核后，将作为默认运营车辆";
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.top.equalTo(view);
        }];
        return view;
        
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    YBInformationCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
        }else{
            
        }
        
    } else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            
        }else{
            
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            
        }else{
            
        }
    }else if (indexPath.section == 3){
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认退出登录？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertOK = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [YBUserDefaults setBool:NO forKey:isLogin];
            [YBUserDefaults setObject:nil forKey:_userId];
            [YBUserDefaults synchronize];
            
            [MBProgressHUD showError:@"退出成功!" toView:self.view];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertVC addAction:alertOK];
        [alertVC addAction:cancel];
        [self presentViewController:alertVC animated:YES completion:nil];
        
    }
    
//    YBSettingDetailVC * vc = [[YBSettingDetailVC alloc]init];
//    vc.title = cell.text.text;
//    [self.navigationController pushViewController:vc animated:NO];
    
}
//分割线
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
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
