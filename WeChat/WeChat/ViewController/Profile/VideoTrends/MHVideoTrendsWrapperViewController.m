//
//  MHVideoTrendsWrapperViewController.m
//  WeChat
//
//  Created by admin on 2020/8/4.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHVideoTrendsWrapperViewController.h"
#import "WHWeatherView.h"
#import "WHWeatherHeader.h"
@interface MHVideoTrendsWrapperViewController ()<UIScrollViewDelegate>
/// viewModel
@property (nonatomic, readonly, strong) MHVideoTrendsWrapperViewModel *viewModel;
/// 上拉容器
@property (nonatomic, readwrite, weak) UIScrollView *scrollView;
/// 天气View
@property (nonatomic, readwrite, weak) WHWeatherView *weatherView;
/// 下拉状态
@property (nonatomic, readwrite, assign) MHRefreshState state;

/// 是否正在拖拽
@property (nonatomic, readwrite, assign, getter=isDragging) BOOL dragging;

/// -----------------------下拉小程序相关------------------------
/// lastOffsetY
@property (nonatomic, readwrite, assign) CGFloat lastOffsetY;
@end

@implementation MHVideoTrendsWrapperViewController

@dynamic viewModel;


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

#pragma mark - 事件处理Or辅助方法

#pragma mark - 初始化OrUI布局
/// 初始化
- (void)_setup{
    self.view.backgroundColor = [UIColor whiteColor];
    self.state = MHRefreshStateIdle;
}

/// 设置导航栏
- (void)_setupNavigationItem{
    
}

/// 初始化子控件
- (void)_setupSubviews{
    /// 天气
    CGRect frame = CGRectMake(0, 0, MH_SCREEN_WIDTH, MH_SCREEN_HEIGHT);
    WHWeatherView *weatherView = [[WHWeatherView alloc] init];
    weatherView.frame = frame;
//    weatherView.weatherBackImageView.frame = frame;
//    [self.view addSubview:weatherView.weatherBackImageView];
    [self.view addSubview:weatherView];
    self.weatherView = weatherView;
    weatherView.alpha = 1.0f;
    /// 天气动画;
    [weatherView showWeatherAnimationWithType:WHWeatherTypeClound];
    
    /// 滚动
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    self.scrollView = scrollView;
    MHAdjustsScrollViewInsets_Never(scrollView);
    [self.view addSubview:scrollView];
    /// 高度为 屏高-导航栏高度 形成滚动条在导航栏下面
    scrollView.frame = CGRectMake(0, MH_APPLICATION_TOP_BAR_HEIGHT, MH_SCREEN_WIDTH, MH_SCREEN_HEIGHT-MH_APPLICATION_TOP_BAR_HEIGHT);
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.delegate = self;
    scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
}

/// 布局子控件
- (void)_makeSubViewsConstraints{
    
}


@end
