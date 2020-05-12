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

/// 关键字 搜索关键字
@property (nonatomic, readwrite, assign) NSString *keyword;
@end

NS_ASSUME_NONNULL_END
