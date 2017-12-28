//
//  YBWebViewVC.m
//  TakeWindmill
//
//  Created by HSH on 2017/12/27.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBWebViewVC.h"

@interface YBWebViewVC ()<UIWebViewDelegate,IMYWebViewDelegate>
{
    
}
@property (nonatomic, strong) UIScrollView *backScroll;
@property (nonatomic, strong) UIWebView *htmlView;

@property (nonatomic, strong) IMYWebView * webView;
@end

@implementation YBWebViewVC
static BOOL isWebView = YES;

-(IMYWebView *)webView{
    if (!_webView) {
        _webView = [[IMYWebView alloc] initWithFrame:self.view.bounds];
        _webView.delegate = self;
    }
    return _webView;
}
-(UIWebView *)htmlView{
    if (!_htmlView) {
        UIWebView *web = [[UIWebView alloc] initWithFrame:self.view.bounds];
        web.scrollView.scrollEnabled = NO;
        web.delegate = self;
        web.dataDetectorTypes = UIDataDetectorTypeAll;//当webview中有电话号码，点击号码就能直接打电话
        _htmlView = web;
    }
    return _htmlView;
}
- (UIScrollView *)backScroll {
    if (!_backScroll) {
        UIScrollView *bigscroll = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        bigscroll.backgroundColor = [UIColor groupTableViewBackgroundColor];
        bigscroll.showsHorizontalScrollIndicator = NO;
        bigscroll.showsVerticalScrollIndicator = NO;
        _backScroll = bigscroll;
    }
    return _backScroll;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
   
    [self setUI];
    
    [self requestData];
}
-(void)setUI{
    [self.view addSubview:self.backScroll];
    
    
    [self.backScroll addSubview:isWebView ? self.htmlView : self.webView];
}
-(void)requestData{
    NSString * urlStr = self.urlString;
    
    urlStr=[urlStr stringByReplacingOccurrencesOfString:@"Service/"withString:@""];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    isWebView ?  [self.htmlView loadRequest:request] : [self.webView loadRequest:request];
}


#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSInteger height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] integerValue];
    self.htmlView.frame=CGRectMake(0, 0, kScreenWidth,height);
    //CGFloat contentHeight = self.backScroll.contentSize.height;
    //YBLog(@"contentHeight==%f",kScreenHeight);
    self.backScroll.contentSize = CGSizeMake(kScreenWidth, height+kNaviHeight);

}
//#pragma mark - IMYWebViewDelegate
//- (void)webViewDidFinishLoad:(IMYWebView*)webView{
//
//}
- (void)dealloc {
    NSLog(@"%s",__func__);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
