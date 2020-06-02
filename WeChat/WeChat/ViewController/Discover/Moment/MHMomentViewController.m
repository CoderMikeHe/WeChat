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
#import "MHMomentCommentToolView.h"

#import "MHNavSearchBar.h"

@interface MHMomentViewController ()
/// viewModel
@property (nonatomic, readonly, strong) MHMomentViewModel *viewModel;
/// tableHeaderView
@property (nonatomic, readwrite, weak) MHMomentProfileView *tableHeaderView;
/// commentToolView
@property (nonatomic, readwrite, weak) MHMomentCommentToolView *commentToolView;
/// 选中的索引 selectedIndexPath
@property (nonatomic, readwrite, strong) NSIndexPath * selectedIndexPath;
/// 记录键盘高度
@property (nonatomic, readwrite, assign) CGFloat keyboardHeight;

/// navBar
@property (nonatomic, readwrite, weak) MHNavigationBar *navBar;

/// 记录上一次的进度
@property (nonatomic, readwrite, assign) CGFloat lastProgress;

/// 状态栏样式
@property (nonatomic, readwrite, assign) UIStatusBarStyle statusBarStyle;

@end

@implementation MHMomentViewController
@dynamic viewModel;

- (void)dealloc{
    MHDealloc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// 设置
    [self _setup];
    
    /// 设置导航栏
    [self _setupNavigationItem];
    
    /// 设置子控件
    [self _setupSubViews];
    
    /// 布局子控件
    [self _makeSubViewsConstraints];
}

#pragma mark - Override
- (UIEdgeInsets)contentInset{
    return UIEdgeInsetsMake(MH_IS_IPHONE_X?-40:-64, 0, 0, 0);
}

- (void)bindViewModel{
    [super bindViewModel];
    /// ... 事件处理...
    @weakify(self);
    
    // 设置title
    RAC(self.navBar.titleLabel, text) = RACObserve(self.viewModel, title);
    
    
    /// 动态更新tableHeaderView的高度. PS:单纯的设置其高度无效的
    [[[RACObserve(self.viewModel.profileViewModel, unread)
      distinctUntilChanged]
     deliverOnMainThread]
     subscribeNext:^(NSNumber * unread) {
         @strongify(self);
         self.tableHeaderView.mh_height = self.viewModel.profileViewModel.height;
         [self.tableView beginUpdates];  // 过度动画
         self.tableView.tableHeaderView = self.tableHeaderView;
         [self.tableView endUpdates];
     }];
    
    /// 全文/收起
    [[self.viewModel.reloadSectionSubject deliverOnMainThread] subscribeNext:^(NSNumber * section) {
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
    [[self.viewModel.commentSubject deliverOnMainThread] subscribeNext:^(NSNumber * section) {
        @strongify(self);
        /// 记录选中的Section 这里设置Row为-1 以此来做判断
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:-1 inSection:section.integerValue];
        /// 显示评论
        [self _commentOrReplyWithItemViewModel:self.viewModel.dataSource[section.integerValue] indexPath:indexPath];
    }];
    
    /// 点击手机号码
    [[self.viewModel.phoneSubject deliverOnMainThread] subscribeNext:^(NSString * phoneNum) {

        LCActionSheet *sheet = [LCActionSheet sheetWithTitle:[NSString stringWithFormat:@"%@可能是一个电话号码，你可以",phoneNum] cancelButtonTitle:@"取消" clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
            if (buttonIndex == 0) return ;
        } otherButtonTitles:@"呼叫",@"复制号码",@"添加到手机通讯录", nil];
        [sheet show];
        
    }];
    
    /// 监听键盘 高度
    /// 监听按钮
    [[[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillChangeFrameNotification object:nil] takeUntil:self.rac_willDeallocSignal ]
      deliverOnMainThread]
     subscribeNext:^(NSNotification * notification) {
         @strongify(self);
         @weakify(self);
         [self mh_convertNotification:notification completion:^(CGFloat duration, UIViewAnimationOptions options, CGFloat keyboardH) {
             @strongify(self);
             if (keyboardH <= 0) {
                 keyboardH = -1 * self.commentToolView.mh_height;
             }
             self.keyboardHeight = keyboardH;
             /// 全局记录keyboardH
             AppDelegate.sharedDelegate.showKeyboard = (keyboardH > 0);
             // bottomToolBar距离底部的高
             [self.commentToolView mas_updateConstraints:^(MASConstraintMaker *make) {
                 make.bottom.equalTo(self.view).with.offset(-1 *keyboardH);
             }];
             // 执行动画
             [UIView animateWithDuration:duration delay:0.0f options:options animations:^{
                 // 如果是Masonry或者autoLayout UITextField或者UITextView 布局 必须layoutSubviews，否则文字会跳动
                 [self.view layoutSubviews];
                 
                 /// 滚动表格
                 [self _scrollTheTableViewForComment];
             } completion:nil];
         }];
     }];
    
    
    //// 监听commentToolView的高度变化
    [[RACObserve(self.commentToolView, toHeight) distinctUntilChanged] subscribeNext:^(NSNumber * toHeight) {
        @strongify(self);
        if (toHeight.floatValue < MHMomentCommentToolViewMinHeight) return ;
        /// 更新CommentView的高度
        [self.commentToolView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(toHeight);
        }];
        [UIView animateWithDuration:.25f animations:^{
            // 适当时候更新布局
            [self.view layoutSubviews];
            /// 滚动表格
            [self _scrollTheTableViewForComment];
        }];
    }];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    return [MHMomentContentCell cellWithTableView:tableView];
}

