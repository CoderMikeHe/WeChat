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
#import "MHScrollView.h"

@interface MHPulldownAppletWrapperViewController ()<UIScrollViewDelegate>
/// viewModel
@property (nonatomic, readonly, strong) MHPulldownAppletWrapperViewModel *viewModel;
/// 下拉容器
@property (nonatomic, readwrite, weak) MHScrollView *scrollView;
/// 蒙版 darkView
@property (nonatomic, readwrite, weak) UIView *darkView;

@property (nonatomic, readwrite, strong) WHWeatherView *weatherView;
/// canScroll
@property (nonatomic, readwrite, assign) BOOL canScroll;

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
    
    self.canScroll = YES;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeStatus) name:@"shop_home_leaveTop" object:nil];
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

-(void)changeStatus{
    
    self.canScroll = YES;
    self.appletController.canScroll = NO;
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
            /// 弄高点 形成滚动条短一点的错觉
            self.scrollView.contentSize = CGSizeMake(0, 20 * MH_SCREEN_HEIGHT);
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

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"abc,.hhhhhhhhhhhh..... %f",scrollView.contentOffset.y);
    CGFloat offset = scrollView.contentOffset.y;
    
//    if (offset < -scrollView.contentInset.top) {
//        /// 这种场景 设置scrollView.contentOffset.y = 0 否则云层会下拉 体验不好
//        scrollView.contentOffset = CGPointMake(0, -scrollView.contentInset.top);
//    }
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
    
    /// 滚动
    MHScrollView *scrollView = [[MHScrollView alloc] init];
    self.scrollView = scrollView;
    MHAdjustsScrollViewInsets_Never(scrollView);
    [self.view addSubview:scrollView];
    /// 高度为 屏高-导航栏高度 形成滚动条在导航栏下面
    scrollView.frame = CGRectMake(0, MH_APPLICATION_TOP_BAR_HEIGHT, MH_SCREEN_WIDTH, MH_SCREEN_HEIGHT-MH_APPLICATION_TOP_BAR_HEIGHT);
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.delegate = self;
    scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    scrollView.clipsToBounds = NO;
    
    /// 天气 注意y = - MH_APPLICATION_TOP_BAR_HEIGHT
    CGRect frame = CGRectMake(0, -0, MH_SCREEN_WIDTH, MH_SCREEN_HEIGHT);
    self.weatherView.frame = frame;
    [self.view addSubview:self.weatherView];
    
    
    /// 添加下拉小程序模块
    CGFloat height = MH_APPLICATION_TOP_BAR_HEIGHT + (102.0f + 48.0f) * 2 + 74.0f + 100.0f;
    MHPulldownAppletViewController *appletController = [[MHPulldownAppletViewController alloc] initWithViewModel:self.viewModel.appletViewModel];
    /// 小修改： 之前是添加在 scrollView , 但是 会存在手势滚动冲突 当然也是可以解决的，但是笔者懒得很，就将其添加到 self.view
//    [scrollView addSubview:appletController.view];
    [self.view addSubview:appletController.view];
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
