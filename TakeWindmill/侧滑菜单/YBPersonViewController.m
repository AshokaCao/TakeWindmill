//
//  YBPersonViewController.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/7.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBPersonViewController.h"
#import "YBCommenItem.h"
#import "YBProfileCell.h"

#import "YBStrokeVC.h"
#import "YBBusinessCardVC.h"
#import "YBSettingVC.h"
#import "YBRedEnvelopesViewController.h"
#import "YBUserListModel.h"
#import "YBUserInfoVC.h"
#import "YBWebViewVC.h"

@interface YBPersonViewController ()<UITableViewDelegate, UITableViewDataSource>

/** tableView */
@property (nonatomic, weak) UITableView *tableView;
/** data */
@property (nonatomic, strong) NSArray *data;


@property (nonatomic, strong) YBUserListModel *userModel;
/** 头像图片 */
@property (nonatomic, strong) UIImageView *headerIcon;
//姓名
@property (nonatomic, strong) UILabel *nameLabel;
//会员级别
@property (nonatomic, strong) UILabel *levelLabel;


@end

@implementation YBPersonViewController


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPersonreloadData object:nil];
}

- (NSArray *)data {
    if (!_data) {
        self.data = [NSArray array];
    }
    return _data;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self getUserListAction];
    
    [self setupData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(personreloadData:) name:kPersonreloadData object:nil];
}
#pragma mark kPersonreloadData  notification
- (void)personreloadData:(NSNotification *)notification{
    [self getUserListAction];
}
- (void)getUserListAction
{
    WEAK_SELF;
    
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    NSString *userID = [YBUserDefaults valueForKey:_userId];
    dict[@"userid"] = userID;
    //    NSLog(@"dict - %@",dict);
    
    [YBRequest postWithURL:UserList MutableDict:dict success:^(id dataArray) {
        NSLog(@"dataArray - %@",dataArray);
        NSDictionary *dic = dataArray;
        NSDictionary *newDic = [NSDictionary changeType:dic];
        YBUserListModel *userModel = [YBUserListModel modelWithDic:newDic];
        weakSelf.userModel = userModel;
       
        [weakSelf.headerIcon sd_setImageWithURL:[NSURL URLWithString:userModel.HeadImgUrl] placeholderImage:[UIImage imageNamed:@"avatar_login"]];
        weakSelf.nameLabel.text = userModel.NickName;
       // weakSelf.levelLabel.text = @"";
    } failure:^(id dataArray) {
        
    }];
}
- (void)setupData {
    YBCommenItem *myWallet = [YBCommenItem itemWithIcon:@"行程" title:@"行程" subtitle:@"" destVcClass:nil];
    
    YBCommenItem *myCoupon = [YBCommenItem itemWithIcon:@"钱包" title:@"钱包" subtitle:@"" destVcClass:nil];
    
    YBCommenItem *myTrip = [YBCommenItem itemWithIcon:@"客服" title:@"客服" subtitle:nil destVcClass:nil];
    
    YBCommenItem *myFriend = [YBCommenItem itemWithIcon:@"名片" title:@"名片" subtitle:nil destVcClass:nil];
    
    YBCommenItem *mySticker = [YBCommenItem itemWithIcon:@"设置-1" title:@"设置" subtitle:nil destVcClass:nil];
    self.data = @[myWallet, myCoupon, myTrip, myFriend, mySticker];
}

