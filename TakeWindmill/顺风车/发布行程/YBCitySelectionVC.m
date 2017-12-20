//
//  YBCitySelectionVC.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/29.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBCitySelectionVC.h"
#import "YBAddressSearchSelectionVC.h"
#import "YBNearbyPassengersVC.h"

#import "YBSearchColumnView.h"


@interface CitySearchView : UIView

/**
 * 城市输入
 */
@property (nonatomic, weak) UITextField *cityText;

/**
 * 选择位置
 */
@property (nonatomic, weak) UIButton *positionButton;

/**
 * 取消按钮
 */
@property (nonatomic, weak) UIButton *cancelButton;

/**
 * 线条
 */
@property (nonatomic, weak) UIView *line;



@end

@implementation CitySearchView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        UITextField *cityText = [[UITextField alloc] init];
        [self addSubview:cityText];
        self.cityText = cityText;
        
        UIButton *positionButton = [[UIButton alloc] init];
        [self addSubview:positionButton];
        self.positionButton = positionButton;
        
        UIButton *cancelButton = [[UIButton alloc] init];
        [self addSubview:cancelButton];
        self.cancelButton = cancelButton;
        
        UIView *line = [[UIView alloc] init];
        [self addSubview:line];
        self.line = line;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.cityText.frame = CGRectMake(10, 29, YBWidth / 2 - 35, 30);
    self.cityText.borderStyle = UITextBorderStyleNone;
    self.cityText.font = YBFont(14);
    self.cityText.placeholder = @"城市中文名或拼音";
    
    self.positionButton.frame = CGRectMake(CGRectGetMaxX(self.cityText.frame), 29, YBWidth / 2 - 35, 30);
    self.positionButton.titleLabel.font = YBFont(14);
    [self.positionButton setTitle:@"你要去哪儿" forState:UIControlStateNormal];
    [self.positionButton setTitleColor:TxetFiedColor forState:UIControlStateNormal];
    
    self.line.frame = CGRectMake(CGRectGetMaxX(self.positionButton.frame), 29, 1, 20);
    self.line.backgroundColor = LightGreyColor;
  
    self.cancelButton.frame = CGRectMake(CGRectGetMaxX(self.line.frame), 29, 60, 30);
    self.cancelButton.titleLabel.font = YBFont(14);
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
}

@end

@interface YBCitySelectionVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, weak) UITableView *addresstableView;

//搜索框
@property (nonatomic, strong) CitySearchView *searchView;

//当前位置
@property (nonatomic, strong) UIButton *currentLocation;

//城市列表
@property (nonatomic, strong) NSMutableArray *cityArray;
//索引列表
@property (nonatomic, strong) NSMutableArray *indexSourceArr;
//索引列表
@property (nonatomic, strong) NSMutableArray *popularArr;

@end

@implementation YBCitySelectionVC

#pragma mark - lazy
//- (UIButton *)currentLocation {
//    if (!_currentLocation) {
//        _currentLocation = [[UIButton alloc] initWithFrame:CGRectMake(10, 74, YBWidth - 20, 30)];
//        _currentLocation sett
//    }
//}

- (UITableView *)addresstableView {
    if (!_addresstableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 74, YBWidth - 20, YBHeight - 10) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.rowHeight = 60;
        [self.view addSubview:tableView];
        
        _addresstableView = tableView;
    }
    return _addresstableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = LightGreyColor;
    //搜索
    [self searchViewAction];
    
    [self popularCityRequest];

}

- (void)popularCityRequest {
    
    self.popularArr = [NSMutableArray array];
    self.cityArray = [NSMutableArray array];
    self.indexSourceArr = [NSMutableArray array];

    NSString *URLStr = baseareahotinfolistPath;
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    
    [YBRequest postWithURL:URLStr MutableDict:dict success:^(id dataArray) {
        
        if ([dataArray[@"HasError"] intValue] == 0) {
            NSMutableArray *array = [NSMutableArray array];
            array = dataArray[@"BaseAreaInfoList"];
            [self.popularArr addObject:array];
            
            //请求城市列表
            [self searchCityDataStr:nil];
        }
    } failure:^(id dataArray) {
    }];

}

