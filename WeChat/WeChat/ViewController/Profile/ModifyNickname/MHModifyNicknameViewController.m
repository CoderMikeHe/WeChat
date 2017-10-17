//
//  MHModifyNicknameViewController.m
//  WeChat
//
//  Created by senba on 2017/10/14.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHModifyNicknameViewController.h"

@interface MHModifyNicknameViewController ()

/// viewModel
@property (nonatomic, readonly, strong) MHModifyNicknameViewModel *viewModel;

/// containerView
@property (weak, nonatomic) IBOutlet UIView *containerView;

/// textField
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation MHModifyNicknameViewController

@dynamic viewModel;

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    /// 唤起键盘
    [self.textField becomeFirstResponder];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.textField resignFirstResponder];
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


#pragma mark - Override
- (void)bindViewModel{
    [super bindViewModel];
    RAC(self.viewModel , text) = [RACSignal merge:@[RACObserve(self.textField, text),self.textField.rac_textSignal]];
    RAC(self.navigationItem.rightBarButtonItem , enabled) = self.viewModel.validCompleteSignal;
}

#pragma mark - 事件处理
- (void)_complete{
    
    /// 除去全是空格的情况
    if ([NSString mh_isEmpty:self.viewModel.text]) {
        [MBProgressHUD mh_showTips:@"请输入正确的昵称"];
        return;
    }
    
    [self.viewModel.completeCommand execute:nil];
}

#pragma mark - 初始化
- (void)_setup{
    self.containerView.backgroundColor = self.view.backgroundColor;
    /// 设置contentSize
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(MH_SCREEN_WIDTH);
        make.height.mas_equalTo(MH_SCREEN_HEIGHT);
    }];
    
    UIScrollView *scrollView = (UIScrollView *)self.view;
    scrollView.alwaysBounceVertical = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    
    /// 适配 iOS 11
    MHAdjustsScrollViewInsets_Never(scrollView);
}

#pragma mark - 设置导航栏
- (void)_setupNavigationItem{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem mh_systemItemWithTitle:@"取消" titleColor:nil imageName:nil target:nil selector:nil textType:YES];
    self.navigationItem.leftBarButtonItem.rac_command = self.viewModel.cancelCommand;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem mh_systemItemWithTitle:@"完成" titleColor:MH_MAIN_TINTCOLOR imageName:nil target:self selector:@selector(_complete) textType:YES];
}

#pragma mark - 设置子控件
- (void)_setupSubViews{
    /// 限制TextField字数
    [self.textField mh_limitMaxLength:20];
    
    /// 初始话
    self.textField.text = self.viewModel.text;
}

@end
