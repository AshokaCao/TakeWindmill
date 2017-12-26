//
//  YBCommonAddressVC.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/12/12.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBCommonAddressVC.h"
#import "YBInformationCell.h"
#import "YBAddressSearchSelectionVC.h"

@interface YBCommonAddressVC ()<UITableViewDelegate,UITableViewDataSource,YBAddressSearchSelectionVCDelegate>
{
    NSIndexPath *selectIndexPath;
}
@property (nonatomic,strong) UITableView *identityTabView;
/**
 * 起点位置信息
 */
@property (nonatomic, strong) NSDictionary *startingPointDict;

@property(nonatomic,strong) NSMutableArray * addressArray;
@property(nonatomic,strong) NSMutableDictionary * addressDic;

@end

@implementation YBCommonAddressVC
static NSArray *textArray;
static NSArray *imageArray;

-(UITableView *)identityTabView
{
    if (_identityTabView == nil) {
        _identityTabView = [[UITableView alloc]init];
        _identityTabView.backgroundColor = LightGreyColor;
        _identityTabView.showsVerticalScrollIndicator = NO;
        _identityTabView.showsHorizontalScrollIndicator = NO;
        //_identityTabView.scrollEnabled = NO;
        _identityTabView.delegate = self;
        _identityTabView.dataSource = self;
        [self.view addSubview:_identityTabView];
    }
    return _identityTabView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"常用地址";
    // 初始化NSMutableArray集合
    self.addressArray = [NSMutableArray array];
    self.addressDic = [NSMutableDictionary dictionary];
    textArray = [NSArray arrayWithObjects:@"家",@"公司",@"常用1",@"常用2", nil];
    imageArray = [NSArray arrayWithObjects:@"jia",@"gongsi",@"常用路线",@"常用路线", nil];
    [self setData];
    [self setUI];
    
}

-(void)setUI{
    [self.view addSubview:self.identityTabView];
    [self.identityTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    UIButton *rigButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [rigButton setTitle:@"删除" forState:UIControlStateNormal];
    [rigButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rigButton addTarget:self action:@selector(rigButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    rigButton.titleLabel.font = YBFont(14);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rigButton];

}
-(void)rigButtonAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.identityTabView setEditing:YES animated:YES];
        [sender setTitle:@"确定" forState:UIControlStateNormal];
    }else{
         [self.identityTabView setEditing:NO animated:YES];
         [sender setTitle:@"删除" forState:UIControlStateNormal];
    }
   
}
#pragma mark - 数据源方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return  4;
    //return _addressArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSString *cellIndentifier = [NSString stringWithFormat:@"cell%ld%ld",indexPath.section,indexPath.row];
    static NSString * cellIndentifier = @"cellIndentifier";
    YBInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[YBInformationCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndentifier];
    }
    //去掉底部多余的表格线
    [tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
   
    cell.imageView.image = [UIImage imageNamed:imageArray[indexPath.row]];
    cell.textLabel.text = textArray[indexPath.row];
    
   
    NSInteger type = indexPath.row+1;
    NSString * address = [self.addressDic objectForKey:[HSHString toString:type]];
    
    YBLog(@"address==%@,type==%ld,addressDic==%@",address,type,self.addressDic);
    cell.detailTextLabel.text = address.length>0 ? address : [NSString stringWithFormat:@"设置%@的地址",cell.textLabel.text];
    
    //设置 选择 图标
    //cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    cell.textField.userInteractionEnabled = NO;
    //设置 选中 cell的状态
    //cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    return cell;
}
#pragma mark - 代理方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    YBInformationCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    selectIndexPath = indexPath;
    
    YBAddressSearchSelectionVC *selec = [[YBAddressSearchSelectionVC alloc] init];
    selec.typesOf                     = @"终点";
    selec.addDelegate                 = self;
    selec.cityname = self.startingPointDict[@"City"] ? self.startingPointDict[@"City"] : @"杭州";
    [self presentViewController:selec animated:YES completion:nil];

}
// 该方法的返回值作为删除指定表格行时确定按钮的文本
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:
(NSIndexPath *)indexPath{
    return @"删除";
}
// UITableViewDataSource协议中定义的方法。该方法的返回值决定某行是否可编辑
- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:
(NSIndexPath *)indexPath
{
    return YES;
}
//设置具体的编辑操作（新增，删除）
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //NSLog(@"-----删除------%ld",indexPath.row);
    ////删除对应数据
//    [_addressArray removeObjectAtIndex:indexPath.row];
    [self.addressDic setObject:@"" forKey:[HSHString toString:indexPath.row+1]];
    [self deleteAddressInformationTypefid:indexPath.row+1];
    
    
    // tableView刷新方式1    重新加载tableView，没有动画效果
    [tableView reloadData];
    
    //tableView刷新方式2    设置tableView带动画效果 删除数据
//    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]  withRowAnimation:UITableViewRowAnimationFade];
    
    //取消编辑状态
    [tableView setEditing:NO animated:YES];
    
}
// 通过本方法返回删除(UITableViewCellEditingStyleDelete)或者新增(UITableViewCellEditingStyleInsert);
// 若不实现此方法，则默认为删除模式。
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    //表示支持默认操作
    //return UITableViewCellEditingStyleNone;
    //表示支持删除操作
    return UITableViewCellEditingStyleDelete;
    //表示支持新增操作
    //return UITableViewCellEditingStyleInsert;
}

