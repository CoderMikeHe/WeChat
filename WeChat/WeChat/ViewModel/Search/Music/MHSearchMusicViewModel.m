//
//  MHSearchMusicViewModel.m
//  WeChat
//
//  Created by 何千元 on 2020/5/13.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchMusicViewModel.h"
#import "MHWebViewModel.h"
static NSUInteger const MHMaxSearchMusicCacheCount = 8;

@interface MHSearchMusicViewModel ()
/// hotItemViewModel
@property (nonatomic, readwrite, strong) MHSearchMusicHotItemViewModel *hotItemViewModel;
/// delHistoryItemViewModel
@property (nonatomic, readwrite, strong) MHSearchMusicDelHistoryItemViewModel *delHistoryItemViewModel;

/// cacheMusics 原始数据
@property (nonatomic, readwrite, copy) NSArray *cacheMusics;
/// cacheMusics 转换数据
@property (nonatomic, readwrite, copy) NSArray *cacheMusicViewModels;

/// clearMusicCommand
@property (nonatomic, readwrite, strong) RACCommand *clearMusicCommand;


@end


@implementation MHSearchMusicViewModel
- (void)initialize {
    [super initialize];
    
    @weakify(self);
    
    self.style = UITableViewStyleGrouped;
    self.shouldMultiSections = YES;
    self.cacheMusics = @[];
    self.cacheMusicViewModels = @[];
    
    self.clearMusicCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(MHSearchMusicHistoryItemViewModel *input) {
       @strongify(self);
        [self _clearMusic: input];
        return [RACSignal empty];
    }];
    
    /// 选中cell 跳转的命令
    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSIndexPath * indexPath) {
        @strongify(self);
        NSInteger section = indexPath.section;
        NSInteger row = indexPath.row;
        if (self.searchMode == MHSearchModeDefault) {
            // 默认形式
            if (section == 1) {
                // 缓存的音乐
                NSArray *itemViewModels = self.dataSource[section];
                MHSearchMusicHistoryItemViewModel *itemViewModel = itemViewModels[row];
                MHSearch *search = [MHSearch searchWithKeyword:itemViewModel.music searchMode:MHSearchModeSearch];
                /// 传递数据
                [self.requestSearchKeywordCommand execute:search];
            }else if (section == 2) {
                // 删除all音乐
                [self _clearAllMusic];
            }
        }else if (self.searchMode == MHSearchModeRelated) {
            // 关联模式
        }else {
            // 搜索模式
            NSURL *url = [NSURL URLWithString:MHMyBlogHomepageUrl];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            MHWebViewModel * viewModel = [[MHWebViewModel alloc] initWithServices:self.services params:@{MHViewModelRequestKey:request}];
            /// 去掉关闭按钮
            viewModel.shouldDisableWebViewClose = YES;
            [self.services pushViewModel:viewModel animated:YES];
        }
        return [RACSignal empty];
    }];
    
    
    
    /// 配置热门音乐
    NSArray *musics = @[@"你我不一", @"隔壁老樊", @"晴天", @"周杰伦", @"中毒", @"野区歌神", @"喉咙唱的沙哑", @"枯木逢春"];
    /// 转换成 itemViewModel
    MHSearchMusicHotItemViewModel *hotItemViewModel = [[MHSearchMusicHotItemViewModel alloc] initWithMusics:musics];
    /// 将关键字的命令传递进去
    hotItemViewModel.requestSearchKeywordCommand = self.requestSearchKeywordCommand;
    self.hotItemViewModel = hotItemViewModel;
    
    
    /// 一旦有搜索信号
    [self.requestSearchKeywordCommand.executionSignals.switchToLatest subscribeNext:^(MHSearch * search) {
        @strongify(self);
        if (search.searchMode == MHSearchModeSearch) {
            /// 必须是搜索模式 才添加到缓存
            [self _cacheMusic:search.keyword];
        }
    }];
    
    /// 获取缓存数据
    [[YYCache sharedCache] objectForKey:MHSearchMusicHistoryCacheKey withBlock:^(NSString * _Nonnull key, NSArray *  _Nonnull cacheMusics) {
        @strongify(self);
        // 子线程执行任务（比如获取较大数据）
        if (!MHArrayIsEmpty(cacheMusics)) {
            /// 转成itemViewMdoel
            NSArray *itemViewModels = [self _historyItemViewModelsWithResults:cacheMusics];
            self.dataSource = @[@[self.hotItemViewModel], itemViewModels, @[self.delHistoryItemViewModel]];
            
            /// 注意这里记录itemVMS
            self.cacheMusics = cacheMusics;
            self.cacheMusicViewModels = itemViewModels;
        }else {
            self.dataSource = @[@[self.hotItemViewModel]];
        }
    }];
}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        /// 模拟网络延迟
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            /// 判断当前模式
            if (self.searchMode == MHSearchModeDefault) {
                // 默认模式
                self.shouldMultiSections = YES;
                self.shouldPullUpToLoadMore = NO;
                
                /// 这种场景 都是默认形式
                if (self.cacheMusicViewModels.count == 0) {
                    self.dataSource = @[@[self.hotItemViewModel]];
                }else {
                    self.dataSource = @[@[self.hotItemViewModel], self.cacheMusicViewModels, @[self.delHistoryItemViewModel]];
                }
            } else if (self.searchMode == MHSearchModeRelated) {
                // 关联模式
                self.shouldMultiSections = NO;
                self.shouldPullUpToLoadMore = NO;
                
                NSInteger count0 = self.relatedKeywords0.count;
                NSInteger count1 = self.relatedKeywords1.count;
                NSMutableArray *dataSource = [NSMutableArray array];
                
                NSInteger count = 0;
                if (self.relatedCount == 0) {
                    count = count0;
                } else if(self.relatedCount == 1) {
                    count = count1;
                }
                for (NSInteger i = 0; i < count; i++) {
                    NSString *relatedTitle = self.relatedCount == 0 ? self.relatedKeywords0[i] : self.relatedKeywords1[i];
                    NSString *title = [NSString stringWithFormat:@"%@ %@", self.keyword, relatedTitle];
                    MHSearchCommonRelatedItemViewModel *itemViewModel = [[MHSearchCommonRelatedItemViewModel alloc] initWithTitle:title keyword:self.keyword];
                    itemViewModel.relatedKeywordCommand = self.relatedKeywordCommand;
                    [dataSource addObject:itemViewModel];
                }
                
                self.dataSource = dataSource.copy;
                
                
            } else {
                // 搜索模式 单个section
                // 需要上拉加载
                self.shouldMultiSections = NO;
                self.shouldPullUpToLoadMore = YES;
                
                NSInteger index = (page - 1) * self.perPage;
                NSInteger count = page * self.perPage;
                NSMutableArray *dataSource = [NSMutableArray array];
                for (NSInteger i = index; i < count; i++) {
                    NSString *title = [NSString stringWithFormat:@"%@ 结果%ld", self.keyword, i];
                    MHSearchCommonSearchItemViewModel *itemViewModel = [[MHSearchCommonSearchItemViewModel alloc] initWithTitle:title subtitle:@"这是搜索到的音乐的子标题..." desc:@"这是搜索到的音乐的描述..." keyword:self.keyword];
                    [dataSource addObject:itemViewModel];
                }
                
                if (page == 1) {
                    self.page = 1;
                    self.dataSource = dataSource.copy;
                }else {
                    NSArray *temps = [dataSource copy];
                    self.dataSource = @[(self.dataSource ?: @[]).rac_sequence, temps.rac_sequence].rac_sequence.flatten.array;
                }
            }
            [subscriber sendNext:self.dataSource];
            [subscriber sendCompleted];
        });
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
}


