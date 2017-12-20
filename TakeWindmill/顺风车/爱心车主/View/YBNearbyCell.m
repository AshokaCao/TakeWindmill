//
//  YBNearbyCell.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/9/4.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBNearbyCell.h"
#import "YBWaitingView.h"
#import "DropMenuView.h"

#import "YBDropMenuCollectionView.h"

@interface YBNearbyCell ()

@property (nonatomic, weak) YBWaitingView *bgView;

@end

@implementation YBNearbyCell

- (YBWaitingView *)bgView
{
    if (!_bgView) {
        YBWaitingView *bgView = [[YBWaitingView alloc] initWithFrame:CGRectMake(10, 5, self.frame.size.width - 20 , self.frame.size.height - 10)];
        //给bgView边框设置阴影
        bgView.layer.shadowOffset = CGSizeMake(1,1);
        bgView.layer.shadowOpacity = 0.1;
        bgView.layer.shadowColor = [UIColor grayColor].CGColor;
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        
        _bgView = bgView;
    }
    return _bgView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.bgView nearbyPassengersAndOwners:self.detailsDict];
    self.bgView.iconImageViewBlock = ^(UITapGestureRecognizer *gest) {
        if (_iconImageView) {
            _iconImageView(gest);
        }
    };
    self.backgroundColor = [UIColor clearColor];
}
@end














//************************************************排序************************************************************//

@interface YBNearbyTitleView ()<DropMenuViewDelegate,YBDropMenuCollectionViewDelegate>

/**
 * 出行计划的人数
 */
@property (nonatomic, weak) UILabel *numberLabel;

/**
 * 智能排序按钮
 */
@property (nonatomic, weak) UIButton *sortingButton;

/**
 * 全部目的地
 */
@property (nonatomic, weak) UIButton *addressButton;

/**
 * UITableView蒙版
 */
@property (nonatomic, strong) DropMenuView *oneLinkageDropMenu;

/**
 * 智能排序数组
 */
@property (nonatomic, strong) NSArray *sortsArray;

/**
 * UICollectionView蒙版
 */
@property (nonatomic, strong) YBDropMenuCollectionView *YBDropMenu;

@end

@implementation YBNearbyTitleView

