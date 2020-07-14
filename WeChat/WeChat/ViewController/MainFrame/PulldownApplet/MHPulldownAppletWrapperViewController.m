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
#import "YYTimer.h"
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
/// lastOffsetY
@property (nonatomic, readwrite, assign) CGFloat lastOffsetY;




/// appletController
@property (nonatomic, readwrite, strong) MHPulldownAppletViewController *appletController;


/// 是否延迟回到主页
@property (nonatomic, readwrite, assign, getter=isDelay) bool delay;

/// Timer
@property (nonatomic, readwrite, strong) YYTimer *timer;
/// stepFastValue
@property (nonatomic, readwrite, assign) CGFloat stepFastValue;
/// stepSlowValue
@property (nonatomic, readwrite, assign) CGFloat stepSlowValue;
/// timerCount 计时次数
@property (nonatomic, readwrite, assign) NSInteger timerCount;
/// offsetValue 开启定时器的偏移量
@property (nonatomic, readwrite, assign) CGFloat offsetValue;
@end

@implementation MHPulldownAppletWrapperViewController

@dynamic viewModel;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    ///
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    /// 放在这里做处理 不然还是会看到动画...
    if (self.isDelay) {
        self.delay = NO;
        self.state = MHRefreshStateRefreshing;
    }
}


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
    
    
    /// 监听小程序的回调数据
    /// completed: YES 回到主页 NO 不回到主页
    self.viewModel.appletViewModel.callback = ^(NSDictionary *dictionary) {
        @strongify(self);
        
        BOOL completed = [dictionary[@"completed"] boolValue];
        BOOL delay = [dictionary[@"delay"] boolValue];
        
        if (completed) {
            /// 增加延迟，方便等到跳转到下一页 再回到主页
            if (delay) {
                self.delay = delay;
            }else {
                self.state = MHRefreshStateRefreshing;
            }
        }
    };
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
            /// show
            self.view.alpha = 1.0f;
            
            /// 小程序View alpha 0 --> .3f
            CGFloat alpha = 0;
            CGFloat step = 0.3 / (MHPulldownAppletCriticalPoint3 - MHPulldownAppletCriticalPoint2);
            alpha = 0 + step * (offset - MHPulldownAppletCriticalPoint2);
            self.appletController.view.alpha = MIN(.3f, alpha);
            
            /// 小程序View scale 0 --> .1f
            CGFloat scale = 0;
            CGFloat step2 = 0.1 / (MHPulldownAppletCriticalPoint3 - MHPulldownAppletCriticalPoint2);
            scale =  0 + step2 * (offset - MHPulldownAppletCriticalPoint2);
            scale = MIN(.1f, scale);
            self.appletController.view.transform = CGAffineTransformMakeScale(0.6 + scale, 0.4 + scale);
            
            /// darkView alpha 0 --> .3f
            CGFloat alpha1 = 0;
            CGFloat step1 = 0.3 / (MHPulldownAppletCriticalPoint3 - MHPulldownAppletCriticalPoint2);
            alpha1 = 0 + step1 * (offset - MHPulldownAppletCriticalPoint2);
            self.darkView.alpha = MIN(.3f, alpha1);
        }else {
            self.view.alpha = .0f;
        }
    }
}

/// 开始定时器
- (void)_startTimer {
    ///
    if (!self.timer && !self.timer.isValid && self.lastOffsetY > 0) {
        /// 获取当前拖拽结束d偏移量
        self.offsetValue = self.scrollView.mh_offsetY;
        
        /// 计时次数清零
        self.timerCount = 0;
        /// 模拟先快后慢 假设 快阶段：0.5s跑80%的距离 慢阶段：0.5s跑20%的距离
        NSTimeInterval interval = .01f;
        CGFloat count0 = 1.5 * 0.3/interval;
        CGFloat count1 = 1.5 * 0.7/interval;
        
        self.stepFastValue = self.offsetValue * 0.5/count0;
        self.stepSlowValue = self.offsetValue * 0.5/count1;
        
        self.timer = [YYTimer timerWithTimeInterval:interval target:self selector:@selector(_timerValueChanged:) repeats:YES];
    }
}

/// 关闭定时器 用户一旦开始拖拽 就关闭定时器
- (void)_stopTimer {
    if (self.timer && self.timer.isValid) {
        [self.timer invalidate];
        self.timer = nil;
    }
}