- (void)configureCell:(MHMomentContentCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object{
    MHMomentItemViewModel *itemViewModel =  self.viewModel.dataSource[indexPath.section];
    id model = itemViewModel.dataSource[indexPath.row];
    [cell bindViewModel:model];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    NSLog(@"🔥 设置状态栏样式 xxxx");
    return self.statusBarStyle;
}


#pragma mark - 辅助方法
- (void)_commentOrReplyWithItemViewModel:(id)itemViewModel indexPath:(NSIndexPath *)indexPath{
    /// 传递数据 (生成 replyItemViewModel)
    MHMomentReplyItemViewModel *viewModel = [[MHMomentReplyItemViewModel alloc] initWithItemViewModel:itemViewModel];
    viewModel.section = indexPath.section;
    viewModel.commentCommand = self.viewModel.commentCommand;
    self.selectedIndexPath = indexPath; /// 记录indexPath
    [self.commentToolView bindViewModel:viewModel];
    /// 键盘弹起
    [self.commentToolView  mh_becomeFirstResponder];
}

/// 评论的时候 滚动tableView
- (void)_scrollTheTableViewForComment{
    CGRect rect = CGRectZero;
    CGRect rect1 = CGRectZero;
    if (self.selectedIndexPath.row == -1) {
        /// 获取整个尾部section对应的尺寸 获取的rect是相当于tableView的尺寸
        rect = [self.tableView rectForFooterInSection:self.selectedIndexPath.section];
        /// 将尺寸转化到window的坐标系 （关键点）
        rect1 = [self.tableView convertRect:rect toViewOrWindow:nil];
    }else{
        /// 回复
        /// 获取整个尾部section对应的尺寸 获取的rect是相当于tableView的尺寸
        rect = [self.tableView rectForRowAtIndexPath:self.selectedIndexPath];
        /// 将尺寸转化到window的坐标系 （关键点）
        rect1 = [self.tableView convertRect:rect toViewOrWindow:nil];
    }
    
    if (self.keyboardHeight > 0) { /// 键盘抬起 才允许滚动
        /// 这个就是你需要滚动差值
        CGFloat delta = self.commentToolView.mh_top - rect1.origin.y - rect1.size.height;
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y-delta) animated:NO];
    }else{
        /// #Bug
        /// 如果处于最后一个，需要滚动到底部
        if(self.selectedIndexPath.section == self.viewModel.dataSource.count-1){
            /// 去掉抖动
            [UIView performWithoutAnimation:^{
                [self.tableView scrollToBottomAnimated:NO];
            }];
        }
    }
}


