//
//  MHSearchViewModel.h
//  WeChat
//
//  Created by admin on 2020/5/6.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHViewModel.h"
#import "MHSearchTypeItemViewModel.h"
#import "MHSearchOfficialAccountsViewModel.h"
#import "MHSearchMomentsViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MHSearchViewModel : MHViewModel

/// searchTypeViewModel
@property (nonatomic, readonly, strong) MHSearchTypeItemViewModel *searchTypeViewModel;

/// searchTypeSubject 点击搜索类型的回调
@property (nonatomic, readonly, strong) RACSubject *searchTypeSubject;

/// popItemSubject 子控制器（朋友圈、文章、 公众号、小程序、音乐、表情）侧滑返回回调
@property (nonatomic, readonly, strong) RACSubject *popItemSubject;

/// officialAccountsViewModel
@property (nonatomic, readonly, strong) MHSearchOfficialAccountsViewModel *officialAccountsViewModel;
/// momentsViewModel
@property (nonatomic, readonly, strong) MHSearchMomentsViewModel *momentsViewModel;

/// 文本框输入回调
@property (nonatomic, readonly, strong) RACSubject *textSubject;


/// keyword 关键字
@property (nonatomic, readonly, copy) NSString *keyword;
/// searchType 搜索类型
@property (nonatomic, readonly, assign) MHSearchType searchType;
@end

NS_ASSUME_NONNULL_END
