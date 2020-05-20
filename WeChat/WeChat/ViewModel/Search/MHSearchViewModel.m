//
//  MHSearchViewModel.m
//  WeChat
//
//  Created by admin on 2020/5/6.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchViewModel.h"
#import "MHWebViewModel.h"
#import "MHSearchDefaultContactItemViewModel.h"
#import "WPFPinYinDataManager.h"
/// 侧滑返回回调
NSString * const  MHSearchViewPopCommandKey = @"MHSearchViewPopCommandKey";

@interface MHSearchViewModel ()

/// searchTypeViewModel
@property (nonatomic, readwrite, strong) MHSearchDefaultSearchTypeItemViewModel *searchTypeItemViewModel;

/// searchTypeSubject
@property (nonatomic, readwrite, strong) RACSubject *searchTypeSubject;

//// 处理 NavSearchBar 的回调
/// 文本框输入回调 + 语音输入回调
@property (nonatomic, readwrite, strong) RACCommand *textCommand;
/// 点击键盘搜索
@property (nonatomic, readwrite, strong) RACCommand *searchCommand;
/// 点击返回按钮回调
@property (nonatomic, readwrite, strong) RACCommand *backCommand;

/// 配置子模块
/// popItemCommand 子控制器（朋友圈、文章、 公众号、小程序、音乐、表情）侧滑返回回调
@property (nonatomic, readwrite, strong) RACCommand *popItemCommand;
/// 弹出搜索页或者隐藏搜索页的回调  以及侧滑搜索页回调
@property (nonatomic, readwrite, strong) RACCommand *popCommand;
/// 点击列表中关键字 or 关联关键字按钮 回调给 searchBar 的命令
@property (nonatomic, readwrite, strong) RACCommand *keywordCommand;

/// momentsViewModel
@property (nonatomic, readwrite, strong) MHSearchMomentsViewModel *momentsViewModel;
/// subscriptionsViewModel
@property (nonatomic, readwrite, strong) MHSearchSubscriptionsViewModel *subscriptionsViewModel;
/// officialAccountsViewModel
@property (nonatomic, readwrite, strong) MHSearchOfficialAccountsViewModel *officialAccountsViewModel;
/// miniprogramViewModel
@property (nonatomic, readwrite, strong) MHSearchMiniprogramViewModel *miniprogramViewModel;
/// musicViewModel
@property (nonatomic, readwrite, strong) MHSearchMusicViewModel *musicViewModel;
/// stickerViewModel
@property (nonatomic, readwrite, strong) MHSearchStickerViewModel *stickerViewModel;

/// searchType
@property (nonatomic, readwrite, assign) MHSearchType searchType;
/// keyword 关键字
@property (nonatomic, readwrite, copy) NSString *keyword;

/// searchMode
@property (nonatomic, readwrite, assign) MHSearchMode searchMode;

@end
@implementation MHSearchViewModel

- (instancetype)initWithServices:(id<MHViewModelServices>)services params:(NSDictionary *)params
{
    if (self = [super initWithServices:services params:params]) {
        self.popCommand = params[MHSearchViewPopCommandKey];
    }
    return self;
}

