//
//  MHSearchViewModel.m
//  WeChat
//
//  Created by admin on 2020/5/6.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchViewModel.h"
#import "MHWebViewModel.h"

/// 侧滑返回回调
NSString * const  MHSearchViewPopCommandKey = @"MHSearchViewPopCommandKey";

@interface MHSearchViewModel ()

/// searchTypeViewModel
@property (nonatomic, readwrite, strong) MHSearchTypeItemViewModel *searchTypeViewModel;

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
    
    /// 默认模式
    self.searchType = MHSearchTypeDefault;
    
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
    self.searchTypeViewModel = [[MHSearchTypeItemViewModel alloc] init];
    self.searchTypeViewModel.searchTypeSubject = self.searchTypeSubject;
    
    
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
}

#pragma mark - 辅助方法

/// 输入模块数据
- (void)_inputTypeModuleData:(NSString *)keyword {
    // 记录keyword
    self.keyword = keyword;
    
    MHSearchMode searchMode = MHStringIsNotEmpty(keyword) ? MHSearchModeRelated : MHSearchModeDefault;
    MHSearch *search = [MHSearch searchWithKeyword:keyword searchMode:searchMode];
    
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


@end
