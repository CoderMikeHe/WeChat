//
//  MHSearchViewController.m
//  WeChat
//
//  Created by admin on 2020/5/6.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchViewController.h"
#import "MHSearchTypeView.h"
#import "MHSearchVoiceInputView.h"


#import "MHSearchMomentsViewController.h"
#import "MHSearchSubscriptionsViewController.h"
#import "MHSearchOfficialAccountsViewController.h"
#import "MHSearchMiniprogramViewController.h"
#import "MHSearchMusicViewController.h"
#import "MHSearchStickerViewController.h"


#import "MHSearchCommonFooterView.h"
#import "MHSearchCommonHeaderView.h"
#import "MHSearchDefaultSearchTypeCell.h"
#import "MHSearchDefaultContactCell.h"

#import "MHSearchDefaultItemViewModel.h"

@interface MHSearchViewController ()
/// scrollView
@property (nonatomic, readwrite, weak) UIScrollView *scrollView;
/// containerView
@property (nonatomic, readwrite, weak) UIView *containerView;

/// searchTypeView
@property (nonatomic, readwrite, weak) MHSearchTypeView *searchTypeView;

/// voiceInputView
@property (nonatomic, readwrite, weak) MHSearchVoiceInputView *voiceInputView;

/// viewModel
@property (nonatomic, readwrite, strong) MHSearchViewModel *viewModel;

/// 当前展示的控制器
@property (nonatomic, readwrite, strong) UIViewController *currentViewController;

/// viewControllers 用来管理子控制器
@property (nonatomic, readwrite, strong) NSMutableArray *viewControllers;


@end

@implementation MHSearchViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// 设置
    [self _setup];
    
    /// 添加子控制器
    [self _setupChildController];
    
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
    
    @weakify(self);
    [[RACObserve(self.viewModel, searchType) deliverOnMainThread] subscribeNext:^(NSNumber *x) {
        @strongify(self);
        MHSearchType searchType = x.integerValue;
        [self _configureSearchView:searchType];
    }];
    
    
    
    /// 监听键盘 高度
    [[[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillChangeFrameNotification object:nil] takeUntil:self.rac_willDeallocSignal ]
      deliverOnMainThread]
     subscribeNext:^(NSNotification * notification) {
         @strongify(self);
         @weakify(self);
         [self mh_convertNotification:notification completion:^(CGFloat duration, UIViewAnimationOptions options, CGFloat keyboardH) {
             @strongify(self);
             if (keyboardH <= 0) {
                 keyboardH = - self.voiceInputView.mh_height;
             }
             // voiceInputView距离底部的高
             [self.voiceInputView mas_updateConstraints:^(MASConstraintMaker *make) {
                 make.bottom.equalTo(self.view).with.offset(-1 *keyboardH);
             }];
             // 执行动画
             [UIView animateWithDuration:duration delay:0.0f options:options animations:^{
                 // 如果是Masonry或者autoLayout UITextField或者UITextView 布局 必须layoutSubviews，否则文字会跳动
                 [self.view layoutIfNeeded];
             } completion:nil];
         }];
     }];
}

#pragma mark - 事件处理Or辅助方法
- (void)_configureSearchView:(MHSearchType)type {
    // 默认页
    if (type == MHSearchTypeDefault) {
        /// 如果有值 说名当前处于搜索子模块
        if (self.currentViewController) {
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [self.currentViewController.view setTransform:CGAffineTransformMakeTranslation(self.currentViewController.view.mh_width, 0)];
            } completion:^(BOOL finished) {
                [self.currentViewController willMoveToParentViewController:nil];
                [self.currentViewController.view removeFromSuperview];
                [self.currentViewController removeFromParentViewController];
                // 置位
                self.currentViewController = nil;
            }];
        }
        return;
    }
    
    /// 取出控制器
    UIViewController *toViewController = self.viewControllers[type];
    /// 清空transform
    toViewController.view.transform = CGAffineTransformIdentity;
    /// 调整frame
    toViewController.view.frame = self.view.bounds;
    /// 加入控制器
    [self.view addSubview:toViewController.view];
    [self addChildViewController:toViewController];
    [toViewController didMoveToParentViewController:self];
    
    // 记录当前子控制器
    self.currentViewController = toViewController;
}

/// 返回自定义的cell
- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    if (self.viewModel.searchMode == MHSearchModeDefault) {
        return [MHSearchDefaultSearchTypeCell cellWithTableView:tableView];
    }
    return [MHSearchDefaultContactCell cellWithTableView:tableView];
}