//分割线
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark YBAddressSearchSelectionVCDelegate
- (void)popViewControllerPassTheValue:(NSDictionary *)value{
    //YBLog(@"value==%@",value);
    
    [self.addressDic setObject:value[@"Name"] forKey:[HSHString toString:selectIndexPath.row+1]];
    [self.identityTabView reloadData];
    
    
    [self uploadAddressInformation:value];
    
}
//返回反地理编码搜索结果
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:result.cityCode forKey:@"CityId"];
    [dict setObject:[NSString stringWithFormat:@"%f",result.location.longitude] forKey:@"Lng"];
    [dict setObject:result.address forKey:@"Address"];
    [dict setObject:result.addressDetail.district forKey:@"District"];
    [dict setObject:[NSString stringWithFormat:@"%f",result.location.latitude] forKey:@"Lat"];
    [dict setObject:result.sematicDescription forKey:@"Name"];
    [dict setObject:result.addressDetail.city forKey:@"City"];
    
    self.startingPointDict = dict;
}
#pragma mark - 获取家和公司
-(void)setData{
    WEAK_SELF;
    //获取家和公司
    NSString *urlStr = commonaddresslistPath;
    NSMutableDictionary *mutableDict = [YBTooler dictinitWithMD5];
    [mutableDict setObject:[YBTooler getTheUserId:self.view] forKey:@"userid"];//关键字
    
    [YBRequest postWithURL:urlStr MutableDict:mutableDict success:^(id dataArray) {
        //YBLog(@"%@",dataArray);
        if ([dataArray[@"CommonAddressList"] count] != 0) {// 如果没有设置返回为空
            weakSelf.addressArray = dataArray[@"CommonAddressList"];
            for (int i = 0; i<weakSelf.addressArray.count; i++) {
                
                NSString *typeFID =  weakSelf.addressArray[i][@"TypeFID"];
                [weakSelf.addressDic setValue:[HSHString IsNotNull:weakSelf.addressArray[i][@"Address"]] forKey:[HSHString toString:typeFID.integerValue]];
            }
            [weakSelf.identityTabView reloadData];
        }
        
    } failure:^(id dataArray) {
        [MBProgressHUD showError:dataArray[@"ErrorMessage"] toView:weakSelf.view];
    }];
}
#pragma mark - 上传地址信息
- (void)uploadAddressInformation:(NSDictionary *)dict
{
    WEAK_SELF;
    //获取家和公司位置
    NSString *urlStr = commonaddresssavePath;
    NSMutableDictionary *mutableDict = [YBTooler dictinitWithMD5];
    [mutableDict setObject:[YBTooler getTheUserId:self.view] forKey:@"userid"];//用户Id
    [mutableDict setObject:dict[@"Lng"] forKey:@"lng"];//经度
    [mutableDict setObject:dict[@"Lat"]  forKey:@"lat"];//纬度
    [mutableDict setObject:dict[@"CityId"] forKey:@"cityid"];//城市id
    [mutableDict setObject:dict[@"City"] forKey:@"city"];//城市
    [mutableDict setObject:dict[@"Name"] forKey:@"address"];//地址
    [mutableDict setObject:[HSHString toString:selectIndexPath.row+1] forKey:@"typefid"];//1-家，2-公司，3-常用1，4-常用2
    
    [YBRequest postWithURL:urlStr MutableDict:mutableDict success:^(id dataArray) {
        //YBLog(@"%@",dataArray);
        [MBProgressHUD showError:@"编辑地址成功" toView:weakSelf.view];
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    } failure:^(id dataArray) {
        [MBProgressHUD showError:dataArray[@"ErrorMessage"] toView:weakSelf.view];
    }];
}
#pragma mark - //删除家和公司
- (void)deleteAddressInformationTypefid:(NSInteger)typefid
{
    NSString *urlStr = commonaddressdeletePath;
    NSMutableDictionary *mutableDict = [YBTooler dictinitWithMD5];
    NSString * null = @"";
    
    [mutableDict setObject:[YBTooler getTheUserId:self.view] forKey:@"userid"];//用户Id
    [mutableDict setObject:null forKey:@"lng"];//经度
    [mutableDict setObject:null  forKey:@"lat"];//纬度
    [mutableDict setObject:null forKey:@"cityid"];//城市id
    [mutableDict setObject:null forKey:@"city"];//城市
    [mutableDict setObject:null forKey:@"address"];//地址
    [mutableDict setObject:[HSHString toString:typefid] forKey:@"typefid"];//1-家，2-公司，3-常用1，4-常用2
    WEAK_SELF;
    [YBRequest postWithURL:urlStr MutableDict:mutableDict success:^(id dataArray) {
        //YBLog(@"%@",dataArray);
        [MBProgressHUD showError:@"删除成功" toView:weakSelf.view];
    } failure:^(id dataArray) {
        [MBProgressHUD showError:dataArray[@"ErrorMessage"] toView:weakSelf.view];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
