//
//  MHWebViewController.m
//  WeChat
//
//  Created by senba on 2017/9/10.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHWebViewController.h"
#import "FBKVOController+MHExtension.h"
#import "UIScrollView+MHRefresh.h"


/// KVO 监听的属性
/// 加载情况
static NSString * const MHWebViewKVOLoading = @"loading";
/// 文章标题
static NSString * const MHWebViewKVOTitle = @"title";
/// 进度
static NSString * const MHWebViewKVOEstimatedProgress = @"estimatedProgress";

@interface MHWebViewController ()
/// webView
@property (nonatomic, weak, readwrite) WKWebView *webView;
/// 进度条
@property (nonatomic, readwrite, strong) UIProgressView *progressView;
/// 返回按钮
@property (nonatomic, readwrite, strong) UIBarButtonItem *backItem;
/// 关闭按钮 （点击关闭按钮  退出WebView）
@property (nonatomic, readwrite, strong) UIBarButtonItem *closeItem;
/// viewModel
@property (nonatomic, strong, readonly) MHWebViewModel *viewModel;

@end

@implementation MHWebViewController
{
    /// KVOController 监听数据
    FBKVOController *_KVOController;
}

@dynamic viewModel;

- (void)dealloc{
    MHDealloc;
    /// remove observer ,otherwise will crash
    [_webView stopLoading];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:self.progressView];
    /// 加载请求数据
    [self.webView loadRequest:self.viewModel.request];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.progressView removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// 添加断言，request错误 应用直接crash
    NSParameterAssert(self.viewModel.request);
    
    
    self.navigationItem.leftBarButtonItem = self.backItem;
    
    
    ///CoderMikeHe FIXED: 切记 lightempty_ios 是前端跟H5商量的结果，请勿修改。
    NSString *userAgent = @"wechat_ios";
    
    if (!(MHIOSVersion>=9.0)) [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"userAgent":userAgent}];
    
    /// 注册JS
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    /// 这里可以注册JS的处理 涉及公司私有方法 这里笔者不作处理

    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    // CoderMikeHe Fixed : 自适应屏幕宽度js
    NSString *jsString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    WKUserScript *userScript = [[WKUserScript alloc] initWithSource:jsString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    // 添加自适应屏幕宽度js调用的方法
    [userContentController addUserScript:userScript];
    /// 赋值userContentController
    configuration.userContentController = userContentController;
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:MH_SCREEN_BOUNDS configuration:configuration];
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    
    if ((MHIOSVersion >= 9.0)) webView.customUserAgent = userAgent;
    self.webView = webView;
    [self.view addSubview:webView];
    
    /// oc调用js
    [webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
        NSLog(@"navigator.userAgent.result is ++++ %@", result);
    }];
    
    /// 监听数据
    _KVOController = [FBKVOController controllerWithObserver:self];
    @weakify(self);
    /// binding self.viewModel.avatarUrlString
    [_KVOController mh_observe:self.webView keyPath:MHWebViewKVOTitle block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        @strongify(self);
        /// CoderMikeHe FIXED: 这里只设置导航栏的title 以免self.title 设置了tabBarItem.title
        if (!self.viewModel.shouldDisableWebViewTitle) self.navigationItem.title = self.webView.title;
    }];
    [_KVOController mh_observe:self.webView keyPath:MHWebViewKVOLoading block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        NSLog(@"--- webView is loading ---");
    }];
    
    [_KVOController mh_observe:self.webView keyPath:MHWebViewKVOEstimatedProgress block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        @strongify(self);
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        if(self.webView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }];

    /// 添加刷新控件
    if(self.viewModel.shouldPullDownToRefresh){
        [self.webView.scrollView mh_addHeaderRefresh:^(MJRefreshNormalHeader *header) {
            @strongify(self);
            [self.webView reload];
        }];
        [self.webView.scrollView.mj_header beginRefreshing];
    }
    self.webView.scrollView.contentInset = self.contentInset;
    
    /// CoderMikeHe: 适配 iPhone X + iOS 11，去掉安全区域
    if (@available(iOS 11.0, *)) {
        MHAdjustsScrollViewInsets_Never(webView.scrollView);
    }
}

