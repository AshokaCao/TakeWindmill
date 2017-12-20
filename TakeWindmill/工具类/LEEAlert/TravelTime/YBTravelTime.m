//
//  YBTravelTime.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/23.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBTravelTime.h"
#import "MyTimeTool.h"


#define SCREENSIZE [UIScreen mainScreen].bounds.size
#define HEIGHTCOUNT 0.5

#define ONEDAYARRAY @[@"今天"]
#define TWODAYARRAY @[@"今天", @"明天"]
#define THREEDAYARRAY @[@"今天", @"明天", @"后天"]
#define HOURARRAY @[@"00点", @"01点", @"02点", @"03点", @"04点", @"05点", @"06点", @"07点", @"08点", @"09点", @"10点", @"11点", @"12点", @"13点", @"14点", @"15点", @"16点", @"17点", @"18点", @"19点", @"20点", @"21点", @"22点", @"23点"]
#define MINUTEARRAY @[@"00分", @"10分", @"20分", @"30分", @"40分", @"50分"]

@interface YBTravelTime ()<UIPickerViewDataSource, UIPickerViewDelegate>

//左边按钮
@property (weak, nonatomic) UIButton *leftButton;

//右边按钮
@property (weak, nonatomic) UIButton *rightButton;

//标题
@property (weak, nonatomic) UILabel *titleLabel;

//底部按钮
@property (weak, nonatomic) UIButton *bottomButton;

//时间轴
@property (weak, nonatomic) UIPickerView *pickerView;

//从今天以后的时间
@property (nonatomic, strong) NSArray *dayArray;
@property (nonatomic, strong) NSArray *showDayArray;
//标准时间
@property (nonatomic, strong) NSMutableArray *standardArray;


@property (nonatomic, strong) NSArray *hourArray;
@property (nonatomic, strong) NSArray *minuteArray;
@property (nonatomic, strong) NSArray *totalArray;

@property (nonatomic, assign) NSInteger columnIndex;
@property (nonatomic, assign) NSInteger rowIndex;

@end

@implementation YBTravelTime

