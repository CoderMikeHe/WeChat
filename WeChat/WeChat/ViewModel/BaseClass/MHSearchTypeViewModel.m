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

@interface MHSearchTypeViewModel ()

/// popSubject 侧滑返回回调
@property (nonatomic, readwrite, strong) RACSubject *popSubject;

/// 搜索类型
@property (nonatomic, readwrite, assign) MHSearchType searchType;

/// search
@property (nonatomic, readwrite, strong) MHSearch *search;

/// 键盘搜索 以及 点击关联结果
@property (nonatomic, readwrite, strong) RACCommand *requestSearchKeywordCommand;

@end


@implementation MHSearchTypeViewModel
- (instancetype)initWithServices:(id<MHViewModelServices>)services params:(NSDictionary *)params
{
    if (self = [super initWithServices:services params:params]) {
        /// 搜索类型
        self.searchType = [params[MHSearchTypeTypeKey] integerValue];
        self.popSubject = params[MHSearchTypePopKey];
        self.keyword = params[MHSearchTypeKeywordKey];
        
        /// 默认模式
        self.searchMode = MHSearchModeDefault;
    }
    return self;
}

- (void)initialize {
    [super initialize];
    
    @weakify(self);
    
    /// searchMode + keyword 聚合起来
    /// 注意：这两个必须调用 sendNext 才会执行 reduce block
    RACSignal *signalMode = [[RACObserve(self, searchMode) distinctUntilChanged] skip:1];
    RACSignal *signalKeyword = [[RACObserve(self, keyword) distinctUntilChanged] skip:1];
    
//    [[[RACSignal
//       combineLatest:@[signalMode, signalKeyword]
//       reduce:^id(NSNumber *mode , NSString *text) {
//           @strongify(self);
//           // 监听
//           NSLog(@" 🔥 搜索类型 👉 %@  oooooo  搜索关键字 👉 %@", mode , text);
//
//           [self.requestRemoteDataCommand execute:@1];
//
//           return nil;
//       }]
//      distinctUntilChanged] subscribeNext:^(id x) {
//        NSLog(@" 🔥 搜索类型 结果 👉");
//    }];
    
    /// 搜索关键字的命令
    self.requestSearchKeywordCommand = [[RACCommand alloc] initWithSignalBlock:^(MHSearch *search) {
        @strongify(self)
        
        self.search = search;
        
        /// 细节处理 如果不是同一个 mode, 清空 dataSource 让页面立即进入指定模式的UI
        if (search.searchMode != self.searchMode) {
            self.dataSource = @[];
        }
        
        /// 一旦进入这里，就是进入搜索模式
        self.searchMode = search.searchMode;
        self.keyword = search.keyword;
        
        /// 请求数据
        [self.requestRemoteDataCommand execute:@1];
        
        // 回调一个信号 而不是空信号 不然子VM监听不到数据
        // return [RACSignal empty];  /// ❌ 这样子VM 监听不到数据
        
        // 方式一
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
@end
