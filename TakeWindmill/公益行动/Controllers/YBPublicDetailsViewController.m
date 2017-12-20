//
//  YBPublicDetailsViewController.m
//  TakeWindmill
//
//  Created by AshokaCao on 2017/11/22.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBPublicDetailsViewController.h"
#import "YBLoverCommentViewController.h"
#import "YBPublicListTableModel.h"
#import "YBDonationViewController.h"
#import "YBListWebTableViewCell.h"
#import "YBCommentModels.h"

@interface YBPublicDetailsViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIView *contView;

@property (weak, nonatomic) IBOutlet UIProgressView *proporView;
@property (weak, nonatomic) IBOutlet UILabel *proporLabel;
@property (nonatomic, assign) CGFloat height;
/**
 用户捐款
 */
@property (weak, nonatomic) IBOutlet UILabel *peopleDonationsMoneyLabel;

/**
 目标
 */
@property (weak, nonatomic) IBOutlet UILabel *targetMoneyLabel;

/**
 爱心份数
 */
@property (weak, nonatomic) IBOutlet UILabel *loverCountLabel;
@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet UILabel *noComment;

@property (weak, nonatomic) IBOutlet UILabel *firstDonationerLabel;
@property (weak, nonatomic) IBOutlet UILabel *secDonationerLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeDonationerLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *secTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *easyIntroduce;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewheight;
@property (weak, nonatomic) IBOutlet UIWebView *listWebView;
@property (nonatomic, strong) NSMutableArray *listTableData;
@property (nonatomic, strong) NSMutableArray *commentArray;

@end

@implementation YBPublicDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getPublicList];
    self.title = @"公益详情";
}

- (void)getPublicList
{
    self.listTableData = [NSMutableArray array];
    self.commentArray = [NSMutableArray array];
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    dict[@"sysno"] = self.sysNum;
    [YBRequest postWithURL:PublicList MutableDict:dict success:^(id dataArray) {
        NSDictionary *dict = dataArray;
        YBPublicListTableModel *model = [YBPublicListTableModel new];
        [model setValuesForKeysWithDictionary:dict];
        [self.listTableData addObject:model];
        [self showPublicDetailsWith:model];
        for (NSDictionary *diction in dict[@"ContributeInfoList"]) {
            YBCommentModels *model = [YBCommentModels new];
            [model setValuesForKeysWithDictionary:diction];
            [self.commentArray addObject:model];
        }
        [self commentDeatils];
        NSLog(@"PublicList - - %@",dataArray);
    } failure:^(id dataArray) {
        NSLog(@"--- %@",dataArray);
    }];
}

- (void)loverAction:(UIButton *)sender
{
    YBPublicListTableModel *model = [self.listTableData firstObject];
    YBLoverCommentViewController *lover = [YBLoverCommentViewController new];
    lover.sysNum = model.SysNo;
    [self.navigationController pushViewController:lover animated:YES];
}

- (IBAction)donationAction:(UIButton *)sender {
    YBDonationViewController *donati = [YBDonationViewController new];
    donati.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:donati animated:YES completion:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    float height = [[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollHeight"]floatValue]; //此方法获取webview的内容高度（建议使用）
//    NSLog(@"height - %f",height);
    self.scrollViewheight.constant = 490 + height + 60;
    UIView *loverView = [[UIView alloc] initWithFrame:CGRectMake(0, 490 + height, YBWidth, 40)];
    loverView.backgroundColor = [UIColor grayColor];
    UIButton *Evaluation = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, YBWidth, 40)];
    [Evaluation addTarget:self action:@selector(loverAction:) forControlEvents:UIControlEventTouchUpInside];
    [Evaluation setTitle:@"爱心留言" forState:UIControlStateNormal];
    [Evaluation setTitleColor:BtnBlueColor forState:UIControlStateNormal];
    [loverView addSubview:Evaluation];
    [self.contView addSubview:loverView];
}

- (void)showPublicDetailsWith:(YBPublicListTableModel *)model
{
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.PicUrl] placeholderImage:[UIImage imageNamed:@"公益"]];
    self.targetMoneyLabel.text = [NSString stringWithFormat:@"%@",model.ContributeMoney];
    self.loverCountLabel.text = [NSString stringWithFormat:@"%@",model.ContributePeapleNumber];
    self.easyIntroduce.text = [NSString stringWithFormat:@"%@",model.SubTitle];
    self.peopleDonationsMoneyLabel.text = [NSString stringWithFormat:@"%@",model.RealContributeMoney];
    
    CGFloat propor = (CGFloat )[model.RealContributeMoney integerValue] / [model.ContributeMoney integerValue];
    self.proporView.progress = propor;
    self.proporLabel.text = [NSString stringWithFormat:@"%.2f%%",propor * 100];
    NSString *introduce = [NSString stringWithFormat:@"%@",model.Introduce];
    NSLog(@"introduce - %@",introduce);
    introduce = [introduce stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    [self.listWebView loadHTMLString:introduce baseURL:nil];
}

- (void)commentDeatils
{
    NSArray *commenterArray = @[self.firstDonationerLabel,self.secDonationerLabel,self.threeDonationerLabel];
    NSArray *timeArray = @[self.firstTimeLabel,self.secTimeLabel,self.threeTimeLabel];
    if (self.commentArray.count >= 3) {
        [self.noComment removeFromSuperview];
        for (int i = 0; i < commenterArray.count; i++) {
            YBCommentModels *model = self.commentArray[i];
            UILabel *comment = commenterArray[i];
            UILabel *time = timeArray[i];
            comment.text = [NSString stringWithFormat:@"%@ 捐款%@元",model.NickName,model.ContributeMoney];
            time.text = model.ContributeTimeStr;
        }
    } else {
        for (int i = 0; i < commenterArray.count; i++) {
            UILabel *comment = commenterArray[i];
            UILabel *time = timeArray[i];
            [comment removeFromSuperview];
            [time removeFromSuperview];
        }
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