/// PS:这里复写了 MHTableViewController 里面的UITableViewDelegate和UITableViewDataSource的方法，所以大家不需要过多关注 MHTableViewController的里面的UITableViewDataSource方法
#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MHMomentItemViewModel *itemViewModel =  self.viewModel.dataSource[section];
    return itemViewModel.dataSource.count;
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

/// 点击Cell的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    /// 先取出该section的说说
    MHMomentItemViewModel *itemViweModel = self.viewModel.dataSource[section];
    /// 然后取出该 row 的评论Or点赞
    MHMomentContentItemViewModel *contentItemViewModel = itemViweModel.dataSource[row];
    /// 去掉点赞
    if ([contentItemViewModel isKindOfClass:MHMomentAttitudesItemViewModel.class]) {
        [self.commentToolView mh_resignFirstResponder];
        return;
    }

    /// 判断是否是自己的评论  或者 回复
    MHMomentCommentItemViewModel *commentItemViewModel = (MHMomentCommentItemViewModel *)contentItemViewModel;
    if ([commentItemViewModel.comment.fromUser.idstr isEqualToString: self.viewModel.services.client.currentUser.idstr]) {
        /// 关掉键盘
        [self.commentToolView  mh_resignFirstResponder];
        
        /// 自己评论的活回复他人
        @weakify(self);
        LCActionSheet *sheet = [LCActionSheet sheetWithTitle:nil cancelButtonTitle:@"取消" clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
            if (buttonIndex == 0) return ;
            @strongify(self);
            /// 删除数据源
            [self.viewModel.delCommentCommand execute:indexPath];
    
        } otherButtonTitles:@"删除", nil];
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:1];
        sheet.destructiveButtonIndexSet = indexSet;
        [sheet show];
        return;
    }
    
    /// 键盘已经显示 你就先关掉键盘
    if (MHSharedAppDelegate.isShowKeyboard) {
        [self.commentToolView mh_resignFirstResponder];
        return;
    }
    /// 评论
    [self _commentOrReplyWithItemViewModel:contentItemViewModel indexPath:indexPath];
}


// custom view for cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    // fetch object 报错 why???
//    id object  = [self.viewModel.dataSource[indexPath.section] dataSource][indexPath.row];
    MHMomentItemViewModel *itemViewModel = self.viewModel.dataSource[indexPath.section];
    id object = itemViewModel.dataSource[indexPath.row];
    /// bind model
    [self configureCell:cell atIndexPath:indexPath withObject:(id)object];
    return cell;
}

/// 设置高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    MHMomentItemViewModel *itemViewModel = self.viewModel.dataSource[section];
    /// 这里每次刷新都会走两次！！！ Why？？？
    NSLog(@"KKKKKK ------- %ld ",section);
    return itemViewModel.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MHMomentItemViewModel *itemViewModel =  self.viewModel.dataSource[indexPath.section];
    /// 这里用 id 去指向（但是一定要确保取出来的模型有 `cellHeight` 属性 ，否则crash）
    id model = itemViewModel.dataSource[indexPath.row];
    return [model cellHeight];
}

/// 监听滚动到顶部
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    /// 这里下拉刷新
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    /// 处理popView
    [MHMomentHelper hideAllPopViewWithAnimated:NO];
}

