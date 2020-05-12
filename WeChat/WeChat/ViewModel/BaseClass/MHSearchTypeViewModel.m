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

@end


@implementation MHSearchTypeViewModel
- (instancetype)initWithServices:(id<MHViewModelServices>)services params:(NSDictionary *)params
{
    if (self = [super initWithServices:services params:params]) {
        /// 搜索类型
        self.searchType = [params[MHSearchTypeTypeKey] integerValue];
        self.popSubject = params[MHSearchTypePopKey];
        self.keyword = params[MHSearchTypeKeywordKey];
    }
    return self;
}
@end
