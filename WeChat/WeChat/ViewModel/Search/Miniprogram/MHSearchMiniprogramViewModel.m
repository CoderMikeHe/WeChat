//
//  MHSearchMiniprogramViewModel.m
//  WeChat
//
//  Created by 何千元 on 2020/5/13.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchMiniprogramViewModel.h"
#import "MHWebViewModel.h"
@implementation MHSearchMiniprogramViewModel

- (void)initialize {
    [super initialize];
    
    self.style = UITableViewStyleGrouped;
    
    @weakify(self);
    /// 选中cell 跳转的命令
    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSIndexPath * indexPath) {
        @strongify(self);
        NSInteger section = indexPath.section;
        NSInteger row = indexPath.row;
        if (self.searchMode == MHSearchModeRelated) {
            
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
                // 更新数据源
                self.dataSource = @[];
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
                    MHSearchCommonSearchItemViewModel *itemViewModel = [[MHSearchCommonSearchItemViewModel alloc] initWithTitle:title subtitle:@"这是搜索到的小程序的子标题..." desc:@"这是搜索到的小程序的描述..." keyword:self.keyword];
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
