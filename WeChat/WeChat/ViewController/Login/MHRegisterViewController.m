//
//  MHRegisterViewController.m
//  WeChat
//
//  Created by senba on 2017/10/12.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHRegisterViewController.h"
#import "MHMobileLoginView.h"

@interface MHRegisterViewController ()
/// viewModel
@property (nonatomic, readwrite, strong) MHRegisterViewModel *viewModel;
/// containerView
@property (weak, nonatomic) IBOutlet UIView *containerView;
/// accountBaseView
@property (weak, nonatomic) IBOutlet UIView *accountBaseView;
/// loginBtn
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
/// mobileLoginView
@property (nonatomic, readwrite, weak) MHMobileLoginView *mobileLoginView;
@end

@implementation MHRegisterViewController

@dynamic viewModel;
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.mobileLoginView.phoneTextField becomeFirstResponder];
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
    @weakify(self);
    RAC(self.viewModel , phone) = [RACSignal merge:@[RACObserve(self.mobileLoginView.phoneTextField, text),self.mobileLoginView.phoneTextField.rac_textSignal]];
    RAC(self.viewModel , zoneCode) = [RACSignal merge:@[RACObserve(self.mobileLoginView.zoneCodeTextField, text),self.mobileLoginView.zoneCodeTextField.rac_textSignal]];
    
    /// 登录按钮有效性
    RAC(self.registerBtn , enabled) = self.viewModel.validRegisterSignal;
    
    /// show HUD
    [[[self.viewModel.captchaCommand.executing skip:0]
      doNext:^(id x) {
          @strongify(self);
          [self.view endEditing:YES];
      }] subscribeNext:^(NSNumber * showHud) {
          @strongify(self);
          if (showHud.boolValue) {
              [MBProgressHUD mh_showProgressHUD:@"请稍后..."];
          }else if(!self.viewModel.error){
              [MBProgressHUD mh_hideHUD];
          }
      }];
    
    /// Show Error
    [[self.viewModel.captchaCommand.errors deliverOnMainThread] subscribeNext:^(NSError * error) {
        [MBProgressHUD mh_showErrorTips:error];
    }];
}

#pragma mark - 事件处理
/// 注册按钮被点击
- (IBAction)_registerBtnDidClicked:(UIButton *)sender {
    /// 判断是否是正确的电话号码
    if (![NSString mh_isValidMobile:self.viewModel.phone]) {
        [NSObject mh_showAlertViewWithTitle:@"手机号码错误" message:@"你输入的是一个无效的手机号码" confirmTitle:@"确定"];
        return;
    }
    
    /// 需要弹框
    @weakify(self);
    NSString *phone = [NSString stringWithFormat:@"+%@%@",self.viewModel.zoneCode , self.viewModel.phone];
    NSString *message = [NSString stringWithFormat:@"我们将发送验证码短信到这个号码：\n %@",phone];
    [NSObject mh_showAlertViewWithTitle:@"确认手机号码" message:message confirmTitle:@"好的" cancelTitle:@"取消" confirmAction:^{
        @strongify(self);
        /// 键盘掉下
        [self.view endEditing:YES];
        /// 获取验证码
        [self.viewModel.captchaCommand execute:nil];
    } cancelAction:NULL];
}



#pragma mark - 初始化
- (void)_setup{
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
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem mh_systemItemWithTitle:@"取消" titleColor:MH_MAIN_TINTCOLOR imageName:nil target:nil selector:nil textType:YES];
    self.navigationItem.leftBarButtonItem.rac_command = self.viewModel.closeCommand;
}

#pragma mark - 设置子控件
- (void)_setupSubViews{
    /// 设置背景
    [self.registerBtn setBackgroundImage:[UIImage yy_imageWithColor:MHColorFromHexString(@"#51AA38")] forState:UIControlStateNormal];
    [self.registerBtn setBackgroundImage:[UIImage yy_imageWithColor:[MHColorFromHexString(@"#51AA38") colorWithAlphaComponent:.5f]] forState:UIControlStateHighlighted];
    [self.registerBtn setBackgroundImage:[UIImage yy_imageWithColor:MHColorFromHexString(@"#AFDDA7")] forState:UIControlStateDisabled];
    
    /// 手机登录
    MHMobileLoginView *mobileLoginView = [MHMobileLoginView mobileLoginView];
    mobileLoginView.titleLabel.text = @"请输入你的手机号";
    mobileLoginView.titleLabel.textAlignment = NSTextAlignmentCenter;
    [mobileLoginView bindViewModel:self.viewModel];
    self.mobileLoginView = mobileLoginView;
    [self.accountBaseView addSubview:mobileLoginView];
    
    /// 布局
    [mobileLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.accountBaseView);
        make.top.and.bottom.equalTo(self.accountBaseView);
        make.width.equalTo(self.accountBaseView);
    }];
}
@end
