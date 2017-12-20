//
//  YBListWebTableViewCell.m
//  TakeWindmill
//
//  Created by AshokaCao on 2017/11/27.
//  Copyright © 2017年 浙江承御天泽公司. All rights reserved.
//

#import "YBListWebTableViewCell.h"



@implementation YBListWebTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //  float height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];     //此方法获取webview的内容高度，但是有时获取的不完全
    //  float height = [webView sizeThatFits:CGSizeZero].height; //此方法获取webview的高度
    float height = [[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollHeight"]floatValue]; //此方法获取webview的内容高度（建议使用）
    //设置通知或者代理来传高度
    [[NSNotificationCenter defaultCenter]postNotificationName:@"getCellHightNotification" object:nil         userInfo:@{@"height":[NSNumber numberWithFloat:height]}];
}

//- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    
//    // 获取内容高度
//    CGFloat height =  [[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollHeight"] intValue];
//    
//    // 防止死循环
//    if (height != _viewModel.htmlHeight) {
//        
//        _viewModel.htmlHeight = height;
//        
//        if (_viewModel.htmlHeight > 0) {
//            
//            // 更新布局
//            CGFloat paddingEdge = 10;
//            // 刷新cell高度
//            _viewModel.cellHeight = _viewModel.otherHeight + _viewModel.htmlHeight;
//            [_viewModel.refreshSubject sendNext:nil];
//        }
//        
//    }
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
