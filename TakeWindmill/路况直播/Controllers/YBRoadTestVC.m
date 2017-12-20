//
//  YBRoadTestVC.m
//  TakeWindmill
//
//  Created by AshokaCao on 2017/10/26.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBRoadTestVC.h"

#import "SDTimeLineTableHeaderView.h"
//#import "SDTimeLineRefreshHeader.h"
//#import "SDTimeLineRefreshFooter.h"
#import "YBRoadTableViewCell.h"
#import "YBAVPlayerTableViewCell.h"
#import "SDTimeLineCellModel.h"
#import "YBChoosePhotosViewController.h"

#import "UITableView+SDAutoTableViewCellHeight.h"
#import "UIView+SDAutoLayout.h"
#import <AVFoundation/AVFoundation.h>

#import "LEETheme.h"
//#import <ZFDownload/ZFDownloadManager.h>
#import "ZFPlayer.h"

#define kTimeLineTableViewCellId @"YBRoadTableViewCell"
#define kVideoTableViewCellId @"videoCells"

static CGFloat textFieldH = 40;


@interface YBRoadTestVC () <YBRoadTableViewCellDelegate, UITextFieldDelegate, SDTimeLineTableHeaderViewDelegate>
@property (nonatomic, strong) NSString *mp4String;

@end

@implementation YBRoadTestVC

{
    //    SDTimeLineRefreshFooter *_refreshFooter;
    //    SDTimeLineRefreshHeader *_refreshHeader;
    CGFloat _lastScrollViewOffsetY;
    UITextField *_textField;
    CGFloat _totalKeybordHeight;
    NSIndexPath *_currentEditingIndexthPath;
}


- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [ZFPlayerView sharedPlayerView];
        //_playerView.delegate = self;
        // 当cell播放视频由全屏变为小屏时候，不回到中间位置
        _playerView.cellPlayerOnCenter = NO;
        
        // 当cell划出屏幕的时候停止播放
        //_playerView.stopPlayWhileCellNotVisable = YES;
        //（可选设置）可以设置视频的填充模式，默认为（等比例填充，直到一个维度到达区域边界）
        // _playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
        // 静音
        // _playerView.mute = YES;
    }
    return _playerView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    [YBRequest postWithURL:RoadListPath MutableDict:dict success:^(id dataArray) {
        
        //        dispatch_sync(dispatch_get_main_queue(), ^{
        self.dataArray = [NSMutableArray array];
        NSDictionary *dic = dataArray;
        NSDictionary *newDic = [NSDictionary changeType:dic];
        //        YBLog(@"newDic - %@",newDic);
        for (NSDictionary *diction in newDic[@"RoadConditionList"]) {
            SDTimeLineCellModel *model = [SDTimeLineCellModel modelWithDic:diction];
            [self.dataArray addObject:model];
        }
        [self.tableView reloadData];
        //        });
        YBLog(@"roadListArray - %@",newDic);
        
    } failure:^(id dataArray) {
        
    }];
    
    
    
    //LEETheme 分为两种模式 , 默认设置模式 标识符设置模式 , 朋友圈demo展示的是默认设置模式的使用 , 微信聊天demo和Demo10 展示的是标识符模式的使用
    
    //    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"日间" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemAction:)];
    //
    //    rightBarButtonItem.lee_theme
    //    .LeeAddCustomConfig(DAY , ^(UIBarButtonItem *item){
    //
    //        item.title = @"夜间";
    //
    //    }).LeeAddCustomConfig(NIGHT , ^(UIBarButtonItem *item){
    //
    //        item.title = @"日间";
    //    });
    
    //为self.view 添加背景颜色设置
    
    //    self.view.lee_theme
    //    .LeeAddBackgroundColor(DAY , [UIColor whiteColor])
    //    .LeeAddBackgroundColor(NIGHT , [UIColor blackColor]);
    
    //    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.edgesForExtendedLayout = UIRectEdgeTop;
    
    //    [self.dataArray addObjectsFromArray:[self creatModelsWithCount:10]];
    
    //    __weak typeof(self) weakSelf = self;
    
    
    //    // 上拉加载
    //    _refreshFooter = [SDTimeLineRefreshFooter refreshFooterWithRefreshingText:@"正在加载数据..."];
    //    __weak typeof(_refreshFooter) weakRefreshFooter = _refreshFooter;
    //    [_refreshFooter addToScrollView:self.tableView refreshOpration:^{
    //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //            [weakSelf.dataArray addObjectsFromArray:[weakSelf creatModelsWithCount:10]];
    //
    //            /**
    //             [weakSelf.tableView reloadDataWithExistedHeightCache]
    //             作用等同于
    //             [weakSelf.tableView reloadData]
    //             只是“reloadDataWithExistedHeightCache”刷新tableView但不清空之前已经计算好的高度缓存，用于直接将新数据拼接在旧数据之后的tableView刷新
    //             */
    //            [weakSelf.tableView reloadDataWithExistedHeightCache];
    //
    //            [weakRefreshFooter endRefreshing];
    //        });
    //    }];
    
    SDTimeLineTableHeaderView *headerView = [SDTimeLineTableHeaderView new];
    headerView.frame = CGRectMake(0, 0, 0, 40);
    headerView.delegate = self;
    self.tableView.tableHeaderView = headerView;
    
    //添加分隔线颜色设置
    
    self.tableView.lee_theme
    .LeeAddSeparatorColor(DAY , [[UIColor lightGrayColor] colorWithAlphaComponent:0.5f])
    .LeeAddSeparatorColor(NIGHT , [[UIColor grayColor] colorWithAlphaComponent:0.5f]);
    
    [self.tableView registerClass:[YBRoadTableViewCell class] forCellReuseIdentifier:kTimeLineTableViewCellId];
    [self.tableView registerNib:[UINib nibWithNibName:@"YBAVPlayerTableViewCell" bundle:nil] forCellReuseIdentifier:kVideoTableViewCellId];
    [self setupTextField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //    if (!_refreshHeader.superview) {
    //
    //        _refreshHeader = [SDTimeLineRefreshHeader refreshHeaderWithCenter:CGPointMake(40, 45)];
    //        _refreshHeader.scrollView = self.tableView;
    //        __weak typeof(_refreshHeader) weakHeader = _refreshHeader;
    //        __weak typeof(self) weakSelf = self;
    //        [_refreshHeader setRefreshingBlock:^{
    //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //                weakSelf.dataArray = [[weakSelf creatModelsWithCount:10] mutableCopy];
    //                [weakHeader endRefreshing];
    //                dispatch_async(dispatch_get_main_queue(), ^{
    //                    [weakSelf.tableView reloadData];
    //                });
    //            });
    //        }];
    //        [self.tableView.superview addSubview:_refreshHeader];
    //    } else {
    //        [self.tableView.superview bringSubviewToFront:_refreshHeader];
    //    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_textField resignFirstResponder];
}

