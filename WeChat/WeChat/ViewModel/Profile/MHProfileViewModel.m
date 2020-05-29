//
//  MHProfileViewModel.m
//  WeChat
//
//  Created by senba on 2017/9/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHProfileViewModel.h"
#import "MHUserInfoViewModel.h"
#import "MHSettingViewModel.h"
#import "MHEmotionViewModel.h"

#if defined(DEBUG)||defined(_DEBUG)
/// PS：调试模式，这里在ViewModel中引用了UIKite的东西， 但是release模式下无效，这里只是用作测试而已
#import "MHDebugTouchView.h"
#endif

@interface MHProfileViewModel()
/// The current `user`.
@property (nonatomic, readwrite , strong) MHUser *user;

@end


@implementation MHProfileViewModel

- (instancetype)initWithServices:(id<MHViewModelServices>)services params:(NSDictionary *)params{
    if (self = [super initWithServices:services params:params]) {
        /// 获取user
        self.user = [self.services.client currentUser];
    }
    return self;
}


- (void)initialize
{
    [super initialize];
    @weakify(self);
    self.title = @"我";
    
    /// 获取网络数据+本地数据
    RACSignal *fetchLocalDataSignal = [RACSignal return:[self fetchLocalData]];
    RACSignal *requestRemoteDataSignal = self.requestRemoteDataCommand.executionSignals.switchToLatest;
    [[[fetchLocalDataSignal
       merge:requestRemoteDataSignal]
      deliverOnMainThread]
     subscribeNext:^(MHUser *user) {
         @strongify(self)
         [self willChangeValueForKey:@"user"];
         /// user模型的数据 重置，但是user的 指针地址不变
         [self.user mergeValuesForKeysFromModel:user];
         [self didChangeValueForKey:@"user"];
     }];
    
    /// 配置数据
    [self _configureData];

}

/// 获取本地的用户数据
- (MHUser *)fetchLocalData{
    return [[self.services client] currentUser];
}
/// 回去网络的用户数据 用于比对
- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page
{
    return [RACSignal empty];
}


#pragma mark - 配置数据
- (void)_configureData{
    
    /// 第一组
    MHCommonGroupViewModel *group0 = [MHCommonGroupViewModel groupViewModel];
    /// 用户信息
    MHCommonProfileHeaderItemViewModel *profileHeader = [[MHCommonProfileHeaderItemViewModel alloc] initViewModelWithUser:self.user];
    /// 由于涉及到 更新用户的数据，这里最后把用户数据传递过去
//    profileHeader.destViewModelClass = [MHUserInfoViewModel class];
    @weakify(self);
    profileHeader.operation = ^{
        @strongify(self);
        MHUserInfoViewModel *viewModel = [[MHUserInfoViewModel alloc] initWithServices:self.services params:@{MHViewModelUtilKey:self.user}];
        [self.services pushViewModel:viewModel animated:YES];
        
    };
    profileHeader.rowHeight = 88.0f;
    group0.itemViewModels = @[profileHeader];
    
    /// 第一组
    MHCommonGroupViewModel *group1 = [MHCommonGroupViewModel groupViewModel];
    /// 支付
    MHCommonArrowItemViewModel *pay = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"支付" icon:@"icons_outlined_wechatpay.svg" svg:YES];
    /// 设置组头高度
    group1.itemViewModels = @[pay];
    
    /// 第二组
    MHCommonGroupViewModel *group2 = [MHCommonGroupViewModel groupViewModel];
    /// 收藏
    MHCommonArrowItemViewModel *collect = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"收藏" icon:@"icons_outlined_colorful_favorites.svg" svg:YES];
    /// 相册
    MHCommonArrowItemViewModel *album = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"相册" icon:@"icons_outlined_album.svg" svg:YES];
    album.svgTintColor = MHColorFromHexString(@"#1485EE");
    /// 卡包
    MHCommonArrowItemViewModel *cardPackage = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"卡包" icon:@"icons_outlined_colorful_cards.svg" svg:YES];
    /// 表情
    MHCommonArrowItemViewModel *expression = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"表情" icon:@"icons_outlined_sticker.svg" svg:YES];
    expression.destViewModelClass = [MHEmotionViewModel class];
    expression.svgTintColor = MHColorFromHexString(@"#F6C543");
    group2.itemViewModels = @[collect, album, cardPackage,expression];
    
    /// 第三组
    MHCommonGroupViewModel *group3 = [MHCommonGroupViewModel groupViewModel];
    /// 设置
    MHCommonArrowItemViewModel *setting = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"设置" icon:@"icons_outlined_setting.svg" svg:YES];
    setting.svgTintColor = MHColorFromHexString(@"#1485EE");
    setting.destViewModelClass = [MHSettingViewModel class];
    
#if defined(DEBUG)||defined(_DEBUG)
    /// 调试模式
    MHCommonArrowItemViewModel *debug = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"打开/关闭调试器" icon:@"mh_profile_debug_25x25"];
    debug.operation = ^{
        [[MHDebugTouchView sharedInstance] setHide:![MHDebugTouchView sharedInstance].isHide];
        [MHSharedAppDelegate.window bringSubviewToFront:[MHDebugTouchView sharedInstance]];
    };
    group3.itemViewModels = @[setting , debug];
#else
    /// 发布模式
    group3.itemViewModels = @[setting];
#endif
    self.dataSource = @[group0 , group1 , group2 , group3];
}
@end