#pragma mark - 事件处理
- (void)_backItemDidClicked{ /// 返回按钮事件处理
    /// 可以返回到上一个网页，就返回到上一个网页
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }else{/// 不能返回上一个网页，就返回到上一个界面
        /// 判断 是Push还是Present进来的，
        if (self.presentingViewController) {
            [self.viewModel.services dismissViewModelAnimated:YES completion:NULL];
        } else {
            [self.viewModel.services popViewModelAnimated:YES];
        }
    }
}

- (void)_closeItemDidClicked{
    /// 判断 是Push还是Present进来的
    if (self.presentingViewController) {
        [self.viewModel.services dismissViewModelAnimated:YES completion:NULL];
    } else {
        [self.viewModel.services popViewModelAnimated:YES];
    }
}

- (UIEdgeInsets)contentInset{
    return UIEdgeInsetsMake(MH_APPLICATION_TOP_BAR_HEIGHT, 0, 0, 0);
}




#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    /// js call OC function
    
}

#pragma mark - WKNavigationDelegate
/// 内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    /// 不显示关闭按钮
    if(self.viewModel.shouldDisableWebViewClose) return;

    UIBarButtonItem *backItem = self.navigationItem.leftBarButtonItems.firstObject;
    if (backItem) {
        if ([self.webView canGoBack]) {
            [self.navigationItem setLeftBarButtonItems:@[backItem, self.closeItem]];
        } else {
            [self.navigationItem setLeftBarButtonItems:@[backItem]];
        }
    }
}

// 导航完成时，会回调（也就是页面载入完成了）
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    if (self.viewModel.shouldPullDownToRefresh) [webView.scrollView.mj_header endRefreshing];
}

// 导航失败时会回调
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    if (self.viewModel.shouldPullDownToRefresh) [webView.scrollView.mj_header endRefreshing];
}

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"navigationAction.request.URL:   %@", navigationAction.request.URL);
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler {
    NSURLCredential *cred = [[NSURLCredential alloc] initWithTrust:challenge.protectionSpace.serverTrust];
    completionHandler(NSURLSessionAuthChallengeUseCredential, cred);
}

#pragma mark - WKUIDelegate
- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    /// CoderMike Fixed : 解决点击网页的链接 不跳转的Bug。
    WKFrameInfo *frameInfo = navigationAction.targetFrame;
    if (![frameInfo isMainFrame]) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

#pragma mark runJavaScript
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    [NSObject mh_showAlertViewWithTitle:nil message:message confirmTitle:@"我知道了"];
    completionHandler();
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    completionHandler(YES);
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    completionHandler(defaultText);
}



#pragma mark - Getter & Setter
- (UIProgressView *)progressView {
    if (!_progressView) {
        CGFloat progressViewW = MH_SCREEN_WIDTH;
        CGFloat progressViewH = 3;
        CGFloat progressViewX = 0;
        CGFloat progressViewY = CGRectGetHeight(self.navigationController.navigationBar.frame) - progressViewH + 1;
        UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(progressViewX, progressViewY, progressViewW, progressViewH)];
        progressView.progressTintColor = MH_MAIN_TINTCOLOR;
        progressView.trackTintColor = [UIColor clearColor];
        self.progressView = progressView;
    }
    return _progressView;
}


- (UIBarButtonItem *)backItem
{
    if (_backItem == nil) {
        _backItem = [UIBarButtonItem mh_svgBarButtonItem:@"icons_filled_back.svg" targetSize:CGSizeMake(12.0, 24.0) tintColor:nil target:self selector:@selector(_backItemDidClicked)];
    }
    return _backItem;
}

- (UIBarButtonItem *)closeItem {
    if (!_closeItem) {
        _closeItem = [UIBarButtonItem mh_systemItemWithTitle:@"关闭" titleColor:MHColorFromHexString(@"#181818") imageName:nil target:self selector:@selector(_closeItemDidClicked) textType:YES];
    }
    return _closeItem;
}



@end
