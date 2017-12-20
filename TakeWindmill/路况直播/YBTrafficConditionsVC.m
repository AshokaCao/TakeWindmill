//
//  YBTrafficConditionsVC.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/10.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBTrafficConditionsVC.h"
#import "YBTextField.h"
#import "YBTrafficTableViewCell.h"
#import "YBLiveViewController.h"
#import "YBPublishedRoadVC.h"
#import "YBPeripheryViewController.h"

//#import "YBRoadNewModel.h"
#import "YBRoadTableViewCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"


#define kDemoVC9CellId @"demovc9cell"

@interface YBTrafficConditionsVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, weak) UITableView *trafficTabelView;

@property (nonatomic, strong) UIView *headView;

@property (nonatomic, strong) NSMutableArray *roadListArray;

@end

@implementation YBTrafficConditionsVC

#pragma mark - lazy
-(UITableView *)trafficTabelView {
    if (!_trafficTabelView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, YBWidth, YBHeight - 40) style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 230;
        tableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:tableView];
        _trafficTabelView = tableView;
    }
    return _trafficTabelView;
}

//头部视图
- (UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc] init];
        _headView.frame = CGRectMake(0, 0, YBWidth, 40);
        _headView.backgroundColor = [UIColor whiteColor];
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, YBWidth, 40)];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        [_headView addSubview:scrollView];
        
        [self headScrollView:scrollView];
        [self.view addSubview:_headView];
    }
    return _headView;
}

- (void)headScrollView:(UIScrollView *)scrollView {

    //录像
    UIButton *videoBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 25, 20)];
    [videoBtn setBackgroundImage:[UIImage imageNamed:@"视频"] forState:UIControlStateNormal];
    [scrollView addSubview:videoBtn];
    
    //相机
    UIButton *photoBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(videoBtn.frame) + 10, 10, 25, 20)];
    [photoBtn setBackgroundImage:[UIImage imageNamed:@"相机"] forState:UIControlStateNormal];
    [photoBtn addTarget:self action:@selector(photoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:photoBtn];
    
    //城市
    UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(photoBtn.frame) + 10, 10, 40, 20)];
    cityLabel.text = @"城市";
    cityLabel.textAlignment = NSTextAlignmentCenter;
    cityLabel.font = YBFont(12);
    cityLabel.layer.cornerRadius = 10;
    cityLabel.layer.borderWidth = 1;
    cityLabel.layer.borderColor = LightGreyColor.CGColor;
    [scrollView addSubview:cityLabel];
    
    YBTextField *cityText = [YBTextField TextFieldFrame:CGRectMake(CGRectGetMaxX(cityLabel.frame) + 10, 10, 60, 20) Style:UITextBorderStyleNone placeholder:@"例:杭州" Textfont:YBFont(12) textColor:[UIColor blackColor] TextEntry:NO FitWidth:YES cornerRadius:10 borderWidth:1 borderColor:LightGreyColor];
    cityText.delegate = self;
    [scrollView addSubview:cityText];
    
    //道路
    UILabel *roadLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cityText.frame) + 10, 10, 80, 20)];
    roadLabel.text = @"道路/地名";
    roadLabel.font = YBFont(12);
    roadLabel.textAlignment = NSTextAlignmentCenter;
    roadLabel.layer.cornerRadius = 10;
    roadLabel.layer.borderWidth = 1;
    roadLabel.layer.borderColor = LightGreyColor.CGColor;
    [scrollView addSubview:roadLabel];

     YBTextField *roadText = [YBTextField TextFieldFrame:CGRectMake(CGRectGetMaxX(roadLabel.frame) + 10, 10, 80, 20) Style:UITextBorderStyleNone placeholder:@"例:颐高广场" Textfont:YBFont(12) textColor:[UIColor blackColor] TextEntry:NO FitWidth:YES cornerRadius:10 borderWidth:1 borderColor:LightGreyColor];
    roadText.delegate = self;
    [scrollView addSubview:roadText];
    
    //周边
    UIButton *cityBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(roadText.frame) + 10, 10, 80, 20)];
    [cityBtn setTitle:@"我周边的路况" forState:UIControlStateNormal];
    [cityBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cityBtn addTarget:self action:@selector(cityButton:) forControlEvents:UIControlEventTouchUpInside];
    cityBtn.titleLabel.font = YBFont(12);
    [scrollView addSubview:cityBtn];

    scrollView.contentSize =  CGSizeMake(CGRectGetMaxX(cityBtn.frame) + 10, 40);
}

- (void)cityButton:(UIButton *)sender {
    YBPeripheryViewController *perihe = [[YBPeripheryViewController alloc] init];
    [self.navigationController pushViewController:perihe animated:YES];
}

- (void)photoButtonAction:(UIButton *)sender {
    YBPublishedRoadVC *published = [[YBPublishedRoadVC alloc] init];
    [self.navigationController pushViewController:published animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"路况直播";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self headView];
    [self trafficTabelView];
    
    [self.trafficTabelView registerClass:[YBRoadTableViewCell class] forCellReuseIdentifier:kDemoVC9CellId];
    
    
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    [YBRequest postWithURL:RoadListPath MutableDict:dict success:^(id dataArray) {
        
//        dispatch_sync(dispatch_get_main_queue(), ^{
            self.roadListArray = [NSMutableArray array];
            NSDictionary *dic = dataArray;
            NSDictionary *newDic = [NSDictionary changeType:dic];
            //        YBLog(@"newDic - %@",newDic);
            for (YBRoadNowModel *model in newDic[@"RoadConditionList"]) {
                [self.roadListArray addObject:model];
            }
            [self.trafficTabelView reloadData];
//        });
        YBLog(@"roadListArray - %@",self.roadListArray);
        
    } failure:^(id dataArray) {
        
    }];
    
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YBRoadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDemoVC9CellId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.indexPath = indexPath;
//    __weak typeof(self) weakSelf = self;
//    if (!cell.moreButtonClickedBlock) {
//        [cell setMoreButtonClickedBlock:^(NSIndexPath *indexPath) {
//            YBRoadNowModel *model = weakSelf.roadListArray[indexPath.row];
//            model.isOpening = !model.isOpening;
//            [weakSelf.trafficTabelView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        }];
//    }
//    [cell setIsLikedButtonClickedBlock:^(NSIndexPath *indexPath) {
//        YBRoadNowModel *model = weakSelf.roadListArray[indexPath.row];
////        NSLog(@"%ld",model.sidx);
////        [self setLikedBtnWithFoundID:model.sidx];
////        [self setFoundList];
//    }];
//    cell.model = self.roadListArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
    
    id model = self.roadListArray[indexPath.row];
    return [self.trafficTabelView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[YBRoadTableViewCell class] contentViewWidth:[self cellContentViewWith]];
}




- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YBLiveViewController *live = [[YBLiveViewController alloc] init];
    [self.navigationController pushViewController:live animated:YES];
}

#pragma mark -textField
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

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
