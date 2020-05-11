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

///
@end

NS_ASSUME_NONNULL_END
