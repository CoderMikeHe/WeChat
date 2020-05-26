//
//  MHTableViewController.m
//  WeChat
//
//  Created by senba on 2017/9/10.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHTableViewController.h"
#import "UIScrollView+MHRefresh.h"

@interface MHTableViewController ()
/// tableView
@property (nonatomic, readwrite, weak)   MHTableView *tableView;
/// contentInset defaul is (64 , 0 , 0 , 0)
@property (nonatomic, readwrite, assign) UIEdgeInsets contentInset;
/// 视图模型
@property (nonatomic, readonly, strong) MHTableViewModel *viewModel;
@end

@implementation MHTableViewController

@dynamic viewModel;

- (void)dealloc
{
    // set nil
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
}

/// init
- (instancetype)initWithViewModel:(MHTableViewModel *)viewModel {
    self = [super initWithViewModel:viewModel];
    if (self) {
        if ([viewModel shouldRequestRemoteDataOnViewDidLoad]) {
            @weakify(self)
            [[self rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
                @strongify(self)
                /// 请求第一页的网络数据
                [self.viewModel.requestRemoteDataCommand execute:@1];
            }];
        }
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // 设置子控件
    [self _su_setupSubViews];
    
}

/// override
- (void)bindViewModel
{
    [super bindViewModel];
    
    /// observe viewModel's dataSource
    @weakify(self)
    [[RACObserve(self.viewModel, dataSource)
      deliverOnMainThread]
     subscribeNext:^(id x) {
         @strongify(self)
         // 刷新数据
         [self reloadData];
     }];
    
    /// 隐藏emptyView
    [self.viewModel.requestRemoteDataCommand.executing subscribeNext:^(NSNumber *executing) {
        @strongify(self)
        UIView *emptyDataSetView = [self.tableView.subviews.rac_sequence objectPassingTest:^(UIView *view) {
            return [NSStringFromClass(view.class) isEqualToString:@"DZNEmptyDataSetView"];
        }];
        emptyDataSetView.alpha = 1.0 - executing.floatValue;
    }];
    
    /// 新增一个需求 有些场景下 进来 不需要下拉刷新和上拉加载  但是切换一种模式 又想要下拉刷新和上拉加载了 安排
    [[[[RACObserve(self.viewModel, shouldPullDownToRefresh) distinctUntilChanged] skip:1]
     deliverOnMainThread]
    subscribeNext:^(NSNumber *x) {
        NSLog(@"🔥 动态加载下拉刷新组件 👉 %@", x);
        @strongify(self)
        /// 添加加载和刷新控件
        if (x.boolValue) {
            /// 下拉刷新
            @weakify(self);
            [self.tableView mh_addHeaderRefresh:^(MJRefreshNormalHeader *header) {
                /// 加载下拉刷新的数据
                @strongify(self);
                [self tableViewDidTriggerHeaderRefresh];
            }];
        }else {
            self.tableView.mj_header = nil;
        }
    }];
    
    [[[[RACObserve(self.viewModel, shouldPullUpToLoadMore) distinctUntilChanged] skip:1]
     deliverOnMainThread]
    subscribeNext:^(NSNumber *x) {
        NSLog(@"🔥 动态加载上拉加载组件 👉 %@", x);
        @strongify(self)
        if (x.boolValue) {
            /// 上拉加载
            @weakify(self);
            [self.tableView mh_addFooterRefresh:^(MJRefreshAutoNormalFooter *footer) {
                /// 加载上拉刷新的数据
                @strongify(self);
                [self tableViewDidTriggerFooterRefresh];
            }];
            
            /// 隐藏footer or 无更多数据
            RAC(self.tableView.mj_footer, hidden) = [[RACObserve(self.viewModel, dataSource)
                                                      deliverOnMainThread]
                                                     map:^(NSArray *dataSource) {
                                                         @strongify(self)
                                                         NSUInteger count = dataSource.count;
                                                         /// 无数据，默认隐藏mj_footer
                                                         if (count == 0) return @1;
                                                         
                                                         if (self.viewModel.shouldEndRefreshingWithNoMoreData) return @(0);
                                                         
                                                         /// because of
                                                         return (count % self.viewModel.perPage)?@1:@0;
                                                     }];
            
        }else {
            self.tableView.mj_footer = nil;
        }
    }];
    
    
//    [self.viewModel.requestRemoteDataCommand.executionSignals.switchToLatest subscribeNext:^(id _) {
//        @strongify(self);
//        /// 有网络
//        self.viewModel.disableNetwork = NO;
//    }];
//    
//    [self.viewModel.requestRemoteDataCommand.errors subscribeNext:^(id _) {
//        @strongify(self);
//        /// 有无网络
//        self.viewModel.disableNetwork = !self.viewModel.services.client.reachabilityManager.reachable;
//    }];
}

#pragma mark - 设置子控件
/// setup add `_su_` avoid sub class override it
- (void)_su_setupSubViews{
    // set up tableView
    /// CoderMikeHe FIXED: 纯代码布局，子类如果重新布局，建议用Masonry重新设置约束
    MHTableView *tableView = [[MHTableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:self.viewModel.style];
    tableView.backgroundColor = MH_MAIN_BACKGROUNDCOLOR;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // set delegate and dataSource
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    /// 占位符
//    tableView.emptyDataSetDelegate = self;
//    tableView.emptyDataSetSource = self;
//    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsZero);
//    }];
    
    
    self.tableView = tableView;
    tableView.contentInset  = self.contentInset;
    // 注册cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    /// CoderMikeHe FIXED: 这里需要强制布局一下界面，解决由于设置了tableView的contentInset，然而contentOffset始终是（0，0）的bug 但是这样会导致 tableView 刷新一次，从而导致子类在 viewDidLoad 无法及时注册的cell，从而会有Crash的隐患
//        [self.tableView layoutIfNeeded];
//        [self.tableView setNeedsLayout];
//        [self.tableView updateConstraintsIfNeeded];
//        [self.tableView setNeedsUpdateConstraints];
//        [self.view layoutIfNeeded];
    
    /// 添加加载和刷新控件
    if (self.viewModel.shouldPullDownToRefresh) {
        /// 下拉刷新
        @weakify(self);
        [self.tableView mh_addHeaderRefresh:^(MJRefreshNormalHeader *header) {
            /// 加载下拉刷新的数据
            @strongify(self);
            [self tableViewDidTriggerHeaderRefresh];
        }];
        [self.tableView.mj_header beginRefreshing];
    }
    
    if (self.viewModel.shouldPullUpToLoadMore) {
        /// 上拉加载
        @weakify(self);
        [self.tableView mh_addFooterRefresh:^(MJRefreshAutoNormalFooter *footer) {
            /// 加载上拉刷新的数据
            @strongify(self);
            [self tableViewDidTriggerFooterRefresh];
        }];
        
        /// 隐藏footer or 无更多数据
        RAC(self.tableView.mj_footer, hidden) = [[RACObserve(self.viewModel, dataSource)
                                                  deliverOnMainThread]
                                                 map:^(NSArray *dataSource) {
                                                     @strongify(self)
                                                     NSUInteger count = dataSource.count;
                                                     /// 无数据，默认隐藏mj_footer
                                                     if (count == 0) return @1;
                                                     
                                                     if (self.viewModel.shouldEndRefreshingWithNoMoreData) return @(0);
                                                     
                                                     /// because of
                                                     return (count % self.viewModel.perPage)?@1:@0;
                                                 }];
        
    }
    
    
    if (@available(iOS 11.0, *)) {
        /// CoderMikeHe: 适配 iPhone X + iOS 11，
        MHAdjustsScrollViewInsets_Never(tableView);
        /// iOS 11上发生tableView顶部有留白，原因是代码中只实现了heightForHeaderInSection方法，而没有实现viewForHeaderInSection方法。那样写是不规范的，只实现高度，而没有实现view，但代码这样写在iOS 11之前是没有问题的，iOS 11之后应该是由于开启了估算行高机制引起了bug。
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
    }
}

#pragma mark - 上下拉刷新事件
/// 下拉事件
- (void)tableViewDidTriggerHeaderRefresh{
    @weakify(self)
    [[[self.viewModel.requestRemoteDataCommand
       execute:@1]
     	deliverOnMainThread]
    	subscribeNext:^(id x) {
            @strongify(self)
            self.viewModel.page = 1;
            /// 重置没有更多的状态
            if (self.viewModel.shouldEndRefreshingWithNoMoreData) [self.tableView.mj_footer resetNoMoreData];
        } error:^(NSError *error) {
            @strongify(self)
            /// 已经在bindViewModel中添加了对viewModel.dataSource的变化的监听来刷新数据,所以reload = NO即可
            [self.tableView.mj_header endRefreshing];
        } completed:^{
            @strongify(self)
            /// 已经在bindViewModel中添加了对viewModel.dataSource的变化的监听来刷新数据,所以只要结束刷新即可
            [self.tableView.mj_header endRefreshing];
            /// 请求完成
            [self _requestDataCompleted];
        }];
}

/// 上拉事件
- (void)tableViewDidTriggerFooterRefresh{
    @weakify(self);
    [[[self.viewModel.requestRemoteDataCommand
       execute:@(self.viewModel.page + 1)]
      deliverOnMainThread]
     subscribeNext:^(id x) {
         @strongify(self)
         self.viewModel.page += 1;
     } error:^(NSError *error) {
         @strongify(self);
         [self.tableView.mj_footer endRefreshing];
     } completed:^{
         @strongify(self)
         [self.tableView.mj_footer endRefreshing];
         /// 请求完成
         [self _requestDataCompleted];
     }];
}


#pragma mark - sub class can override it
- (UIEdgeInsets)contentInset{
    return UIEdgeInsetsMake(MH_APPLICATION_TOP_BAR_HEIGHT, 0, 0, 0);
}

/// reload tableView data
- (void)reloadData{
    [self.tableView reloadData];
}

/// duqueueReusavleCell
- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
}

/// configure cell data
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {}


#pragma mark - 辅助方法
- (void)_requestDataCompleted{
    NSUInteger count = self.viewModel.dataSource.count;
    /// CoderMikeHe Fixed: 这里必须要等到，底部控件结束刷新后，再来设置无更多数据，否则被叠加无效
    if (self.viewModel.shouldEndRefreshingWithNoMoreData && count%self.viewModel.perPage) [self.tableView.mj_footer endRefreshingWithNoMoreData];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.viewModel.shouldMultiSections) return self.viewModel.dataSource ? self.viewModel.dataSource.count : 0;
    return self.viewModel.dataSource.count == 0 ? 0 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.viewModel.shouldMultiSections) return [self.viewModel.dataSource[section] count];
    return self.viewModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self tableView:tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    // fetch object
    id object = nil;
    if (self.viewModel.shouldMultiSections) object = self.viewModel.dataSource[indexPath.section][indexPath.row];
    if (!self.viewModel.shouldMultiSections) object = self.viewModel.dataSource[indexPath.row];
    
    /// bind model
    [self configureCell:cell atIndexPath:indexPath withObject:(id)object];
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // execute commond
    [self.viewModel.didSelectCommand execute:indexPath];
}


@end
