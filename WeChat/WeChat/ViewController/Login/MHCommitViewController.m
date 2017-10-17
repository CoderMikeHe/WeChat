//
//  MHCommitViewController.m
//  WeChat
//
//  Created by senba on 2017/10/12.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHCommitViewController.h"

@interface MHCommitViewController ()
/// viewModel
@property (nonatomic, readwrite, strong) MHCommitViewModel *viewModel;

/// containerView
@property (weak, nonatomic) IBOutlet UIView *containerView;
/// commitBtn
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
/// captchaTextField
@property (weak, nonatomic) IBOutlet UITextField *captchaTextField;

/// phoneTextField
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

/// secondLabel
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;

@end

@implementation MHCommitViewController

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
    
    RAC(self.secondLabel, text) = [[RACObserve(self.viewModel, captchaTitle)
      distinctUntilChanged]
     deliverOnMainThread];
    
    /// 验证码
    RAC(self.viewModel , captcha) = [RACSignal merge:@[RACObserve(self.captchaTextField, text),self.captchaTextField.rac_textSignal]];
    
    RAC(self.commitBtn , enabled) = self.viewModel.validCommitSignal;
    
    /// show HUD
    [[[self.viewModel.commitCommand.executing skip:1]
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
    [[self.viewModel.commitCommand.errors deliverOnMainThread] subscribeNext:^(NSError * error) {
        [MBProgressHUD mh_showErrorTips:error];
    }];
}



#pragma mark - Action
- (void)_close{
    @weakify(self);
    [NSObject mh_showAlertViewWithTitle:@"验证码短信可能略有延迟，确定返回并重新开始？" message:nil confirmTitle:@"返回" cancelTitle:@"等待" confirmAction:^{
        @strongify(self);
        [self.viewModel.closeCommand execute:nil];
    } cancelAction:NULL];
}
/// 提交按钮被点击
- (IBAction)_commitBtnDidClicked:(UIButton *)sender {
    /// 验证码 六位 且必须是纯数字
    if(self.viewModel.captcha.length != 6 || ![NSString mh_isPureDigitCharacters:self.viewModel.captcha]){
        [NSObject mh_showAlertViewWithTitle:@"验证码超时，请重新获取验证码。" message:nil confirmTitle:@"确定"];
        return ;
    }
    /// excute
    [self.viewModel.commitCommand execute:nil];
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
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem mh_systemItemWithTitle:@"<返回" titleColor:MH_MAIN_TINTCOLOR imageName:nil target:self selector:@selector(_close) textType:YES];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem mh_customItemWithTitle:@"返回" titleColor:MH_MAIN_TINTCOLOR imageName:@"invite_Green_arrow_Icon_12x20_left" target:self selector:@selector(_close) contentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
}

#pragma mark - 设置子控件
- (void)_setupSubViews{
    /// 设置背景
    [self.commitBtn setBackgroundImage:[UIImage yy_imageWithColor:MHColorFromHexString(@"#51AA38")] forState:UIControlStateNormal];
    [self.commitBtn setBackgroundImage:[UIImage yy_imageWithColor:[MHColorFromHexString(@"#51AA38") colorWithAlphaComponent:.5f]] forState:UIControlStateHighlighted];
    [self.commitBtn setBackgroundImage:[UIImage yy_imageWithColor:MHColorFromHexString(@"#AFDDA7")] forState:UIControlStateDisabled];
    
    /// 限制验证码输入字数 为6
    [self.captchaTextField mh_limitMaxLength:6];
}

#pragma mark - 初始化部分数据
-(void) _configureData{
    /// 拼接数据
    self.phoneTextField.text = [NSString stringWithFormat:@"+%@ %@",self.viewModel.zoneCode , self.viewModel.phone];
    
    /// 执行验证码
    [self.viewModel.captchaCommand execute:nil];
};

@end
