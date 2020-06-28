//
//  MHMainFrameViewModel.h
//  WeChat
//
//  Created by senba on 2017/9/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHTableViewModel.h"
#import "MHMainFrameItemViewModel.h"

#import "MHNavSearchBarViewModel.h"
#import "MHSearchViewModel.h"

@class MHPulldownAppletViewModel;

@interface MHMainFrameViewModel : MHTableViewModel

/// 商品数组 <MHLiveRoom *>
@property (nonatomic, readonly, copy) NSArray *liveRooms;

/// searchBarViewModel
@property (nonatomic, readonly, strong) MHNavSearchBarViewModel *searchBarViewModel;
/// searchViewModel
@property (nonatomic, readonly, strong) MHSearchViewModel *searchViewModel;
/// 搜索状态
@property (nonatomic, readonly, assign) MHNavSearchBarState searchState;
/// 弹出/消失 搜索内容页 回调
@property (nonatomic, readonly, strong) RACCommand *popCommand;

/// appletViewModel
@property (nonatomic, readonly, strong) MHPulldownAppletViewModel *appletViewModel;

@end
