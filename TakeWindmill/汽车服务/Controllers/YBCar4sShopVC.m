//
//  YBCar4sShopVC.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/16.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBCar4sShopVC.h"

#import "YBCarShopCell.h"
#import "YBCarShopEvaluationCell.h"
#import "YBCarShopIntroductionCell.h"
#import "YBTechnicianCell.h"
#import "YBTechnicianProfileCell.h"

#import "YBTechnicianModel.h"

@interface YBCar4sShopVC ()<UITableViewDelegate,UITableViewDataSource>
//内容
@property (nonatomic, strong) NSMutableArray *dictArray;

@property (nonatomic, weak) UITableView *carTableView;
//
@property (nonatomic, strong) NSMutableArray *workerArray;


@end

@implementation YBCar4sShopVC

- (UITableView *)carTableView {
    if (!_carTableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, YBWidth, YBHeight ) style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.backgroundColor = LightGreyColor;
        [self.view addSubview:tableView];
        _carTableView = tableView;
    }
    return _carTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getShopData];
    
    [self getShopTecherListWithSaynum];
    
    self.title = @"嘉兴宝利德奔驰4s店";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //数据数组
//    NSArray *netData = @[
//                         @{@"name":@"刘师傅",@"Introduction":@[@{@"content":@"从业三十年",@"phone":@"123156765434"}]},
//                         @{@"name":@"刘师傅",@"Introduction":@[@{@"content":@"从业三十年",@"phone":@"123156765434"}]},
//                         @{@"name":@"刘师傅",@"Introduction":@[@{@"content":@"从业三十年",@"phone":@"123156765434"}]}];
    //模型数组
    //    self.dictArray = [NSMutableArray array];
    //    for (int i = 0; i < netData.count; i++) {
    //        YBTechnicianModel *foldCellModel = [YBTechnicianModel modelWithDic:netData[i]];
    //        [self.dictArray addObject:foldCellModel];
    //    }
    
    [self carTableView];
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
        
    } failure:^(id dataArray) {
        
    }];
}

- (void)getShopTecherListWithSaynum
{
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    dict[@"shopsysno"] = [NSString stringWithFormat:@"%@",self.shopModel.SysNo];
    NSLog(@"newDic - - - - %@",dict);
    
    self.workerArray = [NSMutableArray array];
    self.dictArray = [NSMutableArray array];
    [YBRequest postWithURL:ShopTecherList MutableDict:dict success:^(id dataArray) {
        NSDictionary *dic = dataArray;
        NSDictionary *newDic = [NSDictionary changeType:dic];
        for (NSDictionary *diction in newDic[@"WorkerInfoList"]) {
            YBTechnicianModel *foldCellModel = [YBTechnicianModel modelWithDic:diction];
            [self.dictArray addObject:foldCellModel];
        }
        [self.carTableView reloadData];
        NSLog(@"newDic - - - - %@",newDic);
    } failure:^(id dataArray) {
        
    }];
}

