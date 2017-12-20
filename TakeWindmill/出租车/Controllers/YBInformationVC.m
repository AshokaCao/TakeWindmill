//
//  YBInformationVC.m
//  TakeWindmill
//
//  Created by HUSHOUHUA华 on 2017/11/18.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBInformationVC.h"
#import "YBInformationHederSubView.h"
#import "YBInformationCell.h"
#import "YBInformationModel.h"
#import "YBSuccessViewController.h"

@interface YBInformationVC ()<UITableViewDelegate,UITableViewDataSource,HXPhotoViewControllerDelegate>
{
    //    NSInteger index ;
    NSInteger tabIndex ;
    YBInformationCell *infoCell;
    YBInformationModel *modelSever;
    NSString *vehiclemanpicpath;
    NSInteger carSection;
}
@property (nonatomic,strong)UIView * headerView;
@property (nonatomic,strong)UIButton *nextStepBtn;
@property(nonatomic,strong)UIScrollView *scrollView;

@property (nonatomic,strong) UITableView *identityTabView;
@property (nonatomic,strong) UITableView *companyTabView;
@property (nonatomic,strong) UITableView *carTabView;
@property (nonatomic,strong) UITableView *workTabView;

@property (nonatomic,strong) HXPhotoManager *manager;
@property (nonatomic,strong) NSMutableArray * imagesArrUrl;

@end

