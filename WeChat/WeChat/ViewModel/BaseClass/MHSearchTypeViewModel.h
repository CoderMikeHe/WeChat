//
//  MHSearchTypeViewModel.h
//  WeChat
//
//  Created by admin on 2020/5/11.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHTableViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MHSearchTypeViewModel : MHTableViewModel

/// popSubject 侧滑返回回调
@property (nonatomic, readwrite, strong) RACSubject *popSubject;

/// 搜索类型
@property (nonatomic, readonly, assign) MHSearchType searchType;


@end

NS_ASSUME_NONNULL_END
