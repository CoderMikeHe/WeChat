//
//  MHSearchOfficialAccountsViewController.m
//  WeChat
//
//  Created by admin on 2020/5/11.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchOfficialAccountsViewController.h"
#import "MHSearchOfficialAccountsDefaultCell.h"

@interface MHSearchOfficialAccountsViewController ()

@end

@implementation MHSearchOfficialAccountsViewController

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    MHLogFunc;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    MHLogFunc;
}


#pragma mark - Override
- (void)bindViewModel {
    [super bindViewModel];
    
    
}

/// 返回自定义的cell
- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    return [MHSearchOfficialAccountsDefaultCell cellWithTableView:tableView];
}

/// 绑定数据
- (void)configureCell:(MHSearchOfficialAccountsDefaultCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object{
    [cell bindViewModel:object];
}

- (UIEdgeInsets)contentInset {
    return UIEdgeInsetsZero;
}


#pragma mark - 事件处理Or辅助方法


#pragma mark - UITableViewDelegate & UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44 + 109;
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