@implementation YBInformationVC
// 懒加载 照片管理类
- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.openCamera = YES;
        _manager.style = HXPhotoAlbumStylesSystem;
        _manager.photoMaxNum = 1;
        // _manager.videoMaxNum = 1;
        _manager.maxNum = 1;
    }
    return _manager;
}
-(UITableView *)identityTabView
{
    if (_identityTabView == nil) {
        _identityTabView = [[UITableView alloc]init];
        _identityTabView.backgroundColor = LightGreyColor;
        _identityTabView.showsVerticalScrollIndicator = NO;
        _identityTabView.showsHorizontalScrollIndicator = NO;
        _identityTabView.scrollEnabled = NO;
        _identityTabView.delegate = self;
        _identityTabView.dataSource = self;
        [self.view addSubview:_identityTabView];
    }
    return _identityTabView;
}
-(UITableView *)companyTabView
{
    if (_companyTabView == nil) {
        _companyTabView = [[UITableView alloc]init];
        _companyTabView.backgroundColor = LightGreyColor;
        _companyTabView.showsVerticalScrollIndicator = NO;
        _companyTabView.showsHorizontalScrollIndicator = NO;
        _companyTabView.delegate = self;
        _companyTabView.dataSource = self;
        [self.view addSubview:_companyTabView];
    }
    return _companyTabView;
}
-(UITableView *)carTabView
{
    if (_carTabView == nil) {
        _carTabView = [[UITableView alloc]init];
        _carTabView.backgroundColor = LightGreyColor;
        _carTabView.showsVerticalScrollIndicator = NO;
        _carTabView.showsHorizontalScrollIndicator = NO;
        _carTabView.scrollEnabled = NO;
        _carTabView.delegate = self;
        _carTabView.dataSource = self;
        [self.view addSubview:_carTabView];
    }
    return _carTabView;
}
-(UITableView *)workTabView
{
    if (_workTabView == nil) {
        _workTabView = [[UITableView alloc]init];
        _workTabView.backgroundColor = LightGreyColor;
        _workTabView.showsVerticalScrollIndicator = NO;
        _workTabView.showsHorizontalScrollIndicator = NO;
        _workTabView.delegate = self;
        _workTabView.dataSource = self;
        [self.view addSubview:_workTabView];
    }
    return _workTabView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"身份信息";
    self.view.backgroundColor = LightGreyColor;
    self.imagesArrUrl = [NSMutableArray array];
    [self setUI];
    [self addIdentityTabView];
    [self requestData];
}
-(void)requestData{
    WEAK_SELF;
    NSMutableDictionary *parm = [YBTooler dictinitWithMD5];
    NSString *userID = [YBUserDefaults valueForKey:_userId];
    parm[@"userid"] = userID;
    
    [YBRequest postWithURL:UserUserinfodetailbyuserid MutableDict:parm success:^(id dataArray) {
        //YBLog(@"dataArray==%@",dataArray);
        modelSever = [YBInformationModel yy_modelWithJSON:dataArray];
        [weakSelf.identityTabView reloadData];
        
    } failure:^(id dataArray) {
        //YBLog(@"failureDataArray==%@",dataArray);
        [MBProgressHUD showError:dataArray[@"ErrorMessage"] toView:weakSelf.view];
    }];
    
    
}
-(void)setUI{
    WEAK_SELF;
    CGSize subSize = CGSizeMake(60, 40);
    CGFloat headerViewH = 80;
    
    NSArray * textArray = [NSArray arrayWithObjects:@"身份信息",@"公司信息", @"车辆信息", @"从业信息",  nil];
    NSArray * numberArray = [NSArray arrayWithObjects:@"1",@"2", @"3", @"4",  nil];
    
    UIView * headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(headerViewH);
    }];
    self.headerView = headerView;
    
    NSMutableArray * viewArr = [NSMutableArray array];
    for (int i=0; i<textArray.count; i++) {
        YBInformationHederSubView *identityInfo = [[YBInformationHederSubView alloc]init];
        identityInfo.tag = i+1;
        identityInfo.text.text = textArray[i];
        identityInfo.number.text = numberArray[i];
        [headerView addSubview:identityInfo];
        [viewArr addObject:identityInfo];
    }
    CGFloat padding = 10;//269  182
    // 控件size不变,变化的是间隙
    [viewArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:subSize.width leadSpacing:padding tailSpacing:padding];
    [viewArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView);
        make.size.mas_equalTo(subSize);
    }];
    
    UIView * line = [[UIView alloc]init];
    line.backgroundColor = LightGreyColor;
    [headerView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        YBInformationHederSubView *view = viewArr[0];
        [view configColor];
        YBInformationHederSubView *view1 = viewArr[1];
        make.centerY.equalTo(headerView);
        make.left.equalTo(view.mas_right);
        make.right.equalTo(view1.mas_left);
        make.height.mas_equalTo(1);
    }];
    
    line = [[UIView alloc]init];
    line.backgroundColor = LightGreyColor;
    [headerView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        YBInformationHederSubView *view = viewArr[1];
        YBInformationHederSubView *view1 = viewArr[2];
        make.centerY.equalTo(headerView);
        make.left.equalTo(view.mas_right);
        make.right.equalTo(view1.mas_left);
        make.height.mas_equalTo(1);
    }];
    
    line = [[UIView alloc]init];
    line.backgroundColor = LightGreyColor;
    [headerView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        YBInformationHederSubView *view = viewArr[2];
        YBInformationHederSubView *view1 = viewArr[3];
        make.centerY.equalTo(headerView);
        make.left.equalTo(view.mas_right);
        make.right.equalTo(view1.mas_left);
        make.height.mas_equalTo(1);
    }];
    
    UIButton *nextStepBtn = [[UIButton alloc]init];
    [nextStepBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextStepBtn setBackgroundColor:BtnBlueColor];
    nextStepBtn.layer.cornerRadius = 5;
    [nextStepBtn addTarget:self action:@selector(nextStepBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextStepBtn];
    [nextStepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.width.mas_equalTo(YBWidth-30);
        make.height.mas_equalTo(40);
        make.bottom.equalTo(self.view).offset(-30);
    }];
    self.nextStepBtn = nextStepBtn;
    
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headerView.mas_bottom);
        make.width.mas_equalTo(YBWidth);
        make.bottom.equalTo(weakSelf.nextStepBtn.mas_top);
    }];
    self.scrollView = scrollView;
    
}
-(void)addIdentityTabView{
    WEAK_SELF;
    [self.scrollView addSubview:self.identityTabView];
    [self.identityTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.scrollView);
        make.width.mas_equalTo(YBWidth);
        make.height.mas_equalTo(YBHeight-headerH*2);
    }];
    [weakSelf.identityTabView reloadData];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.identityTabView.mas_bottom).offset(10);
    }];
}
-(void)addCompanyTabView{
    WEAK_SELF;
    [self.identityTabView removeFromSuperview];
    self.identityTabView = nil;
    tabIndex = 1;
    self.title = @"公司信息";
    for (int i = 1; i<tabIndex+2; i++) {
        YBInformationHederSubView *view = [self.headerView viewWithTag:i];
        [view configColor];
    }
    
    [self.view addSubview:self.companyTabView];
    [self.companyTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headerView.mas_bottom);
        make.left.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.nextStepBtn.mas_top);
    }];
    [self.companyTabView reloadData];
}
-(void)addCarTabView{
    WEAK_SELF;
    [self.companyTabView removeFromSuperview];
    self.companyTabView = nil;
    tabIndex = 2;
    self.title = @"车辆信息";
    for (int i = 1; i<tabIndex+2; i++) {
        YBInformationHederSubView *view = [self.headerView viewWithTag:i];
        [view configColor];
    }
    
    [self.scrollView addSubview:self.carTabView];
    [self.carTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.scrollView);
        make.width.mas_equalTo(YBWidth);
        make.height.mas_equalTo(headerH*3+30*2+50*3+80*2 +50);
    }];
    [self.carTabView reloadData];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.carTabView.mas_bottom).offset(10);
    }];
    //[self.scrollView setContentSize:CGSizeMake(YBWidth, YBHeight)];
    
}
-(void)addWorkTabView{
    WEAK_SELF;
    [self.carTabView removeFromSuperview];
    self.carTabView = nil;
    tabIndex = 3;
    self.title = @"从业信息";
    [self.nextStepBtn setTitle:@"提交注册信息" forState:UIControlStateNormal];
    for (int i = 1; i<tabIndex+2; i++) {
        YBInformationHederSubView *view = [self.headerView viewWithTag:i];
        [view configColor];
    }
    
    [self.view addSubview:self.workTabView];
    [self.workTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headerView.mas_bottom);
        make.left.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.nextStepBtn.mas_top);
    }];
    [self.workTabView reloadData];
}
#pragma mark 下一步
-(void)nextStepBtnTap:(UIButton *)sender{
    //    userid //用户id
    //    userpwd //密码
    //    mobile //手机号
    //    username //用户名
    //    verifycode //验证码
    //    userflag //用户等级
    //    usertype //用户类型:普通用户0 车主1
    //    nickname //昵称
    //    sex { set; get; } //性别
    //    age //年龄
    //    headimgurl { set; get; } //头像地址
    //    profession { set; get; }
    //    enterprise { set; get; }
    //    personalsign { set; get; }
    //    userip
    //    isverify { get; set; }
    //    realname //真实姓名
    //    identitycard //身份证号
    //    vehicleseriessysno //车辆序列sysno
    //    vehiclecolorsysno //车辆颜色sysno
    //    driverlicensetime //驾照领证日期
    //    driverlicensepicpath //驾驶证图片地址
    //    vehiclenumber //车牌号码
    //    vehicleregtime //车辆注册时间
    //    platenumberlocation //车牌号所在地
    //    vehicleowername //车辆所有人
    //    vehiclelicensenumber //行驶证号码
    //    vehiclelicensepicpath //行驶证图片地址
    //    vehicleprovince //车辆所属省
    //    vehiclecity //车辆所属市
    //    vehiclecounty //车辆所属县（区）
    //    taxicompany //出租车公司
    //    vehiclemanpicpath //人车合影图片地址
    //    servicecertificateno //服务资格证号
    //    servicecertificatevalidtime //服务资格证有效期
    //    servicecertificatepicpath //服务资格证图片地址
    
    WEAK_SELF;
    NSMutableDictionary *parm = [YBTooler dictinitWithMD5];
    NSString *userID = [YBUserDefaults valueForKey:_userId];
    parm[@"userid"] = userID;
    
    if (tabIndex == 0) {
        NSMutableArray * mArr = [NSMutableArray array];
        int nn = 0;
        for (int i = 0; i<3; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
            YBInformationCell *infoCell = [weakSelf.identityTabView cellForRowAtIndexPath:indexPath];
            if (infoCell.textField.text.length == 0) {
                nn = 1;
            }else{
                [mArr addObject:infoCell.textField.text];
            }
        }
        
        if (nn == 1 ||  (weakSelf.imagesArrUrl.count == 0&&modelSever.HeadImgUrl.length==0)) {
            [MBProgressHUD showError:@"请完善信息" toView:self.view];
            return;
        }
        
        if (weakSelf.imagesArrUrl.count>0) {
            parm[@"headimgurl"] = [weakSelf.imagesArrUrl firstObject]; //头像信息
        }
        parm[@"realname"] = mArr[0];
        parm[@"identitycard"] = mArr[1];
        parm[@"driverlicensetime"] = mArr[2];
        
        [weakSelf addCompanyTabView];//公司
        
        
    }else if (tabIndex == 1){//车辆
        NSMutableArray * mArr = [NSMutableArray array];
        int nn = 0;
        for (int i = 0; i<2; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            YBInformationCell *infoCell = [weakSelf.companyTabView cellForRowAtIndexPath:indexPath];
            if (infoCell.textField.text.length == 0) {
                nn = 1;
            }else{
                [mArr addObject:infoCell.textField.text];
            }
        }
        if (nn == 1) {
            [MBProgressHUD showError:@"请完善信息" toView:self.view];
            return;
        }
        parm[@"vehiclecounty"] = mArr[0];
        parm[@"taxicompany"] = mArr[1];
        
        [weakSelf addCarTabView];//车辆
        
    }else if (tabIndex == 2){//从业
        NSMutableArray * mArr = [NSMutableArray array];
        int nn = 0;
        for (int i = 0; i<3; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            YBInformationCell *infoCell = [weakSelf.carTabView cellForRowAtIndexPath:indexPath];
            YBLog(@"infoCell.textField.text==%@",infoCell.textField.text);
            if (infoCell.textField.text.length == 0) {
                nn = 1;
            }else{
                if (i == 0) {
                    [mArr addObject:infoCell.btnCity.titleLabel.text];
                    [mArr addObject:infoCell.btnAZ.titleLabel.text];
                }
                [mArr addObject:infoCell.textField.text];
            }
        }
        
        if (nn == 1 ||
            (weakSelf.imagesArrUrl.count == 0&&modelSever.VehicleLicensePicPath.length==0) ||
            ( vehiclemanpicpath.length == 0&& modelSever.VehicleManPicPath.length==0)) {
            [MBProgressHUD showError:@"请完善信息" toView:self.view];
            return;
        }
        
        if (![HSHString isPureInt:mArr[2]]) {
            [MBProgressHUD showError:@"车牌号码输入有误" toView:self.view];
            return;
        }
        
        parm[@"vehiclenumber"] = [NSString stringWithFormat:@"%@%@%@",mArr[0],mArr[1],mArr[2]];//车牌号码
        parm[@"vehicleregtime"] = mArr[3];
        parm[@"vehicleowername"] = mArr[4];
        if (weakSelf.imagesArrUrl.count) {
            parm[@"vehiclelicensepicpath"] = [self.imagesArrUrl firstObject];
        }
        if (vehiclemanpicpath.length) {
            parm[@"vehiclemanpicpath"] = vehiclemanpicpath;
        }
        
        [self addWorkTabView];//从业
    }else if (tabIndex == 3 ||  tabIndex == 4){
        NSMutableArray * mArr = [NSMutableArray array];
        int nn = 0;
        for (int i = 0; i<2; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            YBInformationCell *infoCell = [weakSelf.workTabView cellForRowAtIndexPath:indexPath];
            if (infoCell.textField.text.length == 0) {
                nn = 1;
            }else{
                [mArr addObject:infoCell.textField.text];
            }
        }
        if (nn == 1 ||
            (weakSelf.imagesArrUrl.count == 0&&modelSever.ServiceCertificatePicPath.length==0)) {
            [MBProgressHUD showError:@"请完善信息" toView:self.view];
            return;
        }
        
        parm[@"servicecertificateno"] = mArr[0];
        parm[@"servicecertificatevalidtime"] = mArr[1];
        if (weakSelf.imagesArrUrl.count) {
            parm[@"servicecertificatepicpath"] = [self.imagesArrUrl firstObject];
        }
        
        tabIndex = 4;
    }
    
    NSLog(@"url =%@",UserTaxidriverinfosave);
    NSLog(@"parm =%@",parm);
    
    [YBRequest postWithURL:UserTaxidriverinfosave MutableDict:parm success:^(id dataArray) {
        //YBLog(@"dataArray==%@",dataArray);
        //YBInformationModel *model = [YBInformationModel yy_modelWithJSON:dataArray];
        if (tabIndex == 4) {
            YBSuccessViewController * vc = [[YBSuccessViewController alloc]init];
            [weakSelf.navigationController pushViewController:vc animated:NO];
        }
        [weakSelf.imagesArrUrl removeAllObjects];
        
    } failure:^(id dataArray) {
        //YBLog(@"failureDataArray==%@",dataArray);
        [MBProgressHUD showError:dataArray[@"ErrorMessage"] toView:weakSelf.view];
    }];
    
}
#pragma mark - 数据源方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.identityTabView) {
        return 2;
    }else if (tableView == self.carTabView){
        return 3;
    }else if (tableView == self.workTabView){
        return 2;
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.identityTabView) {
        if (section ==0) {
            return 1;
        }else if (section == 1){
            return 3;
        }
    }else if (tableView ==self.companyTabView){
        return  2;
    }else if (tableView ==self.carTabView){
        if (section ==0) {
            return 3;
        }
    }else if (tableView ==self.workTabView){
        if (section ==0) {
            return 2;
        }
    }
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIndentifier = [NSString stringWithFormat:@"cell%ld%ld",indexPath.section,indexPath.row];
    YBInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[YBInformationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    //去掉底部多余的表格线
    [tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    if (tableView == _identityTabView) {
        if (indexPath.section == 0) {
            
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:modelSever.HeadImgUrl] placeholderImage:[UIImage imageNamed:@"1"]];
            cell.textField.text = @"重新上传";
            cell.textField.userInteractionEnabled = NO;
        }else{
            NSArray * array = [NSArray arrayWithObjects:@"真实名字",@"身份证号",@"初次领取驾照", nil];
            cell.text.text = [array objectAtIndex:indexPath.row];
            if(indexPath.row != 2)
            {
                cell.textField.placeholder = [NSString stringWithFormat:@"请输入%@", [array objectAtIndex:indexPath.row]];
                cell.imageV.hidden = YES;
            }else{
                cell.textField.userInteractionEnabled = NO;
            }
            
            if (indexPath.row == 0) {
                if (modelSever.RealName) {
                    cell.textField.text = modelSever.RealName;
                }
            }else if (indexPath.row == 1){
                if (modelSever.IdentityCard) {
                    cell.textField.text = modelSever.IdentityCard;
                }
            }else if (indexPath.row == 2){
                if (modelSever.DriverLicenseTime) {
                    cell.textField.text = [HSHString timeWithStr:modelSever.DriverLicenseTime];
                }
            }
            
        }
    }else if (tableView == self.companyTabView){
        NSArray * array = [NSArray arrayWithObjects:@"车牌所属地区",@"出租车公司",nil];
        cell.text.text = [array objectAtIndex:indexPath.row];
        if(indexPath.row == 1)
        {
            cell.textField.placeholder = [NSString stringWithFormat:@"请输入%@", [array objectAtIndex:indexPath.row]];
            cell.imageV.hidden = YES;
            
            if (modelSever.TaxiCompany) {
                cell.textField.text = modelSever.TaxiCompany;
            }
        }else if (indexPath.row == 0){
            cell.textField.userInteractionEnabled = NO;
            
            if (modelSever.VehicleCounty) {
                cell.textField.text = modelSever.VehicleCounty;
            }
        }
        
    }else if (tableView == self.carTabView){
        NSArray * array = [NSArray arrayWithObjects:@"车牌号码",@"车辆注册时间",@"车辆所有人",nil];
        if (indexPath.section ==0) {
            cell.text.text = [array objectAtIndex:indexPath.row];
            if (indexPath.row == 0) {
                cell.btnAZ.hidden  = NO;
                cell.btnCity.hidden = NO;
                cell.textField.placeholder = [NSString stringWithFormat:@"请输入%@", [array objectAtIndex:indexPath.row]];
                cell.imageV.hidden = YES;
                
                if (modelSever.VehicleNumber.length) {
                    NSString * vn = [modelSever.VehicleNumber substringToIndex:1];
                    [cell.btnCity setTitle:vn forState:UIControlStateNormal];
                    
                    vn = [modelSever.VehicleNumber substringWithRange:NSMakeRange(1, 1)];
                    [cell.btnAZ setTitle:vn forState:UIControlStateNormal];
                    cell.textField.text = [modelSever.VehicleNumber substringFromIndex:2];
                }
            }else if(indexPath.row == 1){
                cell.textField.userInteractionEnabled = NO;
                if (modelSever.VehicleRegTime) {
                    cell.textField.text = [HSHString timeWithStr:modelSever.VehicleRegTime];
                }
            }else if (indexPath.row == 2){
                cell.textField.placeholder = [NSString stringWithFormat:@"请输入%@", [array objectAtIndex:indexPath.row]];
                cell.imageV.hidden = YES;
                
                if (modelSever.VehicleOwerName) {
                    cell.textField.text = modelSever.VehicleOwerName;
                }
            }
        }else {
            cell.textField.text = @"重新上传";
            cell.textField.userInteractionEnabled = NO;
            if (indexPath.section == 1) {
                [cell.imageView sd_setImageWithURL:[NSURL URLWithString:modelSever.VehicleLicensePicPath] placeholderImage:[UIImage imageNamed:@"1"]];
            }else{
                [cell.imageView sd_setImageWithURL:[NSURL URLWithString:modelSever.VehicleManPicPath] placeholderImage:[UIImage imageNamed:@"1"]];
            }
        }
        
    }else if (tableView == self.workTabView){
        NSArray * array = [NSArray arrayWithObjects:@"客运资格证号",@"资格证有效期",nil];
        if (indexPath.section ==0) {
            cell.text.text = [array objectAtIndex:indexPath.row];
            if (indexPath.row == 0) {
                
                cell.textField.placeholder = [NSString stringWithFormat:@"请输入%@", [array objectAtIndex:indexPath.row]];
                cell.imageV.hidden = YES;
                
                if (modelSever.ServiceCertificateNo.length) {
                    cell.textField.text = modelSever.ServiceCertificateNo;
                }
            }else if(indexPath.row == 1){
                cell.textField.userInteractionEnabled = NO;
                if (modelSever.ServiceCertificateValidTime) {
                    cell.textField.text = [HSHString timeWithStr:modelSever.ServiceCertificateValidTime];
                }
            }
        }else {
            cell.textField.text = @"重新上传";
            cell.textField.userInteractionEnabled = NO;
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:modelSever.ServiceCertificatePicPath] placeholderImage:[UIImage imageNamed:@"1"]];
        }
        
    }
    
    return cell;
}

