//
//  MHConfigureManager.h
//  WeChat
//
//  Created by senba on 2017/11/26.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHConfigureManager : NSObject
/// 配置公共资源
+ (void)configure;

/// 设置应用环境 YES:正式环境 NO:开发环境
+ (void)setApplicationFormalSetting:(BOOL)formalSetting;
/// 应用是否是正式环境 YES:正式 NO:开发
+ (BOOL)applicationFormalSetting;

/// 设置应用的提交到AppStore的上线环境的状态 YES:正式提交上线的环境 NO:预上线的环境（模拟提交到App Store的环境），前提必须是正式环境
+ (void)setApplicationAppStoreFormalSetting:(BOOL)formalSetting;
/// 应用是否是 AppStore的环境
+ (BOOL)applicationAppStoreFormalSetting;

/// 设置https YES：https NO：http
+ (void)setApplicationUseHttps:(BOOL)useHttps;
/// 是否是https请求方式
+ (BOOL)applicationUseHttps;

/// 请求Url
+ (NSString *)requestBaseUrl;
@end
