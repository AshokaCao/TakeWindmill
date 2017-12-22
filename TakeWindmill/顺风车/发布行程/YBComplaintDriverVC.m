//
//  YBComplaintDriverVC.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/11/7.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBComplaintDriverVC.h"

#import "YBComplaintDriverCell.h"


@interface ComplaintTitleView ()

/**
 *  车主头像
 */
@property (nonatomic, weak) UIImageView *iconImageView;

/**
 *  车主姓名
 */
@property (nonatomic, weak) UILabel *nameLabel;

/**
 *  车主时间
 */
@property (nonatomic, weak) UILabel *timeLabel;

/**
 *  起点与终点
 */
@property (nonatomic, weak) UILabel *sectionLabel;

/**
 *  状态
 */
@property (nonatomic, weak) UILabel *typeLabe;

@end

@implementation ComplaintTitleView

- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        UIImageView *iconIamge = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        [self addSubview:iconIamge];
        _iconImageView = iconIamge;
    }
    return _iconImageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        UILabel *nameLabel  = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 10, 0, YBWidth / 2, self.frame.size.height / 3)];
        nameLabel.font      = YBFont(15);
        [self addSubview:nameLabel];
        _nameLabel = nameLabel;
    }
    return _nameLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        UILabel *timeLabel  = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 10, CGRectGetMaxY(self.nameLabel.frame), YBWidth / 2, self.frame.size.height / 3)];
        timeLabel.font      = YBFont(14);
        timeLabel.textColor = [UIColor grayColor];
        [self addSubview:timeLabel];
        _timeLabel = timeLabel;
    }
    return _timeLabel;
}

- (UILabel *)sectionLabel
{
    if (!_sectionLabel) {
        UILabel *sectionLabel   = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 10, CGRectGetMaxY(self.timeLabel.frame), YBWidth / 2, self.frame.size.height / 3)];
        sectionLabel.font       = YBFont(13);
        sectionLabel.textColor  = [UIColor lightGrayColor];
        [self addSubview:sectionLabel];
        _sectionLabel = sectionLabel;
    }
    return _sectionLabel;
}

- (UILabel *)typeLabe
{
    if (!_typeLabe) {
        UILabel *typeLabe       = [[UILabel alloc] initWithFrame:CGRectMake(YBWidth - 60, 0, 60, self.frame.size.height)];
        typeLabe.font           = YBFont(13);
        typeLabe.textColor      = [UIColor lightGrayColor];
        typeLabe.textAlignment  = NSTextAlignmentCenter;
        [self addSubview:typeLabe];
        _typeLabe = typeLabe;
    }
    return _typeLabe;
}

- (void)itineraryComplaints:(NSDictionary *)dict
{
    YBLog(@"%@",dict);
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"HeadImgUrl"]] placeholderImage:[UIImage imageNamed:@"headimg.gif"]];
    self.nameLabel.text      = dict[@"NickName"];
    
    NSArray *timeArray = [dict[@"SetoutTimeStr"] componentsSeparatedByString:@"+"];
    self.timeLabel.text      = [NSString stringWithFormat:@"%@ %@",timeArray[0],timeArray[1]];
    
    self.sectionLabel.text   = [NSString stringWithFormat:@"%@->%@",dict[@"StartAddress"],dict[@"EndAddress"]];
    self.typeLabe.text       = @"待出发";
}

@end

@interface YBComplaintDriverVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

/**
 * 司机行程信息
 */
@property (nonatomic, weak) ComplaintTitleView *titleView;

@property (nonatomic, weak) UIView *headView;

/**
 * 投诉选项了列表
 */
@property (nonatomic, weak) UITableView *omplaintTableView;

/**
 * 提交按钮
 */
@property (nonatomic, weak) UIButton *submitButton;

/**
 * 投诉选项了列表
 */
@property (nonatomic, strong) NSArray *optionArray;

@property (assign, nonatomic) NSIndexPath *selIndex;//单选，当前选中的行

@end

@implementation YBComplaintDriverVC

#pragma mark - lazy
- (ComplaintTitleView *)titleView
{
    if (!_titleView) {
        ComplaintTitleView *titleView = [[ComplaintTitleView alloc] initWithFrame:CGRectMake(0, 5, YBWidth, 80)];
        titleView.backgroundColor     = [UIColor whiteColor];
        [titleView itineraryComplaints:self.driverDict];
        
        [self.view addSubview:titleView];
        _titleView = titleView;
    }
    return _titleView;
}

