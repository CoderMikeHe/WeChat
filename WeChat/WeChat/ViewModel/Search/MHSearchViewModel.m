//
//  MHSearchViewModel.m
//  WeChat
//
//  Created by admin on 2020/5/6.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchViewModel.h"
#import "MHWebViewModel.h"

@interface MHSearchViewModel ()

/// searchTypeViewModel
@property (nonatomic, readwrite, strong) MHSearchTypeItemViewModel *searchTypeViewModel;

/// searchTypeSubject
@property (nonatomic, readwrite, strong) RACSubject *searchTypeSubject;
/// 文本框输入回调 + 语音输入回调
@property (nonatomic, readwrite, strong) RACSubject *textSubject;

/// popItemSubject 子控制器（朋友圈、文章、 公众号、小程序、音乐、表情）侧滑返回回调
@property (nonatomic, readwrite, strong) RACSubject *popItemSubject;

/// officialAccountsViewModel
@property (nonatomic, readwrite, strong) MHSearchOfficialAccountsViewModel *officialAccountsViewModel;
/// momentsViewModel
@property (nonatomic, readwrite, strong) MHSearchMomentsViewModel *momentsViewModel;

/// searchType
@property (nonatomic, readwrite, assign) MHSearchType searchType;
/// keyword 关键字
@property (nonatomic, readwrite, copy) NSString *keyword;

@end
@implementation MHSearchViewModel


- (void)initialize {
    [super initialize];
    @weakify(self);
    self.searchTypeSubject = [RACSubject subject];
    self.textSubject = [RACSubject subject];
    self.popItemSubject = [RACSubject subject];
    
    /// 默认模式
    self.searchType = MHSearchTypeDefault;
    
    /// searchTypeSubject + textSubject 聚合起来
    /// 注意：这两个必须调用 sendNext 才会执行 reduce block
    [[[RACSignal
       combineLatest:@[self.searchTypeSubject, self.textSubject]
       reduce:^id(NSNumber *type , NSString *text) {
           @strongify(self);
           NSLog(@"type === %@   text === %@", type, text);
           MHSearchType searchType = type.integerValue;
           
           // 先记录一下关键字
           self.keyword = text;
           
           switch (searchType) {
               case MHSearchTypeDefault:
               {
                   /// 这里要处理一下 之前的searchType 重置一下数据
                   [self _resetSearchTypeData:self.searchType];
               }
                   break;
               case MHSearchTypeMoments:
               {
                   // 传递关键字
                   self.momentsViewModel.keyword = text;
               }
                   break;
               case MHSearchTypeOfficialAccounts:
               {
                   // 传递关键字
                   self.officialAccountsViewModel.keyword = text;
               }
                   break;
                   
               default:
                   break;
           }
           // 记录一下 searchType
           self.searchType = searchType;
           return nil;
       }]
      distinctUntilChanged] subscribeNext:^(id x) {
        
    }];
    

    // 创建viewModel
    self.searchTypeViewModel = [[MHSearchTypeItemViewModel alloc] init];
    self.searchTypeViewModel.searchTypeSubject = self.searchTypeSubject;
    
    // 公众号ViewModel
    self.officialAccountsViewModel = [[MHSearchOfficialAccountsViewModel alloc] initWithServices:self.services params:@{MHSearchTypeTypeKey: @(MHSearchTypeOfficialAccounts), MHSearchTypePopKey: self.popItemSubject, MHSearchTypeKeywordKey: @""}];
    
    // 朋友圈ViewModel
    self.momentsViewModel = [[MHSearchMomentsViewModel alloc] initWithServices:self.services params:@{MHSearchTypeTypeKey: @(MHSearchTypeMoments), MHSearchTypePopKey: self.popItemSubject, MHSearchTypeKeywordKey: @""}];
    
}

//// 将各个模块的数据重置一下
- (void)_resetSearchTypeData:(MHSearchType)searchType {
    switch (searchType) {
        case MHSearchTypeOfficialAccounts:
        {
            // 传递关键字 将
            self.keyword = @"";
            // 公众号初始化
            self.officialAccountsViewModel.keyword = @"";
        }
            break;
        case MHSearchTypeMoments:
        {
            // 传递关键字 将
            self.keyword = @"";
            // 传递关键字
            self.momentsViewModel.keyword = @"";
        }
            break;
        default:
            break;
    }
}


@end
