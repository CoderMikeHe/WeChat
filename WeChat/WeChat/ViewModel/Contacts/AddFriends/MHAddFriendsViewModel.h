//
//  MHAddFriendsViewModel.h
//  WeChat
//
//  Created by senba on 2017/9/22.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  添加好友

#import "MHCommonViewModel.h"
#import "MHSearchFriendsHeaderViewModel.h"
@interface MHAddFriendsViewModel : MHCommonViewModel
/// headerViewModel
@property (nonatomic, readonly, strong) MHSearchFriendsHeaderViewModel *headerViewModel;


@end
