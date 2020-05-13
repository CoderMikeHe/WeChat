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
    self.shouldMultiSections = YES;
    self.style = UITableViewStyleGrouped;
    
    @weakify(self);
    [[[RACObserve(self, keyword) distinctUntilChanged] map:^id(NSString *keyword) {
        return keyword.lowercaseString;
    }] subscribeNext:^(NSString * keyword) {
        @strongify(self);
        
        if (MHStringIsEmpty(keyword)) {
            self.results = @[];
            return;
        }
        
        NSMutableArray *results = [NSMutableArray array];
        for (WPFPerson *person in [WPFPinYinDataManager getInitializedDataSource]) {
            WPFSearchResultModel *resultModel = [WPFPinYinTools searchEffectiveResultWithSearchString:keyword Person:person];
            if (resultModel.highlightedRange.length) {
                person.highlightLoaction = resultModel.highlightedRange.location;
                person.textRange = resultModel.highlightedRange;
                person.matchType = resultModel.matchType;
                
                [results addObject:person];
            }
        }
        // 排序
        [results sortUsingDescriptors:[WPFPinYinTools sortingRules]];
        
        self.results = results.copy;
    }];
    
    /// 数据源
    RAC(self,dataSource) = [RACObserve(self, results) map:^(NSArray * results) {
        @strongify(self)
        NSArray *rsts = [self _dataSourceWithResults:results];
        return MHArrayIsEmpty(rsts)?@[]:@[rsts];
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
