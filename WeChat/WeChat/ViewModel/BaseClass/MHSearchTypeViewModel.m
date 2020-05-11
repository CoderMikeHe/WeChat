//
//  MHSearchTypeViewModel.m
//  WeChat
//
//  Created by admin on 2020/5/11.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchTypeViewModel.h"

@interface MHSearchTypeViewModel ()

/// 搜索类型
@property (nonatomic, readwrite, assign) MHSearchType searchType;

@end


@implementation MHSearchTypeViewModel
- (instancetype)initWithServices:(id<MHViewModelServices>)services params:(NSDictionary *)params
{
    if (self = [super initWithServices:services params:params]) {
        /// 搜索类型
        self.searchType = [params[MHViewModelIDKey] integerValue];
        self.popSubject = params[MHViewModelUtilKey];
    }
    
    return self;
}
@end
