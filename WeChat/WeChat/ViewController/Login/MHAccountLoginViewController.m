//
//  MHAccountLoginViewController.m
//  WeChat
//
//  Created by senba on 2017/9/25.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHAccountLoginViewController.h"
#import "MHLoginCaptchaView.h"
#import "MHLoginPasswordView.h"
#import "MHButton.h"
@interface MHAccountLoginViewController ()
/// viewModel
@property (nonatomic, readonly, strong) MHAccountLoginViewModel *viewModel;
/// accountBtn
@property (nonatomic, readwrite, weak) MHButton *accountBtn;
/// loginBtn
@property (nonatomic, readwrite, weak) UIButton *loginBtn;
/// 切换登录方式
@property (nonatomic, readwrite, weak) UIButton *changeLoginBtn;
/// baseView
@property (nonatomic, readwrite, weak) UIView *passwordBaseView;
/// avatarView
@property (nonatomic, readwrite, weak) UIImageView *avatarView;
/// passwordView
@property (nonatomic, readwrite, weak) MHLoginPasswordView *passwordView;
/// captchaView
@property (nonatomic, readwrite, weak) MHLoginCaptchaView *captchaView;
@end

@implementation MHAccountLoginViewController

@dynamic viewModel;

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    /// 成为第一响应者
    [self.passwordView.passwordTextField becomeFirstResponder];
}

- (void)loadView{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = scrollView;
}

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
    
    /// 切换登录方式的按钮事件
    [[[self.changeLoginBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     doNext:^(UIButton * sender) {
         sender.userInteractionEnabled = NO; /// 动画过程中 禁止交互
    }]
     subscribeNext:^(UIButton *sender) {
         @strongify(self);
         sender.selected = !sender.isSelected;
         /// 切换账号
         self.accountBtn.selected = sender.isSelected;
         /// 切换账户
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
             [self.passwordBaseView layoutIfNeeded];
         } completion:^(BOOL finished) {
             /// 重新设置
             [sender.isSelected?self.passwordView:self.captchaView mas_updateConstraints:^(MASConstraintMaker *make) {
                 make.left.equalTo(self.passwordBaseView.mas_left).with.offset(sender.isSelected?offsetX1:offsetX2);
             }];
             sender.userInteractionEnabled = YES;   /// 动画结束 允许交互
         }];
     }];
    
    [[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(UIButton *sender) {
         @strongify(self);
         if (self.changeLoginBtn.isSelected) { /// 手机号登录
             /// 验证码 六位
             if(self.captchaView.captchaTextField.text.length != 6 || ![NSString mh_isPureDigitCharacters:self.viewModel.captcha]){
                 [NSObject mh_showAlertViewWithTitle:@"验证码超时，请重新获取验证码。" message:nil confirmTitle:@"确定"];
                 return ;
             }
         }else{
             /// 密码 8~16位 且 不能含有中文
             if(self.passwordView.passwordTextField.text.length < 8
                || self.passwordView.passwordTextField.text.length >16
                || [NSString mh_isContainChinese:self.passwordView.passwordTextField.text] ){
                 [NSObject mh_showAlertViewWithTitle:@"账号或密码错误，请重新填写。" message:nil confirmTitle:@"确定"];
                 return ;
             }
         }
         
         [self.viewModel.loginCommand execute:@(self.changeLoginBtn.isSelected)];
     }];
    
    
    /// 获取验证码
    [[self.captchaView.captchaBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(UIButton *sender) {
         @strongify(self);
         /// 需要弹框
         @weakify(self);
         NSString *message = [NSString stringWithFormat:@"我们将发送验证码短信到这个号码：\n %@",[self.accountBtn titleForState:UIControlStateSelected]];
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
    } otherButtonTitles:@"切换账号",@"找回密码",@"前往微信安全中心",@"注册", nil];
    [sheet show];
}



#pragma mark - 初始化
- (void)_setup{
    UIScrollView *scrollView = (UIScrollView *)self.view;
    scrollView.alwaysBounceVertical = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    
    /// 适配
    MHAdjustsScrollViewInsets_Never(scrollView);
}

#pragma mark - 设置导航栏
- (void)_setupNavigationItem{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem mh_systemItemWithTitle:nil titleColor:nil imageName:@"barbuttonicon_more_black_30x30" target:self selector:@selector(_moreItemDidClicked) textType:NO];
}

