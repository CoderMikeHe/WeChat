//
//  MHSearchStickerViewController.m
//  WeChat
//
//  Created by 何千元 on 2020/5/13.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchStickerViewController.h"
#import "MHSearchStickerDefaultCell.h"
#import "MHSearchCommonRelatedCell.h"
#import "MHSearchCommonSearchCell.h"
#import "MHSearchCommonHeaderView.h"
@interface MHSearchStickerViewController ()
/// viewModel
@property (nonatomic, readwrite, strong) MHSearchStickerViewModel *viewModel;
@end

@implementation MHSearchStickerViewController
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
    if (self.viewModel.searchMode == MHSearchModeDefault) {
        return [MHSearchStickerDefaultCell cellWithTableView:tableView];
    } else if (self.viewModel.searchMode == MHSearchModeRelated) {
        return [MHSearchCommonRelatedCell cellWithTableView:tableView];
    } else {
        return [MHSearchCommonSearchCell cellWithTableView:tableView];
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
    if(self.viewModel.searchMode == MHSearchModeSearch) {
        MHSearchCommonHeaderView *headerView = [MHSearchCommonHeaderView headerViewWithTableView:tableView];
        headerView.titleLabel.text = @"表情";
        headerView.titleLabel.textColor = MHColorFromHexString(@"#191919");
        headerView.titleLabel.font = MHRegularFont_17;
        return headerView;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 180;
    switch (self.viewModel.searchMode) {
        case MHSearchModeRelated:
        {
            height = 53.0f;
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
