//
//  MHSearchViewModel.m
//  WeChat
//
//  Created by admin on 2020/5/6.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchViewModel.h"
#import "MHWebViewModel.h"
#import "WPFPinYinDataManager.h"
#import "MHSearchDefaultContactItemViewModel.h"
#import "MHSearchDefaultMoreItemViewModel.h"
#import "MHSingleChatViewModel.h"
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
/// lockKeyword 锁定关键字
@property (nonatomic, readwrite, copy) NSString *lockKeyword;
/// searchMode
@property (nonatomic, readwrite, assign) MHSearchMode searchMode;


/// sectionTitles
@property (nonatomic, readwrite, copy) NSArray *sectionTitles;


/// 是否显示 searchMore 页面
@property (nonatomic, readwrite, assign) BOOL searchMore;
/// defaultViewModel
@property (nonatomic, readwrite, strong) MHSearchDefaultViewModel *defaultViewModel;

/// 默认搜索类型
@property (nonatomic, readwrite, assign) MHSearchDefaultType searchDefaultType;

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
    self.searchMore = NO;
    self.searchDefaultType = MHSearchDefaultTypeDefault;
    
    
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
    
    
    /// 默认数据源
    self.dataSource = @[@[self.searchTypeItemViewModel]];
    self.sectionTitles = @[@""];
    
    /// 选中cell 跳转的命令
    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSIndexPath * indexPath) {
        @strongify(self);
        NSInteger section = indexPath.section;
        NSInteger row = indexPath.row;
        if (self.searchMode == MHSearchModeRelated) {
            // 关联模式 点击cell 也是搜索模式
            NSArray *itemViewModels = self.dataSource[section];
            MHSearchDefaultItemViewModel *itemViewModel = itemViewModels[row];
            [self _push2ViewControllerItemViewModel:itemViewModel];
        }
        return [RACSignal empty];
    }];
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
                self.sectionTitles =@[@""];
                self.dataSource = @[@[self.searchTypeItemViewModel]];
            } else if (self.searchMode == MHSearchModeRelated ) {
                // 更新数据源
                self.dataSource = [self _fetchDataSource];
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
    
    MHSearchMode searchMode = MHStringIsNotEmpty(keyword) ? MHSearchModeRelated : MHSearchModeDefault;
    MHSearch *search = [MHSearch searchWithKeyword:keyword searchMode:searchMode];
    
    if (self.searchType == MHSearchTypeDefault && self.searchDefaultType != MHSearchDefaultTypeDefault) {
        // 这个是搜索更多页的内容
        
        /// 不做任何事
        return;
    }
    
    // 记录keyword
    self.keyword = keyword;
    self.searchMode = searchMode;
    switch (self.searchType) {
        case MHSearchTypeDefault:
        {
            /// 默认搜索 发起请求
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
            // 这种场景donothing 因为你已经关联出来了
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
    
    if (searchType == MHSearchTypeDefault && self.searchDefaultType != MHSearchDefaultTypeDefault) {
        // 如果是上一次是默认搜索
        self.keyword = self.lockKeyword.copy;
        self.searchMore = NO;
        self.searchDefaultType = MHSearchDefaultTypeDefault;
        self.defaultViewModel = nil;
        self.lockKeyword = nil;
        /// 不做任何事
        return;
    }
    
    // 默认搜索模式
    self.keyword = @"";
    self.searchMode = MHSearchModeDefault;
    self.searchType = MHSearchTypeDefault;
    MHSearch *search = [MHSearch searchWithKeyword:@"" searchMode:MHSearchModeDefault];
    switch (searchType) {
        case MHSearchTypeDefault:
        {
            /// 默认搜索 发起请求
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

// 根据不同页面下钻不同控制器
- (void)_push2ViewControllerItemViewModel:(MHSearchDefaultItemViewModel *)itemViewModel {
    
    if (itemViewModel.isSearchMore) {
        /// 更多搜索
        /// 根据类型判断下钻
        MHSearchDefaultMoreItemViewModel *moreItemViewModel = (MHSearchDefaultMoreItemViewModel *)itemViewModel;
        
        // 锁定关键字
        self.lockKeyword = self.keyword.copy;
        self.searchDefaultType = MHSearchDefaultTypeContacts;
        
        switch (itemViewModel.searchDefaultType) {
            case MHSearchDefaultTypeContacts: /// 下钻更多联系人
            {
                /// 下钻到
                self.defaultViewModel = [[MHSearchDefaultViewModel alloc] initWithServices:self.services params:@{MHViewModelUtilKey: moreItemViewModel.results, MHViewModelIDKey: @(MHSearchDefaultTypeContacts)}];
                self.searchMore = YES;
                
            }
                break;
            /// .....
            default:
                break;
        }
        
    } else {
        /// 根据类型判断下钻
        switch (itemViewModel.searchDefaultType) {
            case MHSearchDefaultTypeContacts: /// 下钻联系人聊天
            {
                MHSearchDefaultContactItemViewModel *contactItemViewModel = (MHSearchDefaultContactItemViewModel *)itemViewModel;
                /// 下钻单聊页面
                MHSingleChatViewModel *viewModel = [[MHSingleChatViewModel alloc] initWithServices:self.services params:@{MHViewModelUtilKey: contactItemViewModel.person.model}];
                [self.services pushViewModel:viewModel animated:YES];
            }
                break;
                
            default:
                break;
        }
        
    }
}

- (NSArray *)_fetchDataSource {
    // 数据源
    NSMutableArray *dataSource = [NSMutableArray array];
    NSMutableArray *sectionTitles = [NSMutableArray array];
    
    
    // 查询联系人数据
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
        if (contactItemViewModels.count > 3) {
            // 大于三条 有个更多数据
            NSMutableArray *temps = [NSMutableArray array];
            for (NSInteger i = 0; i < 3; i++) {
                MHSearchDefaultContactItemViewModel *vm = contactItemViewModels[i];
                [temps addObject:vm];
            }
            
            // 添加更多数据
            MHSearchDefaultMoreItemViewModel *vm = [[MHSearchDefaultMoreItemViewModel alloc] initWithResults:contactItemViewModels];
            vm.searchDefaultType = MHSearchDefaultTypeContacts;
            vm.title = @"更多联系人";
            vm.searchMore = YES;
            [temps addObject:vm];
            // 添加到数据源
            [dataSource addObject:temps];
        }else {
            // 少于三条 则直接添加
            [dataSource addObject:contactItemViewModels];
        }
        
        /// 添加titles
        [sectionTitles addObject:@"联系人"];
    }
    
    self.sectionTitles = sectionTitles.copy;
    
    return dataSource.copy;
}


- (NSArray *)_contacts2ContactItemViewModels:(NSArray *)results {
    if (MHObjectIsNil(results) || results.count == 0) return nil;
    NSArray *viewModels = [results.rac_sequence map:^(WPFPerson *person) {
        /// 将其转换
        MHSearchDefaultContactItemViewModel *viewModel = [[MHSearchDefaultContactItemViewModel alloc] initWithPerson:person];
        viewModel.searchDefaultType = MHSearchDefaultTypeContacts;
        return viewModel;
    }].array;
    return viewModels ?: @[] ;
}


@end
