//
//  MHDiscoverViewModel.m
//  WeChat
//
//  Created by senba on 2017/9/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHDiscoverViewModel.h"
#import "MHWebViewModel.h"
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
    MHCommonArrowItemViewModel *moment = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"朋友圈" icon:@"ff_IconShowAlbum_25x25"];
    group0.itemViewModels = @[moment];
    
    /// 第二组
    MHCommonGroupViewModel *group1 = [MHCommonGroupViewModel groupViewModel];
    /// 扫一扫
    MHCommonArrowItemViewModel *qrCode = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"扫一扫" icon:@"ff_IconQRCode_25x25"];
    /// 摇一摇
    MHCommonArrowItemViewModel *shake = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"摇一摇" icon:@"ff_IconShake_25x25"];
    group1.itemViewModels = @[qrCode , shake];
    
    /// 第三组
    MHCommonGroupViewModel *group2 = [MHCommonGroupViewModel groupViewModel];
    /// 附近的人
    MHCommonArrowItemViewModel *locationService = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"附近的人" icon:@"ff_IconLocationService_25x25"];
    /// 漂流瓶
    MHCommonArrowItemViewModel *bottle = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"漂流瓶" icon:@"ff_IconBottle_25x25"];
    group2.itemViewModels = @[locationService , bottle];
    
    /// 第四组
    MHCommonGroupViewModel *group3 = [MHCommonGroupViewModel groupViewModel];
    /// 购物
    MHCommonArrowItemViewModel *shopping = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"购物" icon:@"CreditCard_ShoppingBag_25x25"];
    /// 游戏
    MHCommonArrowItemViewModel *game = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"游戏" icon:@"MoreGame_25x25"];
    group3.itemViewModels = @[shopping , game];
    
    /// 第五组
    MHCommonGroupViewModel *group4 = [MHCommonGroupViewModel groupViewModel];
    /// 小程序
    MHCommonArrowItemViewModel *moreApps = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"小程序" icon:@"MoreWeApp_25x25"];
    group4.itemViewModels = @[moreApps];
    
    /// 插件功能
    NSMutableArray *group5s = [NSMutableArray arrayWithCapacity:2];
    /// 看一看
    if ([MHPreferenceSettingHelper boolForKey:MHPreferenceSettingLook]) {
        MHCommonArrowItemViewModel *look= [MHCommonArrowItemViewModel itemViewModelWithTitle:@"看一看" icon:@"ff_IconBrowse1_25x25"];
        look.centerLeftViewName = [MHPreferenceSettingHelper boolForKey:MHPreferenceSettingLookArtboard]?@"Artboard23_38x18":nil;;
        [group5s addObject:look];
        @weakify(look);
        look.operation = ^{
            @strongify(self);
            @strongify(look);
            NSURL *url = [NSURL URLWithString:MHMyBlogHomepageUrl];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            MHWebViewModel * webViewModel = [[MHWebViewModel alloc] initWithServices:self.services params:@{MHViewModelRequestKey:request}];
            /// 去掉关闭按钮
            webViewModel.shouldDisableWebViewClose = YES;
            [self.services pushViewModel:webViewModel animated:YES];
            
            if (look.centerLeftViewName) {
                look.centerLeftViewName = nil;
                [MHPreferenceSettingHelper setBool:NO forKey:MHPreferenceSettingLookArtboard];
                // “手动触发self.dataSource的KVO”，必写。
                [self willChangeValueForKey:@"dataSource"];
                // “手动触发self.now的KVO”，必写。
                [self didChangeValueForKey:@"dataSource"];
            }
        };
    }
    /// 搜一搜
    if ([MHPreferenceSettingHelper boolForKey:MHPreferenceSettingSearch]) {
        MHCommonArrowItemViewModel *search = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"搜一搜" icon:@"ff_IconSearch1_25x25"];
        search.centerLeftViewName = [MHPreferenceSettingHelper boolForKey:MHPreferenceSettingSearchArtboard]?@"Artboard23_38x18":nil;
        [group5s addObject:search];
        @weakify(search);
        search.operation = ^{
            @strongify(self);
            @strongify(search);
            NSURL *url = [NSURL URLWithString:MHMyBlogHomepageUrl];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            MHWebViewModel * webViewModel = [[MHWebViewModel alloc] initWithServices:self.services params:@{MHViewModelRequestKey:request}];
            /// 去掉关闭按钮
            webViewModel.shouldDisableWebViewClose = YES;
            [self.services pushViewModel:webViewModel animated:YES];
            
            if (search.centerLeftViewName) {
                search.centerLeftViewName = nil;
                [MHPreferenceSettingHelper setBool:NO forKey:MHPreferenceSettingSearchArtboard];
                // “手动触发self.dataSource的KVO”，必写。
                [self willChangeValueForKey:@"dataSource"];
                // “手动触发self.now的KVO”，必写。
                [self didChangeValueForKey:@"dataSource"];
            }
        };
    }
    
    
    
    if (group5s.count>0) {
        MHCommonGroupViewModel *group5 = [MHCommonGroupViewModel groupViewModel];
        group5.itemViewModels = [group5s copy];
        self.dataSource = @[group0 , group1 ,group5 , group2 , group3 , group4];
    }else{
        self.dataSource = @[group0 , group1 , group2 , group3 , group4];
    }
}
@end
