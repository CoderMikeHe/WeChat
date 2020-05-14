//
//  MHSearchMomentsViewController.m
//  WeChat
//
//  Created by admin on 2020/5/12.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchMomentsViewController.h"
#import "MHSearchMomentsCell.h"
#import "MHSearchCommonHeaderView.h"
@interface MHSearchMomentsViewController ()
/// viewModel
@property (nonatomic, readonly, strong) MHSearchMomentsViewModel *viewModel;
@end

@implementation MHSearchMomentsViewController
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
    
    
}

/// 返回自定义的cell
- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    return [MHSearchMomentsCell cellWithTableView:tableView];
}

/// 绑定数据
- (void)configureCell:(MHSearchMomentsCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object{
    [cell bindViewModel:object];
}

- (UIEdgeInsets)contentInset {
    return UIEdgeInsetsZero;
}



#pragma mark - 事件处理Or辅助方法

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MHSearchCommonHeaderView *headerView = [MHSearchCommonHeaderView headerViewWithTableView:tableView];
    headerView.titleLabel.text = self.viewModel.sectionTitle;
    return headerView;
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
    self.tableView.rowHeight = 52.0f;
    // style Grouped 无效
    self.tableView.sectionHeaderHeight = 48.0f;
    self.tableView.sectionFooterHeight = CGFLOAT_MIN;
}

/// 设置导航栏
- (void)_setupNavigationItem{
    
}

/// 初始化子控件
- (void)_setupSubviews{
    
}

/// 布局子控件
- (void)_makeSubViewsConstraints{
    
}


@end
