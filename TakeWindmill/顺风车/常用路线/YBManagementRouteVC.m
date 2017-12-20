//
//  YBManagementRouteVC.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/11.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBManagementRouteVC.h"
#import "YBCommonRouteVC.h"

#import "YBManagementCell.h"

@interface YBManagementRouteVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *rigButton;
}
@property (nonatomic, weak) UITableView *managementTableView;

/**
 * 是否是删除状态
 */
@property (nonatomic, assign) BOOL isDelete;

/**
 * 所You的数据
 */
@property (nonatomic, strong) NSMutableArray *dataArray;

/**
 * 所要删除的数据
 */
@property (nonatomic, strong) NSMutableArray *deleteArr;


@end

@implementation YBManagementRouteVC

#pragma mark - lazy
- (UITableView *)managementTableView
{
    if (!_managementTableView) {
        UITableView *tableView      = [[UITableView alloc] initWithFrame:self.view.bounds];
        tableView.delegate          = self;
        tableView.dataSource        = self;
        tableView.editing           = NO;//默认tableview的editing 是不开启的
        tableView.rowHeight         = 120;
        tableView.backgroundColor   = LightGreyColor;
        //去掉分割线
        tableView.separatorStyle    = UITableViewCellSelectionStyleNone;
        [self.view addSubview:tableView];
        _managementTableView = tableView;
    }
    return _managementTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title                = @"常用路线";
    self.view.backgroundColor = LightGreyColor;
    self.dataArray            = [NSMutableArray array];
    self.deleteArr            = [NSMutableArray array];

    rigButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [rigButton setTitle:@"删除" forState:UIControlStateNormal];
    [rigButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rigButton addTarget:self action:@selector(rigButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    rigButton.titleLabel.font = YBFont(14);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rigButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //请求常用数组
    [self commonRouteDataRequest];
}

- (void)commonRouteDataRequest
{
    NSString *urlStr                  = commonaddressdriverlistPath;
    NSMutableDictionary *dict         = [YBTooler dictinitWithMD5];
    [dict setObject:[YBTooler getTheUserId:self.view] forKey:@"userid"];//所在城市的id
    
    [YBRequest postWithURL:urlStr MutableDict:dict success:^(id dataArray) {
        YBLog(@"%@",dataArray);
        self.dataArray = dataArray[@"CommonAddressList"];
        [self.managementTableView reloadData];
    } failure:^(id dataArray) {
        YBLog(@"%@",dataArray);
        self.dataArray = nil;
        [self.managementTableView reloadData];
    }];
}

- (void)rigButtonAction:(UIButton *)denser
{
    if ([denser.titleLabel.text isEqualToString:@"完成"]) {//选择删除
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否删除选中的常用路线" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"保留" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //删除
            [self.dataArray removeObjectsInArray:self.deleteArr];
            //删除服务器内的数据
            [self deleteDataPost];
        }];
        [alertVC addAction:cancel];
        [alertVC addAction:ok];
        [self presentViewController:alertVC animated:YES completion:nil];
      
    }
    
    //支持同时选中多行
    self.managementTableView.allowsMultipleSelectionDuringEditing = YES;
    self.managementTableView.editing = !self.managementTableView.editing;
    
    if (self.managementTableView.editing) {
        self.isDelete = YES;
        [denser setTitle:@"取消" forState:UIControlStateNormal];
    }
    else{
        self.isDelete = NO;
        [denser setTitle:@"删除" forState:UIControlStateNormal];
    }
}

- (void)deleteDataPost
{
    NSString *urlStr = commonaddressdriverdeletePath;
    NSMutableDictionary *deleteDict = [YBTooler dictinitWithMD5];
    [deleteDict setObject:[YBTooler getTheUserId:self.view] forKey:@"userid"];//司机的用户id
    int i = 0;
    NSString *sysno;
    for (NSDictionary *dict in self.deleteArr) {//常用路线的编号
        if (i == 0) {
            sysno = [NSString stringWithFormat:@"%@",dict[@"SysNo"]];
        }
        else {
            sysno = [NSString stringWithFormat:@"%@,%@",sysno,dict[@"SysNo"]];
        }
        i ++;
    }
    [deleteDict setObject:sysno forKey:@"sysno"];

    
    [YBRequest postWithURL:urlStr MutableDict:deleteDict success:^(id dataArray) {
        YBLog(@"%@",dataArray);
        if (self.dataArray) {
            [self.dataArray removeAllObjects];
        }
        self.dataArray = dataArray[@"CommonAddressList"];
        [self.managementTableView reloadData];
    } failure:^(id dataArray) {
        [self.managementTableView reloadData];
    }];
}

- (void)addButtonAction:(UIButton *)sender
{
    YBCommonRouteVC *common = [[YBCommonRouteVC alloc] init];
    [self.navigationController pushViewController:common animated:YES];
}

#pragma mark - TabelViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, YBWidth - 20, 40)];
    [btn setTitle:@"+ 添加常用路线" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:BtnBlueColor];
    btn.layer.cornerRadius = 5;
    [view addSubview:btn];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    YBManagementCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBManagementCell"];
    if (!cell) {
        cell = [[YBManagementCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"YBManagementCell"];
    }
    [cell commonRouteData:self.dataArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark 允许对cell进行编辑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {//删除
        
        //真正项目中做删除
        
        //1.将表中的cell删除
        
        //2.将本地的数组中数据删除
        
        //3.最后将服务器端的数据删除
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isDelete) {//删除状态
        [rigButton setTitle:@"完成" forState:UIControlStateNormal];
        NSArray *subviews = [[tableView cellForRowAtIndexPath:indexPath] subviews];
        for (id subCell in subviews) {
            if ([subCell isKindOfClass:[UIControl class]]) {
                for (UIImageView *circleImage in [subCell subviews]) {
                    circleImage.image = [UIImage imageNamed:@"打钩"];
                }
            }
        }
        [self.deleteArr addObject:[self.dataArray objectAtIndex:indexPath.row]];
    }
    else {
        
    }  
}

//取消选中时 将存放在self.deleteArr中的数据移除
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    YBManagementCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSArray *subviews = cell.subviews;
    for (id subCell in subviews) {
        if ([subCell isKindOfClass:[UIControl class]]) {
            for (UIImageView *circleImage in [subCell subviews]) {
                circleImage.image = [UIImage imageNamed:@"未选择"];
            }
        }
    }
    [self.deleteArr removeObject:[self.dataArray objectAtIndex:indexPath.row]];
    if (self.deleteArr.count == 0) {
        [rigButton setTitle:@"取消" forState:UIControlStateNormal];
    }
}



@end
