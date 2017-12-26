//
//  YBBusinessCardVC.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/12/11.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBBusinessCardVC.h"

@interface YBBusinessCardVC ()
//二维码
@property (nonatomic, strong) UIView *qrView;
@property (nonatomic, strong) UIImageView* qrImgView;
//@property (nonatomic, strong) UIImageView* logoImgView;

@property (nonatomic, strong) UILabel *number;

@end

@implementation YBBusinessCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"名片";
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self setUI];
    [self createQR_logo];
}
-(void)setUI{
    UILabel * label = [[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = CGRectMake(0, 20, YBWidth, 20);
    label.text = @"我的邀请码";
    [self.view addSubview:label];
    
    UILabel *number = [[UILabel alloc]init];
    number.textAlignment = NSTextAlignmentCenter;
    number.frame = CGRectMake(0, CGRectGetMaxY(label.frame)+10, YBWidth, 20);
    number.text = @"9999999";
    [self.view addSubview:number];
    self.number = number;
    
    
    //二维码
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake( (CGRectGetWidth(self.view.frame)-CGRectGetWidth(self.view.frame)*5/6)/2, 100, CGRectGetWidth(self.view.frame)*5/6, CGRectGetWidth(self.view.frame)*5/6)];
    [self.view addSubview:view];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.shadowOffset = CGSizeMake(0, 2);
    view.layer.shadowRadius = 2;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOpacity = 0.5;
    
    
    self.qrImgView = [[UIImageView alloc]init];
    _qrImgView.bounds = CGRectMake(0, 0, CGRectGetWidth(view.frame)-12, CGRectGetWidth(view.frame)-12);
    _qrImgView.center = CGPointMake(CGRectGetWidth(view.frame)/2, CGRectGetHeight(view.frame)/2);
    [view addSubview:_qrImgView];
    self.qrView = view;
    
}

- (void)createQR_logo
{
    WEAK_SELF;
    
    NSMutableDictionary *mutableDict = [YBTooler dictinitWithMD5];
    [mutableDict setObject:[YBTooler getTheUserId:self.view] forKey:@"userid"];//用户Id
    
    
    [YBRequest postWithURL:userMycardinfo MutableDict:mutableDict success:^(id dataArray) {
        //YBLog(@"%@",dataArray);
        /*
        DownloadUrl = http://weixin.qq.com/r/dSmEnHPE5S6arTf-93xn;
        UserId = ;
        CommendCode = 000088;
        HasError = 0;
        ErrorMessage = ;*/
        
        weakSelf.number.text = dataArray[@"CommendCode"];
        
         weakSelf.qrImgView.image = [ZXingWrapper createCodeWithString:dataArray[@"DownloadUrl"] size:_qrImgView.bounds.size CodeFomart:kBarcodeFormatQRCode];
    } failure:^(id dataArray) {
        [MBProgressHUD showError:dataArray[@"ErrorMessage"] toView:weakSelf.view];
    }];
    
   

    
//    CGSize logoSize=CGSizeMake(30, 30);
//    self.logoImgView = [self roundCornerWithImage:[UIImage imageNamed:@"logo"] size:logoSize];
//    _logoImgView.bounds = CGRectMake(0, 0, logoSize.width, logoSize.height);
//    _logoImgView.center = CGPointMake(CGRectGetWidth(_qrImgView.frame)/2, CGRectGetHeight(_qrImgView.frame)/2);
//    [_qrImgView addSubview:_logoImgView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
