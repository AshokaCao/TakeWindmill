//
//  YBRegisteredViewController.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/9.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//
#import "YBRegisteredViewController.h"
#import "YBSlideTabView.h"
#import "YBSuccessViewController.h"
@interface YBRegisteredViewController ()<UIScrollViewDelegate,HXPhotoViewDelegate,UITextFieldDelegate,YMCitySelectDelegate,YBSlideTabViewDelegate>
{
    NSMutableDictionary *parm;
    VehicleSeriesList *vehicleSeriesList;
}
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIView *headView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) UITextField *numberText;
@property (nonatomic, weak) UITextField *nameText;
@property (nonatomic, weak) UILabel *dateText;
@property (strong, nonatomic) HXPhotoManager *manager;
@property (strong, nonatomic) HXPhotoView *photoView;
@property (strong, nonatomic) UIScrollView *photoScrollView;
@property (strong,nonatomic) NSMutableArray *imagesArrUrl;
@property (strong,nonatomic) NSMutableArray *imagesArrUrl1;
//第二步
@property (nonatomic, weak) UILabel *carInfo;
@property (nonatomic, weak) UILabel *cityName;
@property (nonatomic, weak) UILabel *chepai;
@property (nonatomic, weak) UITextField *carNumber;
@property (nonatomic, weak) UITextField *ownerName;
@property (nonatomic, weak) UITextField *driveNumber;
@end
@implementation YBRegisteredViewController
static const CGFloat kPhotoViewMargin = 12.0;
static const CGFloat kPhotoScrollView = 150;
#pragma mark - lazy
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *srcoll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, YBWidth , YBHeight)];
        // 隐藏水平滚动条
        srcoll.showsHorizontalScrollIndicator = NO;
        srcoll.showsVerticalScrollIndicator = NO;
        srcoll.delegate = self;
        srcoll.backgroundColor = LightGreyColor;
        [self.view addSubview:srcoll];
        _scrollView = srcoll;
    }
    return _scrollView;
}
- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhotoAndVideo];
        _manager.openCamera = YES;
        _manager.style = HXPhotoAlbumStylesSystem;
        _manager.photoMaxNum = 1;
        // _manager.videoMaxNum = 9;
        _manager.maxNum = 1;
    }
    return _manager;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"车主认证";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initUIView];
    self.imagesArrUrl = [NSMutableArray array];
    self.imagesArrUrl1 = [NSMutableArray array];
    
}
- (void)initUIView {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, YBWidth, 100)];
    headView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:headView];
    self.headView = headView;
    //驾照图片
    UIImageView *imageVIew = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 100, 70)];
    imageVIew.image = [UIImage imageNamed:@"驾驶证图标"];
    [headView addSubview:imageVIew];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageVIew.frame) + 10, imageVIew.frame.origin.y, YBWidth - CGRectGetMaxX(imageVIew.frame) - 20, 25)];
    titleLabel.text = @"第一步 填写本人驾驶证";
    titleLabel.font = YBFont(16);
    [headView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageVIew.frame) + 10, CGRectGetMaxY(titleLabel.frame), YBWidth - CGRectGetMaxX(imageVIew.frame) - 20, imageVIew.frame.size.height - 25)];
    subTitleLabel.text = @"皕夶将保障您的个人隐私，信息仅用于平台审核，不会泄露给任何组织或个人";
    subTitleLabel.textColor = BtnBlueColor;
    subTitleLabel.numberOfLines = 0;
    subTitleLabel.font = YBFont(12);
    [headView addSubview:subTitleLabel];
    
    //
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headView.frame) + 10, YBWidth, YBHeight)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:contentView];
    self.contentView = contentView;
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 120, 20)];
    nameLabel.font = YBFont(16);
    nameLabel.text = @"真实姓名";
    [contentView addSubview:nameLabel];
    
    UITextField *nameText = [[UITextField alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(nameLabel.frame) + 10, YBWidth - 30, 40)];
    nameText.borderStyle = UITextBorderStyleRoundedRect;
    nameText.placeholder = @"姓名";
    nameText.delegate = self;
    nameText.textColor = [UIColor grayColor];
    nameText.clearButtonMode = UITextFieldViewModeAlways;
    [contentView addSubview:nameText];
    self.nameText =nameText;
    
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(nameText.frame) + 15, 120, 20)];
    numberLabel.font = YBFont(16);
    numberLabel.text = @"驾驶证号";
    [contentView addSubview:numberLabel];
    
    UITextField *numberText = [[UITextField alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(numberLabel.frame) + 10, YBWidth - 30, 40)];
    numberText.borderStyle = UITextBorderStyleRoundedRect;
    numberText.placeholder = @"与身份证一致的18位驾驶证号";
    numberText.delegate = self;
    numberText.textColor = [UIColor grayColor];
    numberText.clearButtonMode = UITextFieldViewModeAlways;
    [contentView addSubview:numberText];
    self.numberText = numberText;
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(numberText.frame) + 15, 200, 20)];
    dateLabel.font = YBFont(16);
    dateLabel.text = @"驾驶证初次领证日期";
    [contentView addSubview:dateLabel];
    
    UILabel *dateText = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(dateLabel.frame) + 10, YBWidth - 30, 40)];
    dateText.userInteractionEnabled = YES;
    dateText.text = @"请选择你初次领取驾驶证的日期";
    dateText.textColor = RGBA(199, 199, 205, 1);
    dateText.layer.cornerRadius = 5;
    dateText.layer.borderWidth = 0.5;
    dateText.layer.borderColor = RGBA(199, 199, 205, 1).CGColor;
    [contentView addSubview:dateText];
    self.dateText = dateText;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dateTextTap:)];
    [dateText addGestureRecognizer:tap];
    
    UILabel *photoLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(dateText.frame) + 15, 200, 20)];
    photoLabel.font = YBFont(16);
    photoLabel.text = @"驾驶证照片";
    [contentView addSubview:photoLabel];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(photoLabel.frame) + 10, YBWidth, kPhotoScrollView)];
    //scrollView.alwaysBounceVertical = YES;
    scrollView.scrollEnabled = NO;
    [contentView addSubview:scrollView];
    self.photoScrollView = scrollView;
    CGFloat width =  self.photoScrollView.frame.size.width;
    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
    photoView.frame = CGRectMake(kPhotoViewMargin, kPhotoViewMargin, width - kPhotoViewMargin * 2, 0);
    photoView.delegate = self;
    photoView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:photoView];
    self.photoView = photoView;
    
    UIButton *nextStepBtn = [[UIButton alloc] initWithFrame:CGRectMake(15 , CGRectGetMaxY(_photoScrollView.frame) + 20 , YBWidth - 30 , 40)];
    [nextStepBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextStepBtn setBackgroundColor:BtnBlueColor];
    nextStepBtn.layer.cornerRadius = 5;
    [nextStepBtn addTarget:self action:@selector(nextStepBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:nextStepBtn];
    
    contentView.frame = CGRectMake(0, CGRectGetMaxY(headView.frame) + 10, YBWidth, CGRectGetMaxY(nextStepBtn.frame) + 50);
    
    self.scrollView.contentSize = CGSizeMake(YBWidth, CGRectGetMaxY(contentView.frame));
    
    
}
-(void)initUIViewSecond{
    CGFloat font = 16;
    
    //[self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.contentView removeFromSuperview];
    //
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headView.frame) + 10, YBWidth, YBHeight)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:contentView];
    self.contentView = contentView;
    //品牌
    UIView *pinpai = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, YBWidth - 30, 40)];
    pinpai.layer.cornerRadius = 5;
    pinpai.layer.borderWidth = 0.5;
    pinpai.layer.borderColor = RGBA(199, 199, 205, 1).CGColor;
    pinpai.userInteractionEnabled = YES;
    [contentView addSubview:pinpai];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    //nameLabel.backgroundColor = [UIColor orangeColor];
    nameLabel.font = YBFont(font);
    nameLabel.text = @"车辆品牌";
    [pinpai addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.height.equalTo(pinpai);
        make.width.equalTo(@80);
    }];
    
    UILabel *dateText = [[UILabel alloc] init];
    //dateText.backgroundColor = [UIColor redColor];
    dateText.userInteractionEnabled = YES;
    dateText.text = @"请选择车辆";
    dateText.textColor = RGBA(199, 199, 205, 1);
    dateText.font = YBFont(font);
    [pinpai addSubview:dateText];
    [dateText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_right);
        make.top.equalTo(@0);
        make.right.equalTo(pinpai);
        make.height.equalTo(pinpai);
    }];
    self.carInfo = dateText;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseCarTap:)];
    [dateText addGestureRecognizer:tap];
    
    
    UIImageView * imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_chose_arrow_nor"]];
    [pinpai addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.equalTo(pinpai);
    }];
    
    //所属地
    UIView *suoshudi = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(pinpai.frame)+10, YBWidth - 30, 40)];
    suoshudi.layer.cornerRadius = 5;
    suoshudi.layer.borderWidth = 0.5;
    suoshudi.userInteractionEnabled = YES;
    suoshudi.layer.borderColor = RGBA(199, 199, 205, 1).CGColor;
    [contentView addSubview:suoshudi];
    
    UILabel * label = [[UILabel alloc]init];
    label.text =@"车辆所属地";
    label.font = YBFont(font);
    [suoshudi addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.left.equalTo(suoshudi);
    }];
    
    dateText = [[UILabel alloc] init];
    dateText.textAlignment = NSTextAlignmentCenter;
    dateText.userInteractionEnabled = YES;
    //dateText.text = @"京";
    dateText.font = YBFont(font);
    dateText.textColor = RGBA(199, 199, 205, 1);
    dateText.layer.borderWidth = 0.5;
    dateText.layer.borderColor = RGBA(199, 199, 205, 1).CGColor;
    [suoshudi addSubview:dateText];
    [dateText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_right).offset(10);
        make.top.equalTo(@0);
        make.width.equalTo(@50);
        make.height.equalTo(pinpai);
    }];
    self.cityName = dateText;
    UITapGestureRecognizer * localTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(localTap:)];
    [dateText addGestureRecognizer:localTap];
    
    imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"下角"]];
    [dateText addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(dateText);
        make.right.equalTo(dateText).offset(-5);
    }];
    
    
    UILabel *chepai = [[UILabel alloc] init];
    chepai.textAlignment = NSTextAlignmentCenter;
    chepai.userInteractionEnabled = YES;
    // chepai.text = @"京";
    chepai.font = YBFont(font);
    chepai.textColor = RGBA(199, 199, 205, 1);
    //dateText.layer.cornerRadius = 5;
    chepai.layer.borderWidth = 0.5;
    chepai.layer.borderColor = RGBA(199, 199, 205, 1).CGColor;
    [suoshudi addSubview:chepai];
    [chepai mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dateText.mas_right);
        make.top.equalTo(@0);
        make.width.equalTo(@50);
        make.height.equalTo(pinpai);
    }];
    self.chepai = chepai;
    UITapGestureRecognizer * chepaiTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chepaiTap:)];
    [chepai addGestureRecognizer:chepaiTap];
    
    imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"下角"]];
    [chepai addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(chepai);
        make.right.equalTo(chepai).offset(-5);
    }];
    
    UITextField *carNum = [[UITextField alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(suoshudi.frame) + 10, YBWidth - 30, 40)];
    carNum.placeholder =@"请输入车牌号";
    carNum.delegate = self;
    carNum.font = YBFont(font);
    carNum.textColor = RGBA(199, 199, 205, 1);
    [suoshudi addSubview:carNum];
    [carNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(chepai.mas_right);
        make.top.height.equalTo(suoshudi);
    }];
    self.carNumber = carNum;
    
    
    //车辆所属人姓名
    UITextField *name = [[UITextField alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(suoshudi.frame) + 10, YBWidth - 30, 40)];
    name.placeholder =@"车辆所属人姓名";
    name.delegate = self;
    name.font = YBFont(font);
    name.textColor = RGBA(199, 199, 205, 1);
    name.layer.cornerRadius = 5;
    name.layer.borderWidth = 0.5;
    name.layer.borderColor = RGBA(199, 199, 205, 1).CGColor;
    [contentView addSubview:name];
    self.ownerName = name;
    
    //行驶证号
    UITextField *number = [[UITextField alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(name.frame) + 10, YBWidth - 30, 40)];
    //number.userInteractionEnabled = YES;
    //number.text = @"行驶证号";
    number.placeholder =@"行驶证号";
    number.delegate = self;
    number.font = YBFont(font);
    number.textColor = RGBA(199, 199, 205, 1);
    number.layer.cornerRadius = 5;
    number.layer.borderWidth = 0.5;
    number.layer.borderColor = RGBA(199, 199, 205, 1).CGColor;
    [contentView addSubview:number];
    self.driveNumber = number;
    
    UILabel *photoLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(number.frame) + 15, 200, 20)];
    photoLabel.font = YBFont(font);
    photoLabel.text = @"行驶证照片";
    [contentView addSubview:photoLabel];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(photoLabel.frame) + 10, YBWidth, kPhotoScrollView)];
    //scrollView.alwaysBounceVertical = YES;
    scrollView.scrollEnabled = NO;
    [contentView addSubview:scrollView];
    self.photoScrollView = scrollView;
    CGFloat width =  self.photoScrollView.frame.size.width;
    self.manager = nil;
    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
    photoView.frame = CGRectMake(kPhotoViewMargin, kPhotoViewMargin, width - kPhotoViewMargin * 2, 0);
    photoView.delegate = self;
    photoView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:photoView];
    self.photoView = photoView;
    
    UIButton *nextStepBtn = [[UIButton alloc] initWithFrame:CGRectMake(15 , CGRectGetMaxY(_photoScrollView.frame) + 20 , YBWidth - 30 , 40)];
    nextStepBtn.tag = 1;
    [nextStepBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextStepBtn setBackgroundColor:BtnBlueColor];
    nextStepBtn.layer.cornerRadius = 5;
    [nextStepBtn addTarget:self action:@selector(nextStepBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:nextStepBtn];
    
    contentView.frame = CGRectMake(0, CGRectGetMaxY(_headView.frame) + 10, YBWidth, CGRectGetMaxY(nextStepBtn.frame) + 50);
    self.scrollView.contentSize = CGSizeMake(YBWidth, CGRectGetMaxY(contentView.frame));
}
//chepaiTap
-(void)chepaiTap:(UITapGestureRecognizer *)sender{
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    NSMutableArray * dataSource = [NSMutableArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"J",@"K",@"L",@"M",@"N",@"P",@"Q",@"R",@"S",@"T",@"W",@"X",@"Y",@"Z", nil];
    WEAK_SELF;
    [BRStringPickerView showStringPickerWithTitle:@"" dataSource:dataSource defaultSelValue:@"A" isAutoSelect:YES resultBlock:^(id selectValue) {
        weakSelf.chepai.text = selectValue;
    }];
}
//localTap
-(void)localTap:(UITapGestureRecognizer *)sender{
    [self presentViewController:[[YMCitySelect alloc] initWithDelegate:self] animated:YES completion:nil];
}
#pragma mark == YMCitySelectDelegate
-(void)ym_ymCitySelectCityName:(NSString *)cityName{
    self.cityName.text = cityName;
    self.cityName.textAlignment = NSTextAlignmentLeft;
}
#pragma mark == YBSlideTabViewDelegate
-(void)didSelectRowAtValue:(VehicleSeriesList *)vs{
    // NSLog(@"vs==%@",vs.VehicleSeries);
    self.carInfo.text = vs.VehicleSeries;
    vehicleSeriesList = vs;
}
#pragma mark 请选择车辆
-(void)chooseCarTap:(UITapGestureRecognizer *)sender{
    YBSlideTabView * view = [[YBSlideTabView alloc]initWithFrame:self.view.bounds];
    view.delegate = self;
    [self.view addSubview:view];
    
    NSMutableDictionary *parm = [YBTooler dictinitWithMD5];
    [YBRequest postWithURL:MemberVehiclebrandlist MutableDict:parm success:^(id dataArray) {
        //YBLog(@"dataArray==%@",dataArray);
        
        Body *body = [Body yy_modelWithJSON:dataArray];
        view.dataArray = [NSMutableArray arrayWithArray:body.VehicleBrandList];
    } failure:^(id dataArray) {
        //YBLog(@"failureDataArray==%@",dataArray);
        [MBProgressHUD showError:dataArray[@"ErrorMessage"] toView:self.view];
    }];
}
#pragma mark 日期选择
-(void)dateTextTap:(UITapGestureRecognizer *)sender{
    [self.view endEditing:YES];
    WEAK_SELF;
    NSString *dateStr = [HSHString NSDateToString:[NSDate date] withFormat:@"YYYY-MM-dd"];
    [BRDatePickerView showDatePickerWithTitle:@"日期选择" dateType:UIDatePickerModeDate defaultSelValue:dateStr minDateStr:@"" maxDateStr:dateStr isAutoSelect:YES resultBlock:^(NSString *selectValue) {
        weakSelf.dateText.text = selectValue;
    }];
}
#pragma mark 下一步
-(void)nextStepBtnTap:(UIButton *)sender{
    if (sender.tag==0) {
        if(_nameText.text.length == 0 || _numberText.text.length == 0 ||_dateText.text.length == 0 || _imagesArrUrl.count == 0){
            [MBProgressHUD showError:@"请完善信息" toView:self.view];
            return;
        }
        parm = [YBTooler dictinitWithMD5];
        NSString *userID = [YBUserDefaults valueForKey:_userId];
        parm[@"userid"] = userID;
        parm[@"realname"] = _nameText.text;
        parm[@"identitycard"] = _numberText.text;
        //parm[@"licenceregistertime"] = _dateText.text;
        parm[@"driverlicensepicpath"] = self.imagesArrUrl.firstObject;
        
        _titleLabel.text = @"第二步 填写汽车信息";
        [self initUIViewSecond];
    }else{
        
        YBLog(@"carNumbe==%@,%@",_carNumber.text,_ownerName.text)
        if(_carNumber.text.length == 0 || _ownerName.text.length == 0 ||_imagesArrUrl1.count == 0){
            [MBProgressHUD showError:@"请完善信息" toView:self.view];
            return;
        }
        //        UserId：用户Id
        //        RealName：真实姓名
        //        IdentityCard：身份证号V
        
        //        ehicleNumber：车牌号
        //        VehicleSeriesSysNo：车辆序列SysNo
        //        VehicleColorSysNo：车辆颜色SysNo
        //        PlateNumberLocation：车牌号  ==vehiclenumber
        //        VehicleOwerName：车辆所有人
        //        VehicleLicenseNumber：行驶证号码
        //        DriverLicensePicPath：驾驶证图片
        //        VehicleLicensePicPath：行驶证图片
        
        parm[@"vehiclenumber"] = self.carNumber.text;
        //parm[@"ehiclenumber"] = self.carNumber.text;
        parm[@"vehicleseriessysno"] =[NSString stringWithFormat:@"%ld", vehicleSeriesList.SysNo] ;
        parm[@"vehiclecolorsysno"] = [NSString stringWithFormat:@"%ld", vehicleSeriesList.SysNo] ;
        parm[@"platenumberlocation"] =  [NSString stringWithFormat:@"%@%@", _cityName.text,_chepai.text] ;
        parm[@"vehicleowername"] = self.ownerName.text;
        parm[@"vehiclelicensenumber"] = self.carNumber.text;
        parm[@"vehiclelicensepicpath"] = self.imagesArrUrl1.firstObject;
        
        YBLog(@"UserTobeowner==%@",UserTobeowner);
        YBLog(@"parm==%@",parm);
        
        [YBRequest postWithURL:UserTobeowner MutableDict:parm success:^(id dataArray) {
            YBLog(@"dataArray==%@",dataArray);
            //[MBProgressHUD showError:@"认证成功"toView:self.view];
            YBSuccessViewController *vc = [[YBSuccessViewController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
        } failure:^(id dataArray) {
            YBLog(@"failureDataArray==%@",dataArray);
            [MBProgressHUD showError:dataArray[@"ErrorMessage"] toView:self.view];
        }];
    }
}
#pragma mark =HXPhotoViewDelegate
// 代理返回 选择、移动顺序、删除之后的图片以及视频
- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal{
    [HXPhotoTools getImageForSelectedPhoto:photos type:HXPhotoToolsFetchHDImageType completion:^(NSArray<UIImage *> *images) {
        //NSSLog(@"images==%@",images);
        
        NSMutableArray *imStrArray = [NSMutableArray array];
        for (UIImage *image in images) {
            NSString *base64 = [self imageChangeBase64:image];
            NSString *typeStr = [NSString stringWithFormat:@"png,%@",base64];
            [imStrArray addObject:typeStr];
        }
        
        NSMutableDictionary *dict = [self dictionaryWithArray:imStrArray];
        [PPNetworkHelper setResponseSerializer:PPResponseSerializerHTTP];
        [PPNetworkHelper POST:UploadPhoto parameters:dict success:^(id responseObject) {
            //                NSLog(@"upload is succse :%@",responseObject);
            NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"upload is succse :%@",str);
            
            NSArray *array = [str componentsSeparatedByString:@";"];
            if (self.imagesArrUrl.count>0) {
                for (NSString *string in array) {
                    NSArray *array = [string componentsSeparatedByString:@","];
                    [self.imagesArrUrl1 addObject:array.firstObject];
                }
            }else{
                for (NSString *string in array) {
                    NSArray *array = [string componentsSeparatedByString:@","];
                    [self.imagesArrUrl addObject:array.firstObject];
                }
            }
            
            //YBLog(@" self.imagesArrUrl%@", self.imagesArrUrl);
            //YBLog(@" self.imagesArrUrl1%@", self.imagesArrUrl1);
        } failure:^(NSError *error) {
            NSLog(@"faile - :%@",error);
        }];
    }];
    
}
// 当view更新高度时调用
- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame{
    //NSLog(@"===%f",frame.origin.y);
    self.photoScrollView.contentSize = CGSizeMake(self.photoScrollView.frame.size.width, CGRectGetMaxY(frame) + kPhotoViewMargin);
    
    //    self.photoScrollView.height = CGRectGetMaxY(frame) + kPhotoViewMargin;
    //    self.photoScrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.photoScrollView.contentSize.height+ kPhotoViewMargin);
    
}
// 删除网络图片的地址
- (void)photoView:(HXPhotoView *)photoView deleteNetworkPhoto:(NSString *)networkPhotoUrl{
    
}
// 网络图片全部下载完成时调用
- (void)photoViewAllNetworkingPhotoDownloadComplete:(HXPhotoView *)photoView{
    
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //    if (textField.tag == 0 || textField.tag == 4) {
    [textField resignFirstResponder];
    //[[UIApplication sharedApplication].keyWindow endEditing:YES];
    //    }
    return YES;
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
    switch (imStrArray.count) {
        case 1:
            dict[@"files"] = [NSString stringWithFormat:@"%@",imStrArray[0]];
            break;
        case 2:
            dict[@"files"] = [NSString stringWithFormat:@"%@;%@",imStrArray[0],imStrArray[1]];
            break;
        case 3:
            dict[@"files"] = [NSString stringWithFormat:@"%@;%@;%@",imStrArray[0],imStrArray[1],imStrArray[2]];
            break;
        case 4:
            dict[@"files"] = [NSString stringWithFormat:@"%@;%@;%@;%@",imStrArray[0],imStrArray[1],imStrArray[2],imStrArray[3]];
            break;
        case 5:
            dict[@"files"] = [NSString stringWithFormat:@"%@;%@;%@;%@;%@",imStrArray[0],imStrArray[1],imStrArray[2],imStrArray[3],imStrArray[4]];
            break;
        case 6:
            dict[@"files"] = [NSString stringWithFormat:@"%@;%@;%@;%@;%@;%@",imStrArray[0],imStrArray[1],imStrArray[2],imStrArray[3],imStrArray[4],imStrArray[5]];
            break;
        case 7:
            dict[@"files"] = [NSString stringWithFormat:@"%@;%@;%@;%@;%@;%@;%@",imStrArray[0],imStrArray[1],imStrArray[2],imStrArray[3],imStrArray[4],imStrArray[5],imStrArray[6]];
            break;
        case 8:
            dict[@"files"] = [NSString stringWithFormat:@"%@;%@;%@;%@;%@;%@;%@;%@",imStrArray[0],imStrArray[1],imStrArray[2],imStrArray[3],imStrArray[4],imStrArray[5],imStrArray[6],imStrArray[7]];
            break;
        case 9:
            dict[@"files"] = [NSString stringWithFormat:@"%@;%@;%@;%@;%@;%@;%@;%@;%@",imStrArray[0],imStrArray[1],imStrArray[2],imStrArray[3],imStrArray[4],imStrArray[5],imStrArray[6],imStrArray[7],imStrArray[8]];
            break;
        default:
            break;
    }
    return dict;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
