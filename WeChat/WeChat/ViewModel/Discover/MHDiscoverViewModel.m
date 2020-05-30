//
//  MHDiscoverViewModel.m
//  WeChat
//
//  Created by senba on 2017/9/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHDiscoverViewModel.h"
#import "MHWebViewModel.h"
#import "MHMomentViewModel.h"
@implementation MHDiscoverViewModel

- (instancetype)initWithServices:(id<MHViewModelServices>)services params:(NSDictionary *)params
{
    if (self = [super initWithServices:services params:params]) {
        /// 监听通知
        @weakify(self);
        [[MHNotificationCenter rac_addObserverForName:MHPlugSwitchValueDidChangedNotification object:nil] subscribeNext:^(id _) {
            @strongify(self);
            /// 配置数据
            [self _configureData];
        }];
    }
    return self;
}

- (void)initialize
{
    [super initialize];
    self.title = @"发现";
    /// 配置数据
    [self _configureData];
}
#pragma mark - 配置数据
- (void)_configureData{
    
    @weakify(self);
    
    /// 第一组
    MHCommonGroupViewModel *group0 = [MHCommonGroupViewModel groupViewModel];
    /// 盆友圈
    MHCommonArrowItemViewModel *moment = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"朋友圈" icon:@"icons_outlined_colorful_moment.svg" svg:YES];
    moment.destViewModelClass = [MHMomentViewModel class];
    group0.itemViewModels = @[moment];
    
    /// 第二组
    MHCommonGroupViewModel *group1 = [MHCommonGroupViewModel groupViewModel];
    /// 视频号
    MHCommonArrowItemViewModel *finder = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"视频号" icon:@"icons_outlined_finder.svg" svg:YES];
    finder.svgTintColor = MHColorFromHexString(@"#EDA150");
    finder.destViewModelClass = [MHMomentViewModel class];
    group1.itemViewModels = @[finder];
    
    
    /// 第三组
    MHCommonGroupViewModel *group2 = [MHCommonGroupViewModel groupViewModel];
    /// 扫一扫
    MHCommonArrowItemViewModel *qrCode = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"扫一扫" icon:@"scan_history_msg.svg" svg:YES];
    /// 摇一摇
    MHCommonArrowItemViewModel *shake = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"摇一摇" icon:@"icons_outlined_shake.svg" svg:YES];
    shake.svgTintColor = MHColorFromHexString(@"#1485EE");
    group2.itemViewModels = @[qrCode , shake];
    
    
    /// 第四组
    MHCommonGroupViewModel *group3 = [MHCommonGroupViewModel groupViewModel];
    /// 看一看
    MHCommonArrowItemViewModel *look = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"看一看" icon:@"icons_outlined_news.svg" svg:YES];
    look.svgTintColor = MHColorFromHexString(@"#F6C543");
    /// 搜一搜
    MHCommonArrowItemViewModel *search = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"搜一搜" icon:@"icons_outlined_search-logo.svg" svg:YES];
    search.svgTintColor = MHColorFromHexString(@"#FA5151");
    group3.itemViewModels = @[look , search];
    
    
    /// 第五组
    MHCommonGroupViewModel *group4 = [MHCommonGroupViewModel groupViewModel];
    /// 附近的人
    MHCommonArrowItemViewModel *locationService = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"附近的人" icon:@"icons_outlined_nearby.svg" svg:YES];
    locationService.svgTintColor = MHColorFromHexString(@"#1485EE");
    group4.itemViewModels = @[locationService];
    
    
    
    /// 第六组
    MHCommonGroupViewModel *group5 = [MHCommonGroupViewModel groupViewModel];
    /// 购物
    MHCommonArrowItemViewModel *shopping = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"购物" icon:@"icons_outlined_shop.svg" svg:YES];
    shopping.svgTintColor = MHColorFromHexString(@"#FA5151");
    /// 游戏
    MHCommonArrowItemViewModel *game = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"游戏" icon:@"icons_outlined_colorful_game.svg" svg:YES];
    group5.itemViewModels = @[shopping , game];
    
    /// 第七组
    MHCommonGroupViewModel *group6 = [MHCommonGroupViewModel groupViewModel];
    /// 小程序
    MHCommonArrowItemViewModel *moreApps = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"小程序" icon:@"icons_outlined_miniprogram.svg" svg:YES];
    moreApps.svgTintColor = MHColorFromHexString(@"#6467e8");
    group6.itemViewModels = @[moreApps];
    
    self.dataSource = @[group0 ,group1 , group2 , group3 , group4, group5, group6];
}
@end
