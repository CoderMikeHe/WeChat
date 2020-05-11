//
//  MHSearchViewController.m
//  WeChat
//
//  Created by admin on 2020/5/6.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchViewController.h"
#import "MHSearchTypeView.h"
//#import "MHSearchOfficialAccountsView.h"
#import "MHSearchMusicView.h"
#import "MHSearchVoiceInputView.h"

#import "MHSearchOfficialAccountsViewController.h"



@interface MHSearchViewController ()
/// scrollView
@property (nonatomic, readwrite, weak) UIScrollView *scrollView;
/// containerView
@property (nonatomic, readwrite, weak) UIView *containerView;

/// searchTypeView
@property (nonatomic, readwrite, weak) MHSearchTypeView *searchTypeView;

/// officialAccountsView
//@property (nonatomic, readwrite, strong) MHSearchOfficialAccountsView *officialAccountsView;

/// voiceInputView
@property (nonatomic, readwrite, weak) MHSearchVoiceInputView *voiceInputView;

/// MusicView
@property (nonatomic, readwrite, strong) MHSearchMusicView *musicView;

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
    [[self.viewModel.searchTypeSubject deliverOnMainThread] subscribeNext:^(NSNumber *x) {
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
    
    
    /// 监听子控制器 侧滑返回
    [[self.viewModel.popItemSubject deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self);
        [self.currentViewController willMoveToParentViewController:nil];
        [self.currentViewController.view removeFromSuperview];
        [self.currentViewController removeFromParentViewController];
        
        // 置位 必须置位nil 
        self.currentViewController = nil;
        
        // 修改 navSearchBar 的 searchType
        [self.viewModel.searchTypeSubject sendNext:@(MHSearchTypeDefault)];
    }];
}

#pragma mark - 事件处理Or辅助方法
- (void)_configureSearchView:(MHSearchType)type {
//    self.view.userInteractionEnabled = NO;
//
//    /// 先隐藏所有的View
//    self.officialAccountsView.alpha = .0f;
//    self.musicView.alpha = .0;
//    self.searchTypeView.alpha = .0f;
//
//    // 更新布局
//    [UIView animateWithDuration:0.25 animations:^{
//        switch (type) {
//            case MHSearchTypeOfficialAccounts:
//            {
//                self.officialAccountsView.alpha = 1.0;
//            }
//                break;
//            case MHSearchTypeMusic:
//            {
//                self.officialAccountsView.alpha = .0;
//            }
//                break;
//            case MHSearchTypeSticker:
//            {
//                self.officialAccountsView.alpha = .0;
//                self.musicView.alpha = .0;
//            }
//                break;
//            default:
//            {
//                self.searchTypeView.alpha = 1.0f;
//            }
//                break;
//        }
//
//
//    } completion:^(BOOL finished) {
//        self.view.userInteractionEnabled = YES;
//    }];
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
    UIViewController *toViewController = self.viewControllers.firstObject;
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
    
    
//    switch (type) {
//        case MHSearchTypeOfficialAccounts:
//        {
//            // 添加view
//        }
//            break;
//        case MHSearchTypeMusic:
//        {
//            self.officialAccountsView.alpha = .0;
//        }
//            break;
//        case MHSearchTypeSticker:
//        {
//            self.officialAccountsView.alpha = .0;
//            self.musicView.alpha = .0;
//        }
//            break;
//        default:
//        {
//            self.searchTypeView.alpha = 1.0f;
//        }
//            break;
//    }

    
    
}




#pragma mark - 初始化OrUI布局
/// 初始化
- (void)_setup{
    
}

/// 设置导航栏
- (void)_setupNavigationItem{
    
}


#pragma mark - 初始化子控制器
- (void)_setupChildController {
    // 公众号
    MHSearchOfficialAccountsViewController *officialAccounts = [[MHSearchOfficialAccountsViewController alloc] initWithViewModel:self.viewModel.officialAccountsViewModel];
    [self.viewControllers addObject:officialAccounts];
}

/// 初始化子控件
- (void)_setupSubviews{
    
    // scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.alwaysBounceVertical = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    /// 适配 iOS 11
    MHAdjustsScrollViewInsets_Never(scrollView);
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    /// containerView
    UIView *containerView = [[UIView alloc] init];
    [scrollView addSubview:containerView];
    self.containerView = containerView;
    
    // searchTypeView
    MHSearchTypeView *searchTypeView = [MHSearchTypeView searchTypeView];
    self.searchTypeView = searchTypeView;
    [searchTypeView bindViewModel:self.viewModel.searchTypeViewModel];
    [containerView addSubview:searchTypeView];
    
    // OfficialAccountsView
//    MHSearchOfficialAccountsView *officialAccountsView = [MHSearchOfficialAccountsView officialAccountsView];
//    [officialAccountsView bindViewModel:self.viewModel.officialAccountsViewModel];
//    self.officialAccountsView = officialAccountsView;
//    officialAccountsView.alpha = .0;
//    [containerView addSubview:officialAccountsView];
    
    // musicView
    MHSearchMusicView *musicView = [MHSearchMusicView musicView];
    self.musicView = musicView;
    musicView.alpha = .0;
    [containerView addSubview:musicView];
    
    // 设置背景色
    containerView.backgroundColor = searchTypeView.backgroundColor = self.view.backgroundColor;
    
    
    /// 语音输入View
    MHSearchVoiceInputView *voiceInputView = [MHSearchVoiceInputView voiceInputView];
    self.voiceInputView = voiceInputView;
    [self.view addSubview:voiceInputView];
}

/// 布局子控件
- (void)_makeSubViewsConstraints{
    
    // 设置view
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    /// 设置contentSize
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(MH_SCREEN_WIDTH);
        make.height.mas_equalTo(MH_SCREEN_HEIGHT);
    }];
    
    /// 布局搜索类型
    [self.searchTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.containerView);
        make.top.equalTo(self.containerView).with.offset(39.0);
    }];
    
    /// 布局公众号
//    [self.officialAccountsView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.and.right.equalTo(self.containerView);
//    }];
//    
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
