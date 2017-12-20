//
//  YBTooler.m
//  TakeWindmill
//
//  Created by 靳亚彬 on 2017/8/15.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBTooler.h"
#import "YBKeyChainStore.h"

#define KEY_USERNAME_PASSWORD @"com.yb.TakeWindmill.usernamepassword"

@implementation YBTooler

+ (void)setTheControlShadow:(UIView *)sender
{
    sender.layer.shadowOffset = CGSizeMake(0, 3);
    sender.layer.shadowRadius = 3;
    sender.layer.shadowOpacity = 0.2;//阴影透明度，默认0
    sender.layer.shadowColor = [UIColor blackColor].CGColor;
}

+ (NSMutableAttributedString *)changeLabelWithText:(NSString*)needText frontTextFont:(CGFloat)titleFont Subscript:(CGFloat)subscript TextLength:(CGFloat)length BehindTxetFont:(CGFloat)subFont Subscript:(CGFloat)sub TextLength:(CGFloat)leng
{
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:needText];
    [attrString addAttribute:NSFontAttributeName value:YBFont(titleFont) range:NSMakeRange(subscript,length)];
    [attrString addAttribute:NSFontAttributeName value:YBFont(subFont) range:NSMakeRange(sub,leng)];
    return attrString;
}

+ (NSMutableAttributedString *)labelThreeFontsAllWords:(NSString*)all oneFont:(CGFloat)oneFont oneSubscript:(CGFloat)oneSubscript oneLength:(CGFloat)oneLength twoFont:(CGFloat)twoFont twoSubscript:(CGFloat)twosub twoLength:(CGFloat)twoLeng threeFont:(CGFloat)threeFont threeSubscript:(CGFloat)threesub threeLength:(CGFloat)threeLeng
{
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:all];
    [attrString addAttribute:NSFontAttributeName value:YBFont(oneFont) range:NSMakeRange(oneSubscript,oneLength)];
    [attrString addAttribute:NSFontAttributeName value:YBFont(twoFont) range:NSMakeRange(twosub,twoLeng)];
    [attrString addAttribute:NSFontAttributeName value:YBFont(threeFont) range:NSMakeRange(threesub,threeLeng)];

    return attrString;
}

+ (NSMutableDictionary *)dictinitWithMD5
{
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    NSString *str1  = [NSString stringWithFormat:@"%f",interval];
    NSString *str = [YBMD5 MD5ForUpper32Bate:[NSString stringWithFormat:@"bibi1712161328%f",interval]];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"md5" forKey:@"authtype"];
    [dict setObject:@"bibi1712161328" forKey:@"appkey"];
    [dict setObject:@"101000@yimi_web_1.0.0" forKey:@"sourceid"];
    [dict setObject:@"6067fa88a29f566571ebf8d3506370bc" forKey:@"weblogid"];
    [dict setObject:@"ios" forKey:@"os"];
    [dict setObject:@"1.1" forKey:@"ver"];
    [dict setObject:str1 forKey:@"t"];
    [dict setObject:str forKey:@"sign"];
    [dict setObject:[self uuid] forKey:@"deviceid"];
    return dict;
}

+ (NSMutableAttributedString *)changeLabelWithText:(NSString*)needText {
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:needText];
    UIFont *font = [UIFont systemFontOfSize:25];
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,needText.length - 2)];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(needText.length - 2,2)];
    
    return attrString;
}

+ (NSString*)URLDecodedString:(NSString*)str
{
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)str,CFSTR(""),CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}

+ (NSString *)uuid
{
    NSString*strUUID = (NSString*)[YBKeyChainStore load:KEY_USERNAME_PASSWORD];
    
    //首次执行该方法时，uuid为空
    if([strUUID isEqualToString:@""]|| !strUUID)
    {
        //生成一个uuid的方法
        CFUUIDRef uuidRef= CFUUIDCreate(kCFAllocatorDefault);
        
        strUUID = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault,uuidRef));
        
        //将该uuid保存到keychain
        [YBKeyChainStore save:KEY_USERNAME_PASSWORD data:strUUID];
        
    }
    return strUUID;
}

+ (CGFloat)accordingToTheWidthOfTheCalculationOfHigh:(NSString *)str with:(CGFloat)with font:(CGFloat)font
{
    CGRect titleSize = [str boundingRectWithSize:CGSizeMake(with, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:YBFont(font)} context:nil];

    return titleSize.size.height;
}

+ (CGFloat)calculateTheStringWidth:(NSString *)str font:(CGFloat)font
{
    CGSize titleSize = [str sizeWithAttributes:@{NSFontAttributeName: YBFont(font)}];
    return ceil(titleSize.width);
}

+ (NSString *)getTheUserId:(UIView *)view
{
    if (![YBUserDefaults objectForKey:_userId]) {
        [MBProgressHUD showError:@"暂未登录,请登录" toView:view];
        return @"";
    }
    return [YBUserDefaults objectForKey:_userId];
}

+ (NSMutableAttributedString *)stringSetsTwoColorsLabel:(NSString *)label Second:(NSString *)second Colour:(UIColor *)color
{
    NSMutableAttributedString *hintString = [[NSMutableAttributedString alloc]initWithString:label];
    NSRange range1                  = [[hintString string]rangeOfString:second];
    [hintString addAttribute:NSForegroundColorAttributeName value:color range:range1];
    return hintString;
}

+ (void)buttonEdgeInsets:(UIButton *)button
{
//    YBLog(@"图片宽度：%f,文字宽度：%f",button.imageView.bounds.size.width,button.titleLabel.bounds.size.width);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, - button.imageView.bounds.size.width, 0, button.imageView.bounds.size.width);
    button.imageEdgeInsets = UIEdgeInsetsMake(5, button.titleLabel.bounds.size.width + 2, 5, - button.titleLabel.bounds.size.width);
}

#pragma mark - 点击电话
+ (void)dialThePhoneNumber:(NSString *)Number displayView:(UIView *)view
{
    NSMutableString * str= [[NSMutableString alloc] initWithFormat:@"tel:%@",Number];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [view addSubview:callWebview];
}

@end
