//
//  MHSearchTypeViewModel.h
//  WeChat
//
//  Created by admin on 2020/5/11.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHTableViewModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 搜索类型
FOUNDATION_EXTERN NSString * const  MHSearchTypeTypeKey ;
/// 侧滑返回回调
FOUNDATION_EXTERN NSString * const  MHSearchTypePopKey ;
/// 关键字
FOUNDATION_EXTERN NSString * const  MHSearchTypeKeywordKey;


@interface MHSearchTypeViewModel : MHTableViewModel

/// popSubject 侧滑返回回调
@property (nonatomic, readonly, strong) RACSubject *popSubject;

/// 搜索类型
@property (nonatomic, readonly, assign) MHSearchType searchType;

/// 键盘搜索 以及 点击关联结果
@property (nonatomic, readonly, strong) RACCommand *requestSearchKeywordCommand;

/// 关键字 搜索关键字
@property (nonatomic, readwrite, assign) NSString *keyword;

/// 搜索模式 默认是defalut
@property (nonatomic, readwrite, assign) MHSearchMode searchMode;
@end

NS_ASSUME_NONNULL_END
