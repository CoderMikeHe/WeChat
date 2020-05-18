//
//  MHSearchStickerViewModel.m
//  WeChat
//
//  Created by 何千元 on 2020/5/13.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchStickerViewModel.h"
#import "MHSearchStickerDefaultItemViewModel.h"
#import "MHWebViewModel.h"
@interface MHSearchStickerViewModel ()

/// defaultItemViewModel
@property (nonatomic, readwrite, strong) MHSearchStickerDefaultItemViewModel *defaultItemViewModel;

@end

@implementation MHSearchStickerViewModel
- (void)initialize {
    [super initialize];
    
    self.style = UITableViewStyleGrouped;
    
    @weakify(self);

    
    /// 默认场景下
    MHSearchStickerDefaultItemViewModel *defaultItemViewModel = [[MHSearchStickerDefaultItemViewModel alloc] init];
    self.dataSource = @[defaultItemViewModel];
    self.defaultItemViewModel = defaultItemViewModel;
    
    /// 选中cell 跳转的命令
    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSIndexPath * indexPath) {
        @strongify(self);
        NSInteger section = indexPath.section;
        NSInteger row = indexPath.row;
        if (self.searchMode == MHSearchModeRelated) {
            // 关联模式 点击cell 也是搜索模式
            MHSearchCommonRelatedItemViewModel *itemViewModel = self.dataSource[row];
            MHSearch *search = [MHSearch searchWithKeyword:itemViewModel.title searchMode:MHSearchModeSearch];
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
                self.dataSource = @[self.defaultItemViewModel];
            } else if (self.searchMode == MHSearchModeRelated) {
                // 关联模式
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
                    MHSearchCommonSearchItemViewModel *itemViewModel = [[MHSearchCommonSearchItemViewModel alloc] initWithTitle:title subtitle:@"这是搜索到的公众号的子标题..." desc:@"这是搜索到的公众号的描述..." keyword:self.keyword];
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
@end
