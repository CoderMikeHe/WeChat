//
//  MHContactsViewController.m
//  WeChat
//
//  Created by senba on 2017/9/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHContactsViewController.h"
#import "MHAddFriendsViewController.h"
#import "MHSearchViewController.h"


#import "WPFPinYinTools.h"
#import "WPFPinYinDataManager.h"

#import "MHContactsTableViewCell.h"
#import "MHContactsHeaderView.h"
#import "UITableView+SCIndexView.h"
#import "MHNavSearchBar.h"

/// 侧滑最大偏移量
static CGFloat const MHSlideOffsetMaxWidth = 56;


@interface MHContactsViewController ()
/// viewModel
@property (nonatomic, readonly, strong) MHContactsViewModel *viewModel;

/// footerView
@property (nonatomic, readwrite, weak) UILabel *footerView;

/// tempView
@property (nonatomic, readwrite, weak) UIView *tempView;

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
@end

@implementation MHContactsViewController

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
    // 这里也根据条件设置隐藏
    self.tabBarController.tabBar.hidden = (self.viewModel.searchState == MHNavSearchBarStateSearch);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 这里也根据条件设置隐藏
    self.tabBarController.tabBar.hidden = (self.viewModel.searchState == MHNavSearchBarStateSearch);
}


#pragma mark - 辅助方法
/// 刷新header color
- (void)_reloadHeaderViewColor {
    NSArray<NSIndexPath *> *indexPaths = self.tableView.indexPathsForVisibleRows;
    for (NSIndexPath *indexPath in indexPaths) {
        // 过滤
        if (indexPath.section == 0) {
            continue;
        }
        MHContactsHeaderView *headerView = (MHContactsHeaderView *)[self.tableView headerViewForSection:indexPath.section];
        [self configColorWithHeaderView:headerView section:indexPath.section];
    }
}

/// 配置 header color
- (void)configColorWithHeaderView:(MHContactsHeaderView *)headerView section:(NSInteger)section{
    if (!headerView) {
        return;
    }
    CGFloat insertTop = UIApplication.sharedApplication.statusBarFrame.size.height + 44;
    CGFloat diff = fabs(headerView.frame.origin.y - self.tableView.contentOffset.y - insertTop);
    CGFloat headerHeight = 33.0f;
    double progress;
    if (diff >= headerHeight) {
        progress = 1;
    }else {
        progress = diff / headerHeight;
    }
    [headerView configColorWithProgress:progress];
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
#pragma mark - Override
- (void)bindViewModel {
    [super bindViewModel];

    /// 监听数据
    @weakify(self);
    [[RACObserve(self.viewModel, letters) distinctUntilChanged] subscribeNext:^(NSArray * letters) {
        @strongify(self);
        if (letters.count > 1) {
            self.tempView.hidden = NO;
        }
        self.tableView.sc_indexViewDataSource = letters;
        self.tableView.sc_startSection = 1;
    }];
    
    
    RAC(self.footerView, text) = RACObserve(self.viewModel, total);
    
    
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
}

/// 配置tableView的区域
- (UIEdgeInsets)contentInset{
    return UIEdgeInsetsMake(MH_APPLICATION_TOP_BAR_HEIGHT, 0, MH_APPLICATION_TAB_BAR_HEIGHT, 0);
}

/// 返回自定义的cell
- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    return [MHContactsTableViewCell cellWithTableView:tableView];
}

/// 绑定数据
- (void)configureCell:(MHContactsTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object{
    [cell bindViewModel:object];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MHContactsHeaderView *headerView = [MHContactsHeaderView headerViewWithTableView:tableView];
    NSString *letter = self.viewModel.letters[section];
    [headerView bindViewModel:letter];
    return headerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGFLOAT_MIN;
    }else {
        return 33.0f;
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    /// 刷新headerColor
    [self _reloadHeaderViewColor];
}

/// 细节处理：
/// 由于要弹出 搜索模块，所以要保证滚动到最顶部时，要确保搜索框完全显示或者完全隐藏，
/// 不然会导致弹出搜索模块,然后收回搜索模块，会导致动画不流畅，影响体验，微信做法也是如此
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    /// 注意：这个方法不一定调用 当你缓慢拖动的时候是不会调用的
    [self _handleSearchBarOffset:scrollView];
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
        [self _handleSearchBarOffset:scrollView];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return NO;
    }
    return YES;
}
- (nullable UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath  API_AVAILABLE(ios(11.0)){
    
    UIContextualAction *remarkAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"备注" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        sourceView.backgroundColor = MHColorFromHexString(@"#4c4c4c");
        sourceView.superview.backgroundColor = MHColorFromHexString(@"#4c4c4c");
        // Fixed Bug: 延迟一丢丢去设置 不然无效 点击需要设置颜色 不然会被重置
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            sourceView.backgroundColor = MHColorFromHexString(@"#4c4c4c");
            sourceView.superview.backgroundColor = MHColorFromHexString(@"#4c4c4c");
        });
        
        completionHandler(YES);
    }];
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[remarkAction]];
    config.performsFirstActionWithFullSwipe = NO;
    
    return config;
}

