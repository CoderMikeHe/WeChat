//
//  MHSearchDefaultViewModel.m
//  WeChat
//
//  Created by admin on 2020/5/21.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchDefaultViewModel.h"
#import "MHSearchDefaultContactItemViewModel.h"
#import "MHSearchDefaultGroupChatItemViewModel.h"
#import "MHSingleChatViewModel.h"
#import "MHGroupChatViewModel.h"
#import "WPFPinYinDataManager.h"

#import "MHContactsService.h"

/// 侧滑返回回调
NSString * const MHSearchDefaultPopCommandKey = @"MHSearchDefaultPopCommandKey";

@interface MHSearchDefaultViewModel ()

/// sectionTitle
@property (nonatomic, readwrite, copy) NSString *sectionTitle;
/// searchDefaultType
@property (nonatomic, readwrite, assign) MHSearchDefaultType searchDefaultType;
/// 键盘搜索 以及 点击关联结果
@property (nonatomic, readwrite, strong) RACCommand *requestSearchKeywordCommand;
/// popCommand 侧滑返回回调
@property (nonatomic, readwrite, strong) RACCommand *popCommand;
/// search
@property (nonatomic, readwrite, strong) MHSearch *search;
/// 关键字 搜索关键字
@property (nonatomic, readwrite, copy) NSString *keyword;
/// 搜索模式 默认是defalut
@property (nonatomic, readwrite, assign) MHSearchMode searchMode;
@end

@implementation MHSearchDefaultViewModel

- (instancetype)initWithServices:(id<MHViewModelServices>)services params:(NSDictionary *)params{
    if (self = [super initWithServices:services params:params]) {
        // 传过来的数据源
        NSArray *results = params[MHViewModelUtilKey];
        MHSearchDefaultType searchDefaultType = [params[MHViewModelIDKey] integerValue];
        self.searchDefaultType = searchDefaultType;
        
        NSString *sectionTitle = @"";
        switch (searchDefaultType) {
            case MHSearchDefaultTypeContacts:
                sectionTitle = @"联系人";
                break;
            case MHSearchDefaultTypeGroupChat:
                sectionTitle = @"群聊";
                break;
            default:
                break;
        }
        
        self.sectionTitle = sectionTitle;
        self.dataSource = results.copy;
        
        self.popCommand = params[MHSearchDefaultPopCommandKey];
    }
    return self;
}

