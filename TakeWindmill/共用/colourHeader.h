//
//  colourHeader.h
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/7.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//


//weak strong self for retain cycle
#define WEAK_SELF __weak typeof(self)weakSelf = self
#define STRONG_SELF __strong typeof(weakSelf)strongSelf = weakSelf

//颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
//按钮绿色
#define BtnGreenColor RGBA(60,188,163,1)
//按钮橙色
#define BtnOrangeColor RGBA(252,159,105,1)
//按钮蓝色
#define TxetFiedColor RGBA(200,200,205,1)
//按钮蓝色
#define BtnBlueColor [UIColor colorWithRed:63/255.0 green:168/255.0 blue:223/255.0 alpha:1]
//背景灰
#define LineLightColor [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1]
//背景灰
#define LightGreyColor [UIColor colorWithRed:241/255.0 green:245/255.0 blue:246/255.0 alpha:1]
//蓝点
#define BluePointColor [UIColor colorWithRed:70/255.0 green:166/255.0 blue:226/255.0 alpha:1]
//蓝点
#define OrangePointColor [UIColor colorWithRed:255/255.0 green:144/255.0 blue:85/255.0 alpha:1]

//字体灰色
#define  kTextGreyColor RGBA(199, 199, 205, 1)
#define  kTextBackColor RGBA(51, 51, 51, 1)
#define kpadding 10
#define kMaxpadding 5
#define kMinPadding 2

//高度
#define YBBounds [UIScreen mainScreen].bounds

#define YBWidth [UIScreen mainScreen].bounds.size.width

#define YBHeight ([UIScreen mainScreen].bounds.size.height - 64)
//百分比


//设置字体大小
#define YBFont(a) [UIFont systemFontOfSize:a]


// 输出日志 DEBUG是调试时系统存在的一个宏. 这样是为了项目发布后,不需要看到的输出日志就不会输出,提高代码的运行.
#ifdef DEBUG
#define YBLog(format, ...) printf("[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
#define YBLog(format, ...)


#endif
