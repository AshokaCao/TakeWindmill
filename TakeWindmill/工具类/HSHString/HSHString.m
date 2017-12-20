//
//  HSHString.m
//  RZECM
//
//  Created by HSH on 15/5/12.
//  Copyright © 2015年 runsoft. All rights reserved.
//

#import "HSHString.h"
#import "sys/utsname.h"

@implementation HSHString

#pragma mark -  json转换
+(instancetype )getObjectFromJsonString:(NSString *)jsonString
{
    NSError *error = nil;
    if (jsonString) {
        id rev=[NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUnicodeStringEncoding] options:NSJSONReadingMutableLeaves error:&error];
        if (error==nil) {
            return rev;
        }
        else
        {
            return nil;
        }
    }
    return nil;
}

+(NSString *)getJsonStringFromObject:(id)object
{
    if ([NSJSONSerialization isValidJSONObject:object])
    {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:0 error:nil];
        return [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return nil;
}

#pragma mark -  NSDate互转NSString
+(NSDate *)NSStringToDate:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:dateString];
    return dateFromString;
}

+(NSDate *)NSStringToDate:(NSString *)dateString withFormat:(NSString *)formatestr{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatestr];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:dateString];
    return dateFromString;
}

+(NSString *)NSDateToString:(NSDate *)dateFromString withFormat:(NSString *)formatestr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatestr];
    NSString *strDate = [dateFormatter stringFromDate:dateFromString];
    return strDate;
}

#pragma mark -  判断字符串是否为空,为空的话返回 “” （一般用于保存字典时）
+(NSString *)IsNotNull:(id)string
{
    NSString * str = (NSString*)string;
    if ([self isBlankString:str]){
        string = @"";
    }
    return string;
    
}
+(NSString *)toString:(NSUInteger)uinteger{
    return [NSString stringWithFormat:@"%ld",uinteger];
}
//..判断字符串是否为空字符的方法
+(BOOL) isBlankString:(id)string {
    NSString * str = (NSString*)string;
    
    if ([str isKindOfClass:[NSNull class]]) {
        NSLog(@"数据有误");
        return YES;
    }
    if ([str isEqualToString:@"(null)"]) {
        return YES;
    }
    if (str == nil || str == NULL) {
        return YES;
    }
    if ([str isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
//去除空格
+(NSString *)removeSpaces:(NSString *)string{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    return string;
}
//copy
+(void)copy:(NSString *)string{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = string;
}
//paste
+(NSString *)paste{
     UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    return pasteboard.string;
}

#pragma mark - 使用subString去除float后面无效的0
+(NSString *)changeFloatWithString:(NSString *)stringFloat

{
    const char *floatChars = [stringFloat UTF8String];
    NSUInteger length = [stringFloat length];
    NSUInteger zeroLength = 0;
    NSInteger i = length-1;
    for(; i>=0; i--)
    {
        if(floatChars[i] == '0') {
            zeroLength++;
        } else {
            if(floatChars[i] == '.')
                i--;
            break;
        }
    }
    NSString *returnString;
    if(i == -1) {
        returnString = @"0";
    } else {
        returnString = [stringFloat substringToIndex:i+1];
    }
    return returnString;
}

#pragma mark - 去除float后面无效的0
+(NSString *)changeFloatWithFloat:(CGFloat)floatValue

{
    return [self changeFloatWithString:[NSString stringWithFormat:@"%f",floatValue]];
}

#pragma mark - 如何通过一个整型的变量来控制数值保留的小数点位数。以往我们通类似@"%.2f"来指定保留2位小数位，现在我想通过一个变量来控制保留的位数
+(NSString *)newFloat:(float)value withNumber:(int)numberOfPlace
{
    NSString *formatStr = @"%0.";
    formatStr = [formatStr stringByAppendingFormat:@"%df", numberOfPlace];
    NSLog(@"____%@",formatStr);
    
    formatStr = [NSString stringWithFormat:formatStr, value];
    NSLog(@"____%@",formatStr);
    
    printf("formatStr %s\n", [formatStr UTF8String]);
    return formatStr;
}


#pragma mark -  手机号码验证
+(BOOL) isValidateMobile:(NSString *)mobile
{
    /*
     //手机号以13， 15，18开头，八个 \d 数字字符
     NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
     NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
     return [phoneTest evaluateWithObject:mobile];
     */
    
    NSPredicate* phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"1[34578]([0-9]){9}"];
    
    return [phoneTest evaluateWithObject:mobile];
    
}

#pragma mark -  阿里云压缩图片
+(NSURL*)UrlWithStringForImage:(NSString*)string{
    NSString * str = [NSString stringWithFormat:@"%@@800w_600h_10Q.jpg",string];
    NSLog(@"加载图片地址=%@",str);
    return [NSURL URLWithString:str];
}

//..去掉压缩属性“@800w_600h_10Q.jpg”
+(NSString*)removeYaSuoAttribute:(NSString*)string{
    NSString * str = @"";
    if ([string rangeOfString:@"@"].location != NSNotFound) {
        NSArray * arry = [string componentsSeparatedByString:@"@"];
        str = arry[0];
    }
    return str;
}

#pragma mark - 字符串类型判断
//..判断是否为整形：
+ (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形：
+ (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}


#pragma mark -  计算内容文本的高度方法
+ (CGFloat)HeightForText:(NSString *)text withSizeOfLabelFont:(CGFloat)font withWidthOfContent:(CGFloat)contentWidth
{
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:font]};
    CGSize size = CGSizeMake(contentWidth, 2000);
    CGRect frame = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return frame.size.height;
}

#pragma mark -  计算字符串长度
+ (CGFloat)WidthForString:(NSString *)text withSizeOfFont:(CGFloat)font
{
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:font]};
    CGSize size = [text sizeWithAttributes:dict];
    return size.width;
}

