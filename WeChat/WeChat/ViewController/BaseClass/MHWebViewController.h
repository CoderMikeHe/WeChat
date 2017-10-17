//
//  MHWebViewController.h
//  WeChat
//
//  Created by senba on 2017/9/10.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  所有需要显示WKWebView的自定义视图控制器的基类

#import "MHViewController.h"
#import "MHWebViewModel.h"
#import <WebKit/WebKit.h>

@interface MHWebViewController : MHViewController<
WKNavigationDelegate,
WKUIDelegate,
WKScriptMessageHandler
>
/// webView
@property (nonatomic, weak, readonly) WKWebView *webView;
/// 内容缩进 (64,0,0,0)
@property (nonatomic, readonly, assign) UIEdgeInsets contentInset;

@end
