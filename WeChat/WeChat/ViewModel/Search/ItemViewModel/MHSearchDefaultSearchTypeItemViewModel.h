//
//  MHSearchDefaultSearchTypeItemViewModel.h
//  WeChat
//
//  Created by admin on 2020/5/7.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//  搜索页 默认样式

#import "MHViewModel.h"
#import "MHSearchDefaultItemViewModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface MHSearchDefaultSearchTypeItemViewModel : MHSearchDefaultItemViewModel

/// searchTypeSubject
@property (nonatomic, readwrite, strong) RACSubject *searchTypeSubject;

@end

NS_ASSUME_NONNULL_END