#pragma mark - 辅助方法
- (NSArray *)_historyItemViewModelsWithResults:(NSArray *)results {
    if (MHObjectIsNil(results) || results.count == 0) return nil;
    NSArray *viewModels = [results.rac_sequence map:^(NSString *music) {
        /// 将其转换
        MHSearchMusicHistoryItemViewModel *viewModel = [[MHSearchMusicHistoryItemViewModel alloc] initWithMusic:music];
        viewModel.clearMusicCommand = self.clearMusicCommand;
        return viewModel;
    }].array;
    return viewModels ?: @[] ;
}
/// 添加一条音乐记录
- (void)_cacheMusic:(NSString *)keyword {
    NSMutableArray *tempArray = self.cacheMusics.mutableCopy;
    NSMutableArray *tempViewModelArray = self.cacheMusicViewModels.mutableCopy;
    /// 先判断是否已经在之前的历史列表中
    NSString *findKeyword = nil;
    NSInteger index = 0;
    for (NSString *tempStr in tempArray) {
        if ([tempStr isEqualToString:keyword]) {
            findKeyword = keyword;
            break;
        }
        index++;
    }
    if (findKeyword) {
        
        MHSearchMusicHistoryItemViewModel *itemViewModel = tempViewModelArray[index];
        
        /// 删除
        [tempArray removeObject:findKeyword];
        [tempViewModelArray removeObject:itemViewModel];
        
        /// 插入到最前面
        [tempArray prependObject:findKeyword];
        [tempViewModelArray prependObject:itemViewModel];
        
    }else{
        /// 插入到最前面
        [tempArray prependObject:keyword];
        
        /// 生成一个
        MHSearchMusicHistoryItemViewModel *itemViewModel = [[MHSearchMusicHistoryItemViewModel alloc] initWithMusic:keyword];
        itemViewModel.clearMusicCommand = self.clearMusicCommand;
        [tempViewModelArray prependObject:itemViewModel];
    }
    
    /// 只允许8个历史记录
    if (tempArray.count > MHMaxSearchMusicCacheCount) {
        tempArray = [tempArray subarrayWithRange:NSMakeRange(0, MHMaxSearchMusicCacheCount)].mutableCopy;
        tempViewModelArray = [tempViewModelArray subarrayWithRange:NSMakeRange(0, MHMaxSearchMusicCacheCount)].mutableCopy;
    }
    /// 缓存
    [[YYCache sharedCache] setObject:tempArray.copy forKey:MHSearchMusicHistoryCacheKey withBlock:^{
        NSLog(@" --- insert search searchText success --- ");
    }];
    
    /// 记录
    self.cacheMusics = tempArray.copy;
    self.cacheMusicViewModels = tempViewModelArray.copy;
}

