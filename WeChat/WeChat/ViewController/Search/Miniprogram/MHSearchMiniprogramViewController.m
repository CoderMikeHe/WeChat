//
//  MHSearchMiniprogramViewController.m
//  WeChat
//
//  Created by 何千元 on 2020/5/13.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchMiniprogramViewController.h"
#import "MHSearchCommonHeaderView.h"
#import "MHSearchCommonSearchCell.h"
@interface MHSearchMiniprogramViewController ()
/// viewModel
@property (nonatomic, readonly, strong) MHSearchMiniprogramViewModel *viewModel;

@end

@implementation MHSearchMiniprogramViewController
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
    return [MHSearchCommonSearchCell cellWithTableView:tableView];
}

/// 绑定数据
- (void)configureCell:(MHTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object{
    [cell bindViewModel:object];
}

- (UIEdgeInsets)contentInset {
    return UIEdgeInsetsZero;
}


#pragma mark - 事件处理Or辅助方法

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MHSearchCommonHeaderView *headerView = [MHSearchCommonHeaderView headerViewWithTableView:tableView];
    headerView.titleLabel.text = @"小程序";
    headerView.titleLabel.textColor = MHColorFromHexString(@"#191919");
    headerView.titleLabel.font = MHRegularFont_17;
    return headerView;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 99.0f;
//    
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 46.0f;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return CGFLOAT_MIN;
//}


#pragma mark - 初始化OrUI布局
/// 初始化
- (void)_setup{
    self.tableView.rowHeight = 99.0f;
    // style Grouped 无效
    self.tableView.sectionHeaderHeight = 46.0f;
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
