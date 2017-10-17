//
//  MHMobileLoginViewController.m
//  WeChat
//
//  Created by senba on 2017/9/27.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHMobileLoginViewController.h"
#import "MHLoginCaptchaView.h"
#import "MHLoginPasswordView.h"

@interface MHMobileLoginViewController ()
/// viewModel
@property (nonatomic, readonly, strong) MHMobileLoginViewModel *viewModel;

/// 切换登录方式
@property (weak, nonatomic) IBOutlet UIButton *changeLoginBtn;
/// containerView
@property (weak, nonatomic) IBOutlet UIView *containerView;
/// accountBaseView
@property (weak, nonatomic) IBOutlet UIView *accountBaseView;
/// phoneView
@property (weak, nonatomic) IBOutlet UIView *phoneView;
/// 电话号码输入款
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

/// passwordBaseView
@property (weak, nonatomic) IBOutlet UIView *passwordBaseView;

/// captchaView
@property (nonatomic, readwrite, weak) MHLoginCaptchaView *captchaView;
/// captchaView
@property (nonatomic, readwrite, weak) MHLoginPasswordView *passwordView;
/// loginBtn
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@end

@implementation MHMobileLoginViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// 设置
    [self _setup];
    
    /// 设置导航栏
    [self _setupNavigationItem];
    
    /// 设置子控件
    [self _setupSubViews];
    
    /// 初始化部分数据
    [self _configureData];
}
#pragma mark - Override
- (void)bindViewModel{
    [super bindViewModel];
    @weakify(self);
    
    /// 密码
    RAC(self.viewModel , password) = [RACSignal merge:@[RACObserve(self.passwordView.passwordTextField, text),self.passwordView.passwordTextField.rac_textSignal]];
    
    /// 验证码
    RAC(self.viewModel , captcha) = [RACSignal merge:@[RACObserve(self.captchaView.captchaTextField, text),self.captchaView.captchaTextField.rac_textSignal]];
    
    /// 登录按钮有效性
    RAC(self.loginBtn , enabled) = self.viewModel.validLoginSignal;
    
    /// show HUD
    [[[[RACSignal combineLatest:@[self.viewModel.loginCommand.executing , self.viewModel.captchaCommand.executing] reduce:^id(NSNumber *cExecuting , NSNumber * fExecuting){
        if (cExecuting.boolValue||fExecuting.boolValue) return @1;
        return @0;
    }]
      deliverOnMainThread] doNext:^(id x) {
        @strongify(self);
        [self.view endEditing:YES];
    }]
     subscribeNext:^(NSNumber * showHud) {
         @strongify(self);
         if (showHud.boolValue) {
             [MBProgressHUD mh_showProgressHUD:@"请稍后..."];
         }else if(!self.viewModel.error){
             [MBProgressHUD mh_hideHUD];
         }
     }];
    
    /// show errors
    [[self.viewModel.captchaCommand.errors merge:self.viewModel.loginCommand.errors] subscribeNext:^(NSError * error) {
        [MBProgressHUD mh_showErrorTips:error];
    }];
    
    /// 获取验证码
    [[self.captchaView.captchaBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(UIButton *sender) {
         @strongify(self);
         /// 需要弹框
         @weakify(self);
         NSString *message = [NSString stringWithFormat:@"我们将发送验证码短信到这个号码：\n %@",self.phoneTextField.text];
         [NSObject mh_showAlertViewWithTitle:@"确认手机号码" message:message confirmTitle:@"好的" cancelTitle:@"取消" confirmAction:^{
             @strongify(self);
             [self.viewModel.captchaCommand execute:nil];
         } cancelAction:NULL];
     }];
    RAC(self.captchaView.captchaBtn , enabled) = self.viewModel.validCaptchaSignal;
    [[[RACObserve(self.viewModel, captchaTitle)
       distinctUntilChanged]
      deliverOnMainThread]
     subscribeNext:^(NSString * captchaTitle) {
         @strongify(self);
         [self.captchaView.captchaBtn setTitle:captchaTitle forState:UIControlStateNormal];
     }];
}

#pragma mark - Action
- (void)_moreItemDidClicked{
    @weakify(self);
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:nil cancelButtonTitle:@"取消" clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
        if (buttonIndex == 0) return ;
        @strongify(self);
        [self.viewModel.moreCommand execute:@(buttonIndex)];
    } otherButtonTitles:@"找回密码",@"前往微信安全中心", nil];
    [sheet show];
}