/// 定时器回调事件
- (void)_timerValueChanged:(YYTimer *)timer{
    /// 进来+1
    self.timerCount++;
    
    /// 设置步进值
    if (self.timerCount <= 1.5 * 0.3 / 0.01) {
        /// 快阶段
        self.offsetValue -= self.stepFastValue;
    }else {
        self.offsetValue -= self.stepSlowValue;
    }
    
    /// 滚动结束 关闭定时器
    if (self.offsetValue <= 0) {
        [timer invalidate];
        self.timer = nil;
        /// 归零
        self.offsetValue = .0f;
    }
    /// 正数
    CGFloat offset = self.offsetValue;
    
    /// 设置scrollView 的偏移量
    [self.scrollView setContentOffset:CGPointMake(0, offset)];
    
    CGFloat progress = MAX(MH_SCREEN_HEIGHT - offset, 0) / MH_SCREEN_HEIGHT;
    
    /// 更新 self.darkView.alpha 最大也只能拖拽 屏幕高
    self.darkView.alpha = 0.6 * progress;
    
    /// 更新 天气/小程序 的Y 和 alpha
    self.weatherView.mh_y = self.appletController.view.mh_y = -offset;
    self.weatherView.alpha = self.appletController.view.alpha = 1.0f * progress;
    
    /// 回调数据
    !self.viewModel.callback?:self.viewModel.callback( @{@"offset": @(-offset), @"state": @(self.state)});
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    MHLogFunc;
    /// 停止减速了 如果偏移量 仍旧>0 则滚动到顶部
    /// 获取偏移量
    //    CGFloat offsetY = scrollView.mh_offsetY;
    //    if (offsetY > 0) {
    //        /// 手动滚动到顶部
    //        [scrollView scrollToTop];
    //    }
    /// 非释放状态 需要手动 滚动到最顶部
//    if (self.state != MHRefreshStatePulling) {
////        [scrollView setContentOffset:CGPointMake(0, scrollView.mh_offsetY)];
//        /// 回调数据
//        !self.viewModel.callback?:self.viewModel.callback( @{@"offset": @(0), @"state": @(self.state), @"animate": @YES});
//        /// 手动滚动到顶部
//        //        [scrollView scrollToTop];
//        [UIView animateWithDuration:1.0f animations:^{
//            [scrollView setContentOffset:CGPointMake(0, 0)];
//            /// 一旦进入这个  说面用户停止 drag了
//            /// 更新 天气/小程序 的Y
//            self.weatherView.mh_y = self.appletController.view.mh_y = 0;
//
//            /// 更新 self.darkView.alpha 最大也只能拖拽 屏幕高
//            self.darkView.alpha = 0.6;
//
//        }];
//
//
//    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    MHLogFunc;
    NSLog(@"🔥🔥🔥ooooooooooooooooooooooo");
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    /// 开始拖拽
    self.dragging = YES;
    
    /// 关掉定时器
    [self _stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    NSLog(@"++++++++++++++++++++++ %d  %ld", decelerate, self.state);
    
    /// 结束拖拽
    self.dragging = NO;
    // decelerate: YES 说明还有速度或者说惯性，会继续滚动 停止时调用scrollViewDidEndDecelerating/scrollViewDidScroll
    // decelerate: NO  说明是很慢的拖拽，没有惯性，不会调用 scrollViewDidEndDecelerating/scrollViewDidScroll
    if (!decelerate) {
        
        /// 非释放状态 需要手动 滚动到最顶部
        if (self.state != MHRefreshStatePulling) {
            [self _startTimer];
        }else {
            /// 手动调用
            [self scrollViewDidScroll:scrollView];
        }
    }else {
        NSLog(@"🔥xxxxxxxxoooooooooooooooooo");
        /// 非释放状态 需要手动 滚动到最顶部
        if (self.state != MHRefreshStatePulling) {
            [self _startTimer];
        }
    }
    
    
}

/// Fixed Bug：scrollView.isDragging/isTracking 手指离开屏幕 可能还是会返回 YES 巨坑
/// 解决方案： 自己控制 dragging 状态， 方法如上
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSLog(@"-------------------------> %f   %ld  %d", scrollView.mh_offsetY, self.state, scrollView.isDecelerating);
    
    /// 是否下拉
    BOOL isPulldown = NO;
    
    /// 获取偏移量
    CGFloat offsetY = scrollView.mh_offsetY;
    
    /// 这种场景 设置scrollView.contentOffset.y = 0 否则滚动条下拉 让用户觉得能下拉 但是又没啥意义 体验不好
    if (offsetY < -scrollView.contentInset.top) {
        scrollView.contentOffset = CGPointMake(0, -scrollView.contentInset.top);
        offsetY = 0;
        isPulldown = YES;
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
        
        CGFloat progress = MAX(MH_SCREEN_HEIGHT - offsetY, 0) / MH_SCREEN_HEIGHT;
        
        /// 更新 self.darkView.alpha 最大也只能拖拽 屏幕高
        self.darkView.alpha = 0.6 * progress;
        
        /// 更新 天气/小程序 的Y 和 alpha
        self.weatherView.mh_y = self.appletController.view.mh_y = delta;
        self.weatherView.alpha = self.appletController.view.alpha = 1.0f * progress;
        
        /// 必须是上拉
        if (self.state == MHRefreshStateIdle && (offsetY > self.lastOffsetY || isPulldown )) {
            // 转为即将刷新状态
            self.state = MHRefreshStatePulling;
        }else if (self.state == MHRefreshStatePulling && (offsetY <= self.lastOffsetY)){
            self.state = MHRefreshStateIdle;
        }
        
        /// 回调数据
        !self.viewModel.callback?:self.viewModel.callback( @{@"offset": @(delta), @"state": @(self.state)});
    } else if (self.state == MHRefreshStatePulling) {
        /// 进入帅新状态
        self.state = MHRefreshStateRefreshing;
    }
    
    
    /// 记录
    self.lastOffsetY = offsetY;
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
            
            self.appletController.view.alpha = .0f;
            
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
            [self.appletController resetOffset];
            
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
    
    /// 设置减速
    //    scrollView.decelerationRate = 0.5f;

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
