//
//  MHSearchDefaultSearchItemViewModel.h
//  WeChat
//
//  Created by admin on 2020/5/25.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchDefaultItemViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MHSearchDefaultSearchItemViewModel : MHSearchDefaultItemViewModel

/// searchKeyword
@property (nonatomic, readonly, copy) NSString *searchKeyword;
/// 搜一搜 xx
@property (nonatomic, readonly, copy) NSAttributedString *titleAttr;
/// subtitle
@property (nonatomic, readonly, copy) NSString *subtitle;

/// keyword
@property (nonatomic, readonly, copy) NSString *keyword;
/// 是否是搜一搜
@property (nonatomic, readonly, assign) BOOL isSearch;


- (instancetype)initWithKeyWord:(NSString *)keyword searchKeyword:(NSString *)searchKeyword search:(BOOL)isSearch;

@end

NS_ASSUME_NONNULL_END
