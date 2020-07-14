//
//  MHMainFrameViewController.m
//  WeChat
//
//  Created by senba on 2017/9/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHMainFrameViewController.h"
#import "MHMainFrameTableViewCell.h"
#import "MHTestViewController.h"
#import "MHCameraViewController.h"
#import "MHSingleChatViewModel.h"
#import "MHSearchViewController.h"
#import "MHPulldownAppletWrapperViewController.h"

#import "WPFPinYinTools.h"
#import "WPFPinYinDataManager.h"

#import "MHContactsTableViewCell.h"
#import "MHContactsHeaderView.h"
#import "UITableView+SCIndexView.h"
#import "MHNavSearchBar.h"
#import "MHMainFrameMoreView.h"
#import "MHBouncyBallsView.h"






/// 侧滑最大偏移量
static CGFloat const MHSlideOffsetMaxWidth = 56;

@interface MHMainFrameViewController ()
/// viewModel
@property (nonatomic, readonly, strong) MHMainFrameViewModel *viewModel;


/// searchBar
@property (nonatomic, readwrite, weak) MHNavSearchBar *searchBar;

/// navBar
@property (nonatomic, readwrite, weak) MHNavigationBar *navBar;

/// searchController
@property (nonatomic, readwrite, strong) MHSearchViewController *searchController;



/// 获取截图
@property (nonatomic, readwrite, weak) UIView *snapshotView;

/// 开始拖拽的偏移量
@property (nonatomic, readwrite, assign) CGFloat startDragOffsetY;
/// 结束拖拽的偏移量
@property (nonatomic, readwrite, assign) CGFloat endDragOffsetY;
/// moreView
@property (nonatomic, readwrite, weak) MHMainFrameMoreView *moreView;


/// ---------------------- 下拉小程序相关 ----------------------
/// lastOffsetY
@property (nonatomic, readwrite, assign) CGFloat lastOffsetY;
/// 下拉状态
@property (nonatomic, readwrite, assign) MHRefreshState state;
/// 下拉三个球
@property (nonatomic, readwrite, weak) MHBouncyBallsView *ballsView;
/// appletWrapperController
@property (nonatomic, readwrite, strong) MHPulldownAppletWrapperViewController *appletWrapperController;
@end

@implementation MHMainFrameViewController

@dynamic viewModel;

/// 子类代码逻辑
- (void)viewDidLoad {
    /// ①：子类调用父类的viewDidLoad方法，而父类主要是创建tableView以及强行布局子控件，从而导致tableView刷新，这样就会去走tableView的数据源方法
    [super viewDidLoad];
    /// 设置
    [self _setup];
    
    /// 设置导航栏
    [self _setupNavigationItem];
    
    /// 设置子控件
    [self _setupSubViews];
    
    /// 布局子控件
    [self _makeSubViewsConstraints];
    
    /// ③：注册cell
    [self.tableView mh_registerNibCell:MHMainFrameTableViewCell.class];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 这里也根据条件设置隐藏
    self.tabBarController.tabBar.hidden = (self.viewModel.searchState == MHNavSearchBarStateSearch );
    
    self.tabBarController.tabBar.alpha = (self.state == MHRefreshStateRefreshing ? .0f : 1.0f) ;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 这里也根据条件设置隐藏
    self.tabBarController.tabBar.hidden = (self.viewModel.searchState == MHNavSearchBarStateSearch  || self.state == MHRefreshStateRefreshing);
    
    self.tabBarController.tabBar.alpha = (self.state == MHRefreshStateRefreshing ? .0f : 1.0f) ;
    
    // 离开此页面 隐藏
    self.moreView.hidden = YES;
}

#pragma mark - Override