/// 切换登录方式的按钮点击
- (IBAction)_changeLoginBtnDidClicked:(UIButton *)sender {
    sender.userInteractionEnabled = NO; /// 动画过程中 禁止交互
    sender.selected = !sender.isSelected;
    /// 赋值
    self.viewModel.selected = sender.isSelected;
    
    CGFloat offsetX1 = sender.isSelected?MH_SCREEN_WIDTH:0;
    CGFloat offsetX2 = sender.isSelected?0:MH_SCREEN_WIDTH;
    /// 做动画
    [self.passwordView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.passwordBaseView).with.offset(-1 *offsetX1);
    }];
    [self.captchaView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.passwordBaseView).with.offset(-1 * offsetX2);
    }];
    [UIView animateWithDuration:.25 animations:^{
        /// animated
        [self.passwordBaseView layoutIfNeeded];
    } completion:^(BOOL finished) {
        /// 重新设置
        [sender.isSelected?self.passwordView:self.captchaView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.passwordBaseView.mas_left).with.offset(sender.isSelected?offsetX1:offsetX2);
        }];
        sender.userInteractionEnabled = YES; /// 动画完成 允许交互
    }];
}

- (IBAction)_loginBtnDidClicked:(UIButton *)sender {
    
    if (self.changeLoginBtn.isSelected) { /// 手机号登录
        /// 验证码 六位
        if(self.captchaView.captchaTextField.text.length != 6 || ![NSString mh_isPureDigitCharacters:self.viewModel.captcha]){
            [NSObject mh_showAlertViewWithTitle:@"验证码超时，请重新获取验证码。" message:nil confirmTitle:@"确定"];
            return ;
        }
    }else{
        /// 密码 8~16位 且 不能含有中文
        if(![NSString mh_isValidMobile:self.viewModel.phone]
           || self.passwordView.passwordTextField.text.length < 8
           || self.passwordView.passwordTextField.text.length >16
           || [NSString mh_isContainChinese:self.passwordView.passwordTextField.text] ){
            [NSObject mh_showAlertViewWithTitle:@"账号或密码错误，请重新填写。" message:nil confirmTitle:@"确定"];
            return ;
        }
    }
    ///登录
    [self.viewModel.loginCommand execute:@(self.changeLoginBtn.isSelected)];
    
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
    
    /// 适配iOS 11
    MHAdjustsScrollViewInsets_Never(scrollView);
}

#pragma mark - 设置导航栏
- (void)_setupNavigationItem{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem mh_systemItemWithTitle:nil titleColor:nil imageName:@"barbuttonicon_more_black_30x30" target:self selector:@selector(_moreItemDidClicked) textType:NO];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem mh_systemItemWithTitle:nil titleColor:nil imageName:@"WAWeb_Back_Dark_10x18" target:nil selector:nil textType:NO];
    self.navigationItem.leftBarButtonItem.rac_command = self.viewModel.closeCommand;
}


#pragma mark - 设置子控件
- (void)_setupSubViews{
    /// 设置背景
    [self.loginBtn setBackgroundImage:[UIImage yy_imageWithColor:MHColorFromHexString(@"#51AA38")] forState:UIControlStateNormal];
    [self.loginBtn setBackgroundImage:[UIImage yy_imageWithColor:[MHColorFromHexString(@"#51AA38") colorWithAlphaComponent:.5f]] forState:UIControlStateHighlighted];
    [self.loginBtn setBackgroundImage:[UIImage yy_imageWithColor:MHColorFromHexString(@"#AFDDA7")] forState:UIControlStateDisabled];
    
    /// 电话号码禁止输入
    self.phoneTextField.userInteractionEnabled = NO;
    
    /// 密码登录
    MHLoginPasswordView *passwordView = [MHLoginPasswordView passwordView];
    passwordView.passwordTextFieldLeftCons.constant = 75.0f;
    passwordView.passwordTextField.placeholder = @"请填写密码";
    self.passwordView = passwordView;
    [self.passwordBaseView addSubview:passwordView];
    
    /// 验证码登录
    MHLoginCaptchaView *captchaView = [MHLoginCaptchaView captchaView];
    captchaView.captchaTextFieldLeftCons.constant = 57.0f;
    self.captchaView = captchaView;
    [self.passwordBaseView addSubview:captchaView];
    
    /// 布局
    [passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.passwordBaseView);
        make.top.and.bottom.equalTo(self.passwordBaseView);
        make.width.equalTo(self.passwordBaseView);
    }];
    
    [captchaView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.passwordBaseView.mas_left).with.offset(MH_SCREEN_WIDTH);
        make.top.and.bottom.equalTo(self.passwordBaseView);
        make.width.equalTo(self.passwordBaseView);
    }];
}

#pragma mark - 初始化部分数据
-(void) _configureData{
    /// 拼接数据
    self.phoneTextField.text = [NSString stringWithFormat:@"+%@%@",self.viewModel.zoneCode , self.viewModel.phone];
};
@end
