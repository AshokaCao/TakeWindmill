//
//  YBPublicActionVC.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/12.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBPublicActionVC.h"
#import "YBMyPublicWelfareVC.h"
#import "YBPublicWelfareVC.h"
#import "YBPublicDetailsViewController.h"
#import "YBMyPublicDetailsViewController.h"
#import "YBPublicTableViewController.h"
#import "YBPublicListTableModel.h"

@interface YBPublicActionVC ()
@property (nonatomic, strong) NSMutableArray *listTableData;
@end

@implementation YBPublicActionVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"公益行动";
    self.view.backgroundColor = [UIColor whiteColor];
    self.mapView.zoomLevel = 6;
    [self getPublicList];
    
}

- (void)getPublicList
{
    self.listTableData = [NSMutableArray array];
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    
    [YBRequest postWithURL:PublicServiceTable MutableDict:dict success:^(id dataArray) {
        NSLog(@"PublicServiceTable - - %@",dataArray);
        NSDictionary *dic = dataArray;
        NSDictionary *newDic = [NSDictionary changeType:dic];
        for (NSDictionary *diction in newDic[@"PublicWelfareList"]) {
            YBPublicListTableModel *model = [YBPublicListTableModel new];
            [model setValuesForKeysWithDictionary:diction];
            [self.listTableData addObject:model];
        }
        
        [self mapViewUIView];
    } failure:^(id dataArray) {
        NSLog(@"error %@",dataArray);
    }];
}

- (void)mapViewUIView
{
    YBBaseButton *myPublicWelfare = [YBBaseButton buttonWithFrame:CGRectMake(0, 20, 90, 20) Strtitle:@"我的公益" titleColor:[UIColor whiteColor] titleFont:12 textAlignment:NSTextAlignmentCenter image:nil BackgroundColor:BtnBlueColor cornerRadius:3];
    [myPublicWelfare addTarget:self action:@selector(myPublicWelfareAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myPublicWelfare];
    
    YBBaseButton *PublicWelfare = [YBBaseButton buttonWithFrame:CGRectMake(0, CGRectGetMaxY(myPublicWelfare.frame) + 10, 90, 20) Strtitle:@"公益行动" titleColor:[UIColor whiteColor] titleFont:12 textAlignment:NSTextAlignmentCenter image:nil BackgroundColor:BtnBlueColor cornerRadius:3];
    [PublicWelfare addTarget:self action:@selector(PublicWelfareAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:PublicWelfare];
    
    for (int i = 0; i < self.listTableData.count; i++) {
        // 添加一个PointAnnotation
        YBPublicListTableModel *model = self.listTableData[i];
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = [model.ActivityLat floatValue];
        coor.longitude = [model.ActivityLng floatValue];
        annotation.title = [NSString stringWithFormat:@"%d",i];
        annotation.coordinate = coor;
        
        [self.mapView addAnnotation:annotation];
    }

}
#pragma mark 公益列表
- (void)PublicWelfareAction:(UIButton *)sender
{
    YBPublicTableViewController *publi = [[YBPublicTableViewController alloc] init];
    [self.navigationController pushViewController:publi animated:YES];
}
#pragma mark 我的公益
- (void)myPublicWelfareAction:(UIButton *)sneder
{
    YBMyPublicDetailsViewController *my = [[YBMyPublicDetailsViewController alloc] init];
    [self.navigationController pushViewController:my animated:YES];
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        //        newAnnotationView.pinColor = BMKPinAnnotationColorRed;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        newAnnotationView.image = [UIImage imageNamed:@"公益行动图标"];
        return newAnnotationView;
    }
    return nil;
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view;
{
    if ([view.annotation isKindOfClass:[BMKPointAnnotation class]]) {
        int num = [view.annotation.title intValue];
        YBPublicListTableModel *model = self.listTableData[num];
        YBPublicDetailsViewController *car = [[YBPublicDetailsViewController alloc] init];
        car.sysNum = model.SysNo;
        [self.navigationController pushViewController:car animated:YES];
    }
    [mapView deselectAnnotation:view.annotation animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