- (void)bindViewModel {
    [super bindViewModel];
    @weakify(self);
    // 设置title
    RAC(self.navBar.titleLabel, text) = RACObserve(self.viewModel, title);
    
    [[[RACObserve(self.viewModel, searchState) skip:1] deliverOnMainThread] subscribeNext:^(NSNumber *state) {
        @strongify(self);
        
        MHNavSearchBarState searchState = state.integerValue;
        
        self.view.userInteractionEnabled = NO;
        
        CGFloat navBarY = 0.0;
        CGFloat searchViewY = 200.0;
        if (searchState == MHNavSearchBarStateSearch) {
            
            navBarY = -MH_APPLICATION_TOP_BAR_HEIGHT;
            
            // 编辑模式场景下 从 tableViwe 身上移掉
            [self.searchBar removeFromSuperview];
            
            // 清除掉tableHeaderView 会导致其 16px = 24 + 56 - 64 像素被遮住
            self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MH_SCREEN_WIDTH, 16)];
            // 将其添加到self.view
            [self.view addSubview:self.searchBar];
            self.searchBar.mh_y = MH_APPLICATION_TOP_BAR_HEIGHT;
            
            [self.view bringSubviewToFront:self.searchController.view];
            searchViewY = MH_APPLICATION_STATUS_BAR_HEIGHT + 4.0 + 56.0;
        } else {
            if (self.snapshotView) {
                [self.snapshotView removeFromSuperview];
                self.snapshotView = nil;
            }
            self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MH_SCREEN_WIDTH, 56)];
            [self.view sendSubviewToBack:self.searchController.view];
        }
        
        [self.navBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).with.offset(navBarY);
        }];
        
        [self.searchController.view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).with.offset(searchViewY);
        }];
        
        /// 隐藏导航栏
        /// Fixed Bug: 这种方式可以暂时隐藏  但是如果子控制器进行push操作 那么返回来这个tabBar又会显示出来
        self.tabBarController.tabBar.hidden = (searchState == MHNavSearchBarStateSearch);
        /// 解决方案：在 viewWillDisappear 和 viewWillAppear 在设置一次显示隐藏逻辑即可
        // 更新布局
        [UIView animateWithDuration:0.25 animations:^{
            [self.view layoutIfNeeded];
            self.searchController.view.alpha = (searchState == MHNavSearchBarStateSearch) ? 1.0 : .0;
            
            // 动画
            self.searchBar.mh_y = (searchState == MHNavSearchBarStateSearch) ? ([UIApplication sharedApplication].statusBarFrame.size.height + 4) : MH_APPLICATION_TOP_BAR_HEIGHT;
            
        } completion:^(BOOL finished) {
            
            if((searchState == MHNavSearchBarStateDefault)) {
                // 退出编辑场景下 从 self.view 身上移掉
                [self.searchBar removeFromSuperview];
                // 添加到tableHeaderView
                self.tableView.tableHeaderView = self.searchBar;
            }else {
                /// 获取缩略图
                // 立即获得当前self.tableView 的屏幕快照
                UIView *snapshotView = [self.tableView snapshotViewAfterScreenUpdates:NO];
                snapshotView.frame = self.view.bounds;
                self.snapshotView = snapshotView;
                [self.view insertSubview:snapshotView belowSubview:self.searchBar];
                snapshotView.mh_x = -MHSlideOffsetMaxWidth;
            }
            
            self.view.userInteractionEnabled = true;
        }];
    }];
    
    
    /// 监听popMoreCommand 回调
    [self.viewModel.popCommand.executionSignals.switchToLatest subscribeNext:^(NSDictionary *dict) {
        @strongify(self);
        
        if ([dict isKindOfClass:NSNumber.class]) {
            return;
        }
        
        MHSearchPopState state = [dict[@"state"] integerValue];
        CGFloat progress = [dict[@"progress"] floatValue];
        
        if (state == MHSearchPopStateBegan || state == MHSearchPopStateChanged) {
            self.snapshotView.mh_x = -MHSlideOffsetMaxWidth + progress * MHSlideOffsetMaxWidth;
        }else if (state == MHSearchPopStateEnded) {
            // 归位
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.snapshotView.mh_x = -MHSlideOffsetMaxWidth + 1 * progress * MHSlideOffsetMaxWidth;
            } completion:^(BOOL finished) {
            }];
        }
    }];
    
    //// 小程序回滚
    /// Fixed bug: distinctUntilChanged 不需要，否则某些场景认为没变化 实际上变化了
    RACSignal *signal = [RACObserve(self.viewModel, offsetInfo) skip:1];
    [signal subscribeNext:^(NSDictionary *dictionary) {
        @strongify(self);
        [self _handleAppletOffset:dictionary];
    }];
}

/// 配置tableView的区域
- (UIEdgeInsets)contentInset{
    return UIEdgeInsetsMake(MH_APPLICATION_TOP_BAR_HEIGHT, 0, MH_APPLICATION_TAB_BAR_HEIGHT, 0);
}

