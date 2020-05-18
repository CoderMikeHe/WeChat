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
#import "MHSearchCommonSearchCell.h"
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
    if (self.viewModel.searchMode == MHSearchModeRelated) {
        return [MHSearchMomentsCell cellWithTableView:tableView];
    }else if (self.viewModel.searchMode == MHSearchModeSearch) {
        return [MHSearchCommonSearchCell cellWithTableView:tableView];
    }else {
        return nil;
    }
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
    headerView.titleLabel.textColor = MHColorFromHexString(@"#b3b3b3");
    headerView.titleLabel.font = MHRegularFont_14;
    headerView.titleLabel.text = nil;
    switch (self.viewModel.searchMode) {
        case MHSearchModeRelated:
        {
            headerView.titleLabel.text = self.viewModel.sectionTitle;
        }
            break;
        case MHSearchModeSearch:
        {
            headerView.titleLabel.text = @"朋友圈";
            headerView.titleLabel.textColor = MHColorFromHexString(@"#191919");
            headerView.titleLabel.font = MHRegularFont_17;
        }
            break;
        default:
            break;
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = CGFLOAT_MIN;
    switch (self.viewModel.searchMode) {
        case MHSearchModeRelated:
        {
            height = 52.0f;
        }
            break;
        case MHSearchModeSearch:
        {
            height = 99.0f;
        }
            break;
        default:
            break;
    }
    return height;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = CGFLOAT_MIN;
    switch (self.viewModel.searchMode) {
        case MHSearchModeRelated:
        {
            height = 48.0f;
        }
            break;
        case MHSearchModeSearch:
        {
            height = 46.0f;
        }
            break;
        default:
            break;
    }
    return height;
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
    
}


@end