- (void)initialize {
    [super initialize];
    
    self.style = UITableViewStyleGrouped;
    self.shouldRequestRemoteDataOnViewDidLoad = NO;
    
    @weakify(self);
    /// 选中cell 跳转的命令
    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSIndexPath * indexPath) {
        @strongify(self);
        NSInteger section = indexPath.section;
        NSInteger row = indexPath.row;
        // 关联模式 点击cell 也是搜索模式
        MHSearchDefaultItemViewModel *itemViewModel = self.dataSource[row];
        
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
            case MHSearchDefaultTypeGroupChat: /// 下钻群聊聊天
            {
                MHSearchDefaultGroupChatItemViewModel *groupChatItemViewModel = (MHSearchDefaultGroupChatItemViewModel *)itemViewModel;
                /// 下钻群聊页面
                MHGroupChatViewModel *viewModel = [[MHGroupChatViewModel alloc] initWithServices:self.services params:@{MHViewModelUtilKey: groupChatItemViewModel.groupUsers, MHViewModelTitleKey: groupChatItemViewModel.groupChatName}];
                [self.services pushViewModel:viewModel animated:YES];
            }
                break;
            default:
                break;
        }
        
        return [RACSignal empty];
    }];
    
    
    /// 搜索关键字的命令
    self.requestSearchKeywordCommand = [[RACCommand alloc] initWithSignalBlock:^(MHSearch *search) {
        @strongify(self)
        
        self.search = search;
        
        /// 细节处理 如果不是同一个 mode, 清空 dataSource 让页面立即进入指定模式的UI
        if (search.searchMode != self.searchMode) {
            /// 一旦进入这里，就是进入搜索模式
            self.searchMode = search.searchMode;
            
            self.dataSource = @[];
        }
        
        // 记录关键字
        self.keyword = search.keyword;
        
        /// 请求数据
        [self.requestRemoteDataCommand execute:@1];
        
        // 回调一个信号 而不是空信号 不然子VM监听不到数据
        // return [RACSignal empty];  /// ❌ 这样子VM 监听不到数据
        
        // 方式一 OK
        //        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        //            @strongify(self);
        //            [subscriber sendNext:search];
        //            [subscriber sendCompleted];
        //            return [RACDisposable disposableWithBlock:^{
        //                /// 取消任务
        //            }];
        //        }];
        /// 方式二 推荐
        return [RACSignal return:search];
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
                self.sectionTitle = @"";
                self.dataSource = @[];
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


- (NSArray *)_fetchDataSource {
    // 数据源
    NSMutableArray *dataSource = [NSMutableArray array];
    
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
    
    if (self.searchDefaultType == MHSearchDefaultTypeContacts) {
        // 转成itemViewMdoel
        NSArray *itemViewModels = [self _contacts2ContactItemViewModels:contacts];
        if (MHArrayIsEmpty(itemViewModels)) {
            MHSearchDefaultNoResultItemViewModel *noResultItemViewModel = [[MHSearchDefaultNoResultItemViewModel alloc] initWithKeyword:self.keyword searchDefaultType:self.searchDefaultType];
            noResultItemViewModel.searchDefaultType = MHSearchDefaultTypeNoResult;
            // 清空
            self.sectionTitle = @"";
            [dataSource addObject:noResultItemViewModel];
        }else {
            // 赋值
            self.sectionTitle = @"联系人";
            [dataSource addObjectsFromArray:itemViewModels];
        }
    } if (self.searchDefaultType == MHSearchDefaultTypeGroupChat) {
        /// 转成群聊itemViewModels
        NSArray *itemViewModels = [self _contacts2GroupChatItemViewModels:contacts];
        if (MHArrayIsEmpty(itemViewModels)) {
            MHSearchDefaultNoResultItemViewModel *noResultItemViewModel = [[MHSearchDefaultNoResultItemViewModel alloc] initWithKeyword:self.keyword searchDefaultType:self.searchDefaultType];
            noResultItemViewModel.searchDefaultType = MHSearchDefaultTypeNoResult;
            // 清空
            self.sectionTitle = @"";
            [dataSource addObject:noResultItemViewModel];
        }else {
            // 赋值
            self.sectionTitle = @"群聊";
            [dataSource addObjectsFromArray:itemViewModels];
        }
    }
    
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


- (NSArray *)_contacts2GroupChatItemViewModels:(NSArray *)results {
    if (MHObjectIsNil(results) || results.count == 0) return nil;
    
    NSMutableArray *viewModels = [NSMutableArray array];
    
    /// 3-9
    NSInteger count = MIN(7, results.count);
    /// 查询数据
    for (NSInteger i=0; i<count; i++) {
        /// 取出查询person
        WPFPerson *person = results[i];
        MHUser *user = (MHUser *)person.model;
        NSString *wechatId = user.wechatId;
        
        /// users 组群聊用户
        NSMutableArray *users = [NSMutableArray array];
        // 首先将查到的数据添加进来
        [users addObject:user];
        
        
        NSInteger cnt = [MHContactsService sharedInstance].girlFriends.count;
        NSInteger initJ = 0;
        
        /// 因为只有33个女朋友
        if (i < 6) {
            if (i != 0) {
                initJ = (2 + i - 1 + 2)/2 * i;
            }
        }else {
            initJ = cnt - 9;
        }
        
        for (NSInteger j = initJ; j < cnt; j++) {
            
            MHUser *girl = [MHContactsService sharedInstance].girlFriends[j];
            if ([girl.wechatId isEqualToString:wechatId]) {
                // 相同则跳过
                continue;
            }
            [users addObject:girl];
            
            /// 超过则直接退出循环
            if (users.count >= (i+3)) {
                break;
            }
        }
        
        /// 把
        MHSearchDefaultGroupChatItemViewModel *viewModel = [[MHSearchDefaultGroupChatItemViewModel alloc] initWithPerson:person groupUsers:users];
        viewModel.searchDefaultType = MHSearchDefaultTypeGroupChat;
        
        [viewModels addObject:viewModel];
    }
    
    
    
    return viewModels.copy;
}

@end
