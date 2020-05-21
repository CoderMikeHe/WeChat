//
//  MHSearchDefaultViewController.m
//  WeChat
//
//  Created by admin on 2020/5/21.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchDefaultViewController.h"
#import "MHSearchCommonHeaderView.h"
#import "MHSearchDefaultContactCell.h"


@interface MHSearchDefaultViewController ()
/// viewModel
@property (nonatomic, readonly, strong) MHSearchDefaultViewModel *viewModel;
@end

@implementation MHSearchDefaultViewController
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
/// 返回自定义的cell
- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{

    MHSearchDefaultItemViewModel *vm = self.viewModel.dataSource[indexPath.row];
    if (vm.searchDefaultType == MHSearchDefaultTypeContacts) {
        return [MHSearchDefaultContactCell cellWithTableView:tableView];
    } else {
        return [MHSearchDefaultContactCell cellWithTableView:tableView];
    }
    return nil;
}

/// 绑定数据 // 利用多态
- (void)configureCell:(MHTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object{
    /// 必须确保 cell 有 bindViewModel 否则崩卡拉卡
    [cell bindViewModel:object];
}

- (UIEdgeInsets)contentInset {
    return UIEdgeInsetsZero;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MHSearchCommonHeaderView *headerView = [MHSearchCommonHeaderView headerViewWithTableView:tableView];
    headerView.titleLabel.text = self.viewModel.sectionTitle;
    headerView.titleLabel.textColor = MHColorFromHexString(@"#808080");
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MHSearchDefaultItemViewModel *vm = self.viewModel.dataSource[indexPath.row];
    return vm.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - 初始化OrUI布局
/// 初始化
- (void)_setup{
    
}

/// 设置导航栏
- (void)_setupNavigationItem{
    
}

/// 初始化子控件
- (void)_setupSubviews{
    
}

/// 布局子控件
- (void)_makeSubViewsConstraints{
    /// 布局好tableView
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


@end