- (void)initialize {
    [super initialize];
    @weakify(self);
    
    self.style = UITableViewStyleGrouped;
    self.shouldMultiSections = YES;
    
    /// 默认模式
    self.searchType = MHSearchTypeDefault;
    self.searchMode = MHSearchModeDefault;
    
    
    /// 定义searchTypeView的回调
    self.searchTypeSubject = [RACSubject subject];
    [[[self.searchTypeSubject distinctUntilChanged] deliverOnMainThread] subscribeNext:^(NSNumber *x) {
        @strongify(self);
         self.searchType = x.integerValue;
    }];
    
    /// 子模块侧滑返回
    self.popItemCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        /// 先重置之前模块的数据
        [self _resetSearchTypeModuleData:self.searchType];
        /// 设置默认搜索类型
        [self.searchTypeSubject sendNext:@(MHSearchTypeDefault)];
        return [RACSignal empty];
    }];
    
    /// 子模块关键字回调给searchBar
    self.keywordCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *input) {
        @strongify(self);
        self.keyword = input;
        return [RACSignal empty];
    }];
    
    
    /// 定义 NavSearchBar 的回调
    self.textCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self _inputTypeModuleData:input];
        return [RACSignal empty];
    }];;
    self.backCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        /// 先重置之前模块的数据
        [self _resetSearchTypeModuleData:self.searchType];
        /// 设置默认搜索类型
        [self.searchTypeSubject sendNext:@(MHSearchTypeDefault)];
        return [RACSignal empty];
    }];
    
    /// 点击键盘的回调
    self.searchCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *input) {
        /// 点击键盘回调
        @strongify(self);
        [self _searchTypeModuleData:input];
        return [RACSignal empty];
    }];
    
    /// 监听searchState
    [[[RACObserve(self, searchState) skip:1] distinctUntilChanged] subscribeNext:^(NSNumber *x) {
        @strongify(self);
        /// 先重置之前模块的数据
        [self _resetSearchTypeModuleData:self.searchType];
        /// 设置默认搜索类型
        [self.searchTypeSubject sendNext:@(MHSearchTypeDefault)];
    }];


    // 创建viewModel
    self.searchTypeItemViewModel = [[MHSearchDefaultSearchTypeItemViewModel alloc] init];
    self.searchTypeItemViewModel.searchTypeSubject = self.searchTypeSubject;
    
    
    //// 配置各个模块的vm
    // 朋友圈ViewModel
    self.momentsViewModel = [[MHSearchMomentsViewModel alloc] initWithServices:self.services params:@{MHSearchTypeTypeKey: @(MHSearchTypeMoments), MHSearchTypePopKey: self.popItemCommand, MHSearchTypeKeywordKey: @"", MHSearchTypeKeywordCommandKey: self.keywordCommand}];
    // 文章ViewModel
    self.subscriptionsViewModel = [[MHSearchSubscriptionsViewModel alloc] initWithServices:self.services params:@{MHSearchTypeTypeKey: @(MHSearchTypeSubscriptions), MHSearchTypePopKey: self.popItemCommand, MHSearchTypeKeywordKey: @"", MHSearchTypeKeywordCommandKey: self.keywordCommand}];
    // 公众号ViewModel
    self.officialAccountsViewModel = [[MHSearchOfficialAccountsViewModel alloc] initWithServices:self.services params:@{MHSearchTypeTypeKey: @(MHSearchTypeOfficialAccounts), MHSearchTypePopKey: self.popItemCommand, MHSearchTypeKeywordKey: @"", MHSearchTypeKeywordCommandKey: self.keywordCommand}];
    // 小程序ViewModel
    self.miniprogramViewModel = [[MHSearchMiniprogramViewModel alloc] initWithServices:self.services params:@{MHSearchTypeTypeKey: @(MHSearchTypeMiniprogram), MHSearchTypePopKey: self.popItemCommand, MHSearchTypeKeywordKey: @"", MHSearchTypeKeywordCommandKey: self.keywordCommand}];
    // 音乐ViewModel
    self.musicViewModel = [[MHSearchMusicViewModel alloc] initWithServices:self.services params:@{MHSearchTypeTypeKey: @(MHSearchTypeMusic), MHSearchTypePopKey: self.popItemCommand, MHSearchTypeKeywordKey: @"", MHSearchTypeKeywordCommandKey: self.keywordCommand}];
    // 表情ViewModel
    self.stickerViewModel = [[MHSearchStickerViewModel alloc] initWithServices:self.services params:@{MHSearchTypeTypeKey: @(MHSearchTypeSticker), MHSearchTypePopKey: self.popItemCommand, MHSearchTypeKeywordKey: @"", MHSearchTypeKeywordCommandKey: self.keywordCommand}];
    
    
    
    self.dataSource = @[@[self.searchTypeItemViewModel]];
}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSTimeInterval t = self.searchMode == MHSearchModeSearch ? 1.0 : .25f;
        /// 模拟网络延迟
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(t * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            /// 判断当前模式
            if (self.searchMode == MHSearchModeDefault) {
         
                /// 这种场景 都是默认形式
                self.dataSource = @[@[self.searchTypeItemViewModel]];
                
                
            } else if (self.searchMode == MHSearchModeRelated ) {
                
                NSMutableArray *dataSource = [NSMutableArray array];
                // 查询数据
                NSMutableArray *contacts = [NSMutableArray array];
                for (WPFPerson *person in [WPFPinYinDataManager getInitializedDataSource]) {
                    /// 用小写字母去查找
                    WPFSearchResultModel *resultModel = [WPFPinYinTools searchEffectiveResultWithSearchString:self.keyword.lowercaseString Person:person];
                    if (resultModel.highlightedRange.length) {
                        person.highlightLoaction = resultModel.highlightedRange.location;
                        person.textRange = resultModel.highlightedRange;
                        person.matchType = resultModel.matchType;
                        [contacts addObject:person];
                    }
                }
                // 排序
                [contacts sortUsingDescriptors:[WPFPinYinTools sortingRules]];
                // 转成itemViewMdoel
                NSArray *contactItemViewModels = [self _contacts2ContactItemViewModels:contacts];
                if (!MHArrayIsEmpty(contactItemViewModels)) {
                    [dataSource addObject:contactItemViewModels];
                }

                // 更新数据源
                self.dataSource = dataSource.copy;
            } else {
                NSInteger index = (page - 1) * self.perPage;
                NSInteger count = page * self.perPage;
                NSMutableArray *dataSource = [NSMutableArray array];
                for (NSInteger i = index; i < count; i++) {
                    NSString *title = [NSString stringWithFormat:@"%@ 结果%ld", self.keyword, i];
                    MHSearchCommonSearchItemViewModel *itemViewModel = [[MHSearchCommonSearchItemViewModel alloc] initWithTitle:title subtitle:@"这是搜索到的文章的子标题..." desc:@"这是搜索到的文章的描述..." keyword:self.keyword];
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

/// 输入模块数据
- (void)_inputTypeModuleData:(NSString *)keyword {
    // 记录keyword
    self.keyword = keyword;
    MHSearchMode searchMode = MHStringIsNotEmpty(keyword) ? MHSearchModeRelated : MHSearchModeDefault;
    MHSearch *search = [MHSearch searchWithKeyword:keyword searchMode:searchMode];
    self.searchMode = searchMode;
    switch (self.searchType) {
        case MHSearchTypeDefault:
        {
            /// 默认搜索
            [self.requestRemoteDataCommand execute:@1];
            
        }
            break;
        case MHSearchTypeMoments:
        {
            [self.momentsViewModel.requestSearchKeywordCommand execute:search];
        }
            break;
        case MHSearchTypeSubscriptions:
        {
            [self.subscriptionsViewModel.requestSearchKeywordCommand execute:search];
        }
            break;
        case MHSearchTypeOfficialAccounts:
        {
            [self.officialAccountsViewModel.requestSearchKeywordCommand execute:search];
        }
            break;
        case MHSearchTypeMiniprogram:
        {
            [self.miniprogramViewModel.requestSearchKeywordCommand execute:search];
        }
            break;
        case MHSearchTypeMusic:
        {
            [self.musicViewModel.requestSearchKeywordCommand execute:search];
        }
            break;
        case MHSearchTypeSticker:
        {
            [self.stickerViewModel.requestSearchKeywordCommand execute:search];
        }
            break;
        default:
            break;
    }
}


/// 搜索模块数据
- (void)_searchTypeModuleData:(NSString *)keyword {
    // 记录keyword
    self.keyword = keyword;
    
    /// 空 search do nothing...
    if (MHStringIsEmpty(keyword)) {
        return ;
    }
    
    MHSearch *search = [MHSearch searchWithKeyword:keyword searchMode:MHSearchModeSearch];
    switch (self.searchType) {
        case MHSearchTypeDefault:
        {
            
        }
            break;
        case MHSearchTypeMoments:
        {
            [self.momentsViewModel.requestSearchKeywordCommand execute:search];
        }
            break;
        case MHSearchTypeSubscriptions:
        {
            [self.subscriptionsViewModel.requestSearchKeywordCommand execute:search];
        }
            break;
        case MHSearchTypeOfficialAccounts:
        {
            [self.officialAccountsViewModel.requestSearchKeywordCommand execute:search];
        }
            break;
        case MHSearchTypeMusic:
        {
            [self.musicViewModel.requestSearchKeywordCommand execute:search];
        }
            break;
        case MHSearchTypeMiniprogram:
        {
            [self.miniprogramViewModel.requestSearchKeywordCommand execute:search];
        }
            break;
        case MHSearchTypeSticker:
        {
            [self.stickerViewModel.requestSearchKeywordCommand execute:search];
        }
            break;
        default:
            break;
    }
}


//// 将各个模块的数据重置一下
- (void)_resetSearchTypeModuleData:(MHSearchType)searchType {
    // 传递关键字 将
    self.keyword = @"";
    // 默认搜索模式
    self.searchType = MHSearchTypeDefault;
    MHSearch *search = [MHSearch searchWithKeyword:@"" searchMode:MHSearchModeDefault];
    switch (searchType) {
        case MHSearchTypeMoments:
        {
            [self.momentsViewModel.requestSearchKeywordCommand execute:search];
        }
            break;
        case MHSearchTypeSubscriptions:
        {
            [self.subscriptionsViewModel.requestSearchKeywordCommand execute:search];
        }
            break;
        case MHSearchTypeOfficialAccounts:
        {
            [self.officialAccountsViewModel.requestSearchKeywordCommand execute:search];
        }
            break;
        case MHSearchTypeMusic:
        {
            [self.musicViewModel.requestSearchKeywordCommand execute:search];
        }
            break;
        case MHSearchTypeMiniprogram:
        {
            [self.miniprogramViewModel.requestSearchKeywordCommand execute:search];
        }
            break;
        case MHSearchTypeSticker:
        {
            [self.stickerViewModel.requestSearchKeywordCommand execute:search];
        }
            break;
        default:
        {
            NSLog(@"++++++++=== 默认搜索类型 ++++++==========");
        }
            break;
    }
}


#pragma mark - 辅助方法
- (NSArray *)_contacts2ContactItemViewModels:(NSArray *)results {
    if (MHObjectIsNil(results) || results.count == 0) return nil;
    NSArray *viewModels = [results.rac_sequence map:^(WPFPerson *person) {
        /// 将其转换
        MHSearchDefaultContactItemViewModel *viewModel = [[MHSearchDefaultContactItemViewModel alloc] initWithPerson:person];
        return viewModel;
    }].array;
    return viewModels ?: @[] ;
}


@end