- (UIButton *)leftButton
{
    if (!_leftButton) {
        UIButton *leftButton       = [[UIButton alloc] init];
        leftButton.tag             = 0;
        leftButton.titleLabel.font = YBFont(14);
        [leftButton setTitle:self.leftButtonStr forState:UIControlStateNormal];
        [leftButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(selectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:leftButton];
        
        _leftButton = leftButton;
    }
    return _leftButton;
}

- (UIButton *)rightButton
{
    if (!_rightButton) {
        UIButton *rightButton       = [[UIButton alloc] init];
        rightButton.tag             = 1;
        rightButton.titleLabel.font = YBFont(14);
        [rightButton setTitle:self.rightButtonStr forState:UIControlStateNormal];
        [rightButton setTitleColor:BtnOrangeColor forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(selectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:rightButton];
        _rightButton = rightButton;
    }
    return _rightButton;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = self.deadStr;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        
        _titleLabel = titleLabel;
        
    }
    return _titleLabel;
}

- (UIPickerView *)pickerView
{
    if (!_pickerView) {
        UIPickerView *pickerView = [[UIPickerView alloc] init];
        pickerView.dataSource    = self;
        pickerView.delegate      = self;
        [self addSubview:pickerView];
        _pickerView = pickerView;
    }
    return _pickerView;
}

- (UIButton *)bottomButton
{
    if (!_bottomButton) {
        UIButton *bottomButton                = [[UIButton alloc] init];
        bottomButton.selected                 = YES;
        bottomButton.titleLabel.font          = YBFont(14);
        bottomButton.titleEdgeInsets          = UIEdgeInsetsMake(0, 10, 0, 0);
        bottomButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        bottomButton.hidden                   = self.isHideBottom;
        
        [bottomButton setTitle:@"愿等15分钟,更容易被接单" forState:UIControlStateNormal];
        [bottomButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [bottomButton setImage:[UIImage imageNamed:@"打钩"] forState:UIControlStateSelected];
        [bottomButton setImage:[UIImage imageNamed:@"未选择"] forState:UIControlStateNormal];
        [bottomButton addTarget:self action:@selector(bottomButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bottomButton];
        
        _bottomButton = bottomButton;
    }
    return _bottomButton;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat btnH = 30;
    
    self.leftButton.frame = CGRectMake(0, 0, 60, btnH);
    self.rightButton.frame = CGRectMake(YBWidth - 60, 0, 60, btnH);
    self.titleLabel.frame = CGRectMake(60, 0, YBWidth - 120, btnH);
    self.pickerView.frame = CGRectMake(0,CGRectGetMaxY(self.titleLabel.frame), YBWidth, 230);
    if (!self.isHideBottom) {
        self.bottomButton.frame = CGRectMake(0, CGRectGetMaxY(self.pickerView.frame), YBWidth, btnH);
    }
    
    [self initData];
}

- (void)bottomButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (void)selectButtonAction:(UIButton *)sender
{
    if (sender.tag == 0) {
        if (_cancelBlock) {
            _cancelBlock(sender);
        }
    }
    else {
        
        NSString *str = [NSString stringWithFormat:@"%@",[self pickerView:self.pickerView titleForRow:[self.pickerView selectedRowInComponent:0] forComponent:0]];
        NSString *str1 = [NSString stringWithFormat:@"%@",[self pickerView:self.pickerView titleForRow:[self.pickerView selectedRowInComponent:1] forComponent:1]];
        NSString *str2 = [NSString stringWithFormat:@"%@",[self pickerView:self.pickerView titleForRow:[self.pickerView selectedRowInComponent:2] forComponent:2]];
        NSString *String = [NSString stringWithFormat:@"%@ %@:%@",str,[str1 substringToIndex:2],[str2 substringToIndex:2]];
        NSInteger da = [self.pickerView selectedRowInComponent:0];
        NSString *date = [NSString stringWithFormat:@"%@ %@:%@",_standardArray[da],[str1 substringToIndex:2],[str2 substringToIndex:2]];
        
        NSDictionary *dict = @{@"displayTime":String,@"standardTime":date};
        
        if (_selectBlock) {
            _selectBlock(dict);
        }
    }
}

- (void)initData{
    _standardArray = [NSMutableArray array];
    //重现在开始的时间
    _dayArray     = [MyTimeTool daysFromNowToDeadLine];
    _showDayArray = [self genShowDayArrayByDayArray:_dayArray];
    _hourArray    = [self validHourArray];
    _minuteArray  = [self validMinuteArray];
    
    //    YBLog(@"%@-----------%@-----------%@-----------%@",_dayArray,_showDayArray,_hourArray,_minuteArray  );
}

- (NSArray *)genShowDayArrayByDayArray:(NSArray *)dayArray{
    
    NSUInteger arrayCount = dayArray.count;
    if(arrayCount == 1) return ONEDAYARRAY;
    if(arrayCount == 2) return TWODAYARRAY;
    if(arrayCount == 3) return THREEDAYARRAY;
    NSMutableArray *showDayArray = [NSMutableArray arrayWithArray:THREEDAYARRAY];
    
    NSMutableArray *dateArray = [NSMutableArray array];
    for (NSString *date in dayArray) {
        NSArray *arrat = [date componentsSeparatedByString:@"-"];
        NSString *str = [NSString stringWithFormat:@"%@%@%@",arrat[1],arrat[2],arrat[3]];
        [dateArray addObject:str];
        
        NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@",arrat[0],arrat[1],arrat[2]];
        [_standardArray addObject:dateStr];
    }
    
    NSArray *tmpArray = [dateArray subarrayWithRange:NSMakeRange(3, arrayCount - 3)];
    for (int i = 0; i< tmpArray.count; i++) {
        [showDayArray addObject:[MyTimeTool displayedSummaryTimeUsingString:tmpArray[i]]];
    }
    return showDayArray;
}

#pragma mark - 有效的小时数
- (NSArray *)validHourArray
{
    NSInteger startIndex = [MyTimeTool currentDateHour];
    if ([MyTimeTool currentDateMinute] >= 40) startIndex++;//当前分钟大于50 分钟选择小时
    return [HOURARRAY subarrayWithRange:NSMakeRange(startIndex, HOURARRAY.count - startIndex)];
}

#pragma Mark - 有效的分钟数
- (NSArray *)validMinuteArray
{
    NSInteger startIndex = [MyTimeTool currentDateMinute] / 10 + 2;
    if (50 > [MyTimeTool currentDateMinute] && [MyTimeTool currentDateMinute] >= 40) startIndex = 0;//当前分钟数大于40
    if ([MyTimeTool currentDateMinute] >= 50) startIndex = 1;//当前分钟数大于50
    return [MINUTEARRAY subarrayWithRange:NSMakeRange(startIndex, MINUTEARRAY.count - startIndex)];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return self.showDayArray.count;
        case 1:
            return self.hourArray.count;
        case 2:
            return self.minuteArray.count;
        default:
            return 0;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    NSInteger firstComponentSelectedRow = [self.pickerView selectedRowInComponent:0];
    if (firstComponentSelectedRow == 0) {
        _hourArray = [self validHourArray];
        _minuteArray = [self validMinuteArray];
        NSInteger secondComponentSelectedRow = [self.pickerView selectedRowInComponent:1];
        if (secondComponentSelectedRow == 0 || component ==0) {
            _minuteArray = [self validMinuteArray];
            //            if(component == 1) [self.pickerView selectRow:0 inComponent:2 animated:YES];
        }else{
            _minuteArray = MINUTEARRAY;
        }
    }else{
        _hourArray = HOURARRAY;
        _minuteArray = MINUTEARRAY;
    }
    [self.pickerView reloadAllComponents];
    
    //当第一列滑到第一个位置时，第二，三列滚回到0位置
    if(component == 0){
        [self.pickerView selectRow:0 inComponent:1 animated:YES];
        [self.pickerView selectRow:0 inComponent:2 animated:YES];
    }
    
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (component==0) {
        return [self.showDayArray objectAtIndex:row];
    }else if (component==1){
        return [[self.hourArray objectAtIndex:row] substringToIndex:2];
    }else{
        return [[self.minuteArray objectAtIndex:row] substringToIndex:2];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *label;
    if (view) {
        label = (UILabel *)view;
    }else{
        label = [[UILabel alloc] init];
    }
    label.textAlignment = NSTextAlignmentCenter;
    switch (component) {
        case 0:
            label.text = self.showDayArray[row];
            break;
        case 1:
            label.text = self.hourArray[row];
            break;
        case 2:
            label.text = self.minuteArray[row];
            break;
        default:
            break;
    }
    
    return label;
}

//view的宽度
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return self.frame.size.width / 3.0;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 44;
}


@end

