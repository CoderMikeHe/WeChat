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
#import "MHVideoTrendsBubbleView.h"
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

/// -----------------------下拉视频动态相关------------------------
/// lastOffsetY
@property (nonatomic, readwrite, assign) CGFloat lastOffsetY;

/// cameraBtn
@property (nonatomic, readwrite, weak) UIButton *cameraBtn;
/// 提示按钮
@property (nonatomic, readwrite, weak) UIButton *tipsBtn;


/// bubbleView
@property (nonatomic, readwrite, weak) MHVideoTrendsBubbleView *bubbleView;

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

//// 这个跟 MHProfileViewController保持一致
- (UIEdgeInsets)contentInset{
    CGFloat top = [MHPreferenceSettingHelper boolForKey:MHPreferenceSettingPulldownVideoTrends] ? 124.0f : 164.0f;
    // 200 - 76
    return UIEdgeInsetsMake(top, 0, MH_APPLICATION_TAB_BAR_HEIGHT, 0);
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
        [self _handleAppletOffset:dictionary];
    }];
}

#pragma mark - 事件处理Or辅助方法
- (void)_handleAppletOffset:(NSDictionary *)dictionary {
    
    if (MHObjectIsNil(dictionary)) {
        return;
    }
    
    CGFloat offset = [dictionary[@"offset"] doubleValue];
    MHRefreshState state = [dictionary[@"state"] doubleValue];
    
    if (state == MHRefreshStateRefreshing) {
        /// 释放刷新状态
        [UIView animateWithDuration:MHPulldownAppletRefreshingDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            /// 设置偏移量
            [self.scrollView setContentOffset:CGPointZero animated:NO];
            /// 按钮显示
            self.cameraBtn.alpha = 1.0f;
            
            /// 提示按钮隐藏
            self.tipsBtn.alpha = .0f;
            
        } completion:^(BOOL finished) {
        }];
    }else {
//        /// 超过这个临界点 才有机会显示
//        if (offset > MHPulldownAppletCriticalPoint2) {
//            /// show
//            self.view.alpha = 1.0f;
//
//            /// 小程序View alpha 0 --> .3f
//            CGFloat alpha = 0;
//            CGFloat step = 0.3 / (MHPulldownAppletCriticalPoint3 - MHPulldownAppletCriticalPoint2);
//            alpha = 0 + step * (offset - MHPulldownAppletCriticalPoint2);
//            self.appletController.view.alpha = MIN(.3f, alpha);
//
//            /// 小程序View scale 0 --> .1f
//            CGFloat scale = 0;
//            CGFloat step2 = 0.1 / (MHPulldownAppletCriticalPoint3 - MHPulldownAppletCriticalPoint2);
//            scale =  0 + step2 * (offset - MHPulldownAppletCriticalPoint2);
//            scale = MIN(.1f, scale);
//            self.appletController.view.transform = CGAffineTransformMakeScale(0.6 + scale, 0.4 + scale);
//
//            /// darkView alpha 0 --> .3f
//            CGFloat alpha1 = 0;
//            CGFloat step1 = 0.3 / (MHPulldownAppletCriticalPoint3 - MHPulldownAppletCriticalPoint2);
//            alpha1 = 0 + step1 * (offset - MHPulldownAppletCriticalPoint2);
//            self.darkView.alpha = MIN(.3f, alpha1);
//        }else {
//            self.view.alpha = .0f;
//        }
        
        /// 细节处理 ： 这里需要对偏移量除以一个阻尼系数(>1)，保证外面的偏移量 大于 内部的偏移量
        CGFloat delta = offset / 1.8;
        
        /// 设置偏移量
        self.scrollView.contentOffset = CGPointMake(0, MH_SCREEN_HEIGHT - self.contentInset.top - delta - 140);
    }
}


