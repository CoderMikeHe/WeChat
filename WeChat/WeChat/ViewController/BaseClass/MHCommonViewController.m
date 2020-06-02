//
//  MHCommonViewController.m
//  WeChat
//
//  Created by senba on 2017/9/14.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHCommonViewController.h"
#import "MHCommonHeaderView.h"
#import "MHCommonFooterView.h"
#import "MHCommonCell.h"

@interface MHCommonViewController ()
/// viewModel
@property (nonatomic, readwrite, strong) MHCommonViewModel *viewModel;
@end

@implementation MHCommonViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Override
- (void)bindViewModel{
    [super bindViewModel];
}

- (UIEdgeInsets)contentInset{
    return UIEdgeInsetsMake(MH_APPLICATION_TOP_BAR_HEIGHT+3, 0, 0, 0);
}

- (void)configureCell:(MHCommonCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object{
    [cell bindViewModel:object];
}

- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    return [MHCommonCell cellWithTableView:tableView];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.viewModel.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    MHCommonGroupViewModel *groupViewModel = self.viewModel.dataSource[section];
    return groupViewModel.itemViewModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    /// fetch cell
    MHCommonCell *cell = (MHCommonCell *)[self tableView:tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    MHCommonGroupViewModel *groupViewModel = self.viewModel.dataSource[indexPath.section];
    id object = groupViewModel.itemViewModels[indexPath.row];
    /// bind model
    [self configureCell:cell atIndexPath:indexPath withObject:(id)object];
    [cell setIndexPath:indexPath rowsInSection:groupViewModel.itemViewModels.count];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    MHCommonFooterView *footerView = [MHCommonFooterView footerViewWithTableView:tableView];
    MHCommonGroupViewModel *groupViewModel = self.viewModel.dataSource[section];
    [footerView bindViewModel:groupViewModel];
    return footerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MHCommonHeaderView *headerView = [MHCommonHeaderView headerViewWithTableView:tableView];
    MHCommonGroupViewModel *groupViewModel = self.viewModel.dataSource[section];
    [headerView bindViewModel:groupViewModel];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MHCommonGroupViewModel *groupViewModel = self.viewModel.dataSource[indexPath.section];
    MHCommonItemViewModel *itemViewModel = groupViewModel.itemViewModels[indexPath.row];
    return itemViewModel.rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    MHCommonGroupViewModel *groupViewModel = self.viewModel.dataSource[section];
    return groupViewModel.headerHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    MHCommonGroupViewModel *groupViewModel = self.viewModel.dataSource[section];
    return groupViewModel.footerHeight;
}
@end