#pragma mark - 设置子控件
- (void)_setupSubViews{
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:containerView];
    
    /// 用户头像
    UIImageView *avatarView = [[UIImageView alloc] init];
    avatarView.image = [UIImage mh_imageAlwaysShowOriginalImageWithImageName:@"SettingProfileHead_66x66"];
    avatarView.layer.cornerRadius = 6.0f;
    avatarView.layer.masksToBounds = YES;
    avatarView.layer.borderWidth = 1.0f;
    avatarView.layer.borderColor = MHColorFromHexString(@"#E4E4E4").CGColor;
    [containerView addSubview:avatarView];
    self.avatarView = avatarView;
    
    /// 账号
    MHButton *accountBtn = [[MHButton alloc] init];
    accountBtn.titleLabel.font = MHMediumFont(17.0f);
    [accountBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    accountBtn.userInteractionEnabled = NO; // 禁止用户交互
    [containerView addSubview:accountBtn];
    self.accountBtn = accountBtn;
    
    /// baseView
    UIView *passwordBaseView = [[UIView alloc] init];
    passwordBaseView.backgroundColor = containerView.backgroundColor;
    [containerView addSubview:passwordBaseView];
    self.passwordBaseView = passwordBaseView;
    
    /// passwordView
    MHLoginPasswordView *passwordView = [MHLoginPasswordView passwordView];
    passwordView.backgroundColor = containerView.backgroundColor;
    [passwordBaseView addSubview:passwordView];
    self.passwordView = passwordView;
    
    /// captchaView
    MHLoginCaptchaView *captchaView = [MHLoginCaptchaView captchaView];
    captchaView.backgroundColor = containerView.backgroundColor;
    [passwordBaseView addSubview:captchaView];
    self.captchaView = captchaView;
    
    /// 切换登录方式按钮 <用QQ密码登录 用短信验证码登录>
    UIButton *changeLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeLoginBtn setTitle:@"用短信验证码登录" forState:UIControlStateNormal];
    [changeLoginBtn setTitle:@"用QQ密码登录" forState:UIControlStateSelected];
    [changeLoginBtn setTitleColor:MHColorFromHexString(@"#576B95") forState:UIControlStateNormal];
    changeLoginBtn.titleLabel.font = MHRegularFont_18;
    [changeLoginBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    self.changeLoginBtn = changeLoginBtn;
    [containerView addSubview:changeLoginBtn];
    
    /// 登录按钮
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setTitleColor:MHColorFromHexString(@"#DBF3D8") forState:UIControlStateDisabled];
    /// 设置背景
    [loginBtn setBackgroundImage:[UIImage yy_imageWithColor:MHColorFromHexString(@"#51AA38")] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage yy_imageWithColor:[MHColorFromHexString(@"#51AA38") colorWithAlphaComponent:.5f]] forState:UIControlStateHighlighted];
    [loginBtn setBackgroundImage:[UIImage yy_imageWithColor:MHColorFromHexString(@"#AFDDA7")] forState:UIControlStateDisabled];
    loginBtn.layer.cornerRadius= 6.0f;
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.borderWidth = 1;
    loginBtn.layer.borderColor = MHColorFromHexString(@"#499932").CGColor;
    self.loginBtn = loginBtn;
    [containerView addSubview:loginBtn];
    
    
    /// layout subViews
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
        make.height.mas_equalTo(MH_SCREEN_HEIGHT);
        make.width.mas_equalTo(MH_SCREEN_WIDTH);
    }];
    
    [avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.and.width.mas_equalTo(66);
        make.centerX.equalTo(containerView);
        make.top.equalTo(containerView).with.offset(134.0f);
    }];
    
    [accountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(avatarView.mas_bottom).with.offset(10.0f);
        make.centerX.equalTo(containerView);
    }];
    
    [passwordBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(containerView);
        make.height.mas_equalTo(38.0f);
        make.top.equalTo(accountBtn.mas_bottom).with.offset(44.0f);
    }];
    
    [passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passwordBaseView);
        make.top.and.bottom.equalTo(passwordBaseView);
        make.width.equalTo(passwordBaseView);
    }];

    [captchaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passwordBaseView).with.offset(MH_SCREEN_WIDTH);
        make.top.and.bottom.equalTo(passwordBaseView);
        make.width.equalTo(passwordBaseView);
    }];
    
    [changeLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(containerView).with.offset(20.0f);
        make.top.equalTo(passwordBaseView.mas_bottom).with.offset(12.0f);
    }];
    
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(containerView).with.offset(20.0f);
        make.right.equalTo(containerView).with.offset(-20.0f);
        make.top.equalTo(changeLoginBtn.mas_bottom).with.offset(68.0f);
        make.height.mas_equalTo(47.0f);
    }];
}

#pragma mark - 初始化部分数据
-(void) _configureData{
    
    /// 获取沙盒里面的用户数据
    MHUser *user = self.viewModel.services.client.currentUser;
    if (user) { /// 配置数据
        [self.accountBtn setTitle:user.qq forState:UIControlStateNormal];
        [self.accountBtn setTitle:user.phone forState:UIControlStateSelected];
        /// 设置头像
        [self.avatarView yy_setImageWithURL:user.profileImageUrl placeholder:[UIImage mh_imageAlwaysShowOriginalImageWithImageName:@"SettingProfileHead_66x66"] options:MHWebImageOptionAutomatic completion:NULL];
        /// 这里假设  只有两种方式 （qq登录 + 手机号登录）
        self.viewModel.account = user.qq;
        self.viewModel.phone = user.phone;
        
        /// 判断一下登录渠道 增强用户体验
        if (user.channel == MHUserLoginChannelTypePhone) { /// 手机号登录
            self.changeLoginBtn.selected = YES;
            /// 切换账号
            self.accountBtn.selected = self.changeLoginBtn.isSelected;
            /// 切换账户
            self.viewModel.selected = self.changeLoginBtn.isSelected;
            CGFloat offsetX1 = self.changeLoginBtn.isSelected?MH_SCREEN_WIDTH:0;
            CGFloat offsetX2 = self.changeLoginBtn.isSelected?0:MH_SCREEN_WIDTH;
            /// 更新约束
            [self.passwordView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.passwordBaseView.mas_left).with.offset(offsetX1);
            }];
            
            [self.captchaView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.passwordBaseView.mas_left).with.offset(offsetX2);
            }];
            
            [self.passwordBaseView layoutIfNeeded];
        }
        
    }
};
@end
