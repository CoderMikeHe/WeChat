//
//  MHSearchDefaultMoreItemViewModel.h
//  WeChat
//
//  Created by admin on 2020/5/21.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//  搜索更多的vm

#import "MHSearchDefaultItemViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MHSearchDefaultMoreItemViewModel : MHSearchDefaultItemViewModel
/// 记录一下数据源
/// results
@property (nonatomic, readonly, copy) NSArray *results;

/// title
@property (nonatomic, readwrite, copy) NSString *title;

- (instancetype)initWithResults:(NSArray *)results;

@end

NS_ASSUME_NONNULL_END
