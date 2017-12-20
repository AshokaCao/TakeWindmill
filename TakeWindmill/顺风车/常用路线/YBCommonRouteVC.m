//
//  YBCommonRouteVC.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/12.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBCommonRouteVC.h"
#import "YBAddressSearchSelectionVC.h"

#import "PGDatePicker.h"

//常用路线
@interface YBCommonRouteSelectView ()

/**
 * 下划线
 */
@property (nonatomic, weak) UIView *line;

/**
 * 下划线1
 */
@property (nonatomic, weak) UIView *line1;

/**
 * 下划线2
 */
@property (nonatomic, weak) UIView *line2;

///**
// * 下划线3
// */
//@property (nonatomic, weak) UIView *line3;

@end

@implementation YBCommonRouteSelectView

- (YBBaseView *)startPoint
{
    if (!_startPoint) {
        YBBaseView *startPoint  = [[YBBaseView alloc] init];
        startPoint.CanClick     = YES;
        startPoint.CanPressLong = YES;
        [self addSubview:startPoint];
        _startPoint = startPoint;
    }
    return _startPoint;
}
- (UIView *)line
{
    if (!_line) {
        UIView *view         = [[UIView alloc] init];
        view.backgroundColor = LightGreyColor;
        [self addSubview:view];
        _line = view;
    }
    return _line;
}

- (YBBaseView *)endPoint
{
    if (!_endPoint) {
        YBBaseView *endPoint  = [[YBBaseView alloc] init];
        endPoint.CanClick     = YES;
        endPoint.CanPressLong = YES;
        [self addSubview:endPoint];
        _endPoint = endPoint;
    }
    return _endPoint;
}

- (UIView *)line1
{
    if (!_line1) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor =LightGreyColor;
        [self addSubview:view];
        _line1 = view;
    }
    return _line1;
}

- (YBBaseView *)timeView
{
    if (!_timeView) {
        YBBaseView *timeView  = [[YBBaseView alloc] init];
        timeView.CanClick     = YES;
        timeView.CanPressLong = YES;
        [self addSubview:timeView];
        _timeView = timeView;
    }
    return _timeView;
}

- (UIView *)line2
{
    if (!_line2) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor =LightGreyColor;
        [self addSubview:view];
        _line2 = view;
    }
    return _line2;
}

- (UITextField *)remarksText
{
    if (!_remarksText) {
        UITextField *remarksText    = [[UITextField alloc] init];
        remarksText.placeholder     = @"给路线起个名字,如:上班(选填)";
        remarksText.borderStyle     = UIReturnKeyDone;
        remarksText.font = [UIFont fontWithName:@"Arial" size:14.0f];
        [self addSubview:remarksText];
        _remarksText = remarksText;
    }
    return _remarksText;
}