/// Fixed Bug：scrollView.isDragging/isTracking 手指离开屏幕 可能还是会返回 YES 巨坑
/// 解决方案： 自己控制 dragging 状态， 方法如上
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    /// 是否下拉
    BOOL isPulldown = NO;
    
    /// 获取偏移量
    CGFloat offsetY = scrollView.mh_offsetY;
    
    NSLog(@"🔥 %f  %d", offsetY, scrollView.isDragging);
    
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
    }else if (self.state == MHRefreshStatePulling && !scrollView.isDragging) {
        /// fixed bug: 这里设置最后一次的偏移量 以免回弹
        [scrollView setContentOffset:CGPointMake(0, self.lastOffsetY)];
    }
    
    /// 计算偏移量 负数
    CGFloat delta = -offsetY;
    
    // 如果正在拖拽
    if (scrollView.isDragging) {
        
        /// 必须是上拉
        if (self.state == MHRefreshStateIdle && (offsetY > self.lastOffsetY || isPulldown )) {
            // 转为即将刷新状态
            self.state = MHRefreshStatePulling;
        }else if (self.state == MHRefreshStatePulling && (offsetY <= self.lastOffsetY)){
            self.state = MHRefreshStateIdle;
        }
        /// 回调数据 这里也得回传一个 比当前大偏移量 大的值 delta * 1.8
        !self.viewModel.callback?:self.viewModel.callback( @{@"offset": @(delta * 1.8), @"state": @(self.state)});
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
        
        /// 细节：外面要比里面的要快，外面动画时间 .35f 内部s动画时间 .5f
        
        // 恢复inset和offset
        [UIView animateWithDuration:.5f animations:^{
          
            CGFloat top = MH_SCREEN_HEIGHT - 124.0f;
            // 设置滚动位置 animated:YES 然后
            [self.scrollView setContentOffset:CGPointMake(0, top) animated:NO];
            
            /// Fixed Bug： 隐藏拍照按钮 有残影
            /// self.cameraBtn.alpha = .0f;
            
        }];
        
        /// Fixed Bug: 隐藏 拍照按钮 放在这里跟外界动画保持一致 否则放在上面的动画中，导致 外面会看到有残影 细节拉满
        [UIView animateWithDuration:MHPulldownAppletRefreshingDuration animations:^{
            /// 隐藏拍照按钮
            self.cameraBtn.alpha = .0f;
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
    self.view.backgroundColor = MH_MAIN_BACKGROUNDCOLOR;
    self.state = MHRefreshStateIdle;
}

/// 设置导航栏
- (void)_setupNavigationItem{
    
}

/// 初始化子控件
- (void)_setupSubviews{
    @weakify(self);
    
    /// 天气
//    CGRect frame = CGRectMake(0, 0, MH_SCREEN_WIDTH, MH_SCREEN_HEIGHT);
//    WHWeatherView *weatherView = [[WHWeatherView alloc] init];
//    weatherView.frame = frame;
//    [self.view addSubview:weatherView];
//    self.weatherView = weatherView;
//    weatherView.alpha = 1.0f;
//    /// 天气动画;
//    [weatherView showWeatherAnimationWithType:WHWeatherTypeClound];
    
    /// 滚动
    CGRect frame = CGRectMake(0, 0, MH_SCREEN_WIDTH, MH_SCREEN_HEIGHT);
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    self.scrollView = scrollView;
    MHAdjustsScrollViewInsets_Never(scrollView);
    [self.view addSubview:scrollView];
    /// 高度为 屏高-导航栏高度 形成滚动条在导航栏下面
    scrollView.frame = frame;
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.delegate = self;
    scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    scrollView.alwaysBounceVertical = YES;
    
    /// 气泡模块
    MHVideoTrendsBubbleView *bubbleView = [MHVideoTrendsBubbleView bubbleView];
    self.bubbleView = bubbleView;
    [scrollView addSubview:bubbleView];
    bubbleView.frame = frame;
    
    /// 增加点击事件回调
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] init];
    [scrollView addGestureRecognizer:tapGr];
    [tapGr.rac_gestureSignal subscribeNext:^(id x) {
        @strongify(self);
        /// 直接回调
        self.state = MHRefreshStateRefreshing;
    }];
    
    
    /// 默认场景下 设置 contentOffset 在最顶部
    scrollView.contentOffset = CGPointMake(0, MH_SCREEN_HEIGHT - self.contentInset.top - 140.0);
    
    
    /// cameraBtnf
    UIColor *color = MHColorFromHexString(@"#4699e0");
    UIImage *image = [UIImage mh_svgImageNamed:@"icons_filled_camera.svg" targetSize:CGSizeMake(24.0, 24.0) tintColor:color];
    UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cameraBtn setImage:image forState:UIControlStateNormal];
    [cameraBtn setImage:image forState:UIControlStateHighlighted];
    [cameraBtn setTitle:@"拍一个视频动态" forState:UIControlStateNormal];
    [cameraBtn setTitle:@"拍一个视频动态" forState:UIControlStateHighlighted];
    [cameraBtn setTitleColor:color forState:UIControlStateNormal];
    [cameraBtn setTitleColor:color forState:UIControlStateHighlighted];
    
    UIImage *highlightBg = [UIImage yy_imageWithColor:MH_MAIN_BACKGROUNDCOLOR];
    
    [cameraBtn setBackgroundImage:highlightBg forState:UIControlStateHighlighted];
    cameraBtn.titleLabel.font = MHMediumFont(17.0f);
    cameraBtn.layer.cornerRadius = 10.0f;
    cameraBtn.masksToBounds = YES;
    [cameraBtn SG_imagePositionStyle:SGImagePositionStyleDefault spacing:8.0f];
    [scrollView addSubview:cameraBtn];
    
    self.cameraBtn = cameraBtn;
    
    /// 默认隐藏
    cameraBtn.alpha = .0f;
    
    [[cameraBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        /// 直接回调
        self.state = MHRefreshStateRefreshing;
        [self.viewModel.cameraCommand execute:nil];
    }];

