//
//  MHSearchMusicViewController.m
//  WeChat
//
//  Created by 何千元 on 2020/5/13.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchMusicViewController.h"
#import "MHSearchMusicHotSearchCell.h"
#import "MHSearchCommonHeaderView.h"
#import "MHSearchMusicHistoryCell.h"
#import "MHSearchMusicDelHistoryCell.h"
#import "MHSearchCommonCell.h"
@interface MHSearchMusicViewController ()
/// viewModel
@property (nonatomic, readonly, strong) MHSearchMusicViewModel *viewModel;
@end

@implementation MHSearchMusicViewController
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
    
    // 
}

/// 返回自定义的cell
- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return [MHSearchMusicHotSearchCell cellWithTableView:tableView];
    } else if (indexPath.section == 1) {
        return [MHSearchCommonCell cellWithTableView:tableView];
    } else{
        return [MHSearchMusicDelHistoryCell cellWithTableView:tableView];
    }
}

/// 绑定数据
- (void)configureCell:(MHSearchMusicHotSearchCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object{
    [cell bindViewModel:object];
}

- (UIEdgeInsets)contentInset {
    return UIEdgeInsetsZero;
}



#pragma mark - 事件处理Or辅助方法

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MHSearchCommonHeaderView *headerView = [MHSearchCommonHeaderView headerViewWithTableView:tableView];
    NSString *headerTitle = @"";
    if (section == 0) {
        headerTitle = @"热门搜索";
    }else if (section == 1){
        headerTitle = @"搜索历史";
    }
    headerView.titleLabel.text = headerTitle;
    headerView.titleLabel.textColor = MHColorFromHexString(@"#808080");
    headerView.titleLabelLeftConstraint.constant = 20.0f;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        NSArray * array = self.viewModel.dataSource[indexPath.section];
        id vm = array[indexPath.row];
        if ([vm isKindOfClass:[MHSearchMusicHotItemViewModel class]]) {
            MHSearchMusicHotItemViewModel *itemViewModel = (MHSearchMusicHotItemViewModel *)vm;
            return itemViewModel.cellHeight;
        }
        return CGFLOAT_MIN;
    }else if (indexPath.section == 1) {
        return 54.0f;
    } else {
        return 58.0f;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 44.0f;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 8.0f;
    }else if (section == 2) {
        return 29.0f;
    }
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
