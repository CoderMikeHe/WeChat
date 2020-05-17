//
//  MHSearchMomentsViewModel.m
//  WeChat
//
//  Created by admin on 2020/5/12.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchMomentsViewModel.h"
#import "MHSearchMomentsItemViewModel.h"
#import "WPFPinYinDataManager.h"
#import "MHWebViewModel.h"
@interface MHSearchMomentsViewModel ()

/// results
@property (nonatomic, readwrite, copy) NSArray *results;

/// sectionTitle
@property (nonatomic, readwrite, copy) NSString *sectionTitle;

@end

@implementation MHSearchMomentsViewModel

- (void)initialize {
    [super initialize];
    
    self.sectionTitle = @"搜索联系人的朋友圈";
    self.shouldMultiSections = NO;
    self.style = UITableViewStyleGrouped;
    
    @weakify(self);
    /// 选中cell 跳转的命令
    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSIndexPath * indexPath) {
        @strongify(self);
        NSInteger section = indexPath.section;
        NSInteger row = indexPath.row;
       if (self.searchMode == MHSearchModeRelated) {
            // 关联模式 点击cell 也是搜索模式
            MHSearchMomentsItemViewModel *itemViewModel = self.dataSource[row];
            MHSearch *search = [MHSearch searchWithKeyword:itemViewModel.person.name searchMode:MHSearchModeSearch];
            /// 传递数据
            [self.requestSearchKeywordCommand execute:search];
        }else if (self.searchMode == MHSearchModeSearch){
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
                self.shouldPullUpToLoadMore = NO;
                /// 这种场景 都是默认形式
                self.dataSource = @[];
            } else if (self.searchMode == MHSearchModeRelated) {
                // 关联模式
                self.shouldPullUpToLoadMore = NO;
                // 查询数据
                NSMutableArray *results = [NSMutableArray array];
                for (WPFPerson *person in [WPFPinYinDataManager getInitializedDataSource]) {
                    WPFSearchResultModel *resultModel = [WPFPinYinTools searchEffectiveResultWithSearchString:self.keyword Person:person];
                    if (resultModel.highlightedRange.length) {
                        person.highlightLoaction = resultModel.highlightedRange.location;
                        person.textRange = resultModel.highlightedRange;
                        person.matchType = resultModel.matchType;
                        
                        [results addObject:person];
                    }
                }
                // 排序
                [results sortUsingDescriptors:[WPFPinYinTools sortingRules]];
                // 转成itemViewMdoel
                NSArray *viewModels = [self _dataSourceWithResults:results];
                // 更新数据源
                self.dataSource = viewModels ?: @[];
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
                    MHSearchCommonSearchItemViewModel *itemViewModel = [[MHSearchCommonSearchItemViewModel alloc] initWithTitle:title subtitle:@"这是搜索到的朋友圈的子标题..." desc:@"这是搜索到的朋友圈的描述..." keyword:self.keyword];
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
- (NSArray *)_dataSourceWithResults:(NSArray *)results {
    if (MHObjectIsNil(results) || results.count == 0) return nil;
    NSArray *viewModels = [results.rac_sequence map:^(WPFPerson *person) {
        /// 将其转换
        MHSearchMomentsItemViewModel *viewModel = [[MHSearchMomentsItemViewModel alloc] initWithPerson:person];
        return viewModel;
    }].array;
    return viewModels ?: @[] ;
}

@end