/// 返回自定义的cell
- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    // ②：父类的tableView的数据源方法的获取cell是通过注册cell的identifier来获取cell，然而此时子类并未注册cell，所以取出来的cell = nil而引发Crash
    return [tableView dequeueReusableCellWithIdentifier:@"MHMainFrameTableViewCell"];
    // 非注册cell 使用时：去掉ViewDidLoad里面注册Cell的代码
    //    return [MHMainFrameTableViewCell cellWithTableView:tableView];
}


/// 绑定数据
- (void)configureCell:(MHMainFrameTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object{
    [cell bindViewModel:object];
}

#pragma mark - 事件处理Or辅助方法
- (void)_addMore{
    
    if (self.moreView.hidden) {
        self.moreView.hidden = NO;
        [self.moreView show];
    }else {
        @weakify(self);
        [self.moreView hideWithCompletion:^{
            @strongify(self);
            self.moreView.hidden = YES;
        }];
    }
}

/// 处理小程序回调的数据
- (void)_handleAppletOffset:(NSDictionary *)dictionary {
    
    if (MHObjectIsNil(dictionary)) {
        return;
    }
    
    /// ⚠️ offset 为负数
    CGFloat offset = [dictionary[@"offset"] doubleValue];
    MHRefreshState state = [dictionary[@"state"] doubleValue];
    if (state == MHRefreshStateRefreshing) {
        /// 回到空闲状态
        self.state = MHRefreshStateIdle;
    }else {
        /// 拖拽状态
        CGFloat delta = MH_SCREEN_HEIGHT - MH_APPLICATION_TOP_BAR_HEIGHT + offset;
        delta = MAX(0, delta);
 
        /// 更新 navBar Y
        [self.navBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).with.offset(delta);
        }];
        
        /// 传递offset
        self.viewModel.ballsViewModel.offsetInfo = @{@"offset": @(delta), @"state": @(state), @"animate": @NO};
        
        /// 更新 ballsView 的 h
        [self.ballsView mas_updateConstraints:^(MASConstraintMaker *make) {
            CGFloat height = delta;
            make.height.mas_equalTo(MAX(6.0f, height));
        }];
        
        /// 更新tableView Y
        self.tableView.mh_y = delta;
        
        /// 修改导航栏颜色
        [self _changeNavBarBackgroundColor:offset];
    }
}

/// 处理搜索框显示偏移
- (void)_handleSearchBarOffset:(UIScrollView *)scrollView {
    // 获取当前偏移量
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat searchBarH = 56.0f;
    /// 在这个范围内
    if (offsetY > -scrollView.contentInset.top && offsetY < (-scrollView.contentInset.top + searchBarH)) {
        // 判断上下拉
        if (self.endDragOffsetY > self.startDragOffsetY) {
            // 上拉 隐藏
            CGPoint offset = CGPointMake(0, -scrollView.contentInset.top + searchBarH);
            [self.tableView setContentOffset:offset animated:YES];
        } else {
            // 下拉 显示
            CGPoint offset = CGPointMake(0, -scrollView.contentInset.top);
            [self.tableView setContentOffset:offset animated:YES];
        }
    }
}


