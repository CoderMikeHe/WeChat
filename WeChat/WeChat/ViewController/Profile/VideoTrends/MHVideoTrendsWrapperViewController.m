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

/// cameraBtn
@property (nonatomic, readwrite, weak) UIButton *cameraBtn;
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


/// Fixed Bug：scrollView.isDragging/isTracking 手指离开屏幕 可能还是会返回 YES 巨坑
/// 解决方案： 自己控制 dragging 状态， 方法如上
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    /// 获取偏移量
    CGFloat offsetY = scrollView.mh_offsetY;
    
    NSLog(@"🔥 %f", offsetY);
}


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
    scrollView.frame = CGRectMake(0, 0, MH_SCREEN_WIDTH, MH_SCREEN_HEIGHT);
    scrollView.backgroundColor = [UIColor yellowColor];
    scrollView.delegate = self;
    scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    scrollView.alwaysBounceVertical = YES;
    
    
    /// cameraBtn
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
    cameraBtn.titleLabel.font = MHMediumFont(16.0f);
    cameraBtn.layer.cornerRadius = 10.0f;
    cameraBtn.masksToBounds = YES;
    [cameraBtn SG_imagePositionStyle:SGImagePositionStyleDefault spacing:8.0f];
    [self.view addSubview:cameraBtn];
    self.cameraBtn = cameraBtn;
    
//    cameraBtn.rac_command = self.viewModel.cameraCommand;

    
}

/// 布局子控件
- (void)_makeSubViewsConstraints{
    [self.cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(-(MH_APPLICATION_TAB_BAR_HEIGHT + 89.0f));
        make.size.mas_equalTo(CGSizeMake(180.0f, 44.0f));
        make.centerX.equalTo(self.view);
    }];
}


@end
