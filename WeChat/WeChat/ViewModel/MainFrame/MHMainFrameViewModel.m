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

@interface MHMainFrameViewModel ()
/// 商品数组 <MHLiveRoom *>
@property (nonatomic, readwrite, copy) NSArray *liveRooms;
@end


@implementation MHMainFrameViewModel

- (void)initialize
{
    [super initialize];
    self.title = @"微信";
    
    /// 允许下拉刷新
    self.shouldPullDownToRefresh = YES;
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
    return [[self.services.client fetchLivesWithUseridx:@"61856069" type:0 page:page lat:nil lon:nil province:nil] map:mapLiveRooms];
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
