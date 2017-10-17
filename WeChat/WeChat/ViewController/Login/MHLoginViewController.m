//
//  MHLoginViewController.m
//  WeChat
//
//  Created by senba on 2017/9/26.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHLoginViewController.h"
#import "MHMobileLoginView.h"
#import "MHAccountLoginView.h"
#import "MHMobileLoginViewModel.h"

@interface MHLoginViewController ()
/// viewModel
@property (nonatomic, readonly, strong) MHLoginViewModel *viewModel;
/// 切换登录方式
@property (weak, nonatomic) IBOutlet UIButton *changeLoginBtn;
/// containerView
@property (weak, nonatomic) IBOutlet UIView *containerView;
/// accountBaseView
@property (weak, nonatomic) IBOutlet UIView *accountBaseView;
/// loginBtn
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
/// accountLoginView
@property (nonatomic, readwrite, weak) MHAccountLoginView *accountLoginView;
/// mobileLoginView
@property (nonatomic, readwrite, weak) MHMobileLoginView *mobileLoginView;
@end

@implementation MHLoginViewController

@dynamic viewModel;

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
    [[RACObserve(self.changeLoginBtn, selected) map:^id(NSNumber * selected) {
        return selected.boolValue?@"登录":@"下一步";
    }] subscribeNext:^(NSString * title) {
        @strongify(self);
        [self.loginBtn setTitle:title forState:UIControlStateNormal];
    }];
    
    /// QQ/微信号/邮箱
    RAC(self.viewModel , account) = [RACSignal merge:@[RACObserve(self.accountLoginView.accountTextField, text),self.accountLoginView.accountTextField.rac_textSignal]];
    RAC(self.viewModel , password) = [RACSignal merge:@[RACObserve(self.accountLoginView.passwordTextField, text),self.accountLoginView.passwordTextField.rac_textSignal]];
    
    /// 手机号
    RAC(self.viewModel , phone) = [RACSignal merge:@[RACObserve(self.mobileLoginView.phoneTextField, text),self.mobileLoginView.phoneTextField.rac_textSignal]];
    RAC(self.viewModel , zoneCode) = [RACSignal merge:@[RACObserve(self.mobileLoginView.zoneCodeTextField, text),self.mobileLoginView.zoneCodeTextField.rac_textSignal]];
    
    /// 登录按钮有效性
    RAC(self.loginBtn , enabled) = self.viewModel.validLoginSignal;
    
    /// show HUD
    [[[self.viewModel.loginCommand.executing
      skip:1]
     doNext:^(id x) {
         @strongify(self)
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
    [self.viewModel.loginCommand.errors subscribeNext:^(NSError * error) {
        [MBProgressHUD mh_showErrorTips:error];
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
    [self.mobileLoginView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.accountBaseView).with.offset(-1 *offsetX1);
    }];
    [self.accountLoginView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.accountBaseView).with.offset(-1 * offsetX2);
    }];
    [UIView animateWithDuration:.25 animations:^{
        /// animated
        [self.accountBaseView layoutIfNeeded];
    } completion:^(BOOL finished) {
        /// 重新设置
        [sender.isSelected?self.mobileLoginView:self.accountLoginView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.accountBaseView.mas_left).with.offset(sender.isSelected?offsetX1:offsetX2);
        }];
        
        sender.userInteractionEnabled = YES; /// 动画完成 允许交互
    }];
}
/// 登录按钮
- (IBAction)_loginBtnDidClicked:(UIButton *)sender {
    /// 这里需要做验证
    if(self.changeLoginBtn.isSelected){ /// QQ登录
        if (![NSString mh_isValidQQ:self.accountLoginView.accountTextField.text]
            || self.accountLoginView.passwordTextField.text.length < 8
            || self.accountLoginView.passwordTextField.text.length >16
            || [NSString mh_isContainChinese:self.accountLoginView.passwordTextField.text] ) {
            [NSObject mh_showAlertViewWithTitle:@"账号或密码错误，请重新填写。" message:nil confirmTitle:@"确定"];
            return;
        }
        [self.viewModel.loginCommand execute:@(self.changeLoginBtn.isSelected)];
    }else{ /// 手机号登录
        /// 手机号登录 将区号+手机号码 传递过去
        MHMobileLoginViewModel *viewModel = [[MHMobileLoginViewModel alloc] initWithServices:self.viewModel.services params:@{MHMobileLoginPhoneKey:self.viewModel.phone,MHMobileLoginZoneCodeKey:self.viewModel.zoneCode}];
        [self.viewModel.services pushViewModel:viewModel animated:YES];
    }
    
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
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem mh_systemItemWithTitle:nil titleColor:nil imageName:@"barbuttonicon_more_black_30x30" target:self selector:@selector(_moreItemDidClicked) textType:NO];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem mh_systemItemWithTitle:nil titleColor:nil imageName:@"SystemTipBtnClose_26x26" target:nil selector:nil textType:NO];
    self.navigationItem.leftBarButtonItem.rac_command = self.viewModel.closeCommand;
}

#pragma mark - 设置子控件
- (void)_setupSubViews{
    /// 设置背景
    [self.loginBtn setBackgroundImage:[UIImage yy_imageWithColor:MHColorFromHexString(@"#51AA38")] forState:UIControlStateNormal];
    [self.loginBtn setBackgroundImage:[UIImage yy_imageWithColor:[MHColorFromHexString(@"#51AA38") colorWithAlphaComponent:.5f]] forState:UIControlStateHighlighted];
    [self.loginBtn setBackgroundImage:[UIImage yy_imageWithColor:MHColorFromHexString(@"#AFDDA7")] forState:UIControlStateDisabled];
    
    
    /// 账号登录
    MHAccountLoginView *accountLoginView = [MHAccountLoginView accoutLoginView];
    self.accountLoginView = accountLoginView;
    [self.accountBaseView addSubview:accountLoginView];
    
    /// 手机登录
    MHMobileLoginView *mobileLoginView = [MHMobileLoginView mobileLoginView];
    [mobileLoginView bindViewModel:self.viewModel];
    self.mobileLoginView = mobileLoginView;
    [self.accountBaseView addSubview:mobileLoginView];
    
    /// 布局
    [mobileLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.accountBaseView);
        make.top.and.bottom.equalTo(self.accountBaseView);
        make.width.equalTo(self.accountBaseView);
    }];
    
    [accountLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.accountBaseView).with.offset(MH_SCREEN_WIDTH);
        make.top.and.bottom.equalTo(self.accountBaseView);
        make.width.equalTo(self.accountBaseView);
    }];
}
@end