#pragma mark - 代理方法
//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.carTabView) {
        if (indexPath.section == 1 || indexPath.section == 2) {
            return 80;
        }
    }
    return 50;
}

//头部高度
static CGFloat headerH = 60;
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.identityTabView) {
        return headerH;
    }else if (tableView == self.carTabView){
        if (section!=0) {
            return  headerH+30;
        }else{
            return headerH;
        }
    }else if (tableView == self.workTabView){
        
        return headerH;
    }
    //return 0;
    return CGFLOAT_MIN;
}

//底部视图高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView == self.carTabView) {
        if (section==2) {
            return 30;
        }
    }
    return 0.001;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == self.identityTabView) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YBWidth, headerH)];
        view.backgroundColor = LightGreyColor;
        
        if (section == 0) {
            UILabel *label = [[UILabel alloc]init];
            label.textColor = kTextGreyColor;
            label.text = [NSString stringWithFormat:@"头像信息"];
            [view addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(kpadding);
                make.bottom.equalTo(view).offset(-kMinPadding);
            }];
        }else{
            UILabel *label = [[UILabel alloc]init];
            label.textColor = [UIColor redColor];
            label.text = [NSString stringWithFormat:@"审核通过后不能修改,请填写真实信息"];
            [view addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(kpadding);
                make.bottom.equalTo(view);
            }];
            
            label = [[UILabel alloc]init];
            label.textColor = kTextGreyColor;
            label.text = [NSString stringWithFormat:@"个人信息"];
            [view addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(kpadding);
                make.top.equalTo(view);
            }];
            
        }
        return view;
    }else if (tableView == self.carTabView){
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YBWidth, headerH)];
        view.backgroundColor = LightGreyColor;
        
        NSArray * array = [NSArray arrayWithObjects:@"基本信息", @"行驶证照片", @"人车合影",nil];
        NSArray * titleArr = [NSArray arrayWithObjects:@"",@" 请上传清晰正面行驶证照片", @" 请上传清晰正面人车合影照片", nil];
        UILabel *label = [[UILabel alloc]init];
        label.textColor = kTextGreyColor;
        label.text = array[section];
        [view addSubview:label];
        
        if (section == 0) {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(kpadding);
                make.bottom.equalTo(view).offset(-kMinPadding);
            }];
        } else {
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(kpadding);
                make.bottom.equalTo(view).offset(-30);
            }];
            label = [[UILabel alloc]init];
            label.backgroundColor = [UIColor whiteColor];
            label.text = titleArr[section];
            [view addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(view);
                make.height.mas_equalTo(30);
            }];
        }
        
        return view;
    }else if (tableView == self.workTabView){
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YBWidth, headerH)];
        view.backgroundColor = LightGreyColor;
        
        NSArray * array = [NSArray arrayWithObjects:@"客运资格证信息", @"客运资格证照片", @"查看客运资格证示例图",nil];
        UILabel *label = [[UILabel alloc]init];
        label.textColor = kTextGreyColor;
        label.text = array[section];
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kpadding);
            make.bottom.equalTo(view).offset(-kMinPadding);
        }];
        
        
        return view;
    }
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (tableView == self.carTabView) {
        if (section == 2) {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YBWidth, 30)];
            view.backgroundColor = LightGreyColor;
            
            UILabel *label = [[UILabel alloc]init];
            label.textColor = kTextGreyColor;
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"该车通过审核后，将作为默认运营车辆";
            [view addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.right.top.equalTo(view);
            }];
            return view;
        }
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAK_SELF;
    infoCell = [tableView cellForRowAtIndexPath:indexPath];
    if (tableView == weakSelf.identityTabView) {
        if (indexPath.section == 0) {//重新上传照片
            //index = 1;
            // 照片选择控制器
            HXPhotoViewController *vc = [[HXPhotoViewController alloc] init];
            vc.delegate = self;
            vc.manager = self.manager;
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
        }else{
            if (indexPath.row == 2) {
                NSString *dateStr = [HSHString NSDateToString:[NSDate date] withFormat:@"YYYY-MM-dd "];
                [BRDatePickerView showDatePickerWithTitle:@"日期选择" dateType:UIDatePickerModeDate defaultSelValue:dateStr minDateStr:@"" maxDateStr:dateStr isAutoSelect:YES resultBlock:^(NSString *selectValue) {
                    infoCell.textField.text = selectValue;
                }];
            }
        }
    }else if (tableView == self.companyTabView){
        if (indexPath.row ==0) {
            [BRAddressPickerView showAddressPickerWithDefaultSelected:@[@10, @0, @3] isAutoSelect:YES resultBlock:^(NSArray *selectAddressArr) {
                infoCell.textField.text = [NSString stringWithFormat:@"%@%@%@", selectAddressArr[0], selectAddressArr[1], selectAddressArr[2]];
            }];
        }
        
    }else if (tableView == self.carTabView){
        if (indexPath.section == 1 || indexPath.section ==2) {
            carSection = indexPath.section;
            HXPhotoViewController *vc = [[HXPhotoViewController alloc] init];
            vc.delegate = self;
            vc.manager = self.manager;
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
        }else{
            if (indexPath.row == 1) {
                NSString *dateStr = [HSHString NSDateToString:[NSDate date] withFormat:@"YYYY-MM-dd "];
                [BRDatePickerView showDatePickerWithTitle:@"日期选择" dateType:UIDatePickerModeDate defaultSelValue:dateStr minDateStr:@"" maxDateStr:dateStr isAutoSelect:YES resultBlock:^(NSString *selectValue) {
                    infoCell.textField.text = selectValue;
                }];
            }
        }
        
    }else if (tableView == self.workTabView){
        if (indexPath.section == 0) {
            if (indexPath.row == 1) {
                NSString *dateStr = [HSHString NSDateToString:[NSDate date] withFormat:@"YYYY-MM-dd "];
                [BRDatePickerView showDatePickerWithTitle:@"日期选择" dateType:UIDatePickerModeDate defaultSelValue:dateStr minDateStr:@"" maxDateStr:dateStr isAutoSelect:YES resultBlock:^(NSString *selectValue) {
                    infoCell.textField.text = selectValue;
                }];
            }
            
        } else {
            HXPhotoViewController *vc = [[HXPhotoViewController alloc] init];
            vc.delegate = self;
            vc.manager = self.manager;
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
        }
    }
    
}
#pragma  mark HXPhotoViewControllerDelegate
// 通过 HXPhotoViewControllerDelegate 代理返回选择的图片以及视频
- (void)photoViewControllerDidNext:(NSArray *)allList Photos:(NSArray *)photos Videos:(NSArray *)videos Original:(BOOL)original{
    //YBLog(@"allList==%@,photos==%@,videos==%@",allList,photos,videos);
    WEAK_SELF;
    self.manager = nil;
    
    [HXPhotoTools getImageForSelectedPhoto:photos type:HXPhotoToolsFetchHDImageType completion:^(NSArray<UIImage *> *images) {
        //NSSLog(@"images==%@",images);
        infoCell.imageView.image = images[0];
        NSMutableArray *imStrArray = [NSMutableArray array];
        for (UIImage *image in images) {
            NSString *base64 = [self imageChangeBase64:image];
            NSString *typeStr = [NSString stringWithFormat:@"png,%@",base64];
            [imStrArray addObject:typeStr];
        }
        NSMutableDictionary *dict = [weakSelf dictionaryWithArray:imStrArray];
        [PPNetworkHelper setResponseSerializer:PPResponseSerializerHTTP];
        [PPNetworkHelper POST:UploadPhoto parameters:dict success:^(id responseObject) {
            
            NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"upload is succse :%@",str);
            
            NSArray *array = [str componentsSeparatedByString:@";"];
            for (NSString *string in array) {
                NSArray *array = [string componentsSeparatedByString:@","];
                if ([array.firstObject length] >0) {
                    
                    if (carSection == 1) {
                        [weakSelf.imagesArrUrl addObject:array.firstObject];
                    }else if (carSection == 2){
                        vehiclemanpicpath = array.firstObject;
                    }else{
                        [weakSelf.imagesArrUrl addObject:array.firstObject];
                    }
                }
                
            }
            //YBLog(@" self.imagesArrUrl%@vehiclemanpicpath==%@", weakSelf.imagesArrUrl,vehiclemanpicpath);
        } failure:^(NSError *error) {
            NSLog(@"faile - :%@",error);
        }];
    }];
    
}
// 点击取消
- (void)photoViewControllerDidCancel{
    
}
#pragma mark -- image转化成Base64位
-(NSString *)imageChangeBase64: (UIImage *)image{
    
    NSData   *imageData = nil;
    //NSString *mimeType  = nil;
    if ([self imageHasAlpha:image]) {
        
        imageData = UIImagePNGRepresentation(image);
        //mimeType = @"image/png";
    }else{
        
        imageData = UIImageJPEGRepresentation(image, 0.3f);
        //mimeType = @"image/jpeg";
    }
    return [NSString stringWithFormat:@"%@",[imageData base64EncodedStringWithOptions: 0]];
}
-(BOOL)imageHasAlpha:(UIImage *)image{
    
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}
- (NSMutableDictionary *)dictionaryWithArray:(NSMutableArray *)imStrArray
{
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    NSString * files = @"";
    for (int i = 0; i<imStrArray.count; i++) {
        if (i == 0) {
            files = [NSString stringWithFormat:@"%@",imStrArray[i]];
        }else{
            files = [NSString stringWithFormat:@"%@;%@",files,imStrArray[i]];
        }
    }
    dict[@"files"] = files;
    return dict;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

