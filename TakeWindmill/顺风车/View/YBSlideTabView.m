//
//  YBSlideTabView.m
//  TakeWindmill
//
//  Created by HUSHOUHUA华 on 2017/11/16.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBSlideTabView.h"

static CGFloat leftTabWidth = 120;
static CGFloat leftCellHeight = 65;
@implementation YBSlideTabView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}
-(void)setUI{
    [self leftTableview];
    [self rightTableview];
    [self lineView];
    _isRelate = YES;
}
-(void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    [_leftTableview reloadData];
}
-(UITableView *)leftTableview
{
    if (nil == _leftTableview) {
        _leftTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,leftTabWidth, self.frame.size.height)];
        _leftTableview.backgroundColor = [UIColor whiteColor];
        _leftTableview.showsVerticalScrollIndicator = NO;
        _leftTableview.showsHorizontalScrollIndicator = NO;
        _leftTableview.delegate = self;
        _leftTableview.dataSource = self;
        [self addSubview:_leftTableview];
    }
    return _leftTableview;
}

-(UITableView *)rightTableview{
    if (nil == _rightTableview) {
        _rightTableview = [[UITableView alloc]initWithFrame:CGRectMake(leftTabWidth, 0, self.frame.size.width - leftTabWidth, self.frame.size.height)];
        _rightTableview.backgroundColor = [UIColor whiteColor];
        _rightTableview.showsVerticalScrollIndicator = NO;
        _rightTableview.showsHorizontalScrollIndicator = NO;
        _rightTableview.delegate = self;
        _rightTableview.dataSource = self;
        [self addSubview:_rightTableview];
    }
    return _rightTableview;
}

-(UIView *)lineView{
    if (nil == _lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(leftTabWidth, 0, 0.5, self.frame.size.height)];
        _lineView.backgroundColor = [UIColor blackColor];
        [self addSubview:_lineView];
    }
    return _lineView;
}

#pragma mark - 数据源方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.leftTableview) {
        return 1;
    }else{
       // return _dataArray.count;
        // return _rightDataArray.count;
         return 1;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //NSDictionary *item = [_dataArray objectAtIndex:section];
    if (tableView == self.leftTableview) {
        return _dataArray.count;
    }else{
       // return [[item objectForKey:@"list"]count];
        return _rightDataArray.count;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier = @"cell";
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIndentifier];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    
    if (tableView == self.leftTableview) {
        UIView *selectedBackGroundView = [[UIView alloc]initWithFrame:cell.frame];
        
        selectedBackGroundView.backgroundColor =RGBA(217, 217, 217, 0.5);
        cell.selectedBackgroundView = selectedBackGroundView;
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5,leftCellHeight)];
        line.backgroundColor = [UIColor orangeColor];
        
        [selectedBackGroundView addSubview:line];
        
        //[_dataArray[indexPath.row]objectForKey:@"title"];
        
        VehicleBrandList *vb =_dataArray[indexPath.row];
        cell.textLabel.text = vb.VehicleBrand;
    }else{
        //NSDictionary *item = [_dataArray objectAtIndex:indexPath.section];
        //cell.textLabel.text = [item objectForKey:@"list"][indexPath.row];
        VehicleSeriesList *vs =_rightDataArray[indexPath.row];
        cell.textLabel.text = vs.VehicleSeries;
    }
    return cell;
}

#pragma mark - 代理方法

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.leftTableview) {
        return leftCellHeight;
    }else{
        return 50;//130;
    }
}

//头部高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.leftTableview) {
        return 0;
    }else{
        return 30;
    }
}

//底部视图高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView == self.leftTableview) {
        return 0;
    }else{
        return CGFLOAT_MIN;
    }
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if (tableView == self.rightTableview) {
//        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
//        view.backgroundColor = RGBA(217, 217, 217, 0.7);
//        UILabel *label = [[UILabel alloc]initWithFrame:view.bounds];
//         VehicleBrandList *vb = [_dataArray objectAtIndex:section];
//        label.text = [NSString stringWithFormat:@"    %@",vb.VehicleBrand];
//        [view addSubview:label];
//        return view;
//    }else{
//        return nil;
//    }
//}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    if (_isRelate) {
        NSInteger topCellSection = [[[tableView indexPathsForVisibleRows]firstObject]section];
        
        if (tableView == self.rightTableview) {
            [self.leftTableview selectRowAtIndexPath:[NSIndexPath indexPathForItem:topCellSection inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        }
    }
}

-(void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section{
    if (_isRelate) {
        NSInteger topCellSection = [[[tableView indexPathsForVisibleRows]firstObject]section];
        if (tableView == self.rightTableview) {
            [self.leftTableview selectRowAtIndexPath:[NSIndexPath indexPathForItem:topCellSection inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAK_SELF;
    if (tableView == weakSelf.leftTableview) {
        _isRelate = NO;
        [weakSelf.leftTableview selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
        
        VehicleBrandList *vb =_dataArray[indexPath.row];
        NSMutableDictionary *parm = [YBTooler dictinitWithMD5];
        parm[@"mastersysno"] = [NSString stringWithFormat:@"%ld",vb.SysNo];
        
        [YBRequest postWithURL:MemberVehicleserieslistbybrandsysno MutableDict:parm success:^(id dataArray) {
            //YBLog(@"dataArray==%@",dataArray);
            
            Body *body = [Body yy_modelWithJSON:dataArray];
            weakSelf.rightDataArray = [NSMutableArray arrayWithArray:body.VehicleSeriesList];
            //YBLog(@"VehicleSeriesList==%@",body.VehicleSeriesList);
            [weakSelf.rightTableview reloadData];
            
        } failure:^(id dataArray) {
            //YBLog(@"failureDataArray==%@",dataArray);
            [MBProgressHUD showError:dataArray[@"ErrorMessage"] toView:self];
        }];
        
        //[self.rightTableview scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:indexPath.row] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }else{
        [self.rightTableview deselectRowAtIndexPath:indexPath animated:NO];
        
        if ([self.delegate respondsToSelector:@selector(didSelectRowAtValue:)]) {
               VehicleSeriesList *vs =_rightDataArray[indexPath.row];
            [self.delegate didSelectRowAtValue:vs];
            
            [self removeFromSuperview];
        }
        //NSLog(@"==%ld,%ld",indexPath.section,indexPath.row);
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    _isRelate = YES;
}

-(void)dealloc{
    YBLog(@"%s",__func__);
}
@end