#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    else if (section == 1) {
        return 1;
        
    }
    else if (section == 2) {
        return 1;
        
    }
    return self.dictArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 100;
    }
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 40;
    }
    else if (indexPath.section == 1) {
        return 120;
        
    }
    else if (indexPath.section == 2) {
        return 110;
        
    } else {
        return 150;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIImageView *storefrontImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, YBWidth, 100)];
        storefrontImage.image = [UIImage imageNamed:@"首页4_01"];
        return storefrontImage;
    }
    else if (section == 1) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 20, 20)];
        imageView.image = [UIImage imageNamed:@"汽车点评论"];
        [view addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 10, 10, 50, 20)];
        label.text = @"评论";
        label.font = YBFont(14);
        [view addSubview:label];
        
        CGFloat imageWH = 20;
        for (int i = 0; i < 5; i ++) {
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame) + 10 + i * (imageWH + 5), 10, imageWH, imageWH)];
            if (i > 3) {
                image.image = [UIImage imageNamed:@"b27_icon_star_gray"];
            }else {
                image.image = [UIImage imageNamed:@"b27_icon_star_yellow"];
            }
            [view addSubview:image];
        }
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(YBWidth - 80, 10, 60, 20)];
        [btn setTitle:@"写评论" forState:UIControlStateNormal];
        [btn setBackgroundColor:BtnBlueColor];
        btn.titleLabel.font = YBFont(14);
        [view addSubview:btn];
        
        return view;
    }
    else if (section == 2) {
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 20, 20)];
        imageView.image = [UIImage imageNamed:@"汽车点简介"];
        [view addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 10, 10, 50, 20)];
        label.text = @"简介";
        label.font = YBFont(14);
        [view addSubview:label];
        
        return view;
    }
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 20, 20)];
    imageView.image = [UIImage imageNamed:@"技师"];
    [view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 10, 10, 50, 20)];
    label.text = @"技师";
    label.font = YBFont(15);
    [view addSubview:label];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {//
        YBCarShopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBCarShopCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"YBCarShopCell" owner:nil options:nil] firstObject];
        }
        if (indexPath.row == 1) {
            cell.iconImageView.image = [UIImage imageNamed:@"汽车电话"];
            cell.contentLabel.text = @"(0573)2222222222222222";
        }
        return cell;
    }
    else if (indexPath.section == 1){
        YBCarShopEvaluationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBCarShopEvaluationCell"];
        if (!cell) {
            cell = [[YBCarShopEvaluationCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"YBCarShopEvaluationCell"];
        }
        return cell;
    }
    else if (indexPath.section == 2){
        YBCarShopIntroductionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBCarShopIntroductionCell"];
        if (!cell) {
            cell = [[YBCarShopIntroductionCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"YBCarShopIntroductionCell"];
        }
        return cell;
    } else {
        
        YBTechnicianModel *didSelectFoldCellModel = self.dictArray[indexPath.row];
        YBTechnicianProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBTechnicianProfileCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"YBTechnicianProfileCell" owner:nil options:nil] firstObject];
        }
//        tableView.rowHeight = 300;
//        cell.phoneNumLabel.text = didSelectFoldCellModel.PhoneNum;
//        cell.easyInstall.text = didSelectFoldCellModel.JobIntrduction;
        [cell showListWIthModel:didSelectFoldCellModel];
        cell.userInteractionEnabled = NO;
        
        return cell;
    }
    
//    if (didSelectFoldCellModel.isUnfolded == 0) {
//        YBTechnicianCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBTechnicianCell"];
//        if (!cell) {
//            cell = [[YBTechnicianCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"YBTechnicianCell"];
//        }
//        cell.technicianLabel.text = didSelectFoldCellModel.WorkerName;
//        NSLog(@"didSelectFoldCellModel.Experience - %@",didSelectFoldCellModel.Experience);
//        cell.yearsLabel.text = didSelectFoldCellModel.Experience;
//        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:didSelectFoldCellModel.WorkerPhotoUrl]];
//        return cell;
//    }else {
//    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 3) {
        YBTechnicianModel *didSelectFoldCellModel = self.dictArray[indexPath.row];
        
        if (didSelectFoldCellModel.isUnfolded == 0) {//展开
            
            //Data
            NSArray *submodels = [didSelectFoldCellModel open];
            NSLog(@"submodels - %@",submodels);
            NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:((NSRange){indexPath.row + 1,submodels.count})];
            
            [self.dictArray insertObjects:submodels atIndexes:indexes];
            
            //Rows
            NSMutableArray *indexPaths = [NSMutableArray new];
            for (int i = 0; i < submodels.count; i++) {
                NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:(indexPath.row + 1 + i) inSection:indexPath.section];
                [indexPaths addObject:insertIndexPath];
            }
            [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            
        }else {//收回
            
            //Data
            NSArray *submodels = [self.dictArray subarrayWithRange:((NSRange){indexPath.row + 1,1})];
            [didSelectFoldCellModel closeWithSubmodels:submodels];
            [self.dictArray removeObjectsInArray:submodels];
            
            //Rows
            NSMutableArray *indexPaths = [NSMutableArray new];
            for (int i = 0; i < submodels.count; i++) {
                NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:(indexPath.row + 1 + i) inSection:indexPath.section];
                [indexPaths addObject:insertIndexPath];
            }
            [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        }
        [tableView endUpdates];
        
        //        YBTechnicianCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBTechnicianCell"];
        //        if (!cell) {
        //            cell = [[YBTechnicianCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"YBTechnicianCell"];
        //        }
        //        cell.openImage.image = [UIImage imageNamed:@"j箭头"];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end

