//
//  YBGroupHelpVC.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/16.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBGroupHelpVC.h"
#import "YBConversationListVC.h"
#import "YBGroupHelpCell.h"
#import "YBChatVC.h"

@interface YBGroupHelpVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong)  NSMutableDictionary *userIdS;
@property (nonatomic,strong) UIButton *rigButton;

@end

@implementation YBGroupHelpVC

-(UITableView *)tableView{
    if (_tableView == nil) {
        UITableView *_tabV = [[UITableView alloc]init];
        _tabV.backgroundColor = LightGreyColor;
        _tabV.showsVerticalScrollIndicator = NO;
        _tabV.showsHorizontalScrollIndicator = NO;
        //_tabV.scrollEnabled = NO;
        _tabV.delegate = self;
        _tabV.dataSource = self;
        _tableView = _tabV;
        
    }
    return  _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择车主";
    [self setUI];
    self.dataArr = [NSMutableArray array];
    self.userIdS = [NSMutableDictionary dictionary];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self requstData];
}
-(void)requstData{

    NSMutableDictionary *parm = [YBTooler dictinitWithMD5];
    //NSString *userID = [YBUserDefaults valueForKey:_userId];
    //CurrentLng：当前经度，CurrentLat：当前纬度
    parm[@"currentlng"] = [NSString stringWithFormat:@"%f",self.startingPoint.location.longitude];
    parm[@"currentlat"] = [NSString stringWithFormat:@"%f",self.startingPoint.location.latitude];
    
    
     YBLog(@"startingPoint==%f,%f",self.startingPoint.location.longitude,self.startingPoint.location.latitude);
    
    WEAK_SELF;
    [YBRequest postWithURL:DriverhelpDriverhelpnearbydriverlist MutableDict:parm success:^(id dataArray) {
        YBLog(@"dataArray==%@",dataArray);
        YBGroupHelpModel *model = [YBGroupHelpModel yy_modelWithJSON:dataArray];
        weakSelf.dataArr = [NSMutableArray arrayWithArray:model.UserInfoList];
        [weakSelf.tableView reloadData];
        
    } failure:^(id dataArray) {
        //YBLog(@"failureDataArray==%@",dataArray);
        [MBProgressHUD showError:dataArray[@"ErrorMessage"] toView:weakSelf.view];
    }];
    
}
-(void)setUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    //    UIBarButtonItem *
    //    complete = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(completeTap:)];
    //    [complete setTintColor:[UIColor blackColor]];
    //    self.navigationItem.rightBarButtonItem =complete;
    
    UIButton *rigButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    rigButton.titleLabel.font = YBFont(14);
    rigButton.hidden = YES;
    [rigButton setTitle:@"完成" forState:UIControlStateNormal];
    [rigButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rigButton addTarget:self action:@selector(completeTap:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rigButton];
    self.rigButton = rigButton;
    
    
}
#pragma mark - 数据源方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIndentifier =[NSString stringWithFormat:@"cell%ld",indexPath.row];
    YBGroupHelpCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[YBGroupHelpCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //去掉底部多余的表格线
    [tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    if (indexPath.row <_dataArr.count) {
        UserInfoList * userInfoList = self.dataArr[indexPath.row];
        cell.userInfoList = userInfoList;
    }
    if (!self.userIdS.count) {
        cell.check.highlighted = NO;
        cell.check.image = [UIImage imageNamed:@"未选择"];
    }
    
    return cell;
}

#pragma mark - 代理方法
//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return headerH;
}

//头部高度
static CGFloat headerH = 60;
static CGFloat nearH = 40;
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return headerH+nearH;
}

