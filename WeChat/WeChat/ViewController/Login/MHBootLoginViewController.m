//
//  MHBootLoginViewController.m
//  WeChat
//
//  Created by senba on 2017/9/26.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHBootLoginViewController.h"

@interface MHBootLoginViewController ()
/// 登录按钮
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
/// 注册按钮
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
/// viewModel
@property (nonatomic, readonly, strong) MHBootLoginViewModel *viewModel;
/// languageBtn
@property (weak, nonatomic) IBOutlet UIButton *languageBtn;

@end

@implementation MHBootLoginViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    /// 设置子控件
    [self _setupSubViews];
}

#pragma mark - 事件处理
- (IBAction)_languageBtnDidClicked:(UIButton *)sender {
    [self.viewModel.languageCommand execute:nil];
}

- (IBAction)_loginBtnDidClicked:(UIButton *)sender {
    [self.viewModel.loginCommand execute:nil];
}

- (IBAction)_registerBtnDidClicked:(UIButton *)sender {
    [self.viewModel.registerCommand execute:nil];
}


#pragma mark - Override
- (void)bindViewModel{
    [super bindViewModel];
    @weakify(self);
    [RACObserve(self.viewModel, language) subscribeNext:^(NSString * language) {
        @strongify(self);
        [self.languageBtn setTitle:language forState:UIControlStateNormal];
    }];
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

#pragma mark - 设置子控件
- (void)_setupSubViews{
    [self.loginBtn setBackgroundImage:[UIImage yy_imageWithColor:MHColorFromHexString(@"#F8F8F8")] forState:UIControlStateNormal];
    [self.loginBtn setBackgroundImage:[UIImage yy_imageWithColor:MHColorFromHexString(@"#E3E3E3")] forState:UIControlStateHighlighted];
    [self.registerBtn setBackgroundImage:[UIImage yy_imageWithColor:MHColorFromHexString(@"#52AA35")] forState:UIControlStateNormal];
    [self.registerBtn setBackgroundImage:[UIImage yy_imageWithColor:MHColorFromHexString(@"#0F961A")] forState:UIControlStateHighlighted];
}
@end
