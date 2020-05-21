//
//  MHSearchViewModel.h
//  WeChat
//
//  Created by admin on 2020/5/6.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHTableViewModel.h"
#import "MHSearchDefaultSearchTypeItemViewModel.h"
#import "MHSearchOfficialAccountsViewModel.h"
#import "MHSearchMomentsViewModel.h"
#import "MHSearchSubscriptionsViewModel.h"
#import "MHSearchMiniprogramViewModel.h"
#import "MHSearchMusicViewModel.h"
#import "MHSearchStickerViewModel.h"
#import "MHSearchDefaultViewModel.h"
NS_ASSUME_NONNULL_BEGIN

/// 侧滑返回回调
FOUNDATION_EXTERN NSString * const  MHSearchViewPopCommandKey ;
/// 关键字

@interface MHSearchViewModel : MHTableViewModel

/// searchTypeSubject 点击搜索类型的回调
@property (nonatomic, readonly, strong) RACSubject *searchTypeSubject;

/// popItemCommand 子控制器（朋友圈、文章、 公众号、小程序、音乐、表情）侧滑返回回调 或者 点击searchBar 返回按钮的回调
@property (nonatomic, readonly, strong) RACCommand *popItemCommand;
/// 弹出搜索页或者隐藏搜索页的回调  以及侧滑搜索页回调
@property (nonatomic, readonly, strong) RACCommand *popCommand;

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
@property (nonatomic, readonly, strong) RACCommand *textCommand;
/// 点击键盘搜索
@property (nonatomic, readonly, strong) RACCommand *searchCommand;
/// 点击返回按钮回调
@property (nonatomic, readonly, strong) RACCommand *backCommand;

//// 传参给 NavSearchBar
/// keyword 关键字
@property (nonatomic, readonly, copy) NSString *keyword;
/// searchType 搜索类型
@property (nonatomic, readonly, assign) MHSearchType searchType;

/// 搜索状态
@property (nonatomic, readwrite, assign) MHNavSearchBarState searchState;

/// searchMode
@property (nonatomic, readonly, assign) MHSearchMode searchMode;

/// sectionTitles
@property (nonatomic, readonly, copy) NSArray *sectionTitles;


/// 是否显示 searchMore 页面
@property (nonatomic, readonly, assign) BOOL searchMore;
/// defaultViewModel
@property (nonatomic, readonly, strong) MHSearchDefaultViewModel *defaultViewModel;

@end

NS_ASSUME_NONNULL_END
