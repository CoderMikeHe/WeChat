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

@interface MHPulldownAppletWrapperViewController ()<UIScrollViewDelegate>
/// viewModel
@property (nonatomic, readonly, strong) MHPulldownAppletWrapperViewModel *viewModel;
/// 下拉容器
@property (nonatomic, readwrite, weak) UIScrollView *scrollView;
/// 蒙版 darkView
@property (nonatomic, readwrite, weak) UIView *darkView;
/// 天气View
@property (nonatomic, readwrite, weak) WHWeatherView *weatherView;

/// 下拉状态
@property (nonatomic, readwrite, assign) MHRefreshState state;

/// 是否正在拖拽
@property (nonatomic, readwrite, assign, getter=isDragging) BOOL dragging;

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
    /// 这个正向下拉逻辑
    /// Fixed bug: distinctUntilChanged 不需要，否则某些场景认为没变化 实际上变化了 引发Bug
    RACSignal *signal = [RACObserve(self.viewModel, offsetInfo) skip:1];
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
        /// 释放刷新状态
        [UIView animateWithDuration:.4 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            /// Fixed Bug: 这里也得显示
            self.view.alpha = 1.0f;
            
            /// 小程序相关
            self.appletController.view.alpha = 1.0f;
            self.appletController.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
            /// 蒙版相关
            self.darkView.alpha = .6f;
            /// 天气相关
            self.weatherView.alpha = 1.0f;
        } completion:^(BOOL finished) {
            /// 弄高点 形成滚动条短一点的错觉
            self.scrollView.contentSize = CGSizeMake(0, 20 * MH_SCREEN_HEIGHT);
        }];
    }else {
        /// 超过这个临界点 才有机会显示
        if (offset > MHPulldownAppletCriticalPoint2) {
            
            self.view.alpha = 1.0f;
            
            /// 小程序 alpha 0 --> .3f
            CGFloat alpha = 0;
            CGFloat step = 0.3 / (MHPulldownAppletCriticalPoint3 - MHPulldownAppletCriticalPoint2);
            alpha = 0 + step * (offset - MHPulldownAppletCriticalPoint2);
            self.appletController.view.alpha = MIN(.3f, alpha);
            
            /// darkView alpha 0 --> .1f
            CGFloat alpha1 = 0;
            CGFloat step1 = 0.1 / (MHPulldownAppletCriticalPoint3 - MHPulldownAppletCriticalPoint2);
            alpha1 = 0 + step1 * (offset - MHPulldownAppletCriticalPoint2);
            self.darkView.alpha = MIN(.1f, alpha1);
        }else {
            self.view.alpha = .0f;
        }
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.dragging = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    MHLogFunc;
    /// 结束拖拽
    self.dragging = NO;
    // decelerate: YES 说明还有速度或者说惯性，会继续滚动 停止时调用scrollViewDidEndDecelerating/scrollViewDidScroll
    // decelerate: NO  说明是很慢的拖拽，没有惯性，不会调用 scrollViewDidEndDecelerating/scrollViewDidScroll
    if (!decelerate) {
        /// 手动调用
        [self scrollViewDidScroll:scrollView];
    }
}

