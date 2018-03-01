//
//  MHAddFriendsViewController.m
//  WeChat
//
//  Created by senba on 2017/9/22.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHAddFriendsViewController.h"
#import "MHSearchFriendsHeaderView.h"
#import "MHSearchFriendsViewController.h"
#import "MHCommonCell.h"


@interface MHAddFriendsViewController ()<UISearchResultsUpdating,UISearchControllerDelegate>
/// viewModel
@property (nonatomic, readwrite, strong) MHAddFriendsViewModel *viewModel;
/// searchController
@property (nonatomic, readwrite, strong) UISearchController *searchController;
/// resultController
@property (nonatomic, readwrite, strong) MHSearchFriendsViewController *resultController;
/// headerView
@property (nonatomic, readwrite, weak) MHSearchFriendsHeaderView *headerView;

/// style
@property (nonatomic, readwrite, assign) UIStatusBarStyle style;
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
    
    /// 监听searchVc的活跃度
    [RACObserve(self, searchController.active)
     subscribeNext:^(NSNumber * active) {
         NSLog(@"active is %zd",active.boolValue);
         
         
    }];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return self.style;
}

- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    return [MHCommonCell cellWithTableView:tableView style:UITableViewCellStyleSubtitle];
}





#pragma mark - 初始化
- (void)_setup{
    self.style = UIStatusBarStyleLightContent;
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark - 设置导航栏
- (void)_setupNavigationItem{
}

#pragma mark - 设置子控件
- (void)_setupSubViews{
    @weakify(self);
    
    MHSearchFriendsHeaderView *headerView = [MHSearchFriendsHeaderView headerView];
    self.headerView = headerView;
    self.tableView.tableHeaderView = headerView;
    self.tableView.tableHeaderView.mh_height = 80.0f;
    /// binderViewModel
    [headerView bindViewModel:self.viewModel.headerViewModel];
    // Callback
    headerView.searchCallback = ^(MHSearchFriendsHeaderView *headerView) {
        @strongify(self);
        /// 手动触发 SearchController 的活跃
        self.searchController.active = YES;
    };
    
    
    /// 配置搜索控制器
    /// 搜索结果vc
    MHSearchFriendsViewModel *viewModel = [[MHSearchFriendsViewModel alloc] initWithServices:self.viewModel.services params:nil];
    MHSearchFriendsViewController *resultController = [[MHSearchFriendsViewController alloc] initWithViewModel:viewModel];
    self.resultController = resultController;
    
    /// 搜索vc
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:resultController];
    // 设置结果更新代理
    self.searchController.searchResultsUpdater = resultController;
    
    // 因为在当前控制器展示结果, 所以不需要这个透明视图
    self.searchController.dimsBackgroundDuringPresentation = YES;
    // 是否自动隐藏导航
    self.searchController.hidesNavigationBarDuringPresentation = YES;
    self.searchController.delegate = self;

    UISearchBar *searchBar = self.searchController.searchBar;
    searchBar.barStyle = UIBarStyleDefault;
    searchBar.translucent = YES;
    searchBar.barTintColor = MHColorFromHexString(@"#EFEFF4");
    searchBar.tintColor = [UIColor colorWithRed:0 green:(190 / 255.0) blue:(12 / 255.0) alpha:1];
    [searchBar setImage:[UIImage imageNamed:@"VoiceSearchStartBtn"] forSearchBarIcon:UISearchBarIconBookmark state:UIControlStateNormal];
    /// 设置代理
    searchBar.delegate = self.resultController;
    [headerView insertSubview:searchBar atIndex:0];
    /// 设置frame
    CGRect rect = searchBar.frame;
    rect.size.height = 44;
    searchBar.frame = rect;
    
    UIImageView *bgView = [[[searchBar.subviews objectAtIndex:0] subviews] firstObject];
    bgView.layer.borderColor = MHColorFromHexString(@"#DFDFDD").CGColor;
    bgView.layer.borderWidth = 1;
    
    // 1. 创建磨砂视图
    // 判断系统版本是否支持 8.0
    UIView *blurEffectView;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        // 磨砂效果
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        // 磨砂视图
        blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    } else {
        // 屏幕截图 - 调用苹果官方框架实现磨砂效果
        UIImage *screenShot = [UIImage mh_screenShot].applyLightEffect;
        blurEffectView = [[UIImageView alloc] initWithImage:screenShot];
    }
    /// 切记： 将磨砂视图 插入到最底层
    [self.searchController.view insertSubview:blurEffectView atIndex:0];
    [blurEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.searchController.view);
    }];
    
    /// 设置当前Controller的definesPresentationContext为YES，表示UISearchController在present时，可以覆盖当前controller。
    self.definesPresentationContext = YES;
    
}

#pragma mark - UISearchResultsUpdating
// Called when the search bar's text or scope has changed or when the search bar becomes first responder.
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
}

#pragma mark - UISearchControllerDelegate
- (void)willPresentSearchController:(UISearchController *)searchController{
    MHLogFunc;
    /// 取消侧滑功能
    self.viewModel.interactivePopDisabled = YES;
}
- (void)didPresentSearchController:(UISearchController *)searchController{
    MHLogFunc;
    self.style = UIStatusBarStyleDefault;
    [self setNeedsStatusBarAppearanceUpdate];
    /// 键盘弹起
    [self.searchController.searchBar becomeFirstResponder];
}
- (void)willDismissSearchController:(UISearchController *)searchController{
    /// 回复侧滑功能
    self.viewModel.interactivePopDisabled = NO;
    MHLogFunc;
}
- (void)didDismissSearchController:(UISearchController *)searchController{
    MHLogFunc;
    self.style = UIStatusBarStyleLightContent;
    [self setNeedsStatusBarAppearanceUpdate];
    
    ///  设置frame 这里searchBar的高度会变化且会显示在最上层 。 Why？？
    /// CoderMikeHe TODO : 这里还不够流畅？？？
    CGRect rect = self.searchController.searchBar.frame;
    rect.size.height = 44;
    self.searchController.searchBar.frame = rect;
    /// 插入到下层
    [self.headerView sendSubviewToBack:self.searchController.searchBar];
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"0----  %@  %@",self.navigationController,self.presentingViewController.navigationController);
}
@end
