//
//  MHSearchDefaultViewController.m
//  WeChat
//
//  Created by admin on 2020/5/21.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchDefaultViewController.h"
#import "MHSearchCommonHeaderView.h"
#import "MHSearchDefaultContactCell.h"
#import "MHSearchDefaultNoResultCell.h"

@interface MHSearchDefaultViewController ()<UIGestureRecognizerDelegate>
/// viewModel
@property (nonatomic, readonly, strong) MHSearchDefaultViewModel *viewModel;
/// coverView
@property (nonatomic, readwrite, weak) UIView *coverView;
@end

@implementation MHSearchDefaultViewController
@dynamic viewModel;

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


#pragma mark - Override
/// 返回自定义的cell
- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{

    MHSearchDefaultItemViewModel *vm = self.viewModel.dataSource[indexPath.row];
    if (vm.searchDefaultType == MHSearchDefaultTypeContacts) {
        return [MHSearchDefaultContactCell cellWithTableView:tableView];
    } else if (vm.searchDefaultType == MHSearchDefaultTypeNoResult){
        return [MHSearchDefaultNoResultCell cellWithTableView:tableView];
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
            [self.viewModel.popCommand execute: dict];
            // 归位
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
    headerView.titleLabel.text = self.viewModel.sectionTitle;
    headerView.titleLabel.textColor = MHColorFromHexString(@"#808080");
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MHSearchDefaultItemViewModel *vm = self.viewModel.dataSource[indexPath.row];
    return vm.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return MHStringIsNotEmpty(self.viewModel.sectionTitle) ? 40.0f : CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
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
    /// 布局好tableView
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(self.view).with.offset(0);
        make.width.mas_equalTo(MH_SCREEN_WIDTH);
        make.right.equalTo(self.view.mas_left).with.offset(0);
    }];
}


@end
