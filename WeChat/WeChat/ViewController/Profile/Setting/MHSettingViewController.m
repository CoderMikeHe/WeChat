//
//  MHSettingViewController.m
//  WeChat
//
//  Created by senba on 2017/10/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHSettingViewController.h"
#import "LCActionSheet.h"

@interface MHSettingViewController ()
/// viewModel
@property (nonatomic, readonly, strong) MHSettingViewModel *viewModel;
@end

@implementation MHSettingViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    /// 设置子控件
    [self _setupSubViews];
}

#pragma mark - Override
- (void)bindViewModel{
    [super bindViewModel];
    @weakify(self);
    /// show HUD
    [[self.viewModel.logoutCommand.executing
       skip:1]
     subscribeNext:^(NSNumber * showHud) {
         if (showHud.boolValue) {
             [MBProgressHUD mh_showProgressHUD:@"正在退出..."];
         }else{
             [MBProgressHUD mh_hideHUD];
         }
     }];
}

#pragma mark - 设置子控件
- (void)_setupSubViews{
    UIButton *footerView = [UIButton buttonWithType:UIButtonTypeCustom];
    footerView.mh_height = 44.0f;
    [footerView setTitle:@"退出登录" forState:UIControlStateNormal];
    [footerView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    footerView.titleLabel.font = MHRegularFont_16;
    [footerView setBackgroundImage:[UIImage yy_imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [footerView setBackgroundImage:[UIImage yy_imageWithColor:MHColor(217, 217, 217)] forState:UIControlStateHighlighted];
    self.tableView.tableFooterView = footerView;
    
    /// 事件处理
    @weakify(self);
    [[footerView rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(UIButton *sender) {
         @strongify(self);
         @weakify(self);
         LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"退出后不会删除任何历史数据，下次登录依然可以使用本账号" cancelButtonTitle:@"取消" clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
             if (buttonIndex == 0) return ;
             /// 退出账号
             @strongify(self);
             [self.viewModel.logoutCommand execute:nil];
             
         } otherButtonTitles:@"退出登录", nil];
         NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
         [indexSet addIndex:1];
         sheet.destructiveButtonIndexSet = indexSet;
         [sheet show];
     }];
}

@end
