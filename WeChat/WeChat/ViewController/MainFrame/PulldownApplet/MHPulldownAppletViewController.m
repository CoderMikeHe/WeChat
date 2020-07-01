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
#import "MHAppletViewController.h"
@interface MHPulldownAppletViewController ()

/// viewModel
@property (nonatomic, readonly, strong) MHPulldownAppletViewModel *viewModel;
/// 搜索框容器
@property (nonatomic, readwrite, weak) UIControl *container;
/// searchBar
@property (nonatomic, readwrite, weak) UIButton *searchBar;
/// navBar
@property (nonatomic, readwrite, weak) MHNavigationBar *navBar;
@end

@implementation MHPulldownAppletViewController

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
    
    self.view.backgroundColor = self.tableView.backgroundColor = [UIColor black50PercentColor];
}
#pragma mark - Override
- (void)bindViewModel {
    [super bindViewModel];
}

/// 返回自定义的cell
- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    return [MHPulldownAppletCell cellWithTableView:tableView];
}

/// 绑定数据
- (void)configureCell:(MHPulldownAppletCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object{
    [cell bindViewModel:object];
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

#pragma mark - 事件处理Or辅助方法

#pragma mark - 初始化OrUI布局
/// 初始化
- (void)_setup{
    
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
    navBar.backgroundColor = navBar.backgroundView.backgroundColor = [UIColor black50PercentColor];
    self.navBar = navBar;
    [self.view addSubview:navBar];
    
    /// 搜索框容器
    UIControl *container = [[UIControl alloc] init];
    self.container = container;
    container.mh_height = 74.0f;
    [[container rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        NSLog(@" searchbar did clicked... ");
        MHAppletViewModel *viewModel = [[MHAppletViewModel alloc] initWithServices:self.viewModel.services params:nil];
        [self.viewModel.services pushViewModel:viewModel animated:YES];
    }];
    
    /// 搜索框
    NSString *imageName = @"icons_outlined_search_full.svg";
    UIColor *color = [[UIColor whiteColor] colorWithAlphaComponent:.5];
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
}

/// 布局子控件
- (void)_makeSubViewsConstraints{
    
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.equalTo(self.view);
        make.height.mas_equalTo(MH_APPLICATION_TOP_BAR_HEIGHT);
    }];
    
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(17.0f, 36.5f, 17.0f, 36.5f));
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}
@end
