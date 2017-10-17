//
//  NSString+MHValid.h
//  MHDevelopExample
//
//  Created by senba on 2017/6/12.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MHValid)

/// 检测字符串是否包含中文
+( BOOL)mh_isContainChinese:(NSString *)str;

/// 整形
+ (BOOL)mh_isPureInt:(NSString *)string;

/// 浮点型
+ (BOOL)mh_isPureFloat:(NSString *)string;

/// 有效的手机号码
+ (BOOL)mh_isValidMobile:(NSString *)str;

/// 纯数字
+ (BOOL)mh_isPureDigitCharacters:(NSString *)string;

/// 字符串为字母或者数字
+ (BOOL)mh_isValidCharacterOrNumber:(NSString *)str;

/// 判断字符串全是空格or空
+ (BOOL) mh_isEmpty:(NSString *) str;

/// 是否是正确的邮箱
+ (BOOL) mh_isValidEmail:(NSString *)email;

/// 是否是正确的QQ
+ (BOOL) mh_isValidQQ:(NSString *)QQ;

@end