#pragma mark - 计算cell的高度
+(CGFloat)theHeightOfString:(NSString*)str width:(CGFloat)width fontSize:(CGFloat)fontSize
{
    CGFloat height=[str sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, 1000000) lineBreakMode:NSLineBreakByWordWrapping].height;
    
    return height+6;
}

#pragma mark 时间戳转NSString
+(NSString *)timeWithTimeIntervalString:(NSString *)timeIntervalStr{//时间戳 timeIntervalStr
    
    NSTimeInterval time=[timeIntervalStr doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //NSLog(@"date:%@",[detaildate description]);
    //设置你想要的格式,hh 12 与HH 24
    return [HSHString NSDateToString:detaildate withFormat:@"yyyy-MM-dd HH:mm:ss"];
}
+(NSString *)timeWithTimeIntervalString:(NSString *)timeIntervalStr withFormat:(NSString *)formatestr{
    
    NSTimeInterval time=[timeIntervalStr doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //NSLog(@"date:%@",[detaildate description]);
    //设置你想要的格式,hh 12 与HH 24
    return [HSHString NSDateToString:detaildate withFormat:formatestr];
}
+(NSString *)timeWithStr:(NSString *)timeString{
    //11/22/2017+00:00:00;
    NSString * dateStr = [HSHString strSubSting:timeString toStr:@"+"];
    dateStr = [dateStr stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    return dateStr;
}
#pragma mark NSDate转化为时间戳
+(NSString *)timeIntervalWithNSDate:(NSDate *)date{
    //NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];// 当前时间
    NSTimeInterval a=[date timeIntervalSince1970]*1000; // *1000 是精确到毫秒，不乘就是精确到秒
    return [NSString stringWithFormat:@"%.0f", a]; //转为字符型
}

#pragma mark -  计算两个时间相差多少秒

+(NSInteger)getSecondsWithBeginDate:(NSString*)currentDateString  AndEndDate:(NSString*)tomDateString{
    
    NSDate * currentDate = [HSHString NSStringToDate:currentDateString withFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSInteger currSec = [currentDate timeIntervalSince1970];
    
    NSDate *tomDate = [HSHString NSStringToDate:tomDateString withFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSInteger tomSec = [tomDate timeIntervalSince1970];
    
    NSInteger newSec = tomSec - currSec;
    NSLog(@"相差秒：%ld",(long)newSec);
    return newSec;
}


#pragma mark - 根据出生日期获取年龄
+ (NSInteger)ageWithDateOfBirth:(NSDate *)date;
{
    // 出生日期转换 年月日
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    NSInteger brithDateYear  = [components1 year];
    NSInteger brithDateDay   = [components1 day];
    NSInteger brithDateMonth = [components1 month];
    
    // 获取系统当前 年月日
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    NSInteger currentDateYear  = [components2 year];
    NSInteger currentDateDay   = [components2 day];
    NSInteger currentDateMonth = [components2 month];
    
    // 计算年龄
    NSInteger iAge = currentDateYear - brithDateYear - 1;
    if ((currentDateMonth > brithDateMonth) || (currentDateMonth == brithDateMonth && currentDateDay >= brithDateDay)) {
        iAge++;
    }
    
    return iAge;
}


#pragma mark - 根据经纬度计算两个位置之间的距离
+(double)distanceBetweenOrderBylat1:(double)lat1 lat2:(double)lat2 lng1:(double)lng1 lng2:(double)lng2{
    double dd = M_PI/180;
    double x1=lat1*dd,x2=lat2*dd;
    double y1=lng1*dd,y2=lng2*dd;
    double R = 6371004;
    double distance = (2*R*asin(sqrt(2-2*cos(x1)*cos(x2)*cos(y1-y2) - 2*sin(x1)*sin(x2))/2));
    //返回km
    return  distance/1000;
    
    //返回m
    //return   distance;
}
#pragma mark ============================================

#pragma mark - 实现富文本（不同颜色字体、xxxx等）
+(NSMutableAttributedString *)strAttribute:(NSString *)str andColor:(UIColor *)color startIndex:(NSUInteger)index
{
    if (str.length>index) {
        NSMutableAttributedString * str1 = [[NSMutableAttributedString alloc]initWithString:str];
        [str1 addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(index,str.length-index)];
        return str1;
    }else{
        return [[NSMutableAttributedString alloc]initWithString:@""];
    }
}
+(NSMutableAttributedString *)strAttribute:(NSString *)str andColor:(UIColor *)color startStr:(NSString *)startStr endStr:(NSString *)endStr
{
    NSRange range = [str rangeOfString:startStr];
    NSRange range1 = [str rangeOfString:endStr];
   
    if (range.location != NSNotFound && range1.location != NSNotFound){
        NSInteger loc = range.location;
        NSInteger len = range1.location - range.location;
        NSMutableAttributedString * str1 = [[NSMutableAttributedString alloc]initWithString:str];
        [str1 addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(loc+1,len-1)];
        return str1;
    }else{
        return [[NSMutableAttributedString alloc]initWithString:str];
    }
    
}
//下划线
+(NSMutableAttributedString *)strAttributeLine:(NSString *)str{
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:str attributes:attribtDic];
    return attribtStr;
}
#pragma mark - 截取字符串
+(NSString *)strSubSting:(NSString *)str startStr:(NSString *)startStr endStr:(NSString *)endStr
{
    NSString * subStr = @"";
    NSRange range = [str rangeOfString:startStr];
    NSRange range1 = [str rangeOfString:endStr];
    
    if (range.location != NSNotFound && range1.location != NSNotFound){
        NSInteger loc = range.location;
        NSInteger len = range1.location - range.location;
        subStr = [str substringWithRange:NSMakeRange(loc+1, len-1)];
    }
    return subStr;
}

#pragma mark - 截取字符串 为两段并返回一个数组
+(NSArray *)strSubSting:(NSString *)str withStr:(NSString *)withStr
{
    NSString * subStr1 = @"";
    NSString * subStr2 = @"";
    NSArray * array;
    
    NSRange range = [str rangeOfString:withStr];
    
    if (range.location != NSNotFound){
        NSInteger loc = range.location;
       subStr1 = [str substringToIndex:loc];
       subStr2 = [str substringFromIndex:loc];
       array = [NSArray arrayWithObjects:subStr1,subStr2, nil];
    }
    return array;
}
#pragma mark - 截取字符串 到某个字符串
+(NSString *)strSubSting:(NSString *)str toStr:(NSString *)toStr
{
    NSString * subStr = @"";
    
    NSRange range = [str rangeOfString:toStr];
    
    if (range.location != NSNotFound){
        NSInteger loc = range.location;
        subStr = [str substringToIndex:loc];
    }
    return subStr;
}
+(NSString *)strSubSting:(NSString *)str ToIndex:(NSInteger)index{
     NSString * subStr = @"";
    if (str.length >= index) {
        subStr = [str substringToIndex:index];
    }else{
        subStr = str;
    }
    return subStr;
}
#pragma mark - 一个个截取
+(NSMutableArray *)strSubSting:(NSString *)str withCount:(int)count
{
    NSMutableArray * array = [NSMutableArray array];
    for (int i =0; i<count; i++) {
        NSString *subStr = [str substringWithRange:NSMakeRange(i,1)];
        [array addObject:subStr];
    }
    return array;
}

+(NSString *)weekDayWithDate:(NSDate *)date
{
    // 日期转换 年月日
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    NSInteger Year = [components1 year];
    NSInteger Day  = [components1 day];
    NSInteger Month = [components1 month];
    
    NSArray * weekdays = [NSArray arrayWithObjects: @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    NSDateComponents *_comps = [[NSDateComponents alloc] init];
    [_comps setDay:Day];
    [_comps setMonth:Month];
    [_comps setYear:Year];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *_date = [gregorian dateFromComponents:_comps];
    NSDateComponents *weekdayComponents =
    [gregorian components:NSWeekdayCalendarUnit fromDate:_date];
    //在这里需要注意的是：星期日是数字1，星期一时数字2，以此类推。。。
    NSUInteger _weekday = [weekdayComponents weekday];
    return weekdays[_weekday-1];
}
#pragma mark - 根据year month day 计算星期几
+(NSString *)weekDayWithYear:(NSString *)year month:(NSString *)month day:(NSString *)day
{
    NSArray * weekdays = [NSArray arrayWithObjects: @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    NSDateComponents *_comps = [[NSDateComponents alloc] init];
    [_comps setDay:[day integerValue]];
    [_comps setMonth:[month integerValue]];
    [_comps setYear:[year integerValue]];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *_date = [gregorian dateFromComponents:_comps];
    NSDateComponents *weekdayComponents =
    [gregorian components:NSWeekdayCalendarUnit fromDate:_date];
    //在这里需要注意的是：星期日是数字1，星期一时数字2，以此类推。。。
    NSUInteger _weekday = [weekdayComponents weekday];
    return weekdays[_weekday-1];

}

/**
 *  16进制转uicolor
 *
 *  @param color @"#FFFFFF" ,@"OXFFFFFF" ,@"FFFFFF"
 *
 *  @return uicolor
 */
+ (UIColor *)colorWithHexString:(NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}
#pragma mark - 计算公式为：font=pt=px*72/96=px*3/4 。
+(CGFloat)fontSizeWithPx:(CGFloat)px
{
    return px*3/4;
}
#pragma mark
+(UIFont *)fontWithPx:(CGFloat)px
{
    return [UIFont systemFontOfSize: px*3/4];
}
#pragma mark
+ (NSString *)getDeviceVersionInfo
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithFormat:@"%s", systemInfo.machine];
    
    NSString *correspondVersion = platform;
    //iPhone
    if ([correspondVersion isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([correspondVersion isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([correspondVersion isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([correspondVersion isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([correspondVersion isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([correspondVersion isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([correspondVersion isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([correspondVersion isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([correspondVersion isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([correspondVersion isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([correspondVersion isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([correspondVersion isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([correspondVersion isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([correspondVersion isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([correspondVersion isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([correspondVersion isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    
    //iPod
    if ([correspondVersion isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([correspondVersion isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([correspondVersion isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([correspondVersion isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([correspondVersion isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    
    //iPad
    if ([correspondVersion isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([correspondVersion isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([correspondVersion isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([correspondVersion isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([correspondVersion isEqualToString:@"iPad2,4"])      return @"iPad 2 (32nm)";
    if ([correspondVersion isEqualToString:@"iPad2,5"])      return @"iPad mini (WiFi)";
    if ([correspondVersion isEqualToString:@"iPad2,6"])      return @"iPad mini (GSM)";
    if ([correspondVersion isEqualToString:@"iPad2,7"])      return @"iPad mini (CDMA)";
    
    if ([correspondVersion isEqualToString:@"iPad3,1"])      return @"iPad 3(WiFi)";
    if ([correspondVersion isEqualToString:@"iPad3,2"])      return @"iPad 3(CDMA)";
    if ([correspondVersion isEqualToString:@"iPad3,3"])      return @"iPad 3(4G)";
    if ([correspondVersion isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([correspondVersion isEqualToString:@"iPad3,5"])      return @"iPad 4 (4G)";
    if ([correspondVersion isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    
    if ([correspondVersion isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([correspondVersion isEqualToString:@"iPad4,2"])      return @"iPad Air";
    if ([correspondVersion isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([correspondVersion isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([correspondVersion isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    
    if ([correspondVersion isEqualToString:@"iPad4,4"]
        ||[correspondVersion isEqualToString:@"iPad4,5"]
        ||[correspondVersion isEqualToString:@"iPad4,6"])      return @"iPad mini 2";
    
    if ([correspondVersion isEqualToString:@"iPad4,7"]
        ||[correspondVersion isEqualToString:@"iPad4,8"]
        ||[correspondVersion isEqualToString:@"iPad4,9"])      return @"iPad mini 3";
    
    // Simulator
    if ([correspondVersion isEqualToString:@"i386"])         return @"Simulator";
    if ([correspondVersion isEqualToString:@"x86_64"])       return @"Simulator";
    
    return correspondVersion;
}

+ (NSString *)getAppCurVersion{
    NSString *appCurVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return appCurVersion;
}


#pragma mark  获取SDImageCach缓存,getSize直接获取
+(void)findAllImageCache{
    NSUInteger imgSize = [[SDImageCache sharedImageCache] getSize];
    NSString * currentVolum = [NSString stringWithFormat:@"%@",[self fileSizeWithInterge:imgSize]];
    NSString *msg = [NSString stringWithFormat:@"SDImageCach缓存为%@",currentVolum];
    NSLog(@"%@",msg);
}
// 转换大小
+(NSString *)fileSizeWithInterge:(NSInteger)size{
    // 1k = 1024b, 1m = 1024k
    if (size < 1024) {// 小于1k
        return [NSString stringWithFormat:@"%ldB",(long)size];
    }else if (size < 1024 * 1024){// 小于1m
        CGFloat aFloat = size/1024;
        return [NSString stringWithFormat:@"%.0fK",aFloat];
    }else if (size < 1024 * 1024 * 1024){// 小于1G
        CGFloat aFloat = size/(1024 * 1024);
        return [NSString stringWithFormat:@"%.1fM",aFloat];
    }else{
        CGFloat aFloat = size/(1024*1024*1024);
        return [NSString stringWithFormat:@"%.1fG",aFloat];
    }
}

+(NSMutableDictionary *)customerParm:(NSDictionary *)parm{
    NSArray * keys = [parm allKeys];
    NSArray *afterSortKeyArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSComparisonResult resuest = [obj1 compare:obj2];
        return resuest;
    }];
    NSString * allStr = @"";
    BOOL isSign = NO;
    NSMutableDictionary * DIC = [NSMutableDictionary dictionary];
    for(NSString* str in afterSortKeyArray){
        if ([str isEqualToString:@"sign"]) {
            isSign = YES;
              [DIC setValue:[parm objectForKey:str] forKey:str];
        }else{
            allStr = [allStr stringByAppendingFormat:@"%@=%@&", str,[parm objectForKey:str]];
            [DIC setValue:[parm objectForKey:str] forKey:str];
        }
    }
    if (!isSign) {
        NSMutableDictionary * muDic = [NSMutableDictionary dictionaryWithDictionary:DIC];
   //     [muDic addEntriesFromDictionary:parm];
        return muDic;
    }
    
    allStr = [allStr stringByAppendingFormat:@"sign=yue135mi"];
   
    NSMutableDictionary * muDic = [NSMutableDictionary dictionaryWithDictionary:DIC];
    // [muDic addEntriesFromDictionary:parm];
//     [muDic setValue:[allStr base64WithMD5] forKey:@"sign"];
    //NSLog(@"muDic==%@allStr==%@",muDic,allStr);
    return muDic;
}

+(CAShapeLayer *)maskLayerView:(UIView *)view cornerRadii:(CGSize)cornerRadii{
    //UIRectCornerTopLeft | UIRectCornerBottomRight
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerBottomLeft cornerRadii:cornerRadii];//CGSizeMake(15, 15)
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
   // view.layer.mask = maskLayer;
    return  maskLayer;
}


@end