/// 处理拖拽时导航栏背景色变化
/// 只处理上拉的逻辑 下拉忽略
/// offset: 偏移量。
- (void)_changeNavBarBackgroundColor:(CGFloat)offset{
    
    static NSDictionary *dict0;
    static NSDictionary *dict1;
    
    /// 导航栏颜色：#ededed --> #fffff
    if (!(dict0 && dict0.allKeys.count != 0)) {
        UIColor *color0 = MHColorFromHexString(@"#ededed");
        dict0 = @{@"red":@(color0.red), @"green": @(color0.green), @"blue":@(color0.blue)};
        
        UIColor *color1 = [UIColor whiteColor];
        dict1 = @{@"red":@(color1.red), @"green": @(color1.green), @"blue":@(color1.blue)};
    }
    
    CGFloat delta = fabs(offset);
    
    if (delta > MH_SCREEN_HEIGHT) {
        delta = MH_SCREEN_HEIGHT;
    }
    
    /// 进度 0 --> 1.0f
    /// 下拉 不修改导航栏颜色
    CGFloat progress = .0f;
    if (delta < MHPulldownAppletCriticalPoint2) {
        /// 上拉 0 ---> 100
        progress = 1 - delta/MHPulldownAppletCriticalPoint2;
    }
    
    
    /// 计算差值
    CGFloat red = ([dict0[@"red"] doubleValue] + progress * ([dict1[@"red"] doubleValue] - [dict0[@"red"] doubleValue])) * 255;
    CGFloat green = ([dict0[@"green"] doubleValue] + progress * ([dict1[@"green"] doubleValue] - [dict0[@"green"] doubleValue])) * 255;
    CGFloat blue = ([dict0[@"blue"] doubleValue] + progress * ([dict1[@"blue"] doubleValue] - [dict0[@"blue"] doubleValue])) * 255;
    
    self.navBar.backgroundView.backgroundColor = MHColor(red, green, blue);
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.viewModel.dataSource[indexPath.row] cellHeight];
}
#pragma mark - UIScrollViewDelegate
/// 细节处理：
/// 由于要弹出 搜索模块，所以要保证滚动到最顶部时，要确保搜索框完全显示或者完全隐藏，
/// 不然会导致弹出搜索模块,然后收回搜索模块，会导致动画不流畅，影响体验，微信做法也是如此
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    /// 注意：这个方法不一定调用 当你缓慢拖动的时候是不会调用的
//    [self _handleSearchBarOffset:scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // 记录刚开始拖拽的值
    self.startDragOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    // 记录刚开始拖拽的值
    self.endDragOffsetY = scrollView.contentOffset.y;
    // decelerate: YES 说明还有速度或者说惯性，会继续滚动 停止时调用scrollViewDidEndDecelerating
    // decelerate: NO  说明是很慢的拖拽，没有惯性，不会调用 scrollViewDidEndDecelerating
    if (!decelerate) {
//        [self _handleSearchBarOffset:scrollView];
    }
}
/// tableView 以滚动就会调用
/// 这里的逻辑 完全可以参照 MJRefreshHeader
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 在刷新的refreshing状态 do nothing...
    if (self.state == MHRefreshStateRefreshing) {
        NSLog(@"🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥");
        return;
    }
    
    
    // 当前的contentOffset
    CGFloat offsetY = scrollView.mh_offsetY;
    // 头部控件刚好出现的offsetY
    CGFloat happenOffsetY = -self.contentInset.top;
    
    // 如果是向上滚动到看不见头部控件，直接返回
    // >= -> >
    if (offsetY > happenOffsetY) return;
    
    // 普通 和 即将刷新 的临界点
    CGFloat normal2pullingOffsetY = - MHPulldownAppletCriticalPoint1 ;
    
    /// 计算偏移量 正数
    CGFloat delta = -(offsetY - happenOffsetY);
    
    // 如果正在拖拽
    if (scrollView.isDragging) {
        
        /// 更新 navBar 的 y
        [self.navBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).with.offset(delta);
        }];
        
        /// 更新 ballsView 的 h
        [self.ballsView mas_updateConstraints:^(MASConstraintMaker *make) {
            CGFloat height = delta;
            make.height.mas_equalTo(MAX(6.0f, height));
        }];
        
        /// 传递offset
        self.viewModel.ballsViewModel.offsetInfo = @{@"offset": @(delta), @"state": @(self.state), @"animate": @NO};;
        
        /// 微信方案：不仅要下拉超过临界点 而且 保证是下拉状态：当前偏移量 > 上一次偏移量
        if (self.state == MHRefreshStateIdle && -delta < normal2pullingOffsetY && offsetY < self.lastOffsetY) {
            // 转为即将刷新状态
            self.state = MHRefreshStatePulling;
        } else if (self.state == MHRefreshStatePulling && (-delta >= normal2pullingOffsetY || offsetY >= self.lastOffsetY)) {
            // 转为普通状态
            self.state = MHRefreshStateIdle;
        }
        
        /// 传递状态
        self.viewModel.appletWrapperViewModel.offsetInfo = @{@"offset": @(delta), @"state": @(self.state)};
        
        /// 记录偏移量
        self.lastOffsetY = offsetY;
        
    } else if (self.state == MHRefreshStatePulling) {
        
        self.lastOffsetY = .0f;
        
        self.state = MHRefreshStateRefreshing;
    } else {
        /// 更新 navBar y
        [self.navBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).with.offset(delta);
        }];
        
        /// 更新 ballsView 的 h
        [self.ballsView mas_updateConstraints:^(MASConstraintMaker *make) {
            CGFloat height = delta;
            make.height.mas_equalTo(MAX(6.0f, height));
        }];
        
        /// 传递offset
        self.viewModel.ballsViewModel.offsetInfo = @{@"offset": @(delta), @"state": @(self.state), @"animate": @NO};
        
        /// 传递状态
        self.viewModel.appletWrapperViewModel.offsetInfo = @{@"offset": @(delta), @"state": @(self.state)};
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
        
        /// 更新位置
        [self.navBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).with.offset(0);
        }];
        
        /// 更新 ballsView 的 h
        [self.ballsView mas_updateConstraints:^(MASConstraintMaker *make) {
            CGFloat height = 0;
            make.height.mas_equalTo(MAX(6.0f, height));
        }];
        
        /// 传递offset
        self.viewModel.ballsViewModel.offsetInfo = @{@"offset": @(0), @"state": @(state), @"animate": @YES};
        
        // 先置位到最底下 后回到原始位置； 因为小程序 下钻到下一模块 tabBar会回到之前的位置
        self.tabBarController.tabBar.mh_y = MH_SCREEN_HEIGHT;
        self.tabBarController.tabBar.alpha = .0f;
        
        [UIView animateWithDuration:.4f animations:^{
            /// 导航栏相关 回到原来位置
//            self.tabBarController.tabBar.hidden = NO;
            self.tabBarController.tabBar.alpha = 1.0f;
            self.tabBarController.tabBar.mh_y = MH_SCREEN_HEIGHT - self.tabBarController.tabBar.mh_height;
            
            
            self.tableView.mh_y = 0;
            
            
            [self.view layoutIfNeeded];
            self.navBar.backgroundView.backgroundColor = MH_MAIN_BACKGROUNDCOLOR;
        } completion:^(BOOL finished) {
            
            /// 完成后 传递数据给
            self.tableView.showsVerticalScrollIndicator = YES;
        }];
    } else if (state == MHRefreshStateRefreshing) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            /// 隐藏滚动条
            self.tableView.showsVerticalScrollIndicator = NO;
            
            /// 传递offset 正向下拉
            self.viewModel.ballsViewModel.offsetInfo = @{@"offset": @(MH_SCREEN_HEIGHT - MH_APPLICATION_TOP_BAR_HEIGHT), @"state": @(self.state), @"animate": @NO};
            
            /// 传递状态
