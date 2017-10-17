//
//  MHHTTPService.h
//  WeChat
//
//  Created by senba on 2017/10/10.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "MHUser.h"
@interface MHHTTPService : AFHTTPSessionManager
/// 单例
+(instancetype) sharedInstance;
/// 存储用户
- (void)saveUser:(MHUser *)user;

/// 删除用户
- (void)deleteUser:(MHUser *)user;

/// 获取当前用户
- (MHUser *)currentUser;

/// 获取当前用户的id
- (NSString *)currentUserId;

/// 用户信息配置完成
- (void)postUserDataConfigureCompleteNotification;

/// 是否登录
- (BOOL)isLogin;

/// 用户登录
- (void)loginUser:(MHUser *)user;

/// 退出登录
- (void)logoutUser;
@end