// 这里监听 滚动 实现导航栏背景色渐变 + 状态栏颜色变化 + 图标颜色变化
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    /// 计算临界点
    CGFloat insertTop = UIApplication.sharedApplication.statusBarFrame.size.height + 44 * .5f;
    /// 51 是用户头像突出部分的高度
    CGFloat cPoint = MH_SCREEN_WIDTH - 51 - insertTop;
    /// 计算偏差
    CGFloat delta = scrollView.contentOffset.y - cPoint;
    /// 导航栏高度
    CGFloat height = UIApplication.sharedApplication.statusBarFrame.size.height + 44;
    /// 计算精度
    double progress = .0f;
    
    if (delta < 0) {
        progress = .0f;
        /// 证明相等 do nothing...
        if (self.lastProgress - progress< 0.00000001) {
            self.lastProgress = progress;
            return ;
        }
    }else {
        if (delta > height) {
            progress = 1.0f;
            if (progress - self.lastProgress < 0.00000001) {
                self.lastProgress = progress;
                return ;
            }
        } else {
            progress = delta/height;
        }
    }
    
    self.lastProgress = progress;
    
    static NSArray<NSNumber *> *defaultTintColors;
    static NSMutableArray<NSNumber *> *selectedTintDeltaColors;

    if (selectedTintDeltaColors.count == 0) {
        UIColor *defaultTintColor = [UIColor whiteColor];
        UIColor *selectedTintColor = MHColorFromHexString(@"#181818");
        
        defaultTintColors = [defaultTintColor rgbaArray];
        NSArray<NSNumber *> *selectedTintColors = [selectedTintColor rgbaArray];
        
        selectedTintDeltaColors = @[].mutableCopy;
        
        for (int i = 0; i < 4; i++) {
            double tintDelta = selectedTintColors[i].doubleValue - defaultTintColors[i].doubleValue;
            [selectedTintDeltaColors addObject:@(tintDelta)];
        }
    }
    
    NSMutableArray<NSNumber *> *tintClors = @[].mutableCopy;
    for (int i = 0; i < 4; i++) {
        double tint = defaultTintColors[i].doubleValue + progress * selectedTintDeltaColors[i].doubleValue;
        [tintClors addObject:@(tint)];
    }
    /// 设置背景色
    /// 注意bgColor 只是从 alpha 0 -> 1 的过程 R/G/B 前后保持一致
    self.navBar.backgroundColor = [MHColorFromHexString(@"#ededed") colorWithAlphaComponent:progress];;
    
    /// 设置标题颜色
    self.navBar.titleLabel.textColor = [MHColorFromHexString(@"#181818") colorWithAlphaComponent:progress];
    
    /// 设置图标颜色 black25PercentColor
    UIColor *tintColor = [UIColor colorFromRGBAArray:tintClors];
    UIColor *tint50PercentColor = [[UIColor colorFromRGBAArray:tintClors] colorWithAlphaComponent:.5f];
    
    /// 设置导航栏样式
    NSString *imageName = @"icons_filled_camera.svg";
    if (progress > 0.35) {
        imageName = @"icons_outlined_camera.svg";
    }
    
    // 0.2 -> 0.3  alpha 1 --> 0
    // 0.3 -> 0.4  alpha 0
    // 0.4 -> 0.5  alpha 0 --> 1
    /// 这个范围 alpha 0 --> 1
    if (progress < 0.2) {
        self.navBar.rightButton.alpha = 1.0f;
    } else if (progress >= 0.2 && progress < 0.3) {
        self.navBar.rightButton.alpha = 1 - (progress - 0.2) * 10;
    } else if (progress >= 0.3 && progress < 0.4) {
        self.navBar.rightButton.alpha = .0f;
    } else if (progress >= 0.4 && progress < 0.5) {
        self.navBar.rightButton.alpha = (progress - 0.4) * 10;
    } else {
        self.navBar.rightButton.alpha = 1.0f;
    }
    
    /// <0.5 白色 否则黑色 注意样式不等才去更新
    if (progress < .5f) {
        if (self.statusBarStyle != UIStatusBarStyleLightContent) {
            self.statusBarStyle = UIStatusBarStyleLightContent;
            [self setNeedsStatusBarAppearanceUpdate];
        }
    } else {
        if (self.statusBarStyle != UIStatusBarStyleDefault) {
            self.statusBarStyle = UIStatusBarStyleDefault;
            [self setNeedsStatusBarAppearanceUpdate];
        }
    }

    UIImage *image = [UIImage mh_svgImageNamed:imageName targetSize:CGSizeMake(24.0, 24.0) tintColor: tintColor];
    UIImage *imageHigh = [UIImage mh_svgImageNamed:imageName targetSize:CGSizeMake(24.0, 24.0) tintColor: tint50PercentColor];
    [self.navBar.rightButton setImage:image forState:UIControlStateNormal];
    [self.navBar.rightButton setImage:imageHigh forState:UIControlStateHighlighted];
    
    UIImage *image0 = [UIImage mh_svgImageNamed:@"icons_outlined_back.svg" targetSize:CGSizeMake(12.0, 24.0) tintColor:tintColor];
    UIImage *imageHigh0 = [UIImage mh_svgImageNamed:@"icons_outlined_back.svg" targetSize:CGSizeMake(12.0, 24.0) tintColor:tint50PercentColor];
    [self.navBar.leftButton setImage:image0 forState:UIControlStateNormal];
    [self.navBar.leftButton setImage:imageHigh0 forState:UIControlStateHighlighted];
}