//            self.viewModel.appletWrapperViewModel.offsetInfo = @{@"offset": @(MH_SCREEN_HEIGHT - MH_APPLICATION_TOP_BAR_HEIGHT), @"state": @(self.state)};
            
            /// 更新位置
            [self.navBar mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view).with.offset(700 - MH_APPLICATION_TOP_BAR_HEIGHT);
            }];
            
            /// 动画过程中 禁止用户交互
            self.view.userInteractionEnabled = NO;
            
            /// 动画
            [UIView animateWithDuration:2.4 animations:^{
                [self.view layoutIfNeeded];
                
                CGFloat top = 700;
                // 增加滚动区域top
                self.tableView.mh_insetT = top;
                // 设置滚动位置
                [self.tableView setContentOffset:CGPointMake(0, -top)];
                
                self.navBar.backgroundView.backgroundColor = [UIColor whiteColor];
                
                /// 这种方式没啥动画
//                self.tabBarController.tabBar.hidden = YES;
                /// 这种方式有动画
                self.tabBarController.tabBar.alpha = .0f;
                self.tabBarController.tabBar.mh_y = MH_SCREEN_HEIGHT;
                
            } completion:^(BOOL finished) {
                NSLog(@"😿😿😿😿😿😿😿😿😿😿v");
                self.tableView.mh_y = MH_SCREEN_HEIGHT - 64;
                CGFloat top = 64;
                // 增加滚动区域top
                self.tableView.mh_insetT = top;
                // 设置滚动位置
                [self.tableView setContentOffset:CGPointMake(0, -top) animated:NO];
                
                /// 动画结束 允许用户交互
                self.view.userInteractionEnabled = YES;
            }];
        });
    }
}


