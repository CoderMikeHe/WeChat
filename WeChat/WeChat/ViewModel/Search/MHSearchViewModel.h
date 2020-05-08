//
//  MHSearchViewModel.h
//  WeChat
//
//  Created by admin on 2020/5/6.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHViewModel.h"
#import "MHSearchTypeViewModel.h"
#import "MHSearchOfficialAccountsViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MHSearchViewModel : MHViewModel

/// searchTypeViewModel
@property (nonatomic, readonly, strong) MHSearchTypeViewModel *searchTypeViewModel;

/// searchTypeSubject 点击搜索类型的回调
@property (nonatomic, readonly, strong) RACSubject *searchTypeSubject;

/// officialAccountsViewModel
@property (nonatomic, readonly, strong) MHSearchOfficialAccountsViewModel *officialAccountsViewModel;
@end

NS_ASSUME_NONNULL_END
