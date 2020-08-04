//
//  MHProfileViewController.m
//  WeChat
//
//  Created by senba on 2017/9/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHProfileViewController.h"
#import "MHProfileHeaderCell.h"
#import "MHVideoTrendsWrapperViewController.h"
@interface MHProfileViewController ()
/// videoDynamicView
@property (nonatomic, readwrite, weak) UIView *videoDynamicView;

/// viewModel
@property (nonatomic, readonly, strong) MHProfileViewModel *viewModel;
/// cameraBtn
@property (nonatomic, readwrite, weak) UIButton *cameraBtn;


/// ---------------------- 下拉视频动态相关 ----------------------
/// lastOffsetY
@property (nonatomic, readwrite, assign) CGFloat lastOffsetY;
/// 下拉状态
@property (nonatomic, readwrite, assign) MHRefreshState state;

/// videoTrendsWrapperController
@property (nonatomic, readwrite, strong) MHVideoTrendsWrapperViewController *videoTrendsWrapperController;
/// 是否需要振动反馈
@property (nonatomic, readwrite, assign, getter=isFeedback) BOOL feedback;
@end

@implementation MHProfileViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// 设置
    [self _setup];
    
    /// 设置导航栏
    [self _setupNavigationItem];
    
    /// 设置子控件
    [self _setupSubViews];
    
    /// 布局子控件
    [self _makeSubViewsConstraints];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.tabBarController.tabBar.alpha = (self.state == MHRefreshStateRefreshing ? .0f : 1.0f) ;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    self.tabBarController.tabBar.alpha = (self.state == MHRefreshStateRefreshing ? .0f : 1.0f) ;
}

#pragma mark - Override
- (void)bindViewModel {
    [super bindViewModel];
    RAC(self.videoDynamicView, hidden) = [RACObserve(self.viewModel, dataSource) map:^id(NSArray * value) {
        return @(value.count == 0);
    }];
}


- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    /// 用户信息的cell
    if (indexPath.section == 0) return [MHProfileHeaderCell cellWithTableView:tableView];
    return [super tableView:tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object{
    /// 用户信息的cell
    if (indexPath.section == 0) {
        MHProfileHeaderCell *profileHeaderCell = (MHProfileHeaderCell *)cell;
        [profileHeaderCell bindViewModel:object];
        return;
    }
    [super configureCell:cell atIndexPath:indexPath withObject:object];
}

- (UIEdgeInsets)contentInset{
    // 200 - 76
    return UIEdgeInsetsMake(124.0f, 0, MH_APPLICATION_TAB_BAR_HEIGHT, 0);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    /// 需要增加振动反馈
    self.feedback = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    self.feedback = NO;
}
/// tableView 以滚动就会调用
/// 这里的逻辑 完全可以参照 MJRefreshHeader
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 在刷新的refreshing状态 do nothing...
    if (self.state == MHRefreshStateRefreshing) {
        return;
    }else if(self.state == MHRefreshStatePulling && !scrollView.isDragging) {
        /// fixed bug: 这里设置最后一次的偏移量 以免回弹
        [scrollView setContentOffset:CGPointMake(0, self.lastOffsetY)];
    }
    
    
    // 当前的contentOffset
    CGFloat offsetY = scrollView.mh_offsetY;
    // 头部控件刚好出现的offsetY
    CGFloat happenOffsetY = -self.contentInset.top;
    
    NSLog(@"👉  %f %f", offsetY, happenOffsetY);
    
    // 如果是向上滚动到看不见头部控件，直接返回
    // >= -> >
    if (offsetY > happenOffsetY) return;
    
    // 普通 和 即将刷新 的临界点
    CGFloat normal2pullingOffsetY = - MHPulldownAppletCriticalPoint1 ;
    
    /// 计算偏移量 正数
    CGFloat delta = -(offsetY - happenOffsetY);
    
    // 如果正在拖拽
    if (scrollView.isDragging) {
        
        /// 微信方案：不仅要下拉超过临界点 而且 保证是下拉状态：当前偏移量 > 上一次偏移量
        if (self.state == MHRefreshStateIdle && -delta < normal2pullingOffsetY && offsetY < self.lastOffsetY) {
            // 转为即将刷新状态
            self.state = MHRefreshStatePulling;
            
            /// iOS 10.0+ 下拉增加振动反馈 https://www.jianshu.com/p/ef7eadfae188
            if (self.isFeedback) {
                /// 只震动一次
                self.feedback = NO;
                /// 开启振动反馈 iOS 10.0+
                UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
                [feedBackGenertor impactOccurred];
            }
            
        } else if (self.state == MHRefreshStatePulling && (-delta >= normal2pullingOffsetY || offsetY >= self.lastOffsetY)) {
            // 转为普通状态
            self.state = MHRefreshStateIdle;
        }
        
        /// 传递状态
        self.viewModel.videoTrendsWrapperViewModel.offsetInfo = @{@"offset": @(delta), @"state": @(self.state)};
        
        /// 修改容器top
        [self.videoTrendsWrapperController.view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).with.offset(-(MH_SCREEN_HEIGHT + happenOffsetY - delta));
        }];
        
        /// 记录偏移量
        self.lastOffsetY = offsetY;
        
    } else if (self.state == MHRefreshStatePulling) {
        
        self.lastOffsetY = .0f;
        
        self.state = MHRefreshStateRefreshing;
    } else {

        /// 传递状态
        self.viewModel.videoTrendsWrapperViewModel.offsetInfo = @{@"offset": @(delta), @"state": @(self.state)};
        
        /// 修改容器top
        [self.videoTrendsWrapperController.view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).with.offset(-(MH_SCREEN_HEIGHT + happenOffsetY - delta));
        }];
        
        /// 记录偏移量
        self.lastOffsetY = offsetY;
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
        
        /// 动画过程中 禁止用户交互
        self.view.userInteractionEnabled = NO;
 
        // 先置位到最底下 后回到原始位置； 因为小程序 下钻到下一模块 tabBar会回到之前的位置
        self.tabBarController.tabBar.mh_y = MH_SCREEN_HEIGHT;
        self.tabBarController.tabBar.alpha = .0f;
        
        [UIView animateWithDuration:MHPulldownAppletRefreshingDuration animations:^{
            /// 导航栏相关 回到原来位置
            //            self.tabBarController.tabBar.hidden = NO;
            self.tabBarController.tabBar.alpha = 1.0f;
            self.tabBarController.tabBar.mh_y = MH_SCREEN_HEIGHT - self.tabBarController.tabBar.mh_height;
            
            /// 设置tableView y
            self.tableView.mh_y = 0;
            
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {

            /// 动画结束 允许用户交互
            self.view.userInteractionEnabled = YES;
        }];
    } else if (state == MHRefreshStateRefreshing) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
        
            /// 最终停留点的位置
            CGFloat top = MH_SCREEN_HEIGHT;
            
            /// 修改容器top
            [self.videoTrendsWrapperController.view mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view).with.offset(0);
            }];
  
            
            /// 动画过程中 禁止用户交互
            self.view.userInteractionEnabled = NO;
            
            /// 动画
            [UIView animateWithDuration:MHPulldownAppletRefreshingDuration animations:^{
                [self.view layoutIfNeeded];
                
                // 增加滚动区域top
                self.tableView.mh_insetT = top;
                
                // ⚠️ FBI Warning：
                // Xcode Version 11.4.1 设置animated: NO 也不好使 总之下面这两个方法都不好使
                // Xcode Version 10.2.1 设置animated: NO 却好使
                /// 妥协处理：这里统一用 animated: Yes 来处理 然后控制动画时间 与 scrollView 的 setContentOffset:animated: 相近即可
                // 设置滚动位置 animated:YES 然后
                [self.tableView setContentOffset:CGPointMake(0, -top) animated:YES];
                /// 按照这个方式 会没有动画 tableView 会直接掉下去
                /// [self.tableView setContentOffset:CGPointMake(0, -top)];
                
                /// - [iphone – UIScrollview setContentOffset与非线性动画？](http://www.voidcn.com/article/p-glnejqrs-bsv.html)
                /// - [iphone – 更改setContentOffset的速度：animated：？](http://www.voidcn.com/article/p-bgupiewh-bsr.html)
 
                /// 这种方式没啥动画
                /// self.tabBarController.tabBar.hidden = YES;
                /// 这种方式有动画
                self.tabBarController.tabBar.alpha = .0f;
                self.tabBarController.tabBar.mh_y = MH_SCREEN_HEIGHT;
                
                
                
            } completion:^(BOOL finished) {
                
                /// 小tips: 这里动画完成后 将tableView 的 y 设置到 MH_SCREEN_HEIGHT - finalTop ; 以及 将contentInset 和 contentOffset 回到原来的位置
                /// 目的：后期上拉的时候 只需要改变tableView 的 y就行了
                CGFloat finalTop = self.contentInset.top;
                self.tableView.mh_y = MH_SCREEN_HEIGHT;
                // 增加滚动区域top
                self.tableView.mh_insetT = finalTop;
                // 设置滚动位置
                [self.tableView setContentOffset:CGPointMake(0, -finalTop) animated:NO];
                /// 动画结束 允许用户交互
                self.view.userInteractionEnabled = YES;
                
            }];
        });
    }
}