/// Fixed Bug：scrollView.isDragging/isTracking 手指离开屏幕 可能还是会返回 YES 巨坑
/// 解决方案： 自己控制 dragging 状态， 方法如上
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    /// 获取偏移量
    CGFloat offsetY = scrollView.mh_offsetY;
    
    /// 这种场景 设置scrollView.contentOffset.y = 0 否则滚动条下拉 让用户觉得能下拉 但是又没啥意义 体验不好
    if (offsetY < -scrollView.contentInset.top) {
        scrollView.contentOffset = CGPointMake(0, -scrollView.contentInset.top);
        offsetY = 0;
    }

    ///  微信只要滚动 结束拖拽 就立即进入刷新状态
    // 在刷新的refreshing状态 do nothing...
    if (self.state == MHRefreshStateRefreshing) {
        return;
    }
    
    /// 计算偏移量 负数
    CGFloat delta = -offsetY;
    
    // 如果正在拖拽
    if (self.isDragging) {

        /// 更新 天气/小程序 的Y
        self.weatherView.mh_y = self.appletController.view.mh_y = delta;
        
        /// 更新 self.darkView.alpha 最大也只能拖拽 屏幕高
        self.darkView.alpha = 0.6 * MAX(MH_SCREEN_HEIGHT - offsetY, 0) / MH_SCREEN_HEIGHT;
       
        if (self.state == MHRefreshStateIdle) {
            // 转为即将刷新状态
            self.state = MHRefreshStatePulling;
        }

        /// 回调数据
        !self.viewModel.callback?:self.viewModel.callback( @{@"offset": @(delta), @"state": @(self.state)});
        
    } else if (self.state == MHRefreshStatePulling) {
        /// 进入帅新状态
        self.state = MHRefreshStateRefreshing;
    }
}

#pragma mark - Setter & Getter
- (void)setState:(MHRefreshState)state {
    MHRefreshState oldState = self.state;
    if (state == oldState) return;
    _state = state;
    
    // 根据状态做事情
    if (state == MHRefreshStateIdle) {
        if (oldState != MHRefreshStateRefreshing) return;
        
        // 恢复inset和offset
        [UIView animateWithDuration:.4f animations:^{
            /// 更新 天气/小程序 的Y
            self.weatherView.mh_y = self.appletController.view.mh_y = -MH_SCREEN_HEIGHT;
            
            self.darkView.alpha = .0f;
            
        } completion:^(BOOL finished) {
            ///  --- 动画结束后做的事情 ---
            /// 隐藏当前view
            self.view.alpha = .0f;
            
            /// 重新调整 天气、小程序 的 y 值
            self.weatherView.mh_y = self.appletController.view.mh_y = 0;
            
            /// 重新将scrollView 偏移量 置为 0
            self.scrollView.contentOffset = CGPointZero;
            self.scrollView.contentSize = CGSizeZero;
            
            /// 重新设置 小程序view的缩放量
            self.appletController.view.transform = CGAffineTransformMakeScale(0.6, 0.4);
            
            /// 配置天气类型
            static NSInteger type = 0;
            type = (type + 1) % 5;
            /// 天气动画;
            [self.weatherView showWeatherAnimationWithType:type];
            self.weatherView.alpha = .0f;
            
        }];
    } else if (state == MHRefreshStateRefreshing) {
        dispatch_async(dispatch_get_main_queue(), ^{
            /// 传递状态
            /// 回调数据 offset info
            !self.viewModel.callback?:self.viewModel.callback( @{@"offset": @(-MH_SCREEN_HEIGHT), @"state": @(self.state)});

            /// 自身也进入空闲状态
            self.state = MHRefreshStateIdle;
        });
    }
}



#pragma mark - 初始化OrUI布局
/// 初始化
- (void)_setup{
    self.view.alpha = .0f;
    self.view.backgroundColor = [UIColor clearColor];
    self.state = MHRefreshStateIdle;
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
    
    /// 天气
    CGRect frame = CGRectMake(0, 0, MH_SCREEN_WIDTH, MH_SCREEN_HEIGHT);
    WHWeatherView *weatherView = [[WHWeatherView alloc] init];
    weatherView.frame = frame;
    [self.view addSubview:weatherView];
    self.weatherView = weatherView;
    weatherView.alpha = .0f;
    
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
        
    
    /// 添加下拉小程序模块
    CGFloat height = MH_APPLICATION_TOP_BAR_HEIGHT + (102.0f + 48.0f) * 2 + 74.0f + 50.0f;
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
    appletController.view.transform = CGAffineTransformMakeScale(0.6, 0.4);
    appletController.view.alpha = .0f;
}

/// 布局子控件
- (void)_makeSubViewsConstraints{
    
    [self.darkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
}

@end
