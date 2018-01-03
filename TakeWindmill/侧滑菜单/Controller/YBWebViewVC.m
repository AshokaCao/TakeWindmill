//
//  YBWebViewVC.m
//  TakeWindmill
//
//  Created by HSH on 2017/12/27.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBWebViewVC.h"
#import "YBJSObject.h"
#import "YBCarpoolOrdersVC.h"


@protocol JSTurnToDelegate <JSExport>

#pragma mark -js调用该oc方法
-(void)turnTo:(NSString *)jsonString;

@end

@interface YBWebViewVC ()<UIWebViewDelegate,IMYWebViewDelegate,JSTurnToDelegate>
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
        //_webView.scrollView.scrollEnabled = NO;
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
    WEAK_SELF;
    if (isWebView) {
        NSInteger height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] integerValue];
        self.htmlView.frame=CGRectMake(0, 0, kScreenWidth,height);
        //CGFloat contentHeight = self.backScroll.contentSize.height;
        //YBLog(@"contentHeight==%f",kScreenHeight);
        self.backScroll.contentSize = CGSizeMake(kScreenWidth, height+kNaviHeight);
        
        JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        context.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
            context.exception = exceptionValue;
            YBLog(@"异常信息：%@", exceptionValue);
        };
        /*
         //1.js里面直接调用方法
         //2.js里面通过对象调用方法
         //str对象是JS那边传递过来。
         context[@"turnTo"] = ^(NSString *str){
         YBLog(@"YBLog==%@",str);
         };
         YBJSObject * object = [[YBJSObject alloc]init];
         context[@"NativeApi"] = object;
         
         NSString *jsFunctStr=@"turnTo('参数test')";
         [context evaluateScript:jsFunctStr];
        
        context[@"turnTo"] = ^() {
            NSArray *args = [JSContext currentArguments];
            for (JSValue *jsVal in args) {
                YBLog(@"%@", jsVal.toString);
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf turnTo:nil];
            });
            
        };*/
        
        
        //YBJSObject * object = [[YBJSObject alloc]init];
        context[@"NativeApi"] = weakSelf;
        
        //模拟一下js调用方法
        //NSString *jsStr1=@"NativeApi.turnTo('参数1')";
        //[context evaluateScript:jsStr1];
        
    }
    
    //NSString * str = [webView stringByEvaluatingJavaScriptFromString:@"window.NativeApi.turnTo()"];
    //YBLog(@"str==%@",str);
    
}
//- (BOOL)webView:(IMYWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType{
//    YBLog(@"request==%@",request);
//    return YES;
//}

#pragma mark - IMYWebViewDelegate
///WKWebView 跟网页进行交互的方法。
//- (void)addScriptMessageHandler:(id<WKScriptMessageHandler>)scriptMessageHandler name:(NSString*)name{
//
//}

#pragma mark JSTurnToDelegate
-(void)turnTo:(NSString *)jsonString{
    WEAK_SELF;
    //YBLog(@"jsonString==%@",jsonString);
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([jsonString isEqualToString:@"bbcar://host/pindan"]) {
            YBCarpoolOrdersVC *carpool = [[YBCarpoolOrdersVC alloc] init];
            [weakSelf.navigationController pushViewController:carpool animated:YES];
        }
    });
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