/// 绑定数据 // 利用多态
- (void)configureCell:(MHTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object{
    /// 必须确保 cell 有 bindViewModel 否则崩卡拉卡
    [cell bindViewModel:object];
}

- (UIEdgeInsets)contentInset {
    return UIEdgeInsetsZero;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(self.viewModel.searchMode == MHSearchModeSearch) {
        MHSearchCommonHeaderView *headerView = [MHSearchCommonHeaderView headerViewWithTableView:tableView];
        headerView.titleLabel.text = @"文章";
        headerView.titleLabel.textColor = MHColorFromHexString(@"#191919");
        headerView.titleLabel.font = MHRegularFont_17;
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = self.viewModel.dataSource[indexPath.section];
    MHSearchDefaultItemViewModel *itemViewModel = array[indexPath.row];
    return itemViewModel.cellHeight;
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
    return 9.0;
}



#pragma mark - 初始化OrUI布局
/// 初始化
- (void)_setup{
    // 自动计算行高
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
}

/// 设置导航栏
- (void)_setupNavigationItem{
    
}


#pragma mark - 初始化子控制器
- (void)_setupChildController {
    
    /// 朋友圈
    MHSearchMomentsViewController *moments = [[MHSearchMomentsViewController alloc] initWithViewModel:self.viewModel.momentsViewModel];
    [self.viewControllers addObject:moments];
    
    /// 文章
    MHSearchSubscriptionsViewController *subscriptions = [[MHSearchSubscriptionsViewController alloc] initWithViewModel:self.viewModel.subscriptionsViewModel];
    [self.viewControllers addObject:subscriptions];
    
    /// 公众号
    MHSearchOfficialAccountsViewController *officialAccounts = [[MHSearchOfficialAccountsViewController alloc] initWithViewModel:self.viewModel.officialAccountsViewModel];
    [self.viewControllers addObject:officialAccounts];
    
    /// 小程序
    MHSearchMiniprogramViewController *miniprogram = [[MHSearchMiniprogramViewController alloc] initWithViewModel:self.viewModel.miniprogramViewModel];
    [self.viewControllers addObject:miniprogram];
    
    /// 音乐
    MHSearchMusicViewController *music = [[MHSearchMusicViewController alloc] initWithViewModel:self.viewModel.musicViewModel];
    [self.viewControllers addObject:music];
    
    /// 表情
    MHSearchStickerViewController *sticker = [[MHSearchStickerViewController alloc] initWithViewModel:self.viewModel.stickerViewModel];
    [self.viewControllers addObject:sticker];
}

/// 初始化子控件
- (void)_setupSubviews{
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // scrollView
//    UIScrollView *scrollView = [[UIScrollView alloc] init];
//    scrollView.alwaysBounceVertical = YES;
//    scrollView.showsHorizontalScrollIndicator = NO;
//    scrollView.showsVerticalScrollIndicator = NO;
//
//    /// 适配 iOS 11
//    MHAdjustsScrollViewInsets_Never(scrollView);
//    [self.view addSubview:scrollView];
//    self.scrollView = scrollView;
//
//    /// containerView
//    UIView *containerView = [[UIView alloc] init];
//    [scrollView addSubview:containerView];
//    self.containerView = containerView;
//
//    // searchTypeView
//    MHSearchTypeView *searchTypeView = [MHSearchTypeView searchTypeView];
//    self.searchTypeView = searchTypeView;
//    [searchTypeView bindViewModel:self.viewModel.searchTypeViewModel];
//    [containerView addSubview:searchTypeView];
//
//
//    // 设置背景色
//    containerView.backgroundColor = searchTypeView.backgroundColor = self.view.backgroundColor;
    
    
    /// 语音输入View
    MHSearchVoiceInputView *voiceInputView = [MHSearchVoiceInputView voiceInputView];
    self.voiceInputView = voiceInputView;
    [self.view addSubview:voiceInputView];
}

/// 布局子控件
- (void)_makeSubViewsConstraints{
    
//    // 设置view
//    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
//
//    /// 设置contentSize
//    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(MH_SCREEN_WIDTH);
//        make.height.mas_equalTo(MH_SCREEN_HEIGHT);
//    }];
//
//    /// 布局搜索类型
//    [self.searchTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.and.right.equalTo(self.containerView);
//        make.top.equalTo(self.containerView).with.offset(39.0);
//    }];
    
    [self.voiceInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(-115.0);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(200.0, 115));
    }];
}


#pragma mark - lazy load
- (NSMutableArray *)viewControllers{
    if (_viewControllers == nil) {
        _viewControllers = [[NSMutableArray alloc] init];
    }
    return _viewControllers;
}

@end