- (void)setupUI {
    CGFloat width = self.view.width-self.slideMenuController.contentViewVisibleWidth;
    CGFloat headerViewH = 200;
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = self.view.bounds;
    tableView.scrollEnabled = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tableView];
    self.tableView = tableView;

    
    //头部视图
    UIView *headerView = [[UIView alloc] init];
    headerView.userInteractionEnabled = YES;
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.frame = CGRectMake(0, 0, width, headerViewH);
    self.tableView.tableHeaderView = headerView;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userInfoTap)];
    [headerView addGestureRecognizer:tap];
    

    
    /** 头像图片 */
    UIImageView *headerIcon = [[UIImageView alloc] init];
    headerIcon.image = [UIImage imageNamed:@"avatar_login"];
    headerIcon.frame = CGRectMake(width/2-36, 39 , 72, 72);
    headerIcon.layer.cornerRadius = headerIcon.bounds.size.width / 2;
    headerIcon.clipsToBounds = YES;
    [headerView addSubview:headerIcon];
    self.headerIcon = headerIcon;
    
    //姓名
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"木星";
    nameLabel.frame = CGRectMake(0,  CGRectGetMaxY(headerIcon.frame)+10, width, 20);
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = YBFont(16);
    [headerView addSubview:nameLabel];
    self.nameLabel = nameLabel;
 
    
    //会员级别
    UILabel *levelLabel = [[UILabel alloc] init];
    levelLabel.text = @"普通会员";
    levelLabel.frame = CGRectMake(0, CGRectGetMaxY(nameLabel.frame)+5, width, 20);
    levelLabel.textAlignment = NSTextAlignmentCenter;
    levelLabel.font = YBFont(13);
    levelLabel.textColor = [UIColor lightGrayColor];
    [headerView addSubview:levelLabel];
    self.levelLabel = levelLabel;
    
    
    
   
    //尾部视图
//    UIView *footerView = [[UIView alloc] init];
//    footerView.frame = CGRectMake(0, 0, width, 60);
//    self.tableView.tableFooterView = footerView;
    
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor whiteColor];
    footerView.frame = CGRectMake(0, self.view.height-100, width, 100);
    [self.view addSubview:footerView];
    
    NSArray *btnNameArray = @[@"积分商城",@"推荐有奖",@"车主招募"];
    
    CGFloat btnWidth = 50;
    CGFloat space = (width-btnWidth*3)/4;
    CGFloat labelY = btnWidth+10;
    CGFloat labelW = width/3;
    
    for (int i =0; i<3; i++) {
        UIImageView *imageV = [[UIImageView alloc]init];
        imageV.image = [UIImage imageNamed:btnNameArray[i]];
        imageV.frame = CGRectMake(btnWidth*i+space*(i+1), 0, btnWidth, btnWidth);
        [footerView addSubview:imageV];
        
        UILabel * label = [[UILabel alloc]init];
        label.textColor = [UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = YBFont(14);
        label.frame = CGRectMake(btnWidth*i+space*(i+1), labelY, labelW, 20);
        label.centerX = imageV.centerX;
        label.text = btnNameArray[i];
        [footerView addSubview:label];
        
        if (i != 1) {
            imageV.hidden = YES;
            label.hidden = YES;
        }else{
             imageV.image = [UIImage imageNamed:btnNameArray[2]];
            imageV.userInteractionEnabled = YES;
            
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageVTap)];
            [imageV addGestureRecognizer:tap];
        }
    }
    
}
-(void)imageVTap{
    YBWebViewVC * vc = [[YBWebViewVC alloc]init];
    vc.urlString = DistributionHtml;
    vc.title = @"分销提成";
    [self.slideMenuController showViewController:vc];
}

-(void)userInfoTap{
    YBUserInfoVC *vc = [YBUserInfoVC new];
    
    [self.slideMenuController showViewController:vc];
}

#pragma mark - TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    // 创建cell
    YBProfileCell *cell = [YBProfileCell cellWithTableView:tableView];
    cell.item = self.data[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        YBStrokeVC * vc = [[YBStrokeVC alloc]init];
        [self.slideMenuController showViewController:vc];
        
    } else if (indexPath.row == 1) {
        YBRedEnvelopesViewController * vc = [[YBRedEnvelopesViewController alloc]init];
        [self.slideMenuController showViewController:vc];
        
    }else if (indexPath.row == 2) {
        
    }else if (indexPath.row == 3) {
        YBBusinessCardVC * vc = [[YBBusinessCardVC alloc]init];
        [self.slideMenuController showViewController:vc];
    }else if (indexPath.row == 4) {
        YBSettingVC * vc = [[YBSettingVC alloc]init];
        [self.slideMenuController showViewController:vc];
    }
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
