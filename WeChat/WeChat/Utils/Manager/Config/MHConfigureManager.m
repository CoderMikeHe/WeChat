//
//  MHConfigureManager.m
//  WeChat
//
//  Created by senba on 2017/11/26.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHConfigureManager.h"

///
static NSString *is_formal_setting = nil;
static NSString *is_use_https = nil;
static NSString *is_appStore_formal_setting = nil;

/// (AppStore环境的key)
static NSString * const MHApplicationAppStoreFormalSettingKey = @"MHApplicationAppStoreFormalSettingKey";
/// 正式环境key
static NSString * const MHApplicationFormalSettingKey = @"MHApplicationFormalSettingKey";
/// 使用Httpskey
static NSString * const MHApplicationUseHttpsKey = @"MHApplicationUseHttpsKey";

@implementation MHConfigureManager
/// 公共配置
+ (void)configure{
    /// 初始化一些公共配置...
    
}

+ (void)setApplicationFormalSetting:(BOOL)formalSetting{
    is_formal_setting = formalSetting?@"1":@"0";
    [[NSUserDefaults standardUserDefaults] setObject:is_formal_setting forKey:MHApplicationFormalSettingKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)applicationFormalSetting{
#if DEBUG
    if (!is_formal_setting) {
        is_formal_setting = [[NSUserDefaults standardUserDefaults] objectForKey:MHApplicationFormalSettingKey];
        is_formal_setting = [is_formal_setting sb_stringValueExtension];
    }
    return (is_formal_setting.integerValue == 1);
#else
    /// Release 模式下默认
    return YES;
#endif
}


+ (void)setApplicationAppStoreFormalSetting:(BOOL)formalSetting{
    is_appStore_formal_setting = formalSetting?@"1":@"0";
    [[NSUserDefaults standardUserDefaults] setObject:is_appStore_formal_setting forKey:MHApplicationAppStoreFormalSettingKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)applicationAppStoreFormalSetting{
#if DEBUG
    if (!is_appStore_formal_setting) {
        is_appStore_formal_setting = [[NSUserDefaults standardUserDefaults] objectForKey:MHApplicationAppStoreFormalSettingKey];
        is_appStore_formal_setting = [is_appStore_formal_setting sb_stringValueExtension];
    }
    return (is_appStore_formal_setting.integerValue == 1);
#else
    /// Release 默认是AppStore环境
    return YES;
#endif
}

+ (void)setApplicationUseHttps:(BOOL)useHttps{
    is_use_https = useHttps?@"1":@"0";
    [[NSUserDefaults standardUserDefaults] setObject:is_use_https forKey:MHApplicationUseHttpsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)applicationUseHttps{
#if DEBUG
    if (!is_use_https) {
        is_use_https = [[NSUserDefaults standardUserDefaults] objectForKey:MHApplicationUseHttpsKey];
        /// 正式环境
        if ([self applicationFormalSetting]) {
            /// 默认如果是nil 则加载Https
            if (is_use_https == nil) {
                is_use_https = @"1";
            }
        }
        is_use_https = [is_use_https sb_stringValueExtension];
    }
    return (is_use_https.integerValue == 1);
#else
    /// Release 默认是AppStore环境
    return YES;
#endif
}



/// 请求的baseUrl
+ (NSString *)requestBaseUrl{
    if ([self applicationFormalSetting])
    {
        /// 注意：这里针对你项目中请求baseUrl来处理....
        if ([self applicationAppStoreFormalSetting]) {
            /// AppStore正式环境
            NSLog(@"￥￥￥￥￥￥￥￥ AppStore正式环境 ￥￥￥￥￥￥￥￥");
            return [self applicationUseHttps] ? @"https://live.9158.com/":@"https://live.9158.com/";
        }else{
            /// 测试正式环境
            NSLog(@"￥￥￥￥￥￥￥￥ 测试正式环境 ￥￥￥￥￥￥￥￥");
            return [self applicationUseHttps] ? @"https://live.9158.com/":@"https://live.9158.com/";
        }
    } else {
        /// 测试环境
        NSLog(@"￥￥￥￥￥￥￥￥ 测试环境 ￥￥￥￥￥￥￥￥");
        return [self applicationUseHttps] ?@"https://live.9158.com/":@"https://live.9158.com/";
    }
}
@end