#pragma mark - 初始化
- (void)_setup{
    /// 配置tableView
    self.tableView.backgroundColor = [UIColor whiteColor];
    /// 固定高度-这样写比使用代理性能好，且使用代理会获取每次刷新数据会调用两次代理 ，苹果的bug
    self.tableView.sectionFooterHeight =  MHMomentFooterViewHeight;
    
    self.lastProgress = .0f;
    self.statusBarStyle = UIStatusBarStyleLightContent;
}

#pragma mark - 初始化子控件
- (void)_setupSubViews{
    
    // 自定义导航栏
    MHNavigationBar *navBar = [MHNavigationBar navigationBar];
    navBar.backgroundColor = [UIColor clearColor];
    navBar.titleLabel.textColor = [MHColorFromHexString(@"#181818") colorWithAlphaComponent:.0];;
    
    UIImage *image = [UIImage mh_svgImageNamed:@"icons_filled_camera.svg" targetSize:CGSizeMake(24.0, 24.0) tintColor:MHColorFromHexString(@"#FFFFFF")];
    UIImage *imageHigh = [UIImage mh_svgImageNamed:@"icons_filled_camera.svg" targetSize:CGSizeMake(24.0, 24.0) tintColor:[MHColorFromHexString(@"#FFFFFF") colorWithAlphaComponent:0.5]];
    [navBar.rightButton setImage:image forState:UIControlStateNormal];
    [navBar.rightButton setImage:imageHigh forState:UIControlStateHighlighted];
    
    UIImage *image0 = [UIImage mh_svgImageNamed:@"icons_outlined_back.svg" targetSize:CGSizeMake(12.0, 24.0) tintColor:MHColorFromHexString(@"#FFFFFF")];
    UIImage *imageHigh0 = [UIImage mh_svgImageNamed:@"icons_outlined_back.svg" targetSize:CGSizeMake(12.0, 24.0) tintColor:[MHColorFromHexString(@"#FFFFFF") colorWithAlphaComponent:0.5]];
    [navBar.leftButton setImage:image0 forState:UIControlStateNormal];
    [navBar.leftButton setImage:imageHigh0 forState:UIControlStateHighlighted];
    @weakify(self);
    [[navBar.leftButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel.services popViewModelAnimated:YES];
    }];
    
    self.navBar = navBar;
    [self.view addSubview:navBar];
    
    
    /// 个人信息view
    MHMomentProfileView *tableHeaderView = [[MHMomentProfileView alloc] init];
    [tableHeaderView bindViewModel:self.viewModel.profileViewModel];
    self.tableView.tableHeaderView = tableHeaderView;
    self.tableView.tableHeaderView.mh_height = self.viewModel.profileViewModel.height;
    self.tableHeaderView = tableHeaderView;

    /// 这里设置下拉黑色的背景图
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:MH_SCREEN_BOUNDS];
    backgroundView.mh_size = MH_SCREEN_BOUNDS.size;
    backgroundView.image = MHImageNamed(@"wx_around-friends_bg_320x568");
    backgroundView.mh_y = -backgroundView.mh_height;
    [self.tableView addSubview:backgroundView];
    
    
    /// 添加评论View
    MHMomentCommentToolView *commentToolView = [[MHMomentCommentToolView alloc] init];
    self.commentToolView = commentToolView;
    [self.view addSubview:commentToolView];
    [commentToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(60);
        make.bottom.equalTo(self.view).with.offset(60);
    }];
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

#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints{
    
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.equalTo(self.view);
        make.height.mas_equalTo(MH_APPLICATION_TOP_BAR_HEIGHT);
    }];
}





@end
