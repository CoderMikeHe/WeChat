//
//  MHDiscoverManagerViewModel.m
//  WeChat
//
//  Created by 何千元 on 2020/6/6.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHDiscoverManagerViewModel.h"
#import "MHCommonSwitchItemViewModel.h"

@implementation MHDiscoverManagerViewModel
- (void)initialize {
    [super initialize];
    
    self.style = UITableViewStyleGrouped;
    
    // 配置数据
    /// 第一组
    MHCommonGroupViewModel *group0 = [MHCommonGroupViewModel groupViewModel];
    group0.header = @"打开/关闭发现页的入口";
    group0.footer = @"关闭后，仅隐藏“发现”中该功能的入口，不会清空任何历史数据。";
       
    /// 计算 20
    CGFloat limitWidth = MH_SCREEN_WIDTH - 2 * 20;
    CGFloat headerHeight = [group0.header mh_sizeWithFont:MHRegularFont_14 limitWidth:limitWidth].height + 5 *2;
    group0.headerHeight = headerHeight;

    CGFloat footerHeight = [group0.footer mh_sizeWithFont:MHRegularFont_14 limitWidth:limitWidth].height + 5 *2;
    group0.footerHeight = footerHeight;
    
    
    /// 盆友圈
    MHCommonSwitchItemViewModel *moment = [MHCommonSwitchItemViewModel itemViewModelWithTitle:@"朋友圈" icon:@"icons_outlined_colorful_moment.svg" svg:YES];
    moment.key = MHPreferenceSettingMoments;
    /// 视频号
    MHCommonSwitchItemViewModel *finder = [MHCommonSwitchItemViewModel itemViewModelWithTitle:@"视频号" icon:@"icons_outlined_finder.svg" svg:YES];
    finder.key = MHPreferenceSettingFinder;
    finder.svgTintColor = MHColorFromHexString(@"#EDA150");
    /// 扫一扫
    MHCommonSwitchItemViewModel *scan = [MHCommonSwitchItemViewModel itemViewModelWithTitle:@"扫一扫" icon:@"scan_history_msg.svg" svg:YES];
    scan.key = MHPreferenceSettingScan;
    /// 摇一摇
    MHCommonSwitchItemViewModel *shake = [MHCommonSwitchItemViewModel itemViewModelWithTitle:@"摇一摇" icon:@"icons_outlined_shake.svg" svg:YES];
    shake.key = MHPreferenceSettingShake;
    shake.svgTintColor = MHColorFromHexString(@"#1485EE");
    /// 看一看
    MHCommonSwitchItemViewModel *look = [MHCommonSwitchItemViewModel itemViewModelWithTitle:@"看一看" icon:@"icons_outlined_news.svg" svg:YES];
    look.key = MHPreferenceSettingLook;
    look.svgTintColor = MHColorFromHexString(@"#F6C543");
    /// 搜一搜
    MHCommonSwitchItemViewModel *search = [MHCommonSwitchItemViewModel itemViewModelWithTitle:@"搜一搜" icon:@"icons_outlined_search-logo.svg" svg:YES];
    search.key = MHPreferenceSettingSearch;
    search.svgTintColor = MHColorFromHexString(@"#FA5151");
    /// 附近的人
    MHCommonSwitchItemViewModel *nearby = [MHCommonSwitchItemViewModel itemViewModelWithTitle:@"附近的人" icon:@"icons_outlined_nearby.svg" svg:YES];
    nearby.key = MHPreferenceSettingNearby;
    nearby.svgTintColor = MHColorFromHexString(@"#1485EE");
    /// 购物
    MHCommonSwitchItemViewModel *shopping = [MHCommonSwitchItemViewModel itemViewModelWithTitle:@"购物" icon:@"icons_outlined_shop.svg" svg:YES];
    shopping.key = MHPreferenceSettingShopping;
    shopping.svgTintColor = MHColorFromHexString(@"#FA5151");
    /// 游戏
    MHCommonSwitchItemViewModel *game = [MHCommonSwitchItemViewModel itemViewModelWithTitle:@"游戏" icon:@"icons_outlined_colorful_game.svg" svg:YES];
    game.key = MHPreferenceSettingGame;
    /// 小程序
    MHCommonSwitchItemViewModel *moreApps = [MHCommonSwitchItemViewModel itemViewModelWithTitle:@"小程序" icon:@"icons_outlined_miniprogram.svg" svg:YES];
    moreApps.key = MHPreferenceSettingMoreApps;
    moreApps.svgTintColor = MHColorFromHexString(@"#6467e8");
    
    group0.itemViewModels = @[moment, finder, scan, shake, look, search, nearby, shopping, game, moreApps];
    
    self.dataSource = @[group0];
}
@end