- (UIButton *)exchangeButton
{
    if (!_exchangeButton) {
        UIButton *exchangeButton = [[UIButton alloc] init];
        [exchangeButton setImage:[UIImage imageNamed:@"切换"] forState:UIControlStateNormal];
        [self addSubview:exchangeButton];
        _exchangeButton = exchangeButton;
    }
    return _exchangeButton;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat viewW = self.frame.size.width;
    CGFloat viewH = self.frame.size.height - 20;
    self.startPoint.frame = CGRectMake(5, 10,viewW - 60, viewH / 4);
    self.line.frame       = CGRectMake(20, CGRectGetMaxY(self.startPoint.frame), viewW - 60, 1);
    self.endPoint.frame   = CGRectMake(5, CGRectGetMaxY(self.line.frame), viewW - 60, viewH / 4);
    self.exchangeButton.frame = CGRectMake(CGRectGetMaxX(self.startPoint.frame), 10, 55, viewH / 2);
    self.line1.frame      = CGRectMake(20, CGRectGetMaxY(self.endPoint.frame), viewW - 25, 1);
    self.timeView.frame   = CGRectMake(5, CGRectGetMaxY(self.line1.frame), viewW - 10, viewH / 4);
    self.line2.frame      = CGRectMake(20, CGRectGetMaxY(self.timeView.frame), viewW - 25, 1);
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.line2.frame) + viewH / 8 - 4, 8, 8)];
    imageView.image = [UIImage imageNamed:@"出行要求"];
    [self addSubview:imageView];
    
    self.remarksText.frame= CGRectMake(CGRectGetMaxX(imageView.frame) + 10, CGRectGetMaxY(self.line2.frame), viewW - 30, viewH / 4 );
    
    [self.startPoint aboutViewImage:nil imageFrame:CGSizeMake(0, 0) imageBacColor:BtnBlueColor LabelTitle:@"获取上车点信息" titleFont:14 titleColor:[UIColor grayColor] subTitle:nil subTitleFont:0 subtitleColor:nil];
    [self.endPoint aboutViewImage:nil imageFrame:CGSizeMake(0, 0) imageBacColor:BtnGreenColor LabelTitle:@"请选择终点信息" titleFont:14 titleColor:BtnGreenColor subTitle:nil subTitleFont:0 subtitleColor:nil];
    [self.timeView aboutViewImage:[UIImage imageNamed:@"时间"] imageFrame:CGSizeMake(7, 7) imageBacColor:nil LabelTitle:@"出发时间" titleFont:14 titleColor:[UIColor grayColor] subTitle:nil subTitleFont:0 subtitleColor:nil];
    
}

@end















@interface YBCommonRouteVC ()<YBAddressSearchSelectionVCDelegate,PGDatePickerDelegate,UITextFieldDelegate>

@property (nonatomic, strong) YBCommonRouteSelectView *routeView;

/**
 * 中心点图片
 */
@property (nonatomic, strong) UIImageView * locnImageView;

/**
 * 时间戳
 */
@property (nonatomic, strong) PGDatePicker *datePicker;

@property (nonatomic, strong) UIView * locAtionView;

@property (nonatomic, strong) BMKGeoCodeSearch *codSearch;

/**
 * 提交按钮
 */
@property (nonatomic, weak) UIButton * submitButton;

/**
 * 起点位置信息
 */
@property (nonatomic, strong) NSDictionary *startingPointDict;

/**
 * 终点位置信息
 */
@property (nonatomic, strong) NSDictionary *endPointDict;

/**
 * 终点还是起点
 */
@property (nonatomic, strong) NSString *isStarOrEnd;

@end

@implementation YBCommonRouteVC

- (UIImageView *)locnImageView
{
    if (!_locnImageView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"定位图标"];
        [self.view addSubview:imageView];
        _locnImageView = imageView;
    }
    return _locnImageView;
}

- (YBCommonRouteSelectView *)routeView
{
    if (!_routeView) {
        YBCommonRouteSelectView *view = [[YBCommonRouteSelectView alloc] initWithFrame:CGRectMake(10, 10, YBWidth - 20, 170)];
        view.backgroundColor          = [UIColor whiteColor];
        [self.view addSubview:view];
        _routeView = view;
    }
    return _routeView;
}