//底部视图高度
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//
//    return 0.001;
//}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == self.tableView) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YBWidth, headerH+nearH)];
        view.backgroundColor = [UIColor whiteColor];
        
        
        UILabel *label = [[UILabel alloc]init];
        //label.textColor = kTextGreyColor;
        label.userInteractionEnabled = YES;
        label.text = [NSString stringWithFormat:@"选择一个群"];
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kpadding);
            make.top.right.equalTo(view);
            make.height.mas_equalTo(headerH);
        }];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detaiTap:)];
        [label addGestureRecognizer:singleTap];
        
        
        UIImageView *imageV = [[UIImageView alloc]init];
        imageV.image = [UIImage imageNamed:@"icon_chose_arrow_nor"];
        [view addSubview:imageV];
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-kpadding);
            make.top.equalTo(@30);
        }];
        
        UILabel *label1 = [[UILabel alloc]init];
        label1.backgroundColor = kTextGreyColor;
        [view addSubview:label1];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(view);
            make.top.equalTo(label.mas_bottom);
            make.height.mas_equalTo(nearH);
        }];
        
        UILabel *near = [[UILabel alloc]init];
        //near.textColor = [UIColor groupTableViewBackgroundColor];
        near.text = [NSString stringWithFormat:@"附近车主"];
        [view addSubview:near];
        [near mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kpadding);
            make.top.equalTo(label.mas_bottom);
            make.height.mas_equalTo(nearH);
        }];
        return view;
    }
    return nil;
}
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//
//    return nil;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //WEAK_SELF;
    YBGroupHelpCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.check.highlighted =  !cell.check.highlighted;
    if (cell.check.highlighted) {
        cell.check.image = [UIImage imageNamed:@"打钩"];
        [self.userIdS setObject:cell.textLabel.text forKey:cell.textLabel.text];
    }else{
        cell.check.image = [UIImage imageNamed:@"未选择"];
        [self.userIdS removeObjectForKey:cell.textLabel.text];
    }
    
    self.rigButton.hidden = self.userIdS.count>0 ? NO : YES;
    
}

-(void)detaiTap:(UITapGestureRecognizer *)sender{
    YBConversationListVC *vc = [[YBConversationListVC alloc]init];
    [self.navigationController pushViewController:vc animated:NO];
    
    if (self.userIdS.count) {
        [self.userIdS removeAllObjects];
        self.rigButton.hidden = YES;
    }
}
//completeTap
-(void)completeTap:(UIButton *)sender{
    /**
     *  创建讨论组
     */
    NSMutableArray *IDS = [[NSMutableArray alloc]init];
    [IDS addObjectsFromArray:[self.userIdS allValues]];
    if (![IDS containsObject:[RCIM sharedRCIM].currentUserInfo.userId]) {
        [IDS addObject:[RCIM sharedRCIM].currentUserInfo.userId];
    }
    WEAK_SELF;
    [[RCIMClient sharedRCIMClient] createDiscussion:@"我的讨论组" userIdList:IDS success:^(RCDiscussion *discussion) {
        //NSLog(@"success  %@",discussion.discussionName);
        //NSLog(@"%@",discussion.discussionId);
        weakSelf.discussionId = discussion.discussionId;
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            //[MBProgressHUD showError:@"成功加入讨论组" toView:weakSelf.view];
            YBChatVC *vc = [[YBChatVC alloc]init];
            vc.conversationType = ConversationType_DISCUSSION;
            vc.targetId = discussion.discussionId;
            [weakSelf.navigationController pushViewController:vc animated:NO];
            [weakSelf.userIdS removeAllObjects];
            weakSelf.rigButton.hidden = YES;
        });
        
    } error:^(RCErrorCode status) {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [MBProgressHUD showError:@"创建讨论组失败" toView:weakSelf.view];
        });
        NSLog(@"faild %ld",status);
        
    }];

}
/**
 *  讨论组加人
 */
-(void)addMemberAction:(UIButton *)sender{
    if (self.discussionId) {
        NSMutableArray *IDS = [[NSMutableArray alloc]init];
        
        [IDS addObject:@"A651B4968A96438F924A4F7139687C1F"];
        //8FA57A8A259E42EB95766C7E04E3BC1A
        [IDS addObject:@"8FA57A8A259E42EB95766C7E04E3BC1A"];
        
        [[RCIMClient sharedRCIMClient] addMemberToDiscussion:self.discussionId userIdList:IDS success:^(RCDiscussion *discussion) {
            NSLog(@"%@",discussion.discussionName);
            
        } error:^(RCErrorCode status) {
            
            NSLog(@"加入讨论组失败%ld",status);
        }];
        
    }else{
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            [WMUtil showTipsWithHUD:@"请先创建讨论组"];
        //        });
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
