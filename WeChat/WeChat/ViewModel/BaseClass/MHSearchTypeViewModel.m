//
//  MHSearchTypeViewModel.m
//  WeChat
//
//  Created by admin on 2020/5/11.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchTypeViewModel.h"

/// 搜索类型
NSString * const  MHSearchTypeTypeKey = @"MHSearchTypeTypeKey" ;
/// 侧滑返回回调
NSString * const  MHSearchTypePopKey = @"MHSearchTypePopKey";
/// 关键字
NSString * const  MHSearchTypeKeywordKey = @"MHSearchTypeKeywordKey";
/// 关键字
NSString * const  MHSearchTypeKeywordCommandKey = @"MHSearchTypeKeywordCommandKey";



@interface MHSearchTypeViewModel ()

/// popCommand 侧滑返回回调
@property (nonatomic, readwrite, strong) RACCommand *popCommand;

/// 搜索类型
@property (nonatomic, readwrite, assign) MHSearchType searchType;

/// search
@property (nonatomic, readwrite, strong) MHSearch *search;
/// 关键字 搜索关键字
@property (nonatomic, readwrite, copy) NSString *keyword;

/// 搜索模式 默认是defalut
@property (nonatomic, readwrite, assign) MHSearchMode searchMode;

/// 键盘搜索 以及 点击关联结果
@property (nonatomic, readwrite, strong) RACCommand *requestSearchKeywordCommand;


/// MHSearchModeRelated 场景下 点击关联符号的事件
@property (nonatomic, readwrite, strong) RACCommand *relatedKeywordCommand;
/// relatedKeywords0  假数据 仅仅模拟微信的逻辑
@property (nonatomic, readwrite, copy) NSArray *relatedKeywords0;
/// relatedKeywords1  假数据 仅仅模拟微信的逻辑
@property (nonatomic, readwrite, copy) NSArray *relatedKeywords1;
/// relatedCount
@property (nonatomic, readwrite, assign) NSInteger relatedCount;
@end


@implementation MHSearchTypeViewModel
- (instancetype)initWithServices:(id<MHViewModelServices>)services params:(NSDictionary *)params
{
    if (self = [super initWithServices:services params:params]) {
        /// 搜索类型
        self.searchType = [params[MHSearchTypeTypeKey] integerValue];
        self.popCommand = params[MHSearchTypePopKey];
        self.keyword = params[MHSearchTypeKeywordKey];
        self.keywordCommand = params[MHSearchTypeKeywordCommandKey];
        
        /// 默认模式
        self.searchMode = MHSearchModeDefault;
        
        
        /// 来源 <生僻字> 欺负我不会写
        self.relatedKeywords0 = @[@"猰",@"貐",@"鷞",@"鼗",@"鷩",@"橐",@"夔",@"蠹"];
        self.relatedKeywords1 = @[@"襳",@"觱",@"蠡",@"瞀"];
    }
    return self;
}

- (void)initialize {
    [super initialize];
    
    @weakify(self);
    
    /// 搜索关键字的命令
    self.requestSearchKeywordCommand = [[RACCommand alloc] initWithSignalBlock:^(MHSearch *search) {
        @strongify(self)
        
        self.search = search;
        
        /// 细节处理 如果不是同一个 mode, 清空 dataSource 让页面立即进入指定模式的UI
        if (search.searchMode != self.searchMode) {
            /// 一旦进入这里，就是进入搜索模式
            self.searchMode = search.searchMode;
           
            self.dataSource = @[];
            
            /// 模式一旦不同 立即请0
            self.relatedCount = 0;
        }
        
        /// 如果是搜索模式 且 关键字与上一次不一样 则回调给searchBar
        if (self.searchMode == MHSearchModeSearch && ![self.keyword isEqualToString:search.keyword]) {
            /// 回调数据到 搜索框
            [self.keywordCommand execute:search.keyword];
        }

        /// 如果用户一旦输入文字 且 关键字与上一次不一样  , 则立即将关联次数清0
        if (self.searchMode == MHSearchModeRelated && ![self.keyword isEqualToString:search.keyword]) {
            self.relatedCount = 0;
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
    
    
    /// 关联关键字的命令
    self.relatedKeywordCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *input) {
        @strongify(self);
        // 增加关联次数
        self.relatedCount++;
        /// 回调数据到 搜索框
        [self.keywordCommand execute:input];
        
        /// 修改值
        self.search.keyword = input;
        /// 请求数据
        self.keyword = input;
        /// 请求数据
        [self.requestRemoteDataCommand execute:@1];
        return [RACSignal empty];
    }];
}
@end
