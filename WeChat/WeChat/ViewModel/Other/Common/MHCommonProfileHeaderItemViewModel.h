//
//  MHCommonProfileHeaderItemViewModel.h
//  WeChat
//
//  Created by senba on 2017/9/21.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  用户信息的ItemViewModel

#import "MHCommonItemViewModel.h"
#import "MHUser.h"
@interface MHCommonProfileHeaderItemViewModel : MHCommonItemViewModel

/// 用户头像
@property (nonatomic, readonly, strong) MHUser *user;


- (instancetype)initViewModelWithUser:(MHUser *)user;
@end