//    cameraBtn.rac_command = self.viewModel.cameraCommand;
    
    /// 这个提示按钮按钮
    UIImage *image1 = [UIImage mh_svgImageNamed:@"icons_filled_download2.svg" targetSize:CGSizeMake(24.0, 24.0) tintColor:color];
    UIButton *tipsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tipsBtn setImage:image1 forState:UIControlStateNormal];
    [tipsBtn setImage:image1 forState:UIControlStateHighlighted];
    [tipsBtn setTitle:@"下拉拍一个视频动态" forState:UIControlStateNormal];
    [tipsBtn setTitle:@"下拉拍一个视频动态" forState:UIControlStateHighlighted];
    [tipsBtn setTitleColor:color forState:UIControlStateNormal];
    [tipsBtn setTitleColor:color forState:UIControlStateHighlighted];

    tipsBtn.titleLabel.font = MHRegularFont_17;
//    [tipsBtn SG_imagePositionStyle:SGImagePositionStyleDefault spacing:8.0f];
    [scrollView addSubview:tipsBtn];
    
    self.tipsBtn = tipsBtn;
    
    /// 默认隐藏
    tipsBtn.alpha = 1.0f;
    
}

/// 布局子控件
- (void)_makeSubViewsConstraints{

    CGFloat cameraBtnW = 180.0f;
    CGFloat cameraBtnH = 44.0f;
    CGFloat cameraBtnY = MH_SCREEN_HEIGHT - cameraBtnH - 128.0f;
    CGFloat cameraBtnX = (MH_SCREEN_WIDTH - cameraBtnW) *.5f;
    self.cameraBtn.frame = CGRectMake(cameraBtnX, cameraBtnY, cameraBtnW, cameraBtnH);
    
    
    CGFloat tipsBtnW = 180.0f;
    CGFloat tipsBtnH = 44.0f;
    CGFloat tipsBtnY = MH_SCREEN_HEIGHT - 260.0f;
    CGFloat tipsBtnX = (MH_SCREEN_WIDTH - tipsBtnW) *.5f;
    self.tipsBtn.frame = CGRectMake(tipsBtnX, tipsBtnY, tipsBtnW, tipsBtnH);
}


@end