- (UIView *)headView
{
    if (!_headView) {
        UIView *titleView           = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleView.frame), YBWidth, 50)];
        titleView.backgroundColor   = LineLightColor;
        [self.view addSubview:titleView];

        UILabel *label  = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, YBWidth , titleView.frame.size.height)];
        label.font      = YBFont(15);
        label.text      = @"投诉类型";
        label.textColor = [UIColor grayColor];
        [titleView addSubview:label];
        
        _headView = titleView;
    }
    return _headView;
}

- (UITableView *)omplaintTableView
{
    if (!_omplaintTableView) {
        UITableView *tableView        = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headView.frame), YBWidth, YBHeight - CGRectGetMaxY(self.headView.frame) - 50) style:UITableViewStyleGrouped];
        tableView.delegate            = self;
        tableView.dataSource          = self;
        tableView.rowHeight           = 50;
        tableView.sectionHeaderHeight = 0;
        tableView.sectionFooterHeight = 5;
        tableView.contentInset         = UIEdgeInsetsMake(-35, 0, 0, 0);
        [self.view addSubview:tableView];
        _omplaintTableView      = tableView;
    }
    return _omplaintTableView;
}

- (UIButton *)submitButton
{
    if (!_submitButton) {
        UIButton *submit = [[UIButton alloc] initWithFrame:CGRectMake(5,CGRectGetMaxY(self.omplaintTableView.frame) + 5, YBWidth - 10, 40)];
        submit.titleLabel.font = YBFont(15);
        [submit setTitle:@"提交" forState:UIControlStateNormal];
        [submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [submit setBackgroundColor:BtnBlueColor];
        [submit addTarget:self action:@selector(submitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:submit];
        _submitButton = submit;
    }
    return _submitButton;
}

- (NSArray *)optionArray
{
    if (!_optionArray) {
        _optionArray = [NSArray array];
        
        NSString *urlStr = baseinfocommonlistPath;
        NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
        [dict setObject:@"7" forKey:@"typefid"];
        
        [YBRequest postWithURL:urlStr MutableDict:dict success:^(id dataArray) {
//            YBLog(@"%@",dataArray);
            _optionArray = dataArray[@"BaseInfoCommonList"];
            [self.omplaintTableView reloadData];
        } failure:^(id dataArray) {
            YBLog(@"请求失败");
        }];
        
    }
    return _optionArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"乘客行程投诉";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [self omplaintTableView];
    [self submitButton];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 提交
- (void)submitButtonAction:(UIButton *)sender
{
    NSString *urlStr = complaininfosavePath;
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    
    [dict setObject:[YBTooler getTheUserId:self.view] forKey:@"userid"];//用户id
    [dict setObject:@"1" forKey:@"typefid"];//1-乘客，2-司机
    [dict setObject:self.optionArray[_selIndex.section][@"FID"] forKey:@"baseinfofid"];//基础信息FID
    YBComplaintDriverCell *cell = (YBComplaintDriverCell *)[self.omplaintTableView cellForRowAtIndexPath:_selIndex];
    if (cell.textLabel.text) {
        [dict setObject:cell.textLabel.text forKey:@"description"]; //描述
    }
    YBLog(@"%@",dict);
    
    [YBRequest postWithURL:urlStr MutableDict:dict success:^(id dataArray) {
        YBLog(@"%@",dataArray);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"投诉成功，我们会尽快处理" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        
    } failure:^(id dataArray) {
        
    }];
    
}

#pragma mark - 代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.optionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableID = @"YBComplaintDriverCell";
    YBComplaintDriverCell *cell = [tableView dequeueReusableCellWithIdentifier:tableID];
    if (!cell) {
        cell = [[YBComplaintDriverCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:tableID];
    }
    cell.reasonText.delegate = self;
    if (_selIndex == indexPath) {
        [cell selectedState:self.optionArray[indexPath.section][@"FName"]];
        tableView.rowHeight = 115;
    }
    else {
        [cell uncheckedStatus:self.optionArray[indexPath.section][@"FName"]];
        tableView.rowHeight = 50;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //之前选中的，取消选择
    UITableViewCell *celled = [tableView cellForRowAtIndexPath:_selIndex];
    celled.accessoryType = UITableViewCellAccessoryNone;
    //记录当前选中的位置索引
    _selIndex = indexPath;
    
    [self.omplaintTableView reloadData];
}


#pragma mark - 代理

///键盘显示事件
- (void)keyboardWillShow:(NSNotification *)notification {
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    CGFloat offset = kbHeight - (YBHeight - self.omplaintTableView.frame.origin.y - _selIndex.section * 70) ;
    
//    YBLog(@"%f -- %f",kbHeight,offset);
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //将视图上移计算好的偏移
    if(offset > 0) {
        [UIView animateWithDuration:duration animations:^{
            self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
}

///键盘消失事件
- (void)keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = CGRectMake(0, 64, YBWidth, YBHeight);
    }];
}

@end
