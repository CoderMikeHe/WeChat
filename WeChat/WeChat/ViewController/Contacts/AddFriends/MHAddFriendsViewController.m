//
//  MHAddFriendsViewController.m
//  WeChat
//
//  Created by senba on 2017/9/22.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHAddFriendsViewController.h"
#import "MHSearchFriendsHeaderView.h"
#import "MHCommonCell.h"


@interface MHAddFriendsViewController ()
/// viewModel
@property (nonatomic, readwrite, strong) MHAddFriendsViewModel *viewModel;
@end

@implementation MHAddFriendsViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// 设置
    [self _setup];
    
    /// 设置导航栏
    [self _setupNavigationItem];
    
    /// 设置子控件
    [self _setupSubViews];
}

#pragma mark - Override
- (void)bindViewModel{
    [super bindViewModel];
}

- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    return [MHCommonCell cellWithTableView:tableView style:UITableViewCellStyleSubtitle];
}





#pragma mark - 初始化
- (void)_setup{
    
}

#pragma mark - 设置导航栏
- (void)_setupNavigationItem{
}

#pragma mark - 设置子控件
- (void)_setupSubViews{
    MHSearchFriendsHeaderView *headerView = [MHSearchFriendsHeaderView headerView];
    self.tableView.tableHeaderView = headerView;
    self.tableView.tableHeaderView.mh_height = 80.0f;
    
    /// binderViewModel
    [headerView bindViewModel:self.viewModel.headerViewModel];
    
    
    

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"0----  %@  %@",self.navigationController,self.presentingViewController.navigationController);
}
@end
