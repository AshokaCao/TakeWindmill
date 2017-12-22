//
//  YBSettingVC.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/12/11.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBSettingVC.h"
#import "YBInformationCell.h"
#import "YBSettingDetailVC.h"
#import "YBCommonAddressVC.h"
#import "YBSettingModel.h"

@interface YBSettingVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *identityTabView;
@end

@implementation YBSettingVC
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
    self.title = @"设置";
    [self setUI];
}
-(void)setUI{
    //WEAK_SELF;
    
    [self.view addSubview:self.identityTabView];
    [self.identityTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    //[weakSelf.identityTabView reloadData];
}
#pragma mark - 数据源方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section != 2) {
        return 2;
    }
    
    return 1;
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
    NSArray * dataArr = [NSArray arrayWithObjects:@"账号与安全",@"常用地址", nil];
    if (indexPath.section == 1) {
        //dataArr = [NSArray arrayWithObjects:@"法律条款与隐私政策",@"用户指南", nil];
        dataArr = [NSArray arrayWithObjects:@"版本更新",@"关于皕夶", nil];
        if (indexPath.row == 0) {
            
            cell.textField.text = [NSString stringWithFormat:@"%@",[HSHString getAppCurVersion]];
            [cell.textField mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.imageV.mas_left).offset(-kpadding);
            }];
            
        }
    } else if (indexPath.section == 2){
        UILabel * label = [[UILabel alloc]init];
        label.text = @"退出登录";
        label.textColor = BtnOrangeColor;
        [cell addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(cell);
        }];
        
        cell.imageV.hidden = YES;
        
        return cell;
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
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAK_SELF;
    YBInformationCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    YBSettingDetailVC * vc = [[YBSettingDetailVC alloc]init];
    vc.title = cell.text.text;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            vc.isAccount = YES;
            [self.navigationController pushViewController:vc animated:NO];
        }else{
            YBCommonAddressVC * vc = [[YBCommonAddressVC alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
        }
        
    } else if (indexPath.section == 1){
        if (indexPath.row == 0) {//版本更新
        
            NSMutableDictionary *mutableDict = [YBTooler dictinitWithMD5];
            //[mutableDict setObject:[YBTooler getTheUserId:self.view] forKey:@"userid"];//用户Id
            
            [YBRequest postWithURL:sysinfoGetsysinfo MutableDict:mutableDict success:^(id dataArray) {
                YBLog(@"%@",dataArray);
                YBSettingModel * model = [YBSettingModel yy_modelWithJSON:dataArray];
                model.version = @"1.2.1";
                if ([HSHString compareVersion:model.version to:[HSHString getAppCurVersion]]) {
                    YBLog(@"要更新");
                }else{
                     YBLog(@"不更新");
                }
                
            } failure:^(id dataArray) {
                [MBProgressHUD showError:dataArray[@"ErrorMessage"] toView:weakSelf.view];
            }];
            
            
        }else{
            vc.isAbout = YES;
            [self.navigationController pushViewController:vc animated:NO];
        }
    }else if (indexPath.section == 2){
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


@end