- (void)dealloc
{
    //    [_refreshHeader removeFromSuperview];
    //    [_refreshFooter removeFromSuperview];
    
    [_textField removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupTextField
{
    _textField = [UITextField new];
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.delegate = self;
    _textField.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8].CGColor;
    _textField.layer.borderWidth = 1;
    
    //为textfield添加背景颜色 字体颜色的设置 还有block设置 , 在block中改变它的键盘样式 (当然背景颜色和字体颜色也可以直接在block中写)
    
    _textField.lee_theme
    .LeeAddBackgroundColor(DAY , [UIColor whiteColor])
    .LeeAddBackgroundColor(NIGHT , [UIColor blackColor])
    .LeeAddTextColor(DAY , [UIColor blackColor])
    .LeeAddTextColor(NIGHT , [UIColor grayColor])
    .LeeAddCustomConfig(DAY , ^(UITextField *item){
        
        item.keyboardAppearance = UIKeyboardAppearanceDefault;
        if ([item isFirstResponder]) {
            [item resignFirstResponder];
            [item becomeFirstResponder];
        }
    }).LeeAddCustomConfig(NIGHT , ^(UITextField *item){
        
        item.keyboardAppearance = UIKeyboardAppearanceDark;
        if ([item isFirstResponder]) {
            [item resignFirstResponder];
            [item becomeFirstResponder];
        }
    });
    
    _textField.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.view.width_sd, textFieldH);
    [[UIApplication sharedApplication].keyWindow addSubview:_textField];
    
    [_textField becomeFirstResponder];
    [_textField resignFirstResponder];
}

// 右栏目按钮点击事件

