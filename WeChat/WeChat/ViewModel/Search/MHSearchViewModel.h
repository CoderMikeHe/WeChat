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
#import "MHSearchSubscriptionsViewModel.h"
#import "MHSearchMiniprogramViewModel.h"
#import "MHSearchMusicViewModel.h"
#import "MHSearchStickerViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MHSearchViewModel : MHViewModel

/// searchTypeViewModel
@property (nonatomic, readonly, strong) MHSearchTypeItemViewModel *searchTypeViewModel;

/// searchTypeSubject 点击搜索类型的回调
@property (nonatomic, readonly, strong) RACSubject *searchTypeSubject;

/// popItemSubject 子控制器（朋友圈、文章、 公众号、小程序、音乐、表情）侧滑返回回调
@property (nonatomic, readonly, strong) RACSubject *popItemSubject;

/// momentsViewModel
@property (nonatomic, readonly, strong) MHSearchMomentsViewModel *momentsViewModel;
/// subscriptionsViewModel
@property (nonatomic, readonly, strong) MHSearchSubscriptionsViewModel *subscriptionsViewModel;
/// officialAccountsViewModel
@property (nonatomic, readonly, strong) MHSearchOfficialAccountsViewModel *officialAccountsViewModel;
/// miniprogramViewModel
@property (nonatomic, readonly, strong) MHSearchMiniprogramViewModel *miniprogramViewModel;
/// musicViewModel
@property (nonatomic, readonly, strong) MHSearchMusicViewModel *musicViewModel;
/// stickerViewModel
@property (nonatomic, readonly, strong) MHSearchStickerViewModel *stickerViewModel;


//// 处理 NavSearchBar 的回调
/// 文本框输入回调
@property (nonatomic, readonly, strong) RACSubject *textSubject;
/// 点击键盘搜索
@property (nonatomic, readonly, strong) RACCommand *searchCommand;
/// 点击返回按钮回调
@property (nonatomic, readonly, strong) RACCommand *backCommand;

//// 传参给 NavSearchBar
/// keyword 关键字
@property (nonatomic, readonly, copy) NSString *keyword;
/// searchType 搜索类型
@property (nonatomic, readonly, assign) MHSearchType searchType;
@end

NS_ASSUME_NONNULL_END
