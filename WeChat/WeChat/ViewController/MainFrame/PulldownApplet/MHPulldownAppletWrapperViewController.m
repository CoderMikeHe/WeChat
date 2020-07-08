//
//  MHPulldownAppletWrapperViewController.m
//  WeChat
//
//  Created by admin on 2020/7/7.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHPulldownAppletWrapperViewController.h"
#import "MHPulldownAppletViewController.h"
#import "WHWeatherView.h"
#import "WHWeatherHeader.h"


@interface MHPulldownAppletWrapperViewController ()
/// viewModel
@property (nonatomic, readonly, strong) MHPulldownAppletWrapperViewModel *viewModel;
/// 下拉容器
@property (nonatomic, readwrite, weak) UIScrollView *scrollView;
/// 蒙版 darkView
@property (nonatomic, readwrite, weak) UIView *darkView;

@property (nonatomic, readwrite, strong) WHWeatherView *weatherView;
/// -----------------------下拉小程序相关------------------------
/// appletController
@property (nonatomic, readwrite, strong) MHPulldownAppletViewController *appletController;
@end

@implementation MHPulldownAppletWrapperViewController

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
#pragma mark - Override
- (void)bindViewModel {
    [super bindViewModel];
    
    @weakify(self);
    RACSignal *signal = [[RACObserve(self.viewModel, offsetInfo) skip:1] distinctUntilChanged];
    [signal subscribeNext:^(NSDictionary *dictionary) {
        @strongify(self);
        CGFloat offset = [dictionary[@"offset"] doubleValue];
        MHRefreshState state = [dictionary[@"state"] doubleValue];
        [self _handleOffset:offset state:state];
    }];
    
}

#pragma mark - 事件处理Or辅助方法
- (void)_handleOffset:(CGFloat)offset state:(MHRefreshState)state {
    if (state == MHRefreshStateRefreshing) {
        /// 天气动画
        NSInteger type = [NSObject mh_randomNumberWithFrom:0 to:0];
        [self.weatherView showWeatherAnimationWithType:type];
        
        /// 动画
        [UIView animateWithDuration:.4 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            /// 释放刷新状态
            self.appletController.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
            
            self.view.alpha = 1.0;
            
            self.darkView.alpha = .6f;
        } completion:^(BOOL finished) {
            self.scrollView.contentSize = CGSizeMake(0, 2 * MH_SCREEN_HEIGHT);
        }];
        
    }else {
        /// 拖拽状态
        CGFloat opacity = 0;
        //
        CGFloat step = 0.5 / (MHPulldownAppletCriticalPoint3 - MHPulldownAppletCriticalPoint2);
        opacity = 0 + step * (offset - MHPulldownAppletCriticalPoint3);
        if (opacity > 0.5) {
            opacity = 0.5;
        } else if (opacity < 0) {
            opacity = 0;
        }
        
        self.view.alpha = opacity;
    }
}


#pragma mark - 初始化OrUI布局
/// 初始化
- (void)_setup{
    self.view.backgroundColor = [UIColor clearColor];
}

/// 设置导航栏
- (void)_setupNavigationItem{
    
}

/// 初始化子控件
- (void)_setupSubviews{
    
    /// 蒙版
    UIView *darkView = [[UIView alloc] init];
    darkView.backgroundColor = MHColorFromHexString(@"#1b1b2e");
    darkView.alpha = .0f;
    self.darkView = darkView;
    [self.view addSubview:darkView];
    
    /// scrollView
    CGFloat height = MH_APPLICATION_TOP_BAR_HEIGHT + (102.0f + 48.0f) * 2 + 50 + 74.0f;
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    self.scrollView = scrollView;
    MHAdjustsScrollViewInsets_Never(scrollView);
    [self.view addSubview:scrollView];
    scrollView.frame = CGRectMake(0, 0, MH_SCREEN_WIDTH, MH_SCREEN_HEIGHT);
    scrollView.backgroundColor = [UIColor clearColor];
    
    /// 天气
    CGRect frame = CGRectMake(0, 0, MH_SCREEN_WIDTH, MH_SCREEN_HEIGHT);
    self.weatherView.frame = frame;
    [scrollView addSubview:self.weatherView];
    
    /// 添加下拉小程序模块
    MHPulldownAppletViewController *appletController = [[MHPulldownAppletViewController alloc] initWithViewModel:self.viewModel.appletViewModel];
    [scrollView addSubview:appletController.view];
    [self addChildViewController:appletController];
    [appletController didMoveToParentViewController:self];
    self.appletController = appletController;

    // 先设置锚点,在设置frame
    appletController.view.layer.anchorPoint = CGPointMake(0.5, 0);
    appletController.view.frame = CGRectMake(0, 0, MH_SCREEN_WIDTH, height);
    appletController.view.transform = CGAffineTransformMakeScale(0.6, 0.3);
}

/// 布局子控件
- (void)_makeSubViewsConstraints{
    
    [self.darkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
}


#pragma mark - Getter
- (WHWeatherView *)weatherView {
    if (!_weatherView) {
        _weatherView = [[WHWeatherView alloc] init];
    }
    return _weatherView;
}
@end
