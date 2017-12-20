//
//  YBChoosePhotosViewController.m
//  TakeWindmill
//
//  Created by AshokaCao on 2017/11/2.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBChoosePhotosViewController.h"
#import "HXPhotoViewController.h"
#import "HXPhotoView.h"
#import "AFNetworking.h"

static const CGFloat kPhotoViewMargin = 12.0;

@interface YBChoosePhotosViewController () <HXPhotoViewDelegate, BMKGeoCodeSearchDelegate, BMKLocationServiceDelegate>
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;

@property (strong, nonatomic) HXPhotoManager *manager;
@property (strong, nonatomic) HXPhotoView *photoView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (nonatomic, strong) NSString *testStr;
/**
 * 定位功能
 */
@property (nonatomic, strong) BMKLocationService *locService;

/**
 * 搜索框
 */
//@property (nonatomic, strong) YBOnTheTrainView *trainView;
/**
 * 反地理编码
 */
@property (nonatomic, strong) BMKGeoCodeSearch *geocodesearch;

/**
 * 起点位置信息
 */
@property (nonatomic, strong) BMKReverseGeoCodeResult *startingPoint;

@end

@implementation YBChoosePhotosViewController


- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhotoAndVideo];
        _manager.openCamera = YES;
        _manager.cacheAlbum = YES;
        _manager.lookLivePhoto = YES;
        _manager.outerCamera = YES;
        _manager.cameraType = HXPhotoManagerCameraTypeFullScreen;
        _manager.photoMaxNum = 9;
        _manager.videoMaxNum = 1;
        _manager.maxNum = 9;
        _manager.videoMaxDuration = 500.f;
        _manager.saveSystemAblum = NO;
        _manager.style = HXPhotoAlbumStylesSystem;
        _manager.reverseDate = YES;
        _manager.showDateHeaderSection = NO;
        //        _manager.selectTogether = NO;
        //        _manager.rowCount = 3;
        
        _manager.UIManager.navBar = ^(UINavigationBar *navBar) {
            //            [navBar setBackgroundImage:[UIImage imageNamed:@"APPCityPlayer_bannerGame"] forBarMetrics:UIBarMetricsDefault];
        };
    }
    return _manager;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //开启反地理编码
    _geocodesearch = [[BMKGeoCodeSearch alloc] init];
    _geocodesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor redColor];
    
    //开始定位
    [self initWithlocService];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    
//    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
//    scrollView.alwaysBounceVertical = YES;
//    [self.view addSubview:scrollView];
//    self.scrollView = scrollView;
    
//    CGFloat width = scrollView.frame.size.width;
    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
    photoView.frame = CGRectMake(kPhotoViewMargin, 120, YBWidth - kPhotoViewMargin * 2, 0);
    photoView.delegate = self;
    photoView.backgroundColor = [UIColor whiteColor];
    [self.topView addSubview:photoView];
    self.photoView = photoView;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册/相机" style:UIBarButtonItemStylePlain target:self action:@selector(didNavBtnClick)];
}

- (void)didNavBtnClick {
    
    
    [PPNetworkHelper POST:UploadContent parameters:nil success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
//    [self.photoView goPhotoViewController];
}

- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal {
    NSSLog(@"所有:%ld - 照片:%ld - 视频:%ld",allList.count,photos.count,videos.count);
    NSSLog(@"所有:%@  - 照片:%@  - 视频:%@" ,allList,photos,videos);
    
    if (allList.count >= 3) {
        self.topViewHeight.constant = 100 + 300;
    }
        
    [HXPhotoTools getImageForSelectedPhoto:photos type:HXPhotoToolsFetchHDImageType completion:^(NSArray<UIImage *> *images) {
        NSSLog(@"%@",images);
        NSMutableArray *imStrArray = [NSMutableArray array];
        
        self.testStr = @"";
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
        } failure:^(NSError *error) {
            NSLog(@"faile - :%@",error);
        }];
    }];
}

- (void)photoView:(HXPhotoView *)photoView deleteNetworkPhoto:(NSString *)networkPhotoUrl {
    NSSLog(@"%@",networkPhotoUrl);
}

- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame {
    NSSLog(@"%@",NSStringFromCGRect(frame));
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, CGRectGetMaxY(frame) + kPhotoViewMargin);
    
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

- (void)initWithlocService
{
    //开启定位
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
}


/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    if (userLocation.location) {//定位成功 关闭定位
        
        BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];//初始化反编码请求
        reverseGeocodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;//设置反编码的店为pt
        BOOL flag =   [self.geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
        if (flag) {
            YBLog(@"定位成功");
            [self.locService stopUserLocationService];
        }else {
            [MBProgressHUD showError:@"定位失败" toView:self.view];
        }
        return;
    }
    [MBProgressHUD showError:@"定位失败" toView:self.view];
    
}
#pragma mark - 起点信息
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    //    NSLog(@"address:%@----%@-----%@----%@",result.addressDetail.district,result.addressDetail.streetName,result.poiList,result.sematicDescription);
    if (result.sematicDescription) {
        NSString *str = [NSString stringWithFormat:@"%@·%@",result.addressDetail.city,result.sematicDescription];
        self.startingPoint = result;
//        [self.trainView.startingPointView initLabelStr:str];
        NSLog(@"str - %@",str);
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
