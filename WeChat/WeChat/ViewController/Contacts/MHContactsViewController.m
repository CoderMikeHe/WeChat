//
//  MHContactsViewController.m
//  WeChat
//
//  Created by senba on 2017/9/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHContactsViewController.h"
#import "MHAddFriendsViewController.h"

#import "WPFPinYinTools.h"
#import "WPFPinYinDataManager.h"

#import "MHContactsTableViewCell.h"

@interface MHContactsViewController ()<UISearchResultsUpdating>
/// viewModel
@property (nonatomic, readonly, strong) MHContactsViewModel *viewModel;
@property (nonatomic, strong) UISearchController *searchController;
@end

@implementation MHContactsViewController

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
- (void)bindViewModel {
    [super bindViewModel];
}

/// 返回自定义的cell
- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    return [MHContactsTableViewCell cellWithTableView:tableView];
}

/// 绑定数据
- (void)configureCell:(MHContactsTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object{
    [cell bindViewModel:object];
}

#pragma mark - 初始化
- (void)_setup{
    
    self.tableView.rowHeight = 56.0f;
    
    /// 监听searchVc的活跃度
//    [RACObserve(self, searchController.active)
//     subscribeNext:^(NSNumber * active) {
//         NSLog(@"active is %zd",active.boolValue);
//     }];
}

#pragma mark - 设置导航栏
- (void)_setupNavigationItem{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem mh_svgBarButtonItem:@"icons_outlined_add-friends.svg" targetSize:CGSizeMake(24.0, 24.0) tintColor:nil target:nil selector:nil];
    self.navigationItem.rightBarButtonItem.rac_command = self.viewModel.addFriendsCommand;
}

#pragma mark - 设置子控件
- (void)_setupSubViews{

//    MHAddFriendsViewModel *viewModel = [[MHAddFriendsViewModel alloc] initWithServices:self.viewModel.services params:nil];
//    MHAddFriendsViewController *add = [[MHAddFriendsViewController alloc] initWithViewModel:viewModel];
    
//    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
//    self.searchController.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.95];
//
//    UISearchBar *bar = self.searchController.searchBar;
//    bar.barStyle = UIBarStyleDefault;
//    bar.translucent = YES;
//    bar.barTintColor = MHColor(248, 248, 248);
//    bar.tintColor = [UIColor colorWithRed:0 green:(190 / 255.0) blue:(12 / 255.0) alpha:1];
////    UIImageView *view = [[[bar.subviews objectAtIndex:0] subviews] firstObject];
////    view.layer.borderColor = [UIColor redColor].CGColor;
////    view.layer.borderWidth = 1;
//
//    bar.layer.borderColor = [UIColor redColor].CGColor;
//
//    bar.showsBookmarkButton = YES;
//    [bar setImage:[UIImage imageNamed:@"VoiceSearchStartBtn"] forSearchBarIcon:UISearchBarIconBookmark state:UIControlStateNormal];
////    bar.delegate = self;
//    CGRect rect = bar.frame;
//    rect.size.height = 44;
//    bar.frame = rect;
//    self.tableView.tableHeaderView = bar;
//
//
//
//
//    self.searchController.searchResultsUpdater = self;
}

// Called when the search bar's text or scope has changed or when the search bar becomes first responder.
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
}
@end
