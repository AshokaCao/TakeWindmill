//
//  YBSlideTabView.h
//  TakeWindmill
//
//  Created by HUSHOUHUA华 on 2017/11/16.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBRegisteredModel.h"
@protocol YBSlideTabViewDelegate<NSObject>
-(void)didSelectRowAtValue:(VehicleSeriesList *)vs;

@end

@interface YBSlideTabView : UIView<UITableViewDelegate,UITableViewDataSource>
{
    BOOL _isRelate;
}
@property(nonatomic,strong)UITableView *leftTableview;
@property(nonatomic,strong)UITableView *rightTableview;
@property(nonatomic,strong)UIView *lineView;

@property (weak, nonatomic) id<YBSlideTabViewDelegate> delegate;

@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *rightDataArray;
@end
