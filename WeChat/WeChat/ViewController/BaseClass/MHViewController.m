//
//  MHViewController.m
//  WeChat
//
//  Created by senba on 2017/9/10.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHViewController.h"
#import "MHNavigationController.h"
@interface MHViewController ()

// viewModel
@property (nonatomic, readwrite, strong) MHViewModel *viewModel;
/// navBarDivider
@property (nonatomic, readwrite, weak) UIView *navBarDivider;
@end

@implementation MHViewController

- (void)dealloc
{
    /// 销毁时保存数据
//    [SBPhotoManager configureSelectOriginalPhoto:_isSelectOriginalPhoto];
    MHDealloc;
}

// when `BaseViewController ` created and call `viewDidLoad` method , execute `bindViewModel` method
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    MHViewController *viewController = [super allocWithZone:zone];
    @weakify(viewController)
    [[viewController
      rac_signalForSelector:@selector(viewDidLoad)]
     subscribeNext:^(id x) {
         @strongify(viewController)
         [viewController bindViewModel];
     }];
    return viewController;
}

- (instancetype)initWithViewModel:(MHViewModel *)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    /// 隐藏导航栏细线 wechat 7.0.0-
//    self.viewModel.prefersNavigationBarBottomLineHidden?[(MHNavigationController *)self.navigationController hideNavigationBottomLine]:[(MHNavigationController *)self.navigationController showNavigationBottomLine];
    
    /// 配置键盘
    IQKeyboardManager.sharedManager.enable = self.viewModel.keyboardEnable;
    IQKeyboardManager.sharedManager.shouldResignOnTouchOutside = self.viewModel.shouldResignOnTouchOutside;
    IQKeyboardManager.sharedManager.keyboardDistanceFromTextField = self.viewModel.keyboardDistanceFromTextField;
    
    /// 这里做友盟统计
    //    [MobClick beginLogPageView:SBPageName(self)];
    
    //// 将自定义的分割线搞到最前面来
    [self.view bringSubviewToFront:self.navBarDivider];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.viewModel.willDisappearSignal sendNext:nil];
    
    // Being popped, take a snapshot
    if ([self isMovingFromParentViewController]) {
        self.snapshot = [self.navigationController.view snapshotViewAfterScreenUpdates:NO];
    }
    
    /// 这里做友盟统计tr
    //    [MobClick endLogPageView:SBPageName(self)];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    /// ignore adjust auto scroll 64
    /// CoderMikeHe: 适配 iOS 11.0 ,iOS11以后，控制器的automaticallyAdjustsScrollViewInsets已经废弃，所以默认就会是YES
    /// iOS 11新增：adjustContentInset 和 contentInsetAdjustmentBehavior 来处理滚动区域
    /// 
    if (@available(iOS 11.0, *)) {
        self.automaticallyAdjustsScrollViewInsets = YES;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    /// backgroundColor
    self.view.backgroundColor = MH_MAIN_BACKGROUNDCOLOR;
    
    /// 导航栏隐藏 只能在ViewDidLoad里面加载，无法动态
    self.fd_prefersNavigationBarHidden = self.viewModel.prefersNavigationBarHidden;
    
    /// pop手势
    self.fd_interactivePopDisabled = self.viewModel.interactivePopDisabled;
    
    /// 先记录
//    self.isSelectOriginalPhoto = [SBPhotoManager isSelectOriginalPhoto];
    /// 后重置
//    [SBPhotoManager configureSelectOriginalPhoto:NO];
    
    
    //// 20200606 ADD: 考虑到 v7.0.0+ 版本 导航栏的分割线的显示是动态的显示隐藏的, 这里在基类里面统一处理
    //// eg: 默认 当处于顶部是隐藏的 当你往上滚动的时候显示，向下滚动隐藏
    CGFloat navBarDividerY = self.viewModel.prefersNavigationBarHidden ? 0.0 : (UIApplication.sharedApplication.statusBarFrame.size.height + 44.0f);
    CGFloat navBarDividerW = MH_SCREEN_WIDTH;
    CGFloat navBarDividerH = MHGlobalBottomLineHeight;
    UIView *navBarDivider = [[UIView alloc] initWithFrame:CGRectMake(0, navBarDividerY, navBarDividerW, navBarDividerH)];
    navBarDivider.backgroundColor = MHColorFromHexString(@"#d5d5d5");
    navBarDivider.hidden = YES;
    self.navBarDivider = navBarDivider;
    [self.view addSubview:navBarDivider];
}


// bind the viewModel
- (void)bindViewModel{
    /// set navgation title
    /// CoderMikeHe Fixed: 这里只是单纯设置导航栏的title。 不然以免self.title同时设置了navigatiItem.title, 同时又设置了tabBarItem.title
    
    NSLog(@"--- %@" , self.viewModel.title);
    @weakify(self);
    
    RAC(self.navigationItem , title) = RACObserve(self, viewModel.title);
    /// 绑定错误信息
    [self.viewModel.errors subscribeNext:^(NSError *error) {
        /// 这里可以统一处理某个错误，例如用户授权失效的的操作
        NSLog(@"...错误...");
    }];
    
    /// 动态改变侧滑
    [[[RACObserve(self.viewModel, interactivePopDisabled) distinctUntilChanged] deliverOnMainThread] subscribeNext:^(NSNumber * x) {
        @strongify(self);
        self.fd_interactivePopDisabled = x.boolValue;
    }];
    
    /// 动态控制其导航栏底部分割线显示隐藏 默认都是隐藏 所以要跳过一个
    RAC(self.navBarDivider, hidden) = [[RACObserve(self.viewModel, prefersNavigationBarBottomLineHidden) skip:1] distinctUntilChanged];
}

#pragma mark - Orientation
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {return UIInterfaceOrientationMaskPortrait;}
- (BOOL)shouldAutorotate {return YES;}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {return UIInterfaceOrientationPortrait;}

#pragma mark - Status bar
- (BOOL)prefersStatusBarHidden { return NO; }
- (UIStatusBarStyle)preferredStatusBarStyle { return UIStatusBarStyleDefault; }
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation { return UIStatusBarAnimationFade; }

@end
