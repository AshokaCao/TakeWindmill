//
//  YBDropMenuCollectionView.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/9/13.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBDropMenuCollectionView.h"


@interface YBDropMenuCollectionCell : UICollectionViewCell

/**
 * 地名
 */
@property (nonatomic, weak) UILabel *nameLabel;

/**
 * 人数
 */
@property (nonatomic, weak) UILabel *numberLabel;

@end

@implementation YBDropMenuCollectionCell

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = YBFont(12);
        nameLabel.textColor = [UIColor blackColor];
        [self addSubview:nameLabel];
        _nameLabel = nameLabel;
    }
    return _nameLabel;
}

- (UILabel *)numberLabel
{
    if (!_numberLabel) {
        UILabel *numberLabel = [[UILabel alloc] init];
        numberLabel.font = YBFont(12);
        numberLabel.textColor = [UIColor grayColor];
        [self addSubview:numberLabel];
        _numberLabel = numberLabel;
    }
    return _numberLabel;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = LightGreyColor;
    self.nameLabel.frame = CGRectMake(5, 5, self.frame.size.width * 0.7, self.frame.size.height - 10);
    self.numberLabel.frame = CGRectMake(self.frame.size.width * 0.7, 5, self.frame.size.width * 0.3, self.frame.size.height - 10);
}

@end

/*******************************************************collectionView*******************************************************/

@interface YBDropMenuCollectionView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate>

/**
 * 选中的cell
 */
@property (nonatomic, assign) NSUInteger selectRow;

/**
 * 类型
 */
@property (nonatomic, assign) NSInteger typeI;

/**
 * 蒙版
 */
@property (nonatomic, strong) UIView *bgView;

/**
 * cell
 */
@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, assign) BOOL show;   // 按钮点击后 视图显示/隐藏

@property (nonatomic, assign) CGFloat rowHeightNum; // 设置 rom 高度

/**
 * 数据
 */
@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation YBDropMenuCollectionView

#pragma mark -lazy
- (NSArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSArray array];
    }
    return _dataArr;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout  = [[UICollectionViewFlowLayout alloc] init];
        //设置布局方向(默认是垂直方向)
        layout.scrollDirection              = UICollectionViewScrollDirectionVertical;
        //设置每个item的大小
        layout.itemSize                     = CGSizeMake(YBWidth / 3 - 20, 30);
        //设置每一行的间距
        layout.minimumLineSpacing           = 10;
        //设置item的间距
        layout.minimumInteritemSpacing      = 10;
        //设置section的边距
        layout.sectionInset                 = UIEdgeInsetsMake(5, 5, 5, 5);
        
        UICollectionView *collectionView    = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, YBWidth, self.frame.size.height / 2) collectionViewLayout:layout];
        
        collectionView.backgroundColor      = [UIColor whiteColor];
        collectionView.delegate             = self;
        collectionView.dataSource           = self;
        collectionView.translatesAutoresizingMaskIntoConstraints=NO;
        collectionView.alwaysBounceVertical = YES;
        
        [self.bgView addSubview:collectionView];
        _collectionView = collectionView;
    }
    return _collectionView;
}

- (UIView *)bgView
{
    if (!_bgView) {
        UIView *blackView = [UIView new];
        blackView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        [self addSubview:blackView];
        //为蒙版添加点击事件
        UIGestureRecognizer *touchMask = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        touchMask.delegate = self;
        [self addGestureRecognizer:touchMask];
        
        _bgView = blackView;
    }
    return _bgView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        /** 保存 初始值为-1 */
        _selectRow = -1;
        //注册cell
        [self.collectionView registerClass:[YBDropMenuCollectionCell class] forCellWithReuseIdentifier:@"YBDropMenuCollectionCell"];
        //默认为NO
        self.show = NO;
        self.rowHeightNum = 40.0f;
    }
    return self;
}

-(void)creatMenuCollectionViewY:(CGFloat)viewY withShowCollectionNum:(NSInteger)tableNum withData:(NSArray *)arr
{
    if (!self.show) {
        
        self.show    = !self.show;
        // 数据
        self.dataArr = arr;
        [self.collectionView reloadData];
        
        self.typeI   = tableNum;
        
        // 初始位置 设置
        CGFloat x = 0.f;
        CGFloat y = 0;
        CGFloat w = YBWidth;
        CGFloat h = YBHeight - y + 64;
        
        self.frame = CGRectMake(x, y, w, h);
        self.bgView.frame = CGRectMake(0, viewY,self.frame.size.width, YBHeight - viewY + 64);
        self.collectionView.frame = CGRectMake(0, 0 , self.frame.size.width, self.rowHeightNum * 7);
        
        if (!self.superview) {
            [[[UIApplication sharedApplication] keyWindow] addSubview:self];
            self.alpha = 0.0f;
            [UIView animateWithDuration:0.2f animations:^{
                self.alpha = 1.0f;
            }];
        }
    }else{
        /** 什么也不选择时候, 再次点击按钮 消失视图 */
        [self dismiss];
    }
    
    
}

#pragma mark - TableView协议
/** 个数 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

/** 自定义cell */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YBDropMenuCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YBDropMenuCollectionCell" forIndexPath:indexPath];
    if (self.typeI == 0) {//附近乘客
        cell.nameLabel.text = self.dataArr[indexPath.row][@"EndRoad"];
        cell.numberLabel.text = [NSString stringWithFormat:@"%@人",self.dataArr[indexPath.row][@"PeopleNumber"]];
    }
    else {//跨城乘客
        cell.nameLabel.text = self.dataArr[indexPath.row][@"AreaName"];
        cell.numberLabel.text = [NSString stringWithFormat:@"%@人",self.dataArr[indexPath.row][@"PeopleNumber"]];
    }
    return cell;
}

#pragma mark -- UICollectionViewDelegateFlowLayout
/** 每个cell的尺寸*/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.frame.size.width / 3 - 10, 30);
}

/** section的margin*/
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

/** 点击 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectRow = indexPath.row;
    
    [self dismiss];
    [_delegate dropMenuCollectionView:self didSelectName:self.typeI == 0 ? self.dataArr[indexPath.row][@"EndRoad"] : self.dataArr[indexPath.row][@"AreaName"]];
}

//隐藏
- (void)dismiss {
    
    if(self.superview) {
        
        self.show = !self.show;
        
        [self endEditing:YES];
        
        [UIView animateWithDuration:.25f animations:^{
            self.alpha = .0f;
        } completion:^(BOOL finished) {
            
            [self removeFromSuperview];
            [UIView animateWithDuration:0.2 animations:^{
                if (self.arrowView) {
                    self.arrowView.transform = CGAffineTransformMakeRotation(0);
                }
            }];
        }];
        
    }
}

#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if([touch.view isDescendantOfView:self.collectionView]){
        return NO;
    }
    return YES;
}

@end

