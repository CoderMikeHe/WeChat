//
//  MHSearchViewController.m
//  WeChat
//
//  Created by admin on 2020/5/6.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchViewController.h"
#import "MHSearchVoiceInputView.h"


#import "MHSearchMomentsViewController.h"
#import "MHSearchSubscriptionsViewController.h"
#import "MHSearchOfficialAccountsViewController.h"
#import "MHSearchMiniprogramViewController.h"
#import "MHSearchMusicViewController.h"
#import "MHSearchStickerViewController.h"

#import "MHSearchDefaultViewController.h"

#import "MHSearchCommonFooterView.h"
#import "MHSearchCommonHeaderView.h"

#import "MHSearchDefaultSearchTypeCell.h"
#import "MHSearchDefaultContactCell.h"
#import "MHSearchDefaultMoreCell.h"

#import "MHSearchDefaultItemViewModel.h"

static CGFloat const MHOffsetWidth = 76;

@interface MHSearchViewController ()

/// voiceInputView
@property (nonatomic, readwrite, weak) MHSearchVoiceInputView *voiceInputView;

/// viewModel
@property (nonatomic, readwrite, strong) MHSearchViewModel *viewModel;

/// 当前展示的控制器
@property (nonatomic, readwrite, strong) UIViewController *currentViewController;

/// viewControllers 用来管理子控制器
@property (nonatomic, readwrite, strong) NSMutableArray *viewControllers;

/// 搜索更多xxx 展示的页面
@property (nonatomic, readwrite, strong) UIViewController *defaultViewController;

/// 获取截图
@property (nonatomic, readwrite, weak) UIView *snapshotView;
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
    
    
    /// 监听searchMore变化
    [[[RACObserve(self.viewModel, searchMore) skip:1] distinctUntilChanged] subscribeNext:^(NSNumber *x) {
        @strongify(self);
        
        BOOL searchMore = x.boolValue;
        
        if (searchMore) {
        
            // 立即获得当前self.view 的屏幕快照
            UIView *snapshotView = [self.view snapshotViewAfterScreenUpdates:NO];
            self.snapshotView = snapshotView;
            snapshotView.frame = self.view.bounds;
            [self.view addSubview:snapshotView];
            
            
            /// 取出控制器
            UIViewController *toViewController = [[MHSearchDefaultViewController alloc] initWithViewModel:self.viewModel.defaultViewModel];
            /// 调整frame
            toViewController.view.frame = self.view.bounds;
            toViewController.view.mh_x = self.view.bounds.size.width;
            
            /// 加入控制器
            [self.view addSubview:toViewController.view];
            [self addChildViewController:toViewController];
            [toViewController didMoveToParentViewController:self];
            
            [UIView animateWithDuration:.25f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                toViewController.view.mh_x = 0;
                snapshotView.mh_x = -MHOffsetWidth;
            } completion:^(BOOL finished) {
                /// 细节
                /// 由于cell按下会有个灰色块，这里重新截取快照，然后添加进去 替换掉之前的
                [self.snapshotView removeFromSuperview];
                self.snapshotView = nil;
                
                // 重新添加 移驾乱真
                UIView *snapshotView0 = [self.tableView snapshotViewAfterScreenUpdates:NO];
                self.snapshotView = snapshotView0;
                snapshotView0.frame = self.view.bounds;
                snapshotView.mh_x = -MHOffsetWidth;
                [self.view insertSubview:snapshotView0 belowSubview:toViewController.view];
                
            }];
            
            // 记录当前子控制器
            self.defaultViewController = toViewController;
            
        }else {
            if (self.defaultViewController) {
                // 这种事点击返回按钮
                if (self.snapshotView && self.snapshotView.mh_x < 0) {
                    /// 做动画
                    [UIView animateWithDuration:.25f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        self.defaultViewController.view.mh_x = self.view.bounds.size.width;
                        self.snapshotView.mh_x = 0;
                    } completion:^(BOOL finished) {
                        // 移除掉搜索更多xxx的view
                        [self _removeSearchDefaultViewController];
                    }];
                }else {
                    // 移除掉搜索更多xxx的view
                    [self _removeSearchDefaultViewController];
                }
            }
        }
    }];
    
    /// 监听popMoreCommand 回调
    [self.viewModel.popMoreCommand.executionSignals.switchToLatest subscribeNext:^(NSDictionary *dict) {
        @strongify(self);
        MHSearchPopState state = [dict[@"state"] integerValue];
        CGFloat progress = [dict[@"progress"] floatValue];
        
        if (state == MHSearchPopStateBegan || state == MHSearchPopStateChanged) {
            self.snapshotView.mh_x = -MHOffsetWidth + progress * MHOffsetWidth;
        }else if (state == MHSearchPopStateEnded) {
            // 归位
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
               self.snapshotView.mh_x = -MHOffsetWidth + 1 * progress * MHOffsetWidth;
            } completion:^(BOOL finished) {
            }];
        }
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
- (void)_removeSearchDefaultViewController {
    // 移除掉快照view
    [self.snapshotView removeFromSuperview];
    self.snapshotView = nil;
    
    [self.defaultViewController willMoveToParentViewController:nil];
    [self.defaultViewController.view removeFromSuperview];
    [self.defaultViewController removeFromParentViewController];
    // 置位
    self.defaultViewController = nil;
}


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
    NSArray *vms = self.viewModel.dataSource[indexPath.section];
    MHSearchDefaultItemViewModel *vm = vms[indexPath.row];
    if (vm.isSearchMore) {
        return [MHSearchDefaultMoreCell cellWithTableView:tableView];
    }else {
        if (vm.searchDefaultType == MHSearchDefaultTypeContacts) {
            return [MHSearchDefaultContactCell cellWithTableView:tableView];
        } else {
            return [MHSearchDefaultContactCell cellWithTableView:tableView];
        }
    }
    
    return nil;
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
    MHSearchCommonHeaderView *headerView = [MHSearchCommonHeaderView headerViewWithTableView:tableView];
    headerView.titleLabel.text = self.viewModel.sectionTitles[section];
    headerView.titleLabel.textColor = MHColorFromHexString(@"#808080");
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *vms = self.viewModel.dataSource[indexPath.section];
    MHSearchDefaultItemViewModel *vm = vms[indexPath.row];
    return vm.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = CGFLOAT_MIN;
    NSString *title = self.viewModel.sectionTitles[section];
    height = MHStringIsNotEmpty(title)?40.0f: CGFLOAT_MIN;
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 9.0;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    // execute commond
    [self.viewModel.didSelectCommand execute:indexPath];
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

    /// 语音输入View
    MHSearchVoiceInputView *voiceInputView = [MHSearchVoiceInputView voiceInputView];
    self.voiceInputView = voiceInputView;
    [self.view addSubview:voiceInputView];
}

/// 布局子控件
- (void)_makeSubViewsConstraints{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
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
