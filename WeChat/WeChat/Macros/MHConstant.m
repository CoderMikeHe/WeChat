//
//  MHConstant.m
//  WeChat
//
//  Created by senba on 2017/9/10.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHConstant.h"
#import <UIKit/UIKit.h>

#pragma mark - 应用相关的
/// 切换根控制器的通知 新特性
NSString * const MHSwitchRootViewControllerNotification = @"MHSwitchRootViewControllerNotification";
/// 切换根控制器的通知 UserInfo key
NSString * const MHSwitchRootViewControllerUserInfoKey = @"MHSwitchRootViewControllerUserInfoKey";
/// 插件Switch按钮值改变
NSString * const MHPlugSwitchValueDidChangedNotification = @"MHPlugSwitchValueDidChangedNotification";


/// 全局分割线高度 .5
CGFloat const MHGlobalBottomLineHeight = 0.5f;

/// 个性签名的最大字数为30
NSUInteger const MHFeatureSignatureMaxWords = 30;

/// 用户昵称的最大字数为20
NSUInteger const MHNicknameMaxWords = 20;


/// 简书首页地址
NSString * const MHMyBlogHomepageUrl = @"http://www.jianshu.com/u/126498da7523";

/// 国家区号
NSString * const MHMobileLoginZoneCodeKey = @"MHMobileLoginZoneCodeKey";
/// 手机号码
NSString * const MHMobileLoginPhoneKey = @"MHMobileLoginPhoneKey";

/// 验证码时间
NSUInteger const MHCaptchaFetchMaxWords = 60;
