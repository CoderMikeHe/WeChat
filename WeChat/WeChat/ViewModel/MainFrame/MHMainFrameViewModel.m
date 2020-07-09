//
//  MHMainFrameViewModel.m
//  WeChat
//
//  Created by senba on 2017/9/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHMainFrameViewModel.h"
#import "MHHTTPService+Live.h"
#import "MHTestViewModel.h"
#import "MHPulldownAppletViewModel.h"
@interface MHMainFrameViewModel ()
/// 商品数组 <MHLiveRoom *>
@property (nonatomic, readwrite, copy) NSArray *liveRooms;

/// searchBarViewModel
@property (nonatomic, readwrite, strong) MHNavSearchBarViewModel *searchBarViewModel;

/// searchViewModel
@property (nonatomic, readwrite, strong) MHSearchViewModel *searchViewModel;

/// appletWrapperViewModel
@property (nonatomic, readwrite, strong) MHPulldownAppletWrapperViewModel *appletWrapperViewModel;
/// ballsViewModel
@property (nonatomic, readwrite, strong) MHBouncyBallsViewModel *ballsViewModel;

/// 搜索状态
@property (nonatomic, readwrite, assign) MHNavSearchBarState searchState;

/// 弹出/消失 搜索内容页 回调
@property (nonatomic, readwrite, strong) RACCommand *popCommand;



/// offsetInfo
@property (nonatomic, readwrite, copy) NSDictionary *offsetInfo;
@end


@implementation MHMainFrameViewModel

- (void)initialize
{
    [super initialize];
    
    /// 隐藏导航栏
    self.prefersNavigationBarHidden = YES;
    /// 不隐藏分割线
    self.prefersNavigationBarBottomLineHidden = NO;
    
    self.title = @"微信";
    
    /// 允许下拉刷新
    self.shouldPullDownToRefresh = NO;
    /// 允许上拉加载
    self.shouldPullUpToLoadMore = YES;
    /// 没有数据时，隐藏底部刷新控件
    self.shouldEndRefreshingWithNoMoreData = NO;
    
    
    @weakify(self);
    /// 直播间列表
    RAC(self, liveRooms) = self.requestRemoteDataCommand.executionSignals.switchToLatest;
    /// 数据源
    RAC(self,dataSource) = [RACObserve(self, liveRooms) map:^(NSArray * liveRooms) {
        @strongify(self)
        return [self dataSourceWithLiveRooms:liveRooms];
    }];
    
    /// 选中cell 跳转的命令
    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSIndexPath * indexPath) {
        @strongify(self);
        /// 这里只是测试
        MHLiveRoom *liveRoom = self.liveRooms[indexPath.row];
        MHTestViewModel *viewModel = [[MHTestViewModel alloc] initWithServices:self.services params:@{MHViewModelTitleKey:liveRoom.myname}];
        /// 执行push or present
        [self.services pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];
    /// --------------------- 下拉c小程序相关 ----------------------
    self.appletWrapperViewModel = [[MHPulldownAppletWrapperViewModel alloc] initWithServices:self.services params:nil];
    self.appletWrapperViewModel.callback = ^(NSDictionary *offsetInfo) {
        @strongify(self);
        self.offsetInfo = offsetInfo;
    };
    self.ballsViewModel = [[MHBouncyBallsViewModel alloc] init];
    
    // --------------------- 搜索相关 ----------------------
    /// 弹出搜索页或者隐藏搜索页的回调  以及侧滑搜索页回调
    self.popCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        if ([input isKindOfClass:NSNumber.class]) {
            NSNumber *value = (NSNumber *)input;
            self.searchState = value.integerValue;
        } else {
            NSDictionary *dict = (NSDictionary *)input;
            MHSearchPopState state = [dict[@"state"] integerValue];
            if (state == MHSearchPopStateCompleted && self.searchState == MHNavSearchBarStateSearch) {
                self.searchState = MHNavSearchBarStateDefault;
            }
        }
        return [RACSignal return:input];
    }];
    
    // 创建 searchViewModel
    self.searchViewModel = [[MHSearchViewModel alloc] initWithServices:self.services params:@{MHSearchViewPopCommandKey: self.popCommand}];
    
    
    // 配置 searchBar viewModel
    self.searchBarViewModel = [[MHNavSearchBarViewModel alloc] init];
    // 语音输入回调 + 文本框输入回调
    self.searchBarViewModel.textCommand = self.searchViewModel.textCommand;
    // 返回按钮的命令
    self.searchBarViewModel.backCommand = self.searchViewModel.backCommand;
    // 键盘搜索按钮的命令
    self.searchBarViewModel.searchCommand = self.searchViewModel.searchCommand;
    // 点击 搜索 或者 取消按钮的回调
    self.searchBarViewModel.popCommand = self.popCommand;
    
    /// 赋值操作
    RAC(self.searchBarViewModel, text) = RACObserve(self.searchViewModel, keyword);
    RAC(self.searchBarViewModel, searchType) = RACObserve(self.searchViewModel, searchType);
    RAC(self.searchBarViewModel, searchDefaultType) = RACObserve(self.searchViewModel, searchDefaultType);
    
    RAC(self.searchViewModel, searchState) = RACObserve(self, searchState);
    RAC(self.searchBarViewModel, searchState) = RACObserve(self, searchState);

}

/// 请求数据
- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page{

    NSArray * (^mapLiveRooms)(NSArray *) = ^(NSArray *products) {
        if (page == 1) {
            /// 下拉刷新
        } else {
            /// 上拉加载
            products = @[(self.liveRooms ?: @[]).rac_sequence, products.rac_sequence].rac_sequence.flatten.array;
        }
        return products;
    };
    /// 请求网络数据 61856069 是我的喵播id type = 0 为热门，其他type 自行测试
    return [[self.services.client fetchLivesWithUseridx:@"61856069" type:1 page:page lat:nil lon:nil province:nil] map:mapLiveRooms];
}

#pragma mark - 辅助方法
- (NSArray *)dataSourceWithLiveRooms:(NSArray *)liveRooms {
    if (MHObjectIsNil(liveRooms) || liveRooms.count == 0) return nil;
    NSArray *viewModels = [liveRooms.rac_sequence map:^(MHLiveRoom *liveRoom) {
        MHMainFrameItemViewModel *viewModel = [[MHMainFrameItemViewModel alloc] initWithLiveRoom:liveRoom];
        return viewModel;
    }].array;
    return viewModels ?: @[] ;
}
@end
