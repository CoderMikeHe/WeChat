//
//  MHMomentViewController.m
//  WeChat
//
//  Created by senba on 2017/12/20.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHMomentViewController.h"
#import "MHMomentHeaderView.h"
#import "MHMomentFooterView.h"
#import "MHMomentCommentCell.h"
#import "MHMomentAttitudesCell.h"
#import "MHMomentProfileView.h"
#import "MHMomentOperationMoreView.h"
#import "LCActionSheet.h"
#import "MHEmoticonManager.h"
#import "MHMomentHelper.h"
@interface MHMomentViewController ()
/// viewModel
@property (nonatomic, readonly, strong) MHMomentViewModel *viewModel;
/// tableHeaderView
@property (nonatomic, readwrite, weak) MHMomentProfileView *tableHeaderView;
/// 点赞
@end

@implementation MHMomentViewController

@dynamic viewModel;

- (void)dealloc{
    MHDealloc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化子控件
    [self _setupSubViews];
    
    /// 初始化导航栏Item
    [self _setupNavigationItem];
    
    NSDictionary * dict = [MHEmoticonManager emoticonDic];
    
}

#pragma mark - Override
- (UIEdgeInsets)contentInset{
    return UIEdgeInsetsMake(MH_IS_IPHONE_X?-40:-64, 0, 0, 0);
}

- (void)bindViewModel{
    [super bindViewModel];
    
    /// ... 事件处理...
    /// 全文/收起
    @weakify(self);
    [self.viewModel.reloadSectionSubject subscribeNext:^(NSNumber * section) {
        @strongify(self);
        /// 局部刷新 (内部已更新子控件的尺寸，这里只做刷新)
        /// 这个刷新会有个奇怪的动画
        /// [self.tableView reloadSection:section.integerValue withRowAnimation:UITableViewRowAnimationNone];
        /// CoderMikeHe Fixed： 这里必须要加这句话！！！否则有个奇怪的动画！！！！
        [UIView performWithoutAnimation:^{
            [self.tableView reloadSection:section.integerValue withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
    }];
    
    /// 评论
    [self.viewModel.commentSubject subscribeNext:^(NSNumber * section) {
        @strongify(self);
        /// 获取整个section对应的尺寸 获取的rect是相当于tableView的尺寸
        CGRect rect = [self.tableView rectForFooterInSection:section.integerValue];
        /// 将尺寸转化到window的坐标系
        CGRect rect1 = [self.tableView convertRect:rect toViewOrWindow:nil];
        NSLog(@"rect --- %@    rect1 --- %@" , NSStringFromCGRect(rect) , NSStringFromCGRect(rect1));
    }];
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    return [MHMomentContentCell cellWithTableView:tableView];
}

- (void)configureCell:(MHMomentContentCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object{
    MHMomentItemViewModel *itemViewModel =  self.viewModel.dataSource[indexPath.section];
    id model = itemViewModel.operationMores[indexPath.row];
    [cell bindViewModel:model];
}

#pragma mark - 初始化子控件
- (void)_setupSubViews{
    /// 配置tableView
    self.tableView.backgroundColor = [UIColor whiteColor];
    /// 固定高度-这样写比使用代理性能好，且使用代理会获取每次刷新数据会调用两次代理 ，苹果的bug
    self.tableView.sectionFooterHeight =  MHMomentFooterViewHeight;
    
    /// 个人信息view
    MHMomentProfileView *tableHeaderView = [[MHMomentProfileView alloc] init];
    [tableHeaderView bindViewModel:self.viewModel.profileViewModel];
    self.tableHeaderView = tableHeaderView;
    
    @weakify(self);
    /// 动态更新tableHeaderView的高度. PS:单纯的设置其高度无效的
    [[RACObserve(self.viewModel.profileViewModel, unread)
      distinctUntilChanged]
     subscribeNext:^(NSNumber * unread) {
         @strongify(self);
         tableHeaderView.mh_height = self.viewModel.profileViewModel.height;
         [self.tableView beginUpdates];  // 过度动画
         self.tableView.tableHeaderView = tableHeaderView;
         [self.tableView endUpdates];
     }];
    
    
    /// 这里设置下拉黑色的背景图
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:MH_SCREEN_BOUNDS];
    backgroundView.mh_size = MH_SCREEN_BOUNDS.size;
    backgroundView.image = MHImageNamed(@"wx_around-friends_bg_320x568");
    backgroundView.mh_y = -backgroundView.mh_height;
    [self.tableView addSubview:backgroundView];
}

#pragma mark - 初始化道导航栏
- (void)_setupNavigationItem{
    @weakify(self);
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem mh_systemItemWithTitle:nil titleColor:nil imageName:@"barbuttonicon_Camera_30x30" target:nil selector:nil textType:NO];
    self.navigationItem.rightBarButtonItem.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        LCActionSheet *sheet = [LCActionSheet sheetWithTitle:nil cancelButtonTitle:@"取消" clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
            if (buttonIndex == 0) return ;
            ///
        } otherButtonTitles:@"拍摄",@"从手机相册选择", nil];
        [sheet show];
        
        return [RACSignal empty];
    }];
}


/// PS:这里复写了 MHTableViewController 里面的UITableViewDelegate和UITableViewDataSource的方法，所以大家不需要过多关注 MHTableViewController的里面的UITableViewDataSource方法
#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MHMomentItemViewModel *itemViewModel =  self.viewModel.dataSource[section];
    return itemViewModel.operationMores.count;
}

// custom view for header. will be adjusted to default or specified header height
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MHMomentHeaderView *headerView = [MHMomentHeaderView headerViewWithTableView:tableView];
    /// 传递section 后期需要用到
    headerView.section = section;
    [headerView bindViewModel:self.viewModel.dataSource[section]];
    return headerView;
}
// custom view for footer. will be adjusted to default or specified footer height
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [MHMomentFooterView footerViewWithTableView:tableView];
}

// custom view for cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self tableView:tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    // fetch object
    id object  = [self.viewModel.dataSource[indexPath.section] operationMores][indexPath.row];;
    
    /// bind model
    [self configureCell:cell atIndexPath:indexPath withObject:(id)object];
    
    return cell;
}

/// 设置高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    MHMomentItemViewModel *itemViewModel = self.viewModel.dataSource[section];
    /// 这里每次刷新都会走两次！！！ Why？？？
    return itemViewModel.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MHMomentItemViewModel *itemViewModel =  self.viewModel.dataSource[indexPath.section];
    /// 这里用 id 去指向（但是一定要确保取出来的模型有 `cellHeight` 属性 ，否则crash）
    id model = itemViewModel.operationMores[indexPath.row];
    return [model cellHeight];
}

/// 监听滚动到顶部
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    /// 这里下拉刷新
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    /// 回收评论和点赞的
    [MHMomentOperationMoreView hideAllOperationMoreViewWithAnimated:NO];
}
@end
