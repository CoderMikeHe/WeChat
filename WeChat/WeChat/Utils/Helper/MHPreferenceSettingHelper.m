//
//  MHPreferenceSettingHelper.m
//  WeChat
//
//  Created by senba on 2017/10/14.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  项目的偏好设置工具类

#import "MHPreferenceSettingHelper.h"
/// 偏好设置
#define MHUserDefaults [NSUserDefaults standardUserDefaults]

/// 存储language
NSString * const MHPreferenceSettingLanguage = @"MHPreferenceSettingLanguage";

/// 存储看一看
NSString * const MHPreferenceSettingLook = @"MHPreferenceSettingLook";
/// 存储看一看（全新）
NSString * const MHPreferenceSettingLookArtboard = @"MHPreferenceSettingLookArtboard";

/// 存储搜一搜
NSString * const MHPreferenceSettingSearch = @"MHPreferenceSettingSearch" ;
/// 存储搜一搜（全新）
NSString * const MHPreferenceSettingSearchArtboard = @"MHPreferenceSettingSearchArtboard" ;

@implementation MHPreferenceSettingHelper

+ (id)objectForKey:(NSString *)defaultName{
    return [MHUserDefaults objectForKey:defaultName];
}

+ (void)setObject:(id)value forKey:(NSString *)defaultName
{
    [MHUserDefaults setObject:value forKey:defaultName];
    [MHUserDefaults synchronize];
}

+ (BOOL)boolForKey:(NSString *)defaultName
{
    return [MHUserDefaults boolForKey:defaultName];
}

+ (void)setBool:(BOOL)value forKey:(NSString *)defaultName
{
    [MHUserDefaults setBool:value forKey:defaultName];
    [MHUserDefaults synchronize];
}
@end
