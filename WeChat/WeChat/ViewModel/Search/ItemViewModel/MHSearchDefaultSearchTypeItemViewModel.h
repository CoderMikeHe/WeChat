//
//  MHSearchDefaultSearchTypeItemViewModel.h
//  WeChat
//
//  Created by admin on 2020/5/7.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//  搜索页 默认样式

#import "MHViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface MHSearchDefaultSearchTypeItemViewModel : NSObject

/// searchTypeSubject
@property (nonatomic, readwrite, strong) RACSubject *searchTypeSubject;

@end

NS_ASSUME_NONNULL_END