/// 清除某条音乐记录
- (void)_clearMusic:(MHSearchMusicHistoryItemViewModel *)itemViewModel {
    NSMutableArray *tempArray = self.cacheMusics.mutableCopy;
    NSMutableArray *tempViewModelArray = self.cacheMusicViewModels.mutableCopy;
    /// 删除
    [tempArray removeObject:itemViewModel.music];
    [tempViewModelArray removeObject:itemViewModel];
    
    self.cacheMusics = tempArray.copy;
    self.cacheMusicViewModels = tempViewModelArray.copy;
    
    /// 缓存
    [[YYCache sharedCache] setObject:tempArray.copy forKey:MHSearchMusicHistoryCacheKey withBlock:^{
        NSLog(@" --- clear insert search searchText success --- ");
    }];
    
    /// 这种场景 都是默认形式
    if (tempArray.count == 0) {
        self.dataSource = @[@[self.hotItemViewModel]];
    }else {
        self.dataSource = @[@[self.hotItemViewModel], self.cacheMusicViewModels, @[self.delHistoryItemViewModel]];
    }
}

/// 清除所有音乐缓存
- (void)_clearAllMusic {
    self.cacheMusics = @[];
    self.cacheMusicViewModels = @[];
    
    /// 这种场景 都是默认形式
    self.dataSource = @[@[self.hotItemViewModel]];
    
    /// 删除
    [[YYCache sharedCache] removeObjectForKey:MHSearchMusicHistoryCacheKey withBlock:^(NSString * _Nullable key) {
        NSLog(@"--- delete all search music success ---");
    }];
}


- (MHSearchMusicDelHistoryItemViewModel *)delHistoryItemViewModel{
    if (_delHistoryItemViewModel == nil) {
        _delHistoryItemViewModel = [[MHSearchMusicDelHistoryItemViewModel alloc] init];
    }
    return _delHistoryItemViewModel;
}
@end
