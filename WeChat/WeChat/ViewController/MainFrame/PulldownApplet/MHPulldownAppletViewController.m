//
//  MHPulldownAppletItemViewController.m
//  WeChat
//
//  Created by admin on 2020/6/28.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHPulldownAppletViewController.h"
#import "MHPulldownAppletHeaderView.h"
#import "MHPulldownAppletCell.h"

@interface MHPulldownAppletViewController ()

/// viewModel
@property (nonatomic, readonly, strong) MHPulldownAppletViewModel *viewModel;
/// 搜索框容器
@property (nonatomic, readwrite, weak) UIControl *container;
/// searchBar
@property (nonatomic, readwrite, weak) UIButton *searchBar;
/// navBar
@property (nonatomic, readwrite, weak) MHNavigationBar *navBar;
/// 分割线
@property (nonatomic, readwrite, weak) UIView *divider;
/// 开始拖拽的偏移量
@property (nonatomic, readwrite, assign) CGFloat startDragOffsetY;
/// 结束拖拽的偏移量
@property (nonatomic, readwrite, assign) CGFloat endDragOffsetY;
@end

@implementation MHPulldownAppletViewController

@dynamic viewModel;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
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
    
    /// 设置内容滚动
    [self resetOffset];
}
#pragma mark - Override
- (void)bindViewModel {
    [super bindViewModel];
}

// CGFloat height = MH_APPLICATION_TOP_BAR_HEIGHT + (102.0f + 48.0f) * 2 + 74.0f + 50.0f;
- (UIEdgeInsets)contentInset {
    /// 50 对应上面的50  57 对应搜索框 17+40
    return UIEdgeInsetsMake(0, 0, 50.0f+57.0f, 0);
}

/// 返回自定义的cell
- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    return [MHPulldownAppletCell cellWithTableView:tableView];
}

/// 绑定数据
- (void)configureCell:(MHPulldownAppletCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object{
    [cell bindViewModel:object];
}

#pragma mark - Public Method
- (void)resetOffset {
    self.tableView.contentOffset = CGPointMake(0, 57.0f);
}


#pragma mark - 事件处理Or辅助方法
/// 处理搜索框显示偏移
- (void)_handleSearchBarOffset:(UIScrollView *)scrollView {
    // 获取当前偏移量
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat searchBarH = 57.0f;
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

/// 处理结束拖拽的事件 135.0f
- (void)_handleEndDraggingAction {
    if (self.endDragOffsetY >= 135.0f) {
        /// 回调数据 直接回到主页
        !self.viewModel.callback ? : self.viewModel.callback(@{@"completed":@YES,@"delay":@NO});
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.y;
    /// 不裁剪子视图
    self.tableView.clipsToBounds = offset > 0;
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
    
    /// 处理结束后的回调
    [self _handleEndDraggingAction];
}


#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self tableView:tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    // fetch object
    id object = self.viewModel.dataSource[indexPath.section];
    
    /// bind model
    [self configureCell:cell atIndexPath:indexPath withObject:(id)object];
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MHPulldownAppletHeaderView *headerView = [MHPulldownAppletHeaderView headerViewWithTableView:tableView];
    headerView.titleLabel.text = section == 0 ? @"最近使用" : @"我的小程序";
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 102.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 48.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}



#pragma mark - 初始化OrUI布局
/// 初始化
- (void)_setup{
    /// toumin
    self.view.backgroundColor = self.tableView.backgroundColor = [UIColor clearColor];

    /// 不要滚动条
    self.tableView.showsVerticalScrollIndicator = NO;
}

/// 设置导航栏
- (void)_setupNavigationItem{
    
}

/// 初始化子控件
- (void)_setupSubviews{
    
    @weakify(self);
    
    // 自定义导航栏
    MHNavigationBar *navBar = [MHNavigationBar navigationBar];
    navBar.titleLabel.text = @"小程序";
    navBar.titleLabel.textColor = [UIColor whiteColor];
    navBar.backgroundColor = navBar.backgroundView.backgroundColor = [UIColor clearColor];
    self.navBar = navBar;
    [self.view addSubview:navBar];
    
    /// 搜索框容器
    UIControl *container = [[UIControl alloc] init];
    self.container = container;
    container.mh_height = 74.0f;
    [[container rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        
    }];
    
    /// 搜索框
    NSString *imageName = @"icons_outlined_search_full.svg";
    UIColor *color = [[UIColor whiteColor] colorWithAlphaComponent:1.0f];
    UIImage *image = [UIImage mh_svgImageNamed:imageName targetSize:CGSizeMake(16.0, 16.0) tintColor:color];
    
    UIButton *searchBar = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBar setImage:image forState:UIControlStateNormal];
    [searchBar setImage:image forState:UIControlStateHighlighted];
    searchBar.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.1];
    [searchBar setTitleColor:color forState:UIControlStateNormal];
    [searchBar setTitle:@"搜索小程序" forState:UIControlStateNormal];
    searchBar.titleLabel.font = MHRegularFont_16;
    [container addSubview:searchBar];
    self.searchBar = searchBar;
    
    searchBar.cornerRadius = 4.0f;
    searchBar.masksToBounds = YES;
    searchBar.userInteractionEnabled = NO;
    
    [searchBar SG_imagePositionStyle:SGImagePositionStyleDefault spacing:8.0f];
    
    self.tableView.tableHeaderView = container;
    self.tableView.tableHeaderView.mh_height = container.mh_height;
    
    /// 设置分割线
    UIView *divider = [[UIView alloc] init];
    divider.backgroundColor = MHColorFromHexString(@"#1b1b2e");
    divider.alpha = .1f;
    [self.view addSubview:divider];
    self.divider = divider;
}

/// 布局子控件
- (void)_makeSubViewsConstraints{
    
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.equalTo(self.view);
        make.height.mas_equalTo(MH_APPLICATION_TOP_BAR_HEIGHT);
    }];
    
    [self.divider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.navBar.mas_bottom);
        make.height.mas_equalTo(MHGlobalBottomLineHeight);
    }];
    
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(17.0f, 36.5f, 17.0f, 36.5f));
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(MH_APPLICATION_TOP_BAR_HEIGHT, 0, 0, 0));
    }];
}
@end
