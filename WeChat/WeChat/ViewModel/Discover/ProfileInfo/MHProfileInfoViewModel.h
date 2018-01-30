//
//  MHProfileInfoViewModel.h
//  WeChat
//
//  Created by senba on 2018/1/29.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//  用户主页信息

#import "MHTableViewModel.h"
#import "MHUser.h"
@interface MHProfileInfoViewModel : MHTableViewModel
/// user
@property (nonatomic, readonly, strong) MHUser *user;

/// pictures
@property (nonatomic, readonly, copy) NSArray *pictures;

/// 是否是当前用户
@property (nonatomic, readonly, assign) BOOL currentUser;
@end
