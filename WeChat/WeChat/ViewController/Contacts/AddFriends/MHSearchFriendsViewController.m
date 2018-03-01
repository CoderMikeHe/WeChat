//
//  MHSearchFriendsViewController.m
//  WeChat
//
//  Created by senba on 2017/9/24.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHSearchFriendsViewController.h"
#import "MHSearchTextCell.h"

@interface MHSearchFriendsViewController ()<UISearchBarDelegate,UIGestureRecognizerDelegate>
/// viewModel
@property (nonatomic, readonly, strong) MHSearchFriendsViewModel *viewModel;

@end

@implementation MHSearchFriendsViewController

@dynamic viewModel;

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// 初始化
    [self _setup];

    /// 初始化子控件
    [self _setupSubViews];
}

#pragma mark - 绑定模型
- (void)bindViewModel{
    [super bindViewModel];
   
}
- (UIEdgeInsets)contentInset{
    return UIEdgeInsetsMake(MH_APPLICATION_TOP_BAR_HEIGHT, 0, 0, 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    MHSearchTextCell *cell = [MHSearchTextCell cellWithTableView:tableView];
    return cell;
}

- (void)configureCell:(MHSearchTextCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object{
    [cell bindViewModel:object];
}

#pragma mark - 初始化
- (void)_setup{

}
#pragma mark - 初始化子控件
- (void)_setupSubViews{

}



#pragma mark - UISearchBarDelegate
// 键盘中，搜索按钮被按下，执行的方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    MHLogFunc;
    
    /// 去掉空格
    if ([NSString mh_isEmpty:searchBar.text]) return;
    
    /// 增加搜索条件
//    [self.viewModel.addSearchHistoryCmd execute:searchBar.text];
}


#pragma mark - UISearchResultsUpdating
// Called when the search bar's text or scope has changed or when the search bar becomes first responder.
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    /// 获取输入的文字
    NSString *inputStr = searchController.searchBar.text;
    NSLog(@"inputStr is %@",inputStr);
    
    self.viewModel.searchText = inputStr;
    
    
    
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66;
}




@end
