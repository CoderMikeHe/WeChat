//
//  MHSearchViewController.m
//  WeChat
//
//  Created by admin on 2020/5/6.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchViewController.h"
#import "MHSearchTypeView.h"
@interface MHSearchViewController ()
/// scrollView
@property (nonatomic, readwrite, weak) UIScrollView *scrollView;
/// containerView
@property (nonatomic, readwrite, weak) UIView *containerView;

/// searchTypeView
@property (nonatomic, readwrite, weak) MHSearchTypeView *searchTypeView;
@end

@implementation MHSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// 设置
    [self _setup];
    
    /// 设置导航栏
    [self _setupNavigationItem];
    
    /// 设置子控件
    [self _setupSubviews];
    
    /// 布局子空间
    [self _makeSubViewsConstraints];
}
#pragma mark - Override
- (void)bindViewModel {
    [super bindViewModel];
}

#pragma mark - 事件处理Or辅助方法

#pragma mark - 初始化OrUI布局
/// 初始化
- (void)_setup{
    
}

/// 设置导航栏
- (void)_setupNavigationItem{
    
}

/// 初始化子控件
- (void)_setupSubviews{
    
    // scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.alwaysBounceVertical = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    /// 适配 iOS 11
    MHAdjustsScrollViewInsets_Never(scrollView);
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    /// containerView
    UIView *containerView = [[UIView alloc] init];
    [scrollView addSubview:containerView];
    self.containerView = containerView;
    
    // searchTypeView
    MHSearchTypeView *searchTypeView = [MHSearchTypeView searchTypeView];
    self.searchTypeView = searchTypeView;
    [containerView addSubview:searchTypeView];
    
    // 设置背景色
    containerView.backgroundColor = searchTypeView.backgroundColor = self.view.backgroundColor;
    
    
//    UITapGestureRecognizer *r = [[UITapGestureRecognizer alloc] init];
//    [containerView addGestureRecognizer:r];
//    
//    [r.rac_gestureSignal subscribeNext:^(id x) {
//        NSLog(@"MLGB");
//    }];
}

/// 布局子控件
- (void)_makeSubViewsConstraints{
    
    // 设置view
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    /// 设置contentSize
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(MH_SCREEN_WIDTH);
        make.height.mas_equalTo(MH_SCREEN_HEIGHT);
    }];
    
    [self.searchTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.containerView);
        make.top.equalTo(self.containerView).with.offset(39.0);
        make.height.mas_equalTo(150);
    }];
}

@end