- (void)rightBarButtonItemAction:(UIBarButtonItem *)sender{
    
    if ([[LEETheme currentThemeTag] isEqualToString:DAY]) {
        
        [LEETheme startTheme:NIGHT];
        
    } else {
        [LEETheme startTheme:DAY];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ///////////////////////////////////////////////////////
    SDTimeLineCellModel *model = self.dataArray[indexPath.row];
    //    YBLog(@"HeadImgUrl - %@",model.HeadImgUrl);
    
    
    NSString *imageStr = model.UploadFiles;
    NSString *newStr = [imageStr substringWithRange:NSMakeRange(0, imageStr.length - 1)];
    NSArray  *imageArray = [newStr componentsSeparatedByString:@","];
    
    NSString *mp4Str = imageArray.firstObject;
    self.mp4String = mp4Str;
    
    if ([mp4Str hasSuffix:@"mp4"]) {
        
        NSURL *url = [[NSURL alloc] initWithString:mp4Str];
        
        YBAVPlayerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kVideoTableViewCellId forIndexPath:indexPath];
        // 取到对应cell的model
        //        SDTimeLineCellModel *model  = self.dataArray[indexPath.row];
        // 赋值model
        cell.model = model;
        __block NSIndexPath *weakIndexPath = indexPath;
        __block YBAVPlayerTableViewCell *weakCell     = cell;
        __weak typeof(self)  weakSelf      = self;
        // 点击播放的回调
        cell.playBlock = ^(UIButton *btn){
            
            ZFPlayerModel *playerModel = [[ZFPlayerModel alloc] init];
            //            playerModel.title            = model.title;
            playerModel.videoURL         = url;
            //            playerModel.placeholderImageURLString = model.coverForFeed;
            playerModel.scrollView       = weakSelf.tableView;
            playerModel.indexPath        = weakIndexPath;
            // 赋值分辨率字典
            //            playerModel.resolutionDic    = dic;
            // player的父视图tag
            playerModel.fatherViewTag    = weakCell.videoImage.tag;
            
            // 设置播放控制层和model
            [weakSelf.playerView playerControlView:nil playerModel:playerModel];
            // 下载功能
            //            weakSelf.playerView.hasDownload = YES;
            // 自动播放
            [weakSelf.playerView autoPlayTheVideo];
        };
        
        return cell;
    } else {
        
        YBRoadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTimeLineTableViewCellId];
        cell.indexPath = indexPath;
        __weak typeof(self) weakSelf = self;
        if (!cell.moreButtonClickedBlock) {
            [cell setMoreButtonClickedBlock:^(NSIndexPath *indexPath) {
                SDTimeLineCellModel *model = weakSelf.dataArray[indexPath.row];
                model.isOpening = !model.isOpening;
                [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
            cell.delegate = self;
        }
        
        ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
        
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        
        ////////////////
        
//        SDTimeLineCellModel *cellModel = self.dataArray[indexPath.row];
        cell.model = model;
        //        [cell testThisItemWithModel:cellModel];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    return 239;
    if ([self.mp4String hasSuffix:@"mp4"]) {
        return 239;
    } else {
        // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
        id model = self.dataArray[indexPath.row];
        return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[YBRoadTableViewCell class] contentViewWidth:[self cellContentViewWith]];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_textField resignFirstResponder];
}



- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}


#pragma mark - SDTimeLineCellDelegate

- (void)didClickcCommentButtonInCell:(UITableViewCell *)cell
{
    [_textField becomeFirstResponder];
    _currentEditingIndexthPath = [self.tableView indexPathForCell:cell];
    
    [self adjustTableViewToFitKeyboard];
    
}

- (void)didClickLikeButtonInCell:(UITableViewCell *)cell
{
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    SDTimeLineCellModel *model = self.dataArray[index.row];
    NSMutableArray *temp = [NSMutableArray arrayWithArray:model.likeItemsArray];
    
    if (!model.isLiked) {
        SDTimeLineCellLikeItemModel *likeModel = [SDTimeLineCellLikeItemModel new];
        likeModel.userName = @"GSD_iOS";
        likeModel.userId = @"gsdios";
        [temp addObject:likeModel];
        model.liked = YES;
    } else {
        SDTimeLineCellLikeItemModel *tempLikeModel = nil;
        for (SDTimeLineCellLikeItemModel *likeModel in model.likeItemsArray) {
            if ([likeModel.userId isEqualToString:@"gsdios"]) {
                tempLikeModel = likeModel;
                break;
            }
        }
        [temp removeObject:tempLikeModel];
        model.liked = NO;
    }
    model.likeItemsArray = [temp copy];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
    });
}


- (void)adjustTableViewToFitKeyboard
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_currentEditingIndexthPath];
    CGRect rect = [cell.superview convertRect:cell.frame toView:window];
    CGFloat delta = CGRectGetMaxY(rect) - (window.bounds.size.height - _totalKeybordHeight);
    
    CGPoint offset = self.tableView.contentOffset;
    offset.y += delta;
    if (offset.y < 0) {
        offset.y = 0;
    }
    
    [self.tableView setContentOffset:offset animated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length) {
        [_textField resignFirstResponder];
        
        SDTimeLineCellModel *model = self.dataArray[_currentEditingIndexthPath.row];
        NSMutableArray *temp = [NSMutableArray new];
        [temp addObjectsFromArray:model.commentItemsArray];
        
        SDTimeLineCellCommentItemModel *commentItemModel = [SDTimeLineCellCommentItemModel new];
        commentItemModel.firstUserName = @"GSD_iOS";
        commentItemModel.commentString = textField.text;
        commentItemModel.firstUserId = @"GSD_iOS";
        [temp addObject:commentItemModel];
        
        model.commentItemsArray = [temp copy];
        
        [self.tableView reloadRowsAtIndexPaths:@[_currentEditingIndexthPath] withRowAnimation:UITableViewRowAnimationNone];
        
        _textField.text = @"";
        
        return YES;
    }
    return NO;
}



- (void)keyboardNotification:(NSNotification *)notification
{
    NSDictionary *dict = notification.userInfo;
    CGRect rect = [dict[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    
    
    CGRect textFieldRect = CGRectMake(0, rect.origin.y - textFieldH, rect.size.width, textFieldH);
    if (rect.origin.y == [UIScreen mainScreen].bounds.size.height) {
        textFieldRect = rect;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        _textField.frame = textFieldRect;
    }];
    
    CGFloat h = rect.size.height + textFieldH;
    if (_totalKeybordHeight != h) {
        _totalKeybordHeight = h;
        [self adjustTableViewToFitKeyboard];
    }
}

- (void)choosePhotoOrVideo
{
    YBChoosePhotosViewController *chooseView = [YBChoosePhotosViewController new];
    [self.navigationController pushViewController:chooseView animated:YES];
}

@end
