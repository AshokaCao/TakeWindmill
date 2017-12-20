//
//  YB4SListViewController.m
//  TakeWindmill
//
//  Created by AshokaCao on 2017/11/17.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YB4SListViewController.h"
#import "LEEStarRating.h"
#import "YBCommentModels.h"
#import "YBTechnicianModel.h"
#import "YBTechnicianProfileCell.h"
#import "YBCommentsViewController.h"
#import "YBWriteCommentViewController.h"

@interface YB4SListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *headerTopView;
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;
@property (weak, nonatomic) IBOutlet UIButton *phoneNumBtn;
@property (weak, nonatomic) IBOutlet UIImageView *commenterheaderImageView;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIView *starView;

@property (weak, nonatomic) IBOutlet UILabel *commentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;
@property (weak, nonatomic) IBOutlet UITableView *shopDetailsTableView;

@property (nonatomic, strong) NSMutableArray *workerArray;
@property (nonatomic, strong) NSMutableArray *dictArray;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSString *mobilNum;
@property (nonatomic, strong) NSString *sysNum;

@end

@implementation YB4SListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"店铺详情";
    [self getShopData];
    
    [self getShopTecherListWithSaynum];
    
}


- (void)getShopData
{
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    dict[@"sysno"] = [NSString stringWithFormat:@"%@",self.shopModel.SysNo];
    
    [YBRequest postWithURL:ShopList MutableDict:dict success:^(id dataArray) {
        NSLog(@"dataArray - - - - %@",dataArray);
        NSDictionary *dic = dataArray;
        NSDictionary *newDic = [NSDictionary changeType:dic];
        YBServiceModels *model = [YBServiceModels new];
        [model setValuesForKeysWithDictionary:newDic];
        [self.addressBtn setTitle:[NSString stringWithFormat:@"%@",model.Address] forState:UIControlStateNormal];
        [self.phoneNumBtn setTitle:[NSString stringWithFormat:@"%@",model.Telephone] forState:UIControlStateNormal];
        self.mobilNum = model.Telephone;
        self.introduceLabel.text = [NSString stringWithFormat:@"%@",model.AbstractContent];
        self.sysNum = model.SysNo;
        [self getShopCommentDetails];
    } failure:^(id dataArray) {
        
    }];
}

- (void)getShopTecherListWithSaynum
{
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    dict[@"shopsysno"] = [NSString stringWithFormat:@"%@",self.shopModel.SysNo];
//    NSLog(@"newDic - - - - %@",dict);
    
    self.dictArray = [NSMutableArray array];
    [YBRequest postWithURL:ShopTecherList MutableDict:dict success:^(id dataArray) {
        NSDictionary *dic = dataArray;
        NSDictionary *newDic = [NSDictionary changeType:dic];
        for (NSDictionary *diction in newDic[@"WorkerInfoList"]) {
            YBTechnicianModel *foldCellModel = [YBTechnicianModel modelWithDic:diction];
            [self.dictArray addObject:foldCellModel];
        }
        [self.shopDetailsTableView reloadData];
        NSLog(@"newDic - - - - %@",newDic);
    } failure:^(id dataArray) {
        
    }];
}

- (void)getShopCommentDetails
{
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    dict[@"shopsysno"] = [NSString stringWithFormat:@"%@",self.shopModel.SysNo];
    NSLog(@"newDic - - - - %@",dict);
    
    self.workerArray = [NSMutableArray array];
    [YBRequest postWithURL:ShopCommentDetail MutableDict:dict success:^(id dataArray) {
        NSDictionary *dic = dataArray;
        NSDictionary *newDic = [NSDictionary changeType:dic];
        NSLog(@"newDic - - - - %@",newDic);
        for (NSDictionary *diction in newDic[@"ShopCommentInfoList"]) {
            YBCommentModels *foldCellModel = [YBCommentModels new];
            [foldCellModel setValuesForKeysWithDictionary:diction];
            [self.workerArray addObject:foldCellModel];
        }
        YBCommentModels *foldCellModel = [self.workerArray firstObject];
        [self.commenterheaderImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",foldCellModel.HeadImgUrl]] placeholderImage:[UIImage imageNamed:@"小草"]];
        self.commentLabel.text = [NSString stringWithFormat:@"%@",foldCellModel.CommnentContent];
        self.commentTimeLabel.text = [NSString stringWithFormat:@"%@",foldCellModel.AddTime];
        [self addStarCountWithCount:foldCellModel.Stars andEnable:NO];
        NSLog(@"newDic - - - - %@",self.dictArray);
    } failure:^(id dataArray) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dictArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    YBTechnicianModel *didSelectFoldCellModel = self.dictArray[indexPath.row];
    YBTechnicianProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBTechnicianProfileCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YBTechnicianProfileCell" owner:nil options:nil] firstObject];
    }
    //        tableView.rowHeight = 300;
    //        cell.phoneNumLabel.text = didSelectFoldCellModel.PhoneNum;
    //        cell.easyInstall.text = didSelectFoldCellModel.JobIntrduction;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell showListWIthModel:didSelectFoldCellModel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBTechnicianModel *didSelectFoldCellModel = self.dictArray[indexPath.row];
    if (_webView == nil) {
        
        _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        
    }
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",didSelectFoldCellModel.PhoneNum]]]];
    NSLog(@"didSelectFoldCellModel.PhoneNum - %@",didSelectFoldCellModel.PhoneNum);
}

- (IBAction)rightCommentAction:(UIButton *)sender {
    [MBProgressHUD showError:@"需拨打电话后才能评论成功" toView:self.view];
    YBWriteCommentViewController *donati = [YBWriteCommentViewController new];
    donati.sysNum = self.sysNum;
    donati.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:donati animated:YES completion:nil];
    
}
- (IBAction)moreCommentAction:(UIButton *)sender {
    YBCommentsViewController *comment = [YBCommentsViewController new];
    
    comment.shopModel = self.shopModel;
    [self.navigationController pushViewController:comment animated:YES];
}
- (IBAction)callShopAction:(UIButton *)sender {
    if (_webView == nil) {
        
        _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        
    }
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.mobilNum]]]];
    NSLog(@"didSelectFoldCellModel.PhoneNum - %@",self.mobilNum);
    
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    NSString *userID = [YBUserDefaults valueForKey:_userId];
    dict[@"userid"] = userID;
    dict[@"dialphone"] = self.mobilNum;
    [YBRequest postWithURL:CallShop MutableDict:dict success:^(id dataArray) {
        
        NSLog(@"comment - %@",dataArray);
    } failure:^(id dataArray) {
        
    }];
}

- (void)addStarCountWithCount:(NSString *)count andEnable:(BOOL )enable
{
    LEEStarRating *ratingView = [[LEEStarRating alloc] initWithFrame:CGRectMake(0, 0, 80, 20) Count:5]; //初始化并设置frame和个数
    
    ratingView.spacing = 1.0f; //间距
    ratingView.checkedImage = [UIImage imageNamed:@"star_orange"]; //选中图片
    ratingView.uncheckedImage = [UIImage imageNamed:@"game_evaluate_gray"]; //未选中图片
    ratingView.type = RatingTypeWhole; //评分类型
    ratingView.touchEnabled = enable; //是否启用点击评分 如果纯为展示则不需要设置
    ratingView.slideEnabled = NO; //是否启用滑动评分 如果纯为展示则不需要设置
    ratingView.maximumScore = 5.0f; //最大分数
    ratingView.minimumScore = 0.0f; //最小分数
    ratingView.currentScore = [count intValue];
    [self.starView addSubview:ratingView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