#pragma mark - 初始化
- (void)_setup{
    /// set up ...
    self.state = MHRefreshStateIdle;
}
#pragma mark - 设置导航栏
- (void)_setupNavigationItem{
}

#pragma mark - 设置子控件
- (void)_setupSubViews{
    
    // 自定义导航栏
    MHNavigationBar *navBar = [MHNavigationBar navigationBar];
    UIImage *image = [UIImage mh_svgImageNamed:@"icons_outlined_add2.svg" targetSize:CGSizeMake(24.0, 24.0) tintColor:MHColorFromHexString(@"#181818")];
    UIImage *imageHigh = [UIImage mh_svgImageNamed:@"icons_outlined_add2.svg" targetSize:CGSizeMake(24.0, 24.0) tintColor:[MHColorFromHexString(@"#181818") colorWithAlphaComponent:0.5]];
    [navBar.rightButton setImage:image forState:UIControlStateNormal];
    [navBar.rightButton setImage:imageHigh forState:UIControlStateHighlighted];
    self.navBar = navBar;
    [self.view addSubview:navBar];
    [navBar.rightButton addTarget:self action:@selector(_addMore) forControlEvents:UIControlEventTouchUpInside];
    
    // 创建searchBar
    MHNavSearchBar *searchBar = [[MHNavSearchBar alloc] init];
    [searchBar bindViewModel:self.viewModel.searchBarViewModel];
    self.tableView.tableHeaderView = searchBar;
    self.tableView.tableHeaderView.mh_height = self.viewModel.searchBarViewModel.height;
    self.searchBar = searchBar;
    
    /// 添加搜索View
    MHSearchViewController *searchController = [[MHSearchViewController alloc] initWithViewModel:self.viewModel.searchViewModel];
    searchController.view.alpha = 0.0;
    [self.view addSubview:searchController.view];
    [self addChildViewController:searchController];
    [searchController didMoveToParentViewController:self];
    self.searchController = searchController;
    
    /// moreView
    MHMainFrameMoreView *moreView = [[MHMainFrameMoreView alloc] init];
    self.moreView = moreView;
    moreView.hidden = YES;
    [self.view addSubview:moreView];
    /// 事件回调
    @weakify(moreView);
    moreView.maskAction = ^{
        @strongify(moreView);
        @weakify(moreView);
        [moreView hideWithCompletion:^{
            @strongify(moreView);
            moreView.hidden = YES;
        }];
    };
    moreView.menuItemAction = ^(MHMainFrameMoreViewType type) {
        @strongify(moreView);
        @weakify(moreView);
        [moreView hideWithCompletion:^{
            @strongify(moreView);
            moreView.hidden = YES;
        }];
        
        /// 下钻...
    };
    
    /// 下拉小程序模块
    MHPulldownAppletWrapperViewController *appletWrapperController = [[MHPulldownAppletWrapperViewController alloc] initWithViewModel:self.viewModel.appletWrapperViewModel];
    self.appletWrapperController = appletWrapperController;
    [self.view addSubview:appletWrapperController.view];
    [self addChildViewController:appletWrapperController];
    [appletWrapperController didMoveToParentViewController:self];
    
    
    /// 下拉三个球模块
    MHBouncyBallsView *ballsView = [[MHBouncyBallsView alloc] init];
    self.ballsView = ballsView;
    [ballsView bindViewModel:self.viewModel.ballsViewModel];
    ballsView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:ballsView];
}

#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints{
    
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.equalTo(self.view);
        make.height.mas_equalTo(MH_APPLICATION_TOP_BAR_HEIGHT);
    }];
    
    [self.searchController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(200);
    }];
    
    [self.moreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view).with.offset(0);
        make.top.equalTo(self.view).with.offset(MH_APPLICATION_TOP_BAR_HEIGHT);
        make.bottom.equalTo(self.view).with.offset(-MH_APPLICATION_TAB_BAR_HEIGHT);
    }];
    
    /// 由于是自定义导航栏 分割线 这里重新布局一下
    [self.navBarDivider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom).with.offset(0);
        make.left.and.right.equalTo(self.view).with.offset(0);
        make.height.mas_equalTo(.8f);
    }];
    
    /// 布局三个球
    [self.ballsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.equalTo(self.view).with.offset(0);
        make.height.mas_equalTo(6.0f);
    }];
    
    /// 布局小程序容器
    [self.appletWrapperController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}



@end