- (void)searchCityDataStr:(NSString *)str {
    
    NSString *URLStr = baseareainfolistPath;
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    
    if (str) {
        [dict setObject:str forKey:@"areaname"];
    }
    [self.cityArray removeAllObjects];
    
    [YBRequest postWithURL:URLStr MutableDict:dict View:_addresstableView success:^(id dataArray) {
        
//        YBLog(@"%@",dataArray);
        if ([dataArray[@"HasError"] intValue] == 0) {
            NSMutableArray *array = [NSMutableArray array];
            array = dataArray[@"BaseAreaInfoList"];
            self.cityArray = [self sortArray:array];
            
            [self.addresstableView reloadData];
        }
    } failure:nil];
}

#pragma marlk - 排序
- (NSMutableArray *)sortArray:(NSMutableArray *)originalArray
{
    NSMutableArray *array = [NSMutableArray array];
    
    //根据拼音对数组排序
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"LetterIndex" ascending:YES]];
    //排序
    [originalArray sortUsingDescriptors:sortDescriptors];

    NSMutableArray *tempArray = nil;
    BOOL flag = NO;
    
    [self.indexSourceArr removeAllObjects];
    
    [self.indexSourceArr setObject:@"★" atIndexedSubscript:0];
    //分组
    for (int i = 0;i < originalArray.count; i++) {
        NSString *pinyin = [originalArray[i] objectForKey:@"LetterIndex"];
        NSString *firstChar = [pinyin substringToIndex:1];
        if (![self.indexSourceArr containsObject:[firstChar uppercaseString]]) {
            [self.indexSourceArr addObject:[firstChar uppercaseString]];
            tempArray = [[NSMutableArray alloc]init];
            flag = NO;
        }

        if ([self.indexSourceArr containsObject:[firstChar uppercaseString]]) {
            [tempArray addObject:originalArray[i]];
            if (flag == NO) {
                [array addObject:tempArray];
                flag = YES;
            }
        }
    }
    return array;
}


- (void)searchViewAction {
    //搜索
    self.searchView = [[CitySearchView alloc] initWithFrame:CGRectMake(0, 0, YBWidth, 64)];
    [self.view addSubview:self.searchView];
    self.searchView.cityText.delegate = self;
    self.searchView.cityText.returnKeyType =UIReturnKeyDone;
    
    [self.searchView.positionButton addTarget:self action:@selector(positionButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    [self.searchView.cancelButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [YBTooler setTheControlShadow:self.searchView];

}

- (void)positionButtonAction:(UIButton *)sender {

    [self dismissViewControllerAnimated:NO  completion:nil];
}

- (void)backAction:(UIButton *)sender {

    if (self.isPush == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self searchCityDataStr:textField.text];
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cityArray.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [self.popularArr[section] count];
    }
    return [self.cityArray[section - 1] count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0,YBWidth, 30)];
    view.backgroundColor = LineLightColor;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, self.addresstableView.frame.size.width , 20)];
    label.text =  [_indexSourceArr objectAtIndex:section];
    if (section == 0) {
        label.text =  [NSString stringWithFormat:@"%@热门城市",[_indexSourceArr objectAtIndex:section]];
    }
    label.textColor = [UIColor grayColor];
    label.font = YBFont(14);
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.indexSourceArr;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *cellIndentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = [[self.popularArr[indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"AreaName"];
    }else {
        cell.textLabel.text = [[self.cityArray[indexPath.section - 1] objectAtIndex:indexPath.row] objectForKey:@"AreaName"];
    }
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.cross_City isEqualToString:@"跨城"]) {
        YBAddressSearchSelectionVC *selection = [[YBAddressSearchSelectionVC alloc] init];
        if (indexPath.section == 0) {
            selection.cityname = [[self.popularArr[indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"AreaName"];
        }else {
            selection.cityname = [[self.cityArray[indexPath.section - 1] objectAtIndex:indexPath.row] objectForKey:@"AreaName"];
        }
        [self presentViewController:selection animated:NO completion:nil];
        return;
    }
    
    NSDictionary *dict;
    if (indexPath.section == 0) {
        dict = @{@"city": [[self.popularArr[indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"AreaName"]};
    }else {
        dict = @{@"city": [[self.cityArray[indexPath.section - 1] objectAtIndex:indexPath.row] objectForKey:@"AreaName"]};
    }
    if (self.cityDelegate && [self.cityDelegate respondsToSelector:@selector(popViewControllerPassTheValueDict:)]) {
        [self.cityDelegate popViewControllerPassTheValueDict:dict];
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