- (UIButton *)submitButton
{
    if (!_submitButton) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, YBHeight - 50, YBWidth - 20, 40)];
        button.layer.cornerRadius = 5;
        [button setBackgroundColor:BtnBlueColor];
        [button setTitle:@"确认添加" forState:UIControlStateNormal];
        [self.view addSubview:button];
        _submitButton = button;
    }
    return _submitButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"添加常用路线";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *noticeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    noticeButton.titleLabel.font = YBFont(12);
    [noticeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [noticeButton setTitle:@"通知设置" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:noticeButton];
    
    self.view.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    
    [self.view addGestureRecognizer:singleTap];
        
    //点击了起点
    self.routeView.startPoint.selectBlock = ^(YBBaseView *view) {
        [self chooseLocationInformation:@"起点"];
    };
    //点击了终点
    self.routeView.endPoint.selectBlock = ^(YBBaseView *view) {
        [self chooseLocationInformation:@"终点"];
    };
    //点击了切换
    [self.routeView.exchangeButton addTarget:self action:@selector(exchangeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    //点击了时间
    self.routeView.timeView.selectBlock = ^(YBBaseView *view) {
        [self selectTheour];
    };
    self.routeView.remarksText.delegate        = self;//设置代理
    //显示地图中心点
    [self createLocationSignImage:self.mapView.centerCoordinate];
    //提交按钮
    [self.submitButton addTarget:self action:@selector(submitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)dealloc
{
    self.codSearch.delegate = nil;
}

- (void)selectTheour
{
    _datePicker                 = [[PGDatePicker alloc]init];
    _datePicker.delegate        = self;
    [_datePicker show];
    _datePicker.datePickerMode  = PGDatePickerModeTime;
    _datePicker.titleLabel.text = @"添加常用路线";
}

- (void)submitButtonAction:(UIButton *)sender
{
    if (![self.routeView.startPoint.label.text isEqualToString:@"获取上车点信息"] &&![self.routeView.endPoint.label.text isEqualToString:@"请选择终点信息"] &&![self.routeView.timeView.label.text isEqualToString:@"出发时间"]) {
        
        //司机常用路线保存
        NSString *urlStr = commonaddressdriversavePath;
        NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
        [dict setObject:[YBTooler getTheUserId:self.view] forKey:@"userid"];//用户id
        [dict setObject:self.startingPointDict[@"Lng"] forKey:@"startlng"];//起点经度
        [dict setObject:self.startingPointDict[@"Lat"] forKey:@"startlat"];//起点纬度
        [dict setObject:self.startingPointDict[@"CityId"] forKey:@"startcityid"];//起点城市id
        [dict setObject:self.startingPointDict[@"City"] forKey:@"startcity"];//起点城市
        [dict setObject:self.startingPointDict[@"Name"] forKey:@"startaddress"];//起点城市
        [dict setObject:self.endPointDict[@"Lng"] forKey:@"endlng"];//终点经度
        [dict setObject:self.endPointDict[@"Lat"] forKey:@"endlat"];//终点纬度
        [dict setObject:self.endPointDict[@"CityId"] forKey:@"endcityid"];//终点城市id
        [dict setObject:self.endPointDict[@"City"] forKey:@"endcity"];//起点城市
        [dict setObject:self.endPointDict[@"Name"] forKey:@"endaddress"];//起点城市
        [dict setObject:self.routeView.timeView.label.text forKey:@"setouttime"];//出发时间
        [dict setObject:[self.routeView.remarksText.text length] == 0 ? @"常用" : self.routeView.remarksText.text forKey:@"note"];//行程备注
        
        [YBRequest postWithURL:urlStr MutableDict:dict View:self.view success:^(id dataArray) {
//            YBLog(@"添加成功常用路线%@",dataArray);
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(id dataArray) {
//            YBLog(@"添加失败常用路线%@",dataArray);
        }];
    }
    else {
        [MBProgressHUD showError:@"请先完成行程信息填写" toView:self.view];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    [self.view endEditing:YES];
}


#pragma PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents
{
    NSLog(@"dateComponents = %@", dateComponents);
    NSString *timeStr = [NSString stringWithFormat:@"%ld点%ld分",dateComponents.hour,dateComponents.minute];
    [self.routeView.timeView initLabelStr:timeStr];
}

- (void)exchangeButtonAction:(UIButton *)sender
{
    if (![self.routeView.endPoint.label.text isEqualToString:@"请选择终点信息"] && ![self.routeView.startPoint.label.text isEqualToString:@"获取上车点信息"]) {
//        YBLog(@"起点信息%@----终点信息%@",self.startingPointDict,self.endPointDict);
        //把当前定位的经纬度换算为了View上的坐标
        CLLocationCoordinate2D pt = CLLocationCoordinate2DMake([self.endPointDict[@"Lat"] doubleValue],[self.endPointDict[@"Lng"] doubleValue]);
        [self.mapView setCenterCoordinate:pt animated:YES];
        NSString *StarStr = [NSString stringWithFormat:@"%@·%@",self.endPointDict[@"City"],self.endPointDict[@"Name"]];
        [self.routeView.startPoint initLabelStr:StarStr];
        
        NSString *endStr = [NSString stringWithFormat:@"%@·%@",self.startingPointDict[@"City"],self.startingPointDict[@"Name"]];
        [self.routeView.endPoint initLabelStr:endStr];
        
        NSDictionary *dict     = self.startingPointDict;
        self.startingPointDict = self.endPointDict;
        self.endPointDict      = dict;
    }else {
        [MBProgressHUD showError:@"请完成行程选择" toView:self.view];
    }
}

- (void)chooseLocationInformation:(NSString *)str
{
    self.isStarOrEnd = str;
    
    YBAddressSearchSelectionVC *selec = [[YBAddressSearchSelectionVC alloc] init];
    selec.typesOf                     = @"终点";
    selec.addDelegate                 = self;
    selec.cityname = self.startingPointDict[@"City"] ? self.startingPointDict[@"City"] : @"杭州";
    [self presentViewController:selec animated:YES completion:nil];
    
}

#pragma mark - 终点代理
- (void)popViewControllerPassTheValue:(NSDictionary *)value
{
    if ([self.isStarOrEnd isEqualToString:@"起点"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.startingPointDict = value;
            
            [self.routeView.startPoint initLabelStr:[NSString stringWithFormat:@"%@·%@",self.startingPointDict[@"City"],self.startingPointDict[@"Name"]]];
            
            CLLocationCoordinate2D pt = CLLocationCoordinate2DMake([self.startingPointDict[@"Lat"] doubleValue], [self.startingPointDict[@"Lng"] doubleValue]);
            [self createLocationSignImage:pt];
            
            if ([self.routeView.endPoint.label.text isEqualToString:@"请选择终点信息"]) {
                [MBProgressHUD showError:@"请输入终点位置" toView:self.view];
                return ;
            }
        });
    }else {
        if ([self.routeView.startPoint.label.text isEqualToString:@"获取上车点信息"]) {
            [MBProgressHUD showError:@"请选择上车点位置" toView:self.view];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.endPointDict = value;
            NSString *progress = [NSString stringWithFormat:@"%@·%@",self.endPointDict[@"City"],self.endPointDict[@"Name"]];
            [self.routeView.endPoint initLabelStr:progress];
        });
    }
}

- (void)createLocationSignImage:(CLLocationCoordinate2D)pt
{
    self.codSearch.delegate = self;
    
    //把当前定位的经纬度换算为了View上的坐标
    CGPoint point = [self.mapView convertCoordinate:pt toPointToView:self.mapView];
    
    //当解析出现错误的时候，会出现超出屏幕的情况，一种是大于了屏幕，一种是小于了屏幕
    if(point.x > YBWidth || point.x < YBWidth/5){
        point.x = YBWidth / 2;
        point.y = (YBHeight + 64) / 2 ;
    }
    self.locnImageView.center = point;
    [self.locnImageView setFrame:CGRectMake( point.x - 10, point.y - 29, 20, 29)];
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    
//    CGPoint touchPoint = self.locAtionView.center;
//    CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];//这里touchMapCoordinate就是该点的经纬度了
//
//    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];//初始化反编码请求
//    reverseGeocodeSearchOption.reverseGeoPoint = touchMapCoordinate;//设置反编码的店为pt
//    BOOL flag =   [self.geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
//    if (flag) {
//        YBLog(@"定位搜索成功");
//    }
//    else {
//        [MBProgressHUD showError:@"定位搜索失败" toView:self.view];
//    }
}

-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSString *starStr = [NSString stringWithFormat:@"%@·%@",result.addressDetail.city,result.sematicDescription];
    [self.routeView.startPoint initLabelStr:starStr];
    
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


@end

