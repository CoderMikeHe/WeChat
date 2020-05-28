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
#import "MHSearchDefaultGroupChatCell.h"
#import "MHSearchDefaultMoreCell.h"
#import "MHSearchDefaultSearchCell.h"

#import "MHSearchDefaultItemViewModel.h"

/// 侧滑最大偏移量
static CGFloat const MHSlideOffsetMaxWidth = 56;

@interface MHSearchViewController ()<UIGestureRecognizerDelegate>

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
/// coverView
@property (nonatomic, readwrite, weak) UIView *coverView;
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
                snapshotView.mh_x = -MHSlideOffsetMaxWidth;
            } completion:^(BOOL finished) {
                /// 细节
                /// 由于cell按下会有个灰色块，这里重新截取快照，然后添加进去 替换掉之前的
                [self.snapshotView removeFromSuperview];
                self.snapshotView = nil;
                
                // 重新添加 移驾乱真
                UIView *snapshotView0 = [self.tableView snapshotViewAfterScreenUpdates:NO];
                self.snapshotView = snapshotView0;
                snapshotView0.frame = self.view.bounds;
                snapshotView0.mh_x = -MHSlideOffsetMaxWidth;
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
            self.snapshotView.mh_x = -MHSlideOffsetMaxWidth + progress * MHSlideOffsetMaxWidth;
        }else if (state == MHSearchPopStateEnded) {
            // 归位
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
               self.snapshotView.mh_x = -MHSlideOffsetMaxWidth + 1 * progress * MHSlideOffsetMaxWidth;
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
        } else if (vm.searchDefaultType == MHSearchDefaultTypeGroupChat) {
            return [MHSearchDefaultGroupChatCell cellWithTableView:tableView];
        } else if (vm.searchDefaultType == MHSearchDefaultTypeSearch) {
            return [MHSearchDefaultSearchCell cellWithTableView:tableView];
        } else{
            return nil;
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

// 侧滑事件
-(void)_panGestureDetected:(UIScreenEdgePanGestureRecognizer *)recognizer{
    
    // 计算手指滑的物理距离（滑了多远，与起始位置无关）
    CGFloat progress = [recognizer translationInView:recognizer.view].x /(recognizer.view.bounds.size.width);
    // 把这个百分比限制在0~1之间
    progress = MIN(1.0, MAX(0.0, progress));
    /*获取状态*/
    UIGestureRecognizerState state = [recognizer state];
    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged)
    {
        if (state == UIGestureRecognizerStateBegan) {
            self.coverView.hidden = NO;
            /// 数据回调出去
            NSDictionary *dict = @{@"state": @(MHSearchPopStateBegan), @"progress": @(progress)};
            [self.viewModel.popCommand execute: dict];
        }else {
            /// 数据回调出去
            NSDictionary *dict = @{@"state": @(MHSearchPopStateChanged), @"progress": @(progress)};
            [self.viewModel.popCommand execute: dict];
        }
        recognizer.view.mh_x = progress * recognizer.view.mh_width;
        
        
    } else if (state == UIGestureRecognizerStateEnded || state == UIGestureRecognizerStateCancelled) {
        if (progress <= 0.5) {
            /// 数据回调出去
            NSDictionary *dict = @{@"state": @(MHSearchPopStateEnded), @"progress": @0};
            [self.viewModel.popCommand execute: dict];            // 归位
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                recognizer.view.mh_x = 0;
            } completion:^(BOOL finished) {
            }];
        }else {
            /// 回调回去
            NSDictionary *dict = @{@"state": @(MHSearchPopStateEnded), @"progress": @1};
            [self.viewModel.popCommand execute: dict];
            // 返回
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                recognizer.view.mh_x = recognizer.view.bounds.size.width;
            } completion:^(BOOL finished) {
                /// 回调回去
                NSDictionary *dict = @{@"state": @(MHSearchPopStateCompleted), @"progress": @1};
                [self.viewModel.popCommand execute: dict];
                self.coverView.hidden = YES;
            }];
        }
        
    }
}

#pragma mark - UIGestureRecognizerDelegate
// 是否允许pan
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

/// 只有当系统侧滑手势失败了，才去触发ScrollView的滑动
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
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
    return section == self.viewModel.sectionTitles.count-1 ? 40.0f : 9.0;
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
    
    /// 添加一个边缘手势
    UIScreenEdgePanGestureRecognizer *panGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(_panGestureDetected:)];
    panGestureRecognizer.edges = UIRectEdgeLeft;
    [panGestureRecognizer setDelegate:self];
    [self.view addGestureRecognizer:panGestureRecognizer];
    
    /// 添加一个侧滑跟随的蒙版
    UIView *coverView = [[UIView alloc] initWithFrame:self.view.bounds];
    coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1f];
    // 默认是不需要蒙版的 只有侧滑时才需要
    coverView.hidden = YES;
    self.coverView = coverView;
    [self.view addSubview:coverView];
}

/// 布局子控件
- (void)_makeSubViewsConstraints{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.voiceInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(115.0f);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(200.0, 115));
    }];
    
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(self.view).with.offset(0);
        make.width.mas_equalTo(MH_SCREEN_WIDTH);
        make.right.equalTo(self.view.mas_left).with.offset(0);
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