#pragma mark - 初始化
- (void)_setup{
    self.tableView.backgroundColor = [UIColor clearColor];
    self.state = MHRefreshStateIdle;
    /// 隐藏滚动条
    self.tableView.showsVerticalScrollIndicator = NO;
}

#pragma mark - 设置导航栏
- (void)_setupNavigationItem{
}

#pragma mark - 设置子控件
- (void)_setupSubViews{
    /// 下拉视频模块
    MHVideoTrendsWrapperViewController *videoTrendsWrapperController = [[MHVideoTrendsWrapperViewController alloc] initWithViewModel:self.viewModel.videoTrendsWrapperViewModel];
    self.videoTrendsWrapperController = videoTrendsWrapperController;
    [self.view insertSubview:videoTrendsWrapperController.view belowSubview:self.tableView];
    [self addChildViewController:videoTrendsWrapperController];
    [videoTrendsWrapperController didMoveToParentViewController:self];
    
    /// cameraBtn
    UIImage *image = [UIImage mh_svgImageNamed:@"icons_filled_camera.svg" targetSize:CGSizeMake(24.0, 24.0) tintColor:MHColorFromHexString(@"#1A1A1A")];
    UIImage *imageHigh = [UIImage mh_svgImageNamed:@"icons_filled_camera.svg" targetSize:CGSizeMake(24.0, 24.0) tintColor:[MHColorFromHexString(@"#1A1A1A") colorWithAlphaComponent:0.5]];
    UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cameraBtn setImage:image forState:UIControlStateNormal];
    [cameraBtn setImage:imageHigh forState:UIControlStateHighlighted];
    [self.view addSubview:cameraBtn];
    self.cameraBtn = cameraBtn;
    cameraBtn.rac_command = self.viewModel.cameraCommand;
}

#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints{
    
    [self.videoTrendsWrapperController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.height.mas_equalTo(MH_SCREEN_HEIGHT);
        make.top.equalTo(self.view).with.offset(-(MH_SCREEN_HEIGHT - self.contentInset.top));
    }];
    
    [self.cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).with.offset(-22.0);
        make.top.equalTo(self.view).with.offset(34.0);
        make.size.mas_equalTo(CGSizeMake(24.0f, 24.0f));
    }];
}

@end
