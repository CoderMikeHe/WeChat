//
//  MHPlugDetailViewController.m
//  WeChat
//
//  Created by senba on 2017/10/16.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHPlugDetailViewController.h"
#import "MHPhotoManager.h"
@interface MHPlugDetailViewController ()<IDMPhotoBrowserDelegate>
/// viewModel
@property (nonatomic, readonly, strong) MHPlugDetailViewModel *viewModel;
/// containerView
@property (weak, nonatomic) IBOutlet UIView *containerView;
/// 图标
@property (weak, nonatomic) IBOutlet UIImageView *plugLogo;

/// 类型名称
@property (weak, nonatomic) IBOutlet UILabel *typeTitleLabel;
/// 类型说明
@property (weak, nonatomic) IBOutlet UILabel *typeIntroLabel;
/// 预览
@property (weak, nonatomic) IBOutlet UIImageView *previewView;
/// openTitleLabel
@property (weak, nonatomic) IBOutlet UILabel *openTitleLabel;
/// 开启或关闭
@property (weak, nonatomic) IBOutlet UISwitch *onSwitch;

@end

@implementation MHPlugDetailViewController

@dynamic viewModel;

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    /// 设置颜色
    [self.navigationController.navigationBar setBarTintColor:MH_MAIN_NAVIGATIONBAR_BACKGROUNDCOLOR_4];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    /// 设置颜色
    [self.navigationController.navigationBar setBarTintColor:MH_MAIN_NAVIGATIONBAR_BACKGROUNDCOLOR_1];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    /// 设置
    [self _setup];
    
    /// 设置导航栏
    [self _setupNavigationItem];
    
    /// 设置子控件
    [self _setupSubViews];
}


#pragma mark - 事件处理
- (IBAction)_switchValueDidChanged:(UISwitch *)sender {
    /// 存储数据
    [MHPreferenceSettingHelper setBool:sender.isOn forKey:(self.viewModel.type == MHPlugDetailTypeLook)?MHPreferenceSettingLook:MHPreferenceSettingSearch];
    
    if (![MHPreferenceSettingHelper boolForKey:(self.viewModel.type == MHPlugDetailTypeLook)?MHPreferenceSettingLookArtboard:MHPreferenceSettingSearchArtboard] && sender.isOn) {
        [MHPreferenceSettingHelper setBool:YES forKey:(self.viewModel.type == MHPlugDetailTypeLook)?MHPreferenceSettingLookArtboard:MHPreferenceSettingSearchArtboard];
    }
    
    /// 发送通知
    [MHNotificationCenter postNotificationName:MHPlugSwitchValueDidChangedNotification object:nil];
}

- (IBAction)_feedbackBtnDidClicked:(UIButton *)sender {
    [self.viewModel.feedbackCommand execute:nil];
}
#pragma mark - 初始化
- (void)_setup{
    UIScrollView *scrollView = (UIScrollView *)self.view;
    scrollView.alwaysBounceVertical = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.backgroundColor = MH_MAIN_NAVIGATIONBAR_BACKGROUNDCOLOR_4;
    self.containerView.backgroundColor = MH_MAIN_NAVIGATIONBAR_BACKGROUNDCOLOR_4;
    /// 适配 iOS 11
    MHAdjustsScrollViewInsets_Never(scrollView);
}

#pragma mark - 设置导航栏
- (void)_setupNavigationItem{
}

#pragma mark - 设置子控件
- (void)_setupSubViews{
    @weakify(self);
    /// 判断一下 搜一搜
    if (self.viewModel.type == MHPlugDetailTypeSearch) {
        self.plugLogo.image = [UIImage mh_imageAlwaysShowOriginalImageWithImageName:@"ff_IconSearch1_25x25"];
        self.typeTitleLabel.text = @"搜一搜";
        self.typeIntroLabel.text = @"你可以在\"发现\"中，找到\"搜一搜\"入口，快速查找微信内及互联网信息。";
        self.openTitleLabel.text = @"应用搜一搜";
        self.previewView.image = MHImageNamed(@"search");
    }
    
    /// 初始化值
    [self.onSwitch setOn:[MHPreferenceSettingHelper boolForKey:(self.viewModel.type == MHPlugDetailTypeLook)?MHPreferenceSettingLook:MHPreferenceSettingSearch] animated:YES];
    
    /// 点击图片添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [self.previewView addGestureRecognizer:tap];
    [tap.rac_gestureSignal subscribeNext:^(id x) {
        @strongify(self);
        IDMPhoto *photo = [IDMPhoto photoWithImage:self.previewView.image];
        [MHPhotoManager showPhotoBrowser:self photos:@[photo] initialPageIndex:0 animatedFromView:self.previewView scaleImage:self.previewView.image delegate:self];
    }];
}

@end
