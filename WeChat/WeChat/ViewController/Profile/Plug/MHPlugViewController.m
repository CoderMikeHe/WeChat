//
//  MHPlugViewController.m
//  WeChat
//
//  Created by senba on 2017/10/15.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHPlugViewController.h"

@interface MHPlugViewController ()

/// viewModel
@property (nonatomic, readonly, strong) MHPlugViewModel *viewModel;

/// containerView
@property (weak, nonatomic) IBOutlet UIView *containerView;

/// lookLookView
@property (weak, nonatomic) IBOutlet UIView *lookLookView;
/// searchView
@property (weak, nonatomic) IBOutlet UIView *searchView;

@end

@implementation MHPlugViewController

@dynamic viewModel;

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    /// 设置颜色
    [self.navigationController.navigationBar setBarTintColor:MH_MAIN_NAVIGATIONBAR_BACKGROUNDCOLOR_4];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    /// 设置颜色
    [self.navigationController.navigationBar setBarTintColor:MH_MAIN_NAVIGATIONBAR_BACKGROUNDCOLOR_1];
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

#pragma mark - 事件处理
/// 使用须知
- (IBAction)_useKnowBtnDidClicked:(UIButton *)sender {
    [self.viewModel.useIntroCommand execute:nil];
}

#pragma mark - 初始化
- (void)_setup{
    
    UIScrollView *scrollView = (UIScrollView *)self.view;
    scrollView.alwaysBounceVertical = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.backgroundColor = MH_MAIN_NAVIGATIONBAR_BACKGROUNDCOLOR_4;
    self.containerView.backgroundColor = MH_MAIN_NAVIGATIONBAR_BACKGROUNDCOLOR_4;
    
    /// 适配 iOS 11
    MHAdjustsScrollViewInsets_Never(scrollView);
    
}

#pragma mark - 设置导航栏
- (void)_setupNavigationItem{
}

#pragma mark - 设置子控件
- (void)_setupSubViews{
    @weakify(self);
    /// 添加手势监听
    UITapGestureRecognizer *lookTap = [[UITapGestureRecognizer alloc] init];
    [self.lookLookView addGestureRecognizer:lookTap];
    [lookTap.rac_gestureSignal subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel.plugDetailCommand execute:@(MHPlugDetailTypeLook)];
    }];
    
    
    UITapGestureRecognizer *searchTap = [[UITapGestureRecognizer alloc] init];
    [self.searchView addGestureRecognizer:searchTap];
    [searchTap.rac_gestureSignal subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel.plugDetailCommand execute:@(MHPlugDetailTypeSearch)];
    }];
}


@end
