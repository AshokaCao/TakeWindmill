//
//  YBStrokeVC.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/12/11.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBStrokeVC.h"
#import "YBEvaluationDriverVC.h"

#import "YBStrokeModel.h"

#import "YBStrokeCell.h"

@interface YBStrokeVC ()

/**
 * 当前页面
 */
@property (nonatomic,assign) int pageIndex;

/**
 * 我的行程数据
 */
@property (nonatomic,strong) NSMutableArray *itineraryArray;

@end

@implementation YBStrokeVC

#pragma mark - lazy
- (NSMutableArray *)itineraryArray
{
    if (!_itineraryArray) {
        _itineraryArray = [NSMutableArray array];
    }
    return _itineraryArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"我的行程";
    self.pageIndex = 1;
    //请求数据
    [self myItinerary];
    WEAK_SELF;
    //下拉刷新
    self.tableView.mj_header =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //需要将页码设置为1
        weakSelf.pageIndex = 1;
        [weakSelf.itineraryArray removeAllObjects];
        [weakSelf myItinerary];
    }];

    //上啦加载
    self.tableView.mj_footer =  [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //页码
        [weakSelf myItinerary];
        weakSelf.pageIndex ++;
    }];

    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, kpadding, 0, kpadding));
    }];
}


#pragma mark - 我的行程数据
- (void)myItinerary
{
    WEAK_SELF;
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    [dict setObject:[YBTooler getTheUserId:self.view] forKey:@"userid"];
    [dict setObject:[NSString stringWithFormat:@"%d",_pageIndex] forKey:@"pageindex"];

    [YBRequest postWithURL:travelinfolistbyuseridPath MutableDict:dict View:self.tableView success:^(id dataArray) {
        YBLog(@"%@",dataArray);
        NSArray *array = dataArray[@"TravelInfoList"];
        if (array.count == 0) {
            [MBProgressHUD showSuccess:@"没有更多的数据了" toView:weakSelf.view];
        }
        for (NSDictionary *dict in array) {
            YBStrokeModel *model = [YBStrokeModel yy_modelWithJSON:dict];
            [weakSelf.itineraryArray addObject:model];
        }
        [weakSelf.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];

    } failure:^(id dataArray) {
        YBLog(@"%@",dataArray);
        [MBProgressHUD showError:dataArray[@"ErrorMessage"] toView:weakSelf.view];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];

    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.itineraryArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * reuseIdentifier = @"reuseIdentifier";
    
    YBStrokeCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[YBStrokeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    cell.model = self.itineraryArray[indexPath.section];
    return cell;
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

//头部高度
static CGFloat headerH = 20;
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return headerH;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == self.tableView) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YBWidth, headerH)];
        view.backgroundColor = LightGreyColor;
        return view;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YBEvaluationDriverVC * vc = [[YBEvaluationDriverVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

//StylePlain (取消粘性效果)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = headerH;
    if(scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0,0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