/// 修改侧滑出来的按钮的背景色 👉 https://www.jianshu.com/p/aa6ff5d9f965
- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    /// 注意低版本的Xcode中 不一定是 `_UITableViewCellSwipeContainerView+UISwipeActionPullView+UISwipeActionStandardButton` 而是 `UISwipeActionPullView+UISwipeActionStandardButton`
    
    for (UIView *subView in tableView.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UISwipeActionPullView")]) {
            subView.backgroundColor = MHColorFromHexString(@"#4c4c4c");
            for (UIButton *button in subView.subviews) {
                if ([button isKindOfClass:NSClassFromString(@"UISwipeActionStandardButton")]) {
                    // 修改背景色
                    button.backgroundColor = MHColorFromHexString(@"#4c4c4c");
                }
            }
        } else if ([subView isKindOfClass:NSClassFromString(@"_UITableViewCellSwipeContainerView")]) {
            for (UIView *childView in subView.subviews) {
                if ([childView isKindOfClass:NSClassFromString(@"UISwipeActionPullView")]) {
                    childView.backgroundColor = MHColorFromHexString(@"#4c4c4c");
                    for (UIButton *button in childView.subviews) {
                        if ([button isKindOfClass:NSClassFromString(@"UISwipeActionStandardButton")]) {
                            // 修改背景色
                            button.backgroundColor = MHColorFromHexString(@"#4c4c4c");
                        }
                    }
                }
            }
        }
    }
}

#pragma mark - 初始化
- (void)_setup{
    
    self.tableView.rowHeight = 56.0f;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // 配置索引模块
    SCIndexViewConfiguration *configuration = [SCIndexViewConfiguration configuration];
    // 设置item 距离 右侧屏幕的间距
    configuration.indexItemRightMargin = 8.0;
    // 设置item 文字颜色
    configuration.indexItemTextColor = MHColorFromHexString(@"#555555");
    // 设置item 选中时的背景色
    configuration.indexItemSelectedBackgroundColor = MHColorFromHexString(@"#57be6a");
    /// 设置索引之间的间距
    configuration.indexItemsSpace = 4.0;
    
    self.tableView.sc_indexViewConfiguration = configuration;
    self.tableView.sc_translucentForTableViewInNavigationBar = true;
    
}

#pragma mark - 设置导航栏
- (void)_setupNavigationItem{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem mh_svgBarButtonItem:@"icons_outlined_add-friends.svg" targetSize:CGSizeMake(24.0, 24.0) tintColor:nil target:nil selector:nil];
    self.navigationItem.rightBarButtonItem.rac_command = self.viewModel.addFriendsCommand;
}

#pragma mark - 设置子控件
- (void)_setupSubViews{
    
    // 自定义导航栏
    MHNavigationBar *navBar = [MHNavigationBar navigationBar];
    navBar.titleLabel.text = @"通讯录";
    UIImage *image = [UIImage mh_svgImageNamed:@"icons_outlined_add-friends.svg" targetSize:CGSizeMake(24.0, 24.0) tintColor:MHColorFromHexString(@"#181818")];
    UIImage *imageHigh = [UIImage mh_svgImageNamed:@"icons_outlined_add-friends.svg" targetSize:CGSizeMake(24.0, 24.0) tintColor:[MHColorFromHexString(@"#181818") colorWithAlphaComponent:0.5]];
    [navBar.rightButton setImage:image forState:UIControlStateNormal];
    [navBar.rightButton setImage:imageHigh forState:UIControlStateHighlighted];
    self.navBar = navBar;
    [self.view addSubview:navBar];
    
    // 创建searchBar
    MHNavSearchBar *searchBar = [[MHNavSearchBar alloc] init];
    [searchBar bindViewModel:self.viewModel.searchBarViewModel];
    self.tableView.tableHeaderView = searchBar;
    self.tableView.tableHeaderView.mh_height = self.viewModel.searchBarViewModel.height;
    self.searchBar = searchBar;
    
    
    /// tableViewFooterView
    UILabel *footerView = [[UILabel alloc] init];
    footerView.mh_width = MH_SCREEN_WIDTH;
    footerView.mh_height = 50.0f;
    footerView.textAlignment = NSTextAlignmentCenter;
    footerView.font = MHRegularFont_16;
    footerView.textColor = MHColorFromHexString(@"#808080");
    footerView.numberOfLines = 1;
    footerView.backgroundColor = [UIColor whiteColor];
    self.footerView = footerView;
    self.tableView.tableFooterView = footerView;
    
    
    /// 添加一个tempView 放在最底下 用于上拉显示白底
    UIView *tempView = [[UIView alloc] init];
    self.tempView = tempView;
    // 默认隐藏
    tempView.hidden = YES;
    tempView.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:tempView belowSubview:self.tableView];
    
    
    /// 添加搜索View
    MHSearchViewController *searchController = [[MHSearchViewController alloc] initWithViewModel:self.viewModel.searchViewModel];
    searchController.view.alpha = 0.0;
    [self.view addSubview:searchController.view];
    [self addChildViewController:searchController];
    [searchController didMoveToParentViewController:self];
    self.searchController = searchController;
}

#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints{
    
    [self.tempView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.bottom.equalTo(self.view).with.offset(0);
        make.height.mas_equalTo(MH_SCREEN_HEIGHT * 0.5);
    }];
    
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.equalTo(self.view);
        make.height.mas_equalTo(MH_APPLICATION_TOP_BAR_HEIGHT);
    }];
    
    [self.searchController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(200);
    }];
}

@end
