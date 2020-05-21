//
//  MHSearchDefaultViewModel.h
//  WeChat
//
//  Created by admin on 2020/5/21.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHTableViewModel.h"
#import "MHSearchDefaultItemViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MHSearchDefaultViewModel : MHTableViewModel
/// sectionTitle
@property (nonatomic, readonly, copy) NSString *sectionTitle;
/// searchDefaultType
@property (nonatomic, readonly, assign) MHSearchDefaultType searchDefaultType;
/// 键盘搜索 以及 点击关联结果的回调 ，数据传递  MHSearch
@property (nonatomic, readonly, strong) RACCommand *requestSearchKeywordCommand;

/// 关键字 搜索关键字
@property (nonatomic, readonly, copy) NSString *keyword;
/// 搜索模式 默认是defalut
@property (nonatomic, readonly, assign) MHSearchMode searchMode;
/// search
@property (nonatomic, readonly, strong) MHSearch *search;
@end

NS_ASSUME_NONNULL_END