- (NSArray *)sortsArray
{
    if (!_sortsArray) {
        _sortsArray =  [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sorts.plist" ofType:nil]];
    }
    return _sortsArray;
}

//
- (DropMenuView *)oneLinkageDropMenu
{
    if (!_oneLinkageDropMenu) {
        _oneLinkageDropMenu             = [[DropMenuView alloc] init];
        _oneLinkageDropMenu.delegate    = self;
        _oneLinkageDropMenu.arrowView   = self.sortingButton.imageView;
    }
    return _oneLinkageDropMenu;
}

- (YBDropMenuCollectionView *)YBDropMenu
{
    if (!_YBDropMenu) {
        _YBDropMenu             = [[YBDropMenuCollectionView alloc] init];
        _YBDropMenu.delegate    = self;
        _YBDropMenu.arrowView   = self.addressButton.imageView;
    }
    return _YBDropMenu;
}

//全部目的地
- (UIButton *)addressButton
{
    if (!_addressButton) {
        UIButton *addressButton                = [UIButton buttonWithType:UIButtonTypeCustom];
        addressButton.titleLabel.font          = YBFont(10);
        addressButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [addressButton setTitle:@"全部目的地" forState:UIControlStateNormal];
        [addressButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [addressButton setImage:[UIImage imageNamed:@"下角"] forState:UIControlStateNormal];
        [addressButton addTarget:self action:@selector(positionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        addressButton.frame                    = CGRectMake(self.sortingButton.frame.origin.x - 70, 10, 65,self.frame.size.height - 20);
        [YBTooler buttonEdgeInsets:addressButton];
        [self addSubview:addressButton];
        
        _addressButton = addressButton;
    }
    return _addressButton;

    
}

//排序按钮
- (UIButton *)sortingButton
{
    if (!_sortingButton) {
        UIButton *sorting                = [UIButton buttonWithType:UIButtonTypeCustom];
        sorting.titleLabel.font          = YBFont(10);
        sorting.titleLabel.textAlignment = NSTextAlignmentCenter;
        [sorting setTitle:@"智能排序" forState:UIControlStateNormal];
        [sorting setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [sorting setImage:[UIImage imageNamed:@"下角"] forState:UIControlStateNormal];
        [sorting addTarget:self action:@selector(sortingButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        sorting.frame                    = CGRectMake(YBWidth - 65, 10, 55, self.frame.size.height - 20);
        [YBTooler buttonEdgeInsets:sorting];
        [self addSubview:sorting];
        
        _sortingButton = sorting;
    }
    return _sortingButton;
}

//出行计划人数
- (UILabel *)numberLabel
{
    if (!_numberLabel) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = self.NumberPassengers;
        titleLabel.font = YBFont(12);
        [self addSubview:titleLabel];
        
        _numberLabel = titleLabel;
    }
    return _numberLabel;
}

- (void)setLeftBtnStr:(NSString *)leftBtnStr
{
    [self.addressButton setTitle:leftBtnStr forState:UIControlStateNormal];
}

- (void)setRightBtnStr:(NSString *)rightBtnStr
{
    [self.sortingButton setTitle:rightBtnStr forState:UIControlStateNormal];
}

- (void)setNumberPassengers:(NSString *)NumberPassengers
{
    self.numberLabel.text = NumberPassengers;
}

- (void)setIsLeftBtnHinde:(BOOL)isLeftBtnHinde
{
    self.addressButton.hidden = isLeftBtnHinde;
}

- (void)setIsRightBtnHinde:(BOOL)isRightBtnHinde
{
    self.sortingButton.hidden = isRightBtnHinde;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.numberLabel.frame = CGRectMake(10, 10, self.frame.size.width / 2,self.frame.size.height - 20);
    [self addressButton];//全部目的地
}


#pragma mark - 全部目的地菜单 (并且其他的菜单收起)
- (void)positionBtnAction:(UIButton *)sender
{
    //view 在父试图的父试图上的位置
    CGFloat viewY = [self.superview convertRect:self.frame toView:self.superview.superview].origin.y + 64 + self.frame.size.height;//加导航栏的高度和view本身的高度
    [self.YBDropMenu creatMenuCollectionViewY:viewY withShowCollectionNum:self.isTypes withData:self.leftArray];
    [self.oneLinkageDropMenu dismiss];
}

#pragma mark - 智能排序菜单 (并且其他的菜单收起)
- (void)sortingButtonAction:(UIButton *)sender
{
    CGFloat viewY = [self.superview convertRect:self.frame toView:self.superview.superview].origin.y + 64 + self.frame.size.height;
//    YBLog(@"头部试图%f-----------%f",viewY,self.frame.size.height);
    [self.oneLinkageDropMenu creatDropViewY:viewY withShowTableNum:1 withData:self.sortsArray];
    [self.YBDropMenu dismiss];
}

#pragma mark - 协议实现
-(void)dropMenuView:(DropMenuView *)view didSelectName:(NSString *)str{
    
    //改变按钮frame
    CGFloat btnW = [YBTooler calculateTheStringWidth:str font:10] + 15;
    self.sortingButton.frame = CGRectMake(YBWidth - btnW - 10 , 10, btnW, self.frame.size.height - 20);
    [self.sortingButton setTitle:str forState:UIControlStateNormal];

    CGRect addBtn = self.addressButton.frame;
    addBtn.origin.x = self.sortingButton.frame.origin.x - addBtn.size.width;
    self.addressButton.frame = addBtn;
    
    //旋转按钮图片
    [YBTooler buttonEdgeInsets:self.sortingButton];
    
    //返回选中文字
    if (_rightBtnBlock) {
        _rightBtnBlock(str);
    }
}

#pragma mark - delegate
#pragma mark - 协议实现
-(void)dropMenuCollectionView:(YBDropMenuCollectionView *)view didSelectName:(NSString *)str
{
    //改变按钮frame
    
    CGFloat btnW = [YBTooler calculateTheStringWidth:str font:10] + 15;
    [self.addressButton setTitle:str forState:UIControlStateNormal];
    
    CGRect addBtn = self.addressButton.frame;
    addBtn.origin.x = CGRectGetMaxX(addBtn) - btnW;
    addBtn.size.width = btnW;
    self.addressButton.frame = addBtn;
    
    //旋转按钮图片
    [YBTooler buttonEdgeInsets:self.addressButton];
    
    if (_leftBtnBlock) {
        _leftBtnBlock(str);
    }
}

#pragma mark - 筛选菜单消失
- (void)menuScreeningViewDismiss{
    
    [self.oneLinkageDropMenu dismiss];
    [self.YBDropMenu dismiss];
}

@end

//************************************************排序************************************************************//

