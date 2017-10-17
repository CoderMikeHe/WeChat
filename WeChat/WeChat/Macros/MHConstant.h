//
//  MHConstant.h
//  WeChat
//
//  Created by senba on 2017/9/10.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/// Block
///------
typedef void (^VoidBlock)();
typedef BOOL (^BoolBlock)();
typedef int  (^IntBlock) ();
typedef id   (^IDBlock)  ();

typedef void (^VoidBlock_int)(int);
typedef BOOL (^BoolBlock_int)(int);
typedef int  (^IntBlock_int) (int);
typedef id   (^IDBlock_int)  (int);

typedef void (^VoidBlock_string)(NSString *);
typedef BOOL (^BoolBlock_string)(NSString *);
typedef int  (^IntBlock_string) (NSString *);
typedef id   (^IDBlock_string)  (NSString *);

typedef void (^VoidBlock_id)(id);
typedef BOOL (^BoolBlock_id)(id);
typedef int  (^IntBlock_id) (id);
typedef id   (^IDBlock_id)  (id);


#pragma mark - 应用相关的
/// 切换根控制器的通知 新特性
FOUNDATION_EXTERN NSString * const MHSwitchRootViewControllerNotification;
/// 切换根控制器的通知 UserInfo key
FOUNDATION_EXTERN NSString * const MHSwitchRootViewControllerUserInfoKey;

/// 插件Switch按钮值改变
FOUNDATION_EXTERN NSString * const MHPlugSwitchValueDidChangedNotification;




/// 全局分割线高度 .5
FOUNDATION_EXTERN CGFloat const MHGlobalBottomLineHeight;

/// 个性签名的最大字数为30
FOUNDATION_EXTERN NSUInteger const MHFeatureSignatureMaxWords;

/// 用户昵称的最大字数为20
FOUNDATION_EXTERN NSUInteger const MHNicknameMaxWords;

/// 简书首页地址
FOUNDATION_EXTERN NSString * const MHMyBlogHomepageUrl ;

/// 国家区号
FOUNDATION_EXTERN NSString * const MHMobileLoginZoneCodeKey ;
/// 手机号码
FOUNDATION_EXTERN NSString * const MHMobileLoginPhoneKey ;

/// 验证码时间
FOUNDATION_EXTERN NSUInteger const MHCaptchaFetchMaxWords;







