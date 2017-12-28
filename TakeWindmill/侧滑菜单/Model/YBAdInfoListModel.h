//
//  YBAdInfoListModel.h
//  TakeWindmill
//
//  Created by HSH on 2017/12/28.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdInfoModel : NSObject
//PicUrl = http://121.40.76.10:93/UploadFiles/ad/index_slide/路况首页图.jpg?v=1.1;
//CountySysNo = 0;
//CitySysNo = 0;
//ClassSysNo = 1;
//AddUser = ;
//LinkUrl = http://www.bibizl.com/WebPage/Ad/Ad01.html;
//AddTime = 12/13/2017+14:45:00;
//ErrorMessage = ;
//HasError = 0;
//SysNo = 9;
//Title = ;
//AdName = 首页轮播1;
//}
@property(nonatomic,strong) NSString *PicUrl;
@property(nonatomic,strong) NSString *CountySysNo;
@property(nonatomic,strong) NSString *CitySysNo;
@property(nonatomic,strong) NSString *ClassSysNo;
@property(nonatomic,strong) NSString *AddUser;
@property(nonatomic,strong) NSString *LinkUrl;
@property(nonatomic,strong) NSString *AddTime;
@property(nonatomic,strong) NSString *ErrorMessage;
@property(nonatomic,strong) NSString *HasError;
@property(nonatomic,strong) NSString *SysNo;
@property(nonatomic,strong) NSString *Title;
@property(nonatomic,strong) NSString *AdName;
@end
@interface YBAdInfoListModel : NSObject
@property(nonatomic,strong) NSString *ErrorMessage;
@property(nonatomic,strong) NSString *HasError;

@property(nonatomic,strong) NSArray *AdInfoList;
@end
