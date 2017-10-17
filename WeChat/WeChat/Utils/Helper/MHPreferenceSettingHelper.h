//
//  MHPreferenceSettingHelper.h
//  WeChat
//
//  Created by senba on 2017/10/14.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 存储language
FOUNDATION_EXTERN NSString * const MHPreferenceSettingLanguage ;

/// 存储看一看
FOUNDATION_EXTERN NSString * const MHPreferenceSettingLook ;
/// 存储看一看（全新）
FOUNDATION_EXTERN NSString * const MHPreferenceSettingLookArtboard ;
/// 存储搜一搜
FOUNDATION_EXTERN NSString * const MHPreferenceSettingSearch ;
/// 存储搜一搜（全新）
FOUNDATION_EXTERN NSString * const MHPreferenceSettingSearchArtboard ;

@interface MHPreferenceSettingHelper : NSObject

+ (id)objectForKey:(NSString *)defaultName;
+ (void)setObject:(id)value forKey:(NSString *)defaultName;

+ (BOOL)boolForKey:(NSString *)defaultName;
+ (void)setBool:(BOOL)value forKey:(NSString *)defaultName;
@end
