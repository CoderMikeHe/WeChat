//
//  MHFeatureSignatureViewController.m
//  WeChat
//
//  Created by senba on 2017/9/21.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHFeatureSignatureViewController.h"
#import "MHFeatureSignatureTextView.h"
@interface MHFeatureSignatureViewController ()
/// viewModel
@property (nonatomic, readonly, strong) MHFeatureSignatureViewModel *viewModel;
/// featureSignatureTextView
@property (nonatomic, readwrite, weak) MHFeatureSignatureTextView *featureSignatureTextView;
@end

@implementation MHFeatureSignatureViewController

@dynamic viewModel;

- (void)loadView{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = scrollView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.featureSignatureTextView.textView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.featureSignatureTextView.textView resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /// 设置
    [self _setup];
    
    /// 设置导航栏
    [self _setupNavigationItem];
    
    /// 设置子控件
    [self _setupSubViews];
}
#pragma mark - BindViewModel
- (void)bindViewModel{
    [super bindViewModel];
    
    @weakify(self);
    RAC(self.viewModel , text) = [RACSignal merge:@[RACObserve(self.featureSignatureTextView.textView, text),self.featureSignatureTextView.textView.rac_textSignal]];
    RAC(self.navigationItem.rightBarButtonItem , enabled) = self.viewModel.validCompleteSignal;
}
#pragma mark - 事件处理
- (void)_complete{
    
    /// 去掉全部为空格的情况
    if ([NSString mh_isEmpty:self.viewModel.text]) {
        [MBProgressHUD mh_showTips:@"请输入正确的个性签名"];
        return;
    }
    
    [self.viewModel.completeCommand execute:nil];
}


#pragma mark - 初始化
- (void)_setup{
    UIScrollView *scrollView = (UIScrollView *)self.view;
    scrollView.alwaysBounceVertical = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    
    /// 适配 iOS 11
    MHAdjustsScrollViewInsets_Never(scrollView);
}

#pragma mark - 设置导航栏
- (void)_setupNavigationItem{
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.leftBarButtonItem.rac_command = self.viewModel.cancelCommand;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem mh_systemItemWithTitle:@"完成" titleColor:MH_MAIN_TEXT_COLOR_2 imageName:nil target:self selector:@selector(_complete) textType:YES];
}

#pragma mark - 设置子控件
- (void)_setupSubViews{
    MHFeatureSignatureTextView *featureSignatureTextView = [MHFeatureSignatureTextView featureSignatureTextView];
    featureSignatureTextView.mh_height = 81.0f;
    featureSignatureTextView.mh_width = MH_SCREEN_WIDTH;
    featureSignatureTextView.mh_y = MH_APPLICATION_TOP_BAR_HEIGHT+16.0f;
    self.featureSignatureTextView = featureSignatureTextView;
    [self.view addSubview:featureSignatureTextView];
    
    /// 初始化数据
    self.featureSignatureTextView.textView.text = self.viewModel.text;
}

@end
