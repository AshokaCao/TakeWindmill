//
//  YBUserInfoVC.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/12/15.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBUserInfoVC.h"
#import "YBInformationCell.h"
#import "YBUserListModel.h"

@interface YBUserInfoVC ()<HXAlbumListViewControllerDelegate>
{
    
}
@property (nonatomic,strong) HXPhotoManager *manager;
@property (nonatomic,strong) HXDatePhotoToolManager *toolManager;
@property (nonatomic,strong) YBUserListModel *userModel;
@property (nonatomic,strong) NSMutableArray * imagesArrUrl;
@property (nonatomic,strong) YBInformationCell *infoCell;


@end

@implementation YBUserInfoVC
static NSArray *textArray;

// 懒加载 照片管理类
- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.openCamera = YES;
        //_manager.style = HXPhotoAlbumStylesSystem;
        _manager.configuration.photoMaxNum = 1;
        // _manager.videoMaxNum = 1;
        _manager.configuration.maxNum = 1;
    }
    return _manager;
}
- (HXDatePhotoToolManager *)toolManager {
    if (!_toolManager) {
        _toolManager = [[HXDatePhotoToolManager alloc] init];
    }
    return _toolManager;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人信息";
    textArray = [NSArray arrayWithObjects:@"头像",@"昵称",@"性别",@"年龄", nil];
    self.imagesArrUrl = [NSMutableArray array];
    
    [self setUpView];
   
    
    [self getUserListAction];
}
-(void)setUpView{
    
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YBWidth, 60)];
    UIButton * btn = [[UIButton alloc]init];
    btn.frame = CGRectMake(10, 10, YBWidth-20, 40);
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn setBackgroundColor:BtnBlueColor];
    btn.layer.cornerRadius = 4;
    [btn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn];
    self.tableView.tableFooterView = footView;
}
-(void)submit{
    WEAK_SELF;
    NSString * nickName = @"";
     NSString * sex = @"";
     NSString * age = @"";
    for (int i = 1; i<textArray.count; i++) {
        NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:1 inSection:0];
        YBInformationCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath1];
        if (i == 1) {
            nickName = cell.textField.text;
        }else if (i == 2){
             sex = cell.textField.text;
        }else if (i == 3){
             age = cell.textField.text;
        }
        
    }
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    NSString *userID = [YBUserDefaults valueForKey:_userId];
    //dict[@"userid"] = userID;
    
//    [YBRequest postWithURL:UserList MutableDict:dict success:^(id dataArray) {
//        NSLog(@"dataArray - %@",dataArray);
//
//        
//    } failure:^(id dataArray) {
//
    //    }];
}
- (void)getUserListAction
{
    WEAK_SELF;
    
    NSMutableDictionary *dict = [YBTooler dictinitWithMD5];
    NSString *userID = [YBUserDefaults valueForKey:_userId];
    dict[@"userid"] = userID;
    //    NSLog(@"dict - %@",dict);
    
    [YBRequest postWithURL:UserList MutableDict:dict success:^(id dataArray) {
        NSLog(@"dataArray - %@",dataArray);
        NSDictionary *dic = dataArray;
        NSDictionary *newDic = [NSDictionary changeType:dic];
        
        if (dic.count) {
            weakSelf.userModel = [YBUserListModel modelWithDic:newDic];
            [weakSelf.tableView reloadData];
        }
        
    } failure:^(id dataArray) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return textArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAK_SELF;
    static NSString * reuseIdentifier = @"reuseIdentifier";
    YBInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[YBInformationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    [cell.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.text.mas_right).offset(kpadding);
        make.centerY.equalTo(cell.text);
    }];
    [cell.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    
    
    if (indexPath.row == 0) {
        UIImage * image = [UIImage imageNamed:@"avatar_login"];
        [cell.imageV sd_setImageWithURL:[NSURL URLWithString:weakSelf.userModel.HeadImgUrl] placeholderImage:image];
        cell.imageV.layer.cornerRadius = 30;
        cell.imageV.clipsToBounds = YES;
        
        cell.textField.hidden = YES;
    }else{
        cell.imageV.hidden = YES;
    }
    

    if (indexPath.row <textArray.count) {
        cell.text.text = textArray[indexPath.row];
        cell.textField.textAlignment = NSTextAlignmentLeft;
        
        
        if (indexPath.row == 1) {
            cell.textField.placeholder = [NSString stringWithFormat:@"请输入%@",textArray[indexPath.row]];
            if(weakSelf.userModel.NickName.length){
                cell.textField.text = weakSelf.userModel.NickName;
            }
        }else{
            cell.textField.placeholder = [NSString stringWithFormat:@"请选择%@",textArray[indexPath.row]];
            cell.textField.userInteractionEnabled = NO;
            
            if(indexPath.row == 2){
                if(weakSelf.userModel.Sex.length){
                    cell.textField.text = weakSelf.userModel.Sex;
                }
            }else{
                if(weakSelf.userModel.Age.length){
                    cell.textField.text = weakSelf.userModel.Age;
                }
            }
        }
    }

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAK_SELF;
    
    YBInformationCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    weakSelf.infoCell = cell;
    
    if (indexPath.row != 1) {
        NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:1 inSection:0];
        YBInformationCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath1];
        [cell endEditing:YES];
    }
   

    if (indexPath.row == 0) {
        // 照片选择控制器
//        HXPhotoViewController *vc = [[HXPhotoViewController alloc] init];
//        vc.delegate = self;
//        vc.manager = self.manager;
//        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
        
         [self hx_presentAlbumListViewControllerWithManager:self.manager delegate:self];
        
    }else if (indexPath.row == 1){
        
    }else if (indexPath.row == 2){
        NSMutableArray * dataSource = [NSMutableArray arrayWithObjects:@"男",@"女", nil];
        [BRStringPickerView showStringPickerWithTitle:@"" dataSource:dataSource defaultSelValue:@"男" isAutoSelect:YES resultBlock:^(id selectValue) {
            weakSelf.infoCell.textField.text = selectValue;
        }];
        
    }else if (indexPath.row == 3){
        NSMutableArray * dataSource = [NSMutableArray array];
        for (int i =0; i<10; i++) {
            NSString *str = [NSString stringWithFormat:@"%d0后",i];
            [dataSource addObject:str];
        }
        [BRStringPickerView showStringPickerWithTitle:@"" dataSource:dataSource defaultSelValue:weakSelf.infoCell.textField.text isAutoSelect:YES resultBlock:^(id selectValue) {
            weakSelf.infoCell.textField.text = selectValue;
        }];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}
#pragma  mark HXAlbumListViewControllerDelegate
- (void)albumListViewController:(HXAlbumListViewController *)albumListViewController didDoneAllList:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photoList videos:(NSArray<HXPhotoModel *> *)videoList original:(BOOL)original {
    WEAK_SELF;
   //YBLog(@"allList==%@,photos==%@,videos==%@",allList,photoList,videoList);
    [self.manager clearSelectedList];
    
    [self.toolManager getSelectedImageList:photoList success:^(NSArray<UIImage *> *imageList) {
        weakSelf.infoCell.imageV.image = imageList[0];
        NSMutableArray *imStrArray = [NSMutableArray array];
        for (UIImage *image in imageList) {
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
                    
                    [weakSelf.imagesArrUrl addObject:array.firstObject];
                    
                }
                
            }
            //YBLog(@" self.imagesArrUrl%@vehiclemanpicpath==%@", weakSelf.imagesArrUrl,vehiclemanpicpath);
        } failure:^(NSError *error) {
            NSLog(@"faile - :%@",error);
        }];
    } failed:^{
        
    }];
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
