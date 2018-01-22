//
//  MHMomentHelper.m
//  MHDevelopExample
//
//  Created by senba on 2017/7/17.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  

#import "MHMomentHelper.h"

@implementation MHMomentHelper
/// 时间转化
+ (NSString *)createdAtTimeWithSourceDate:(NSDate *)sourceDate{
    if (MHObjectIsNil(sourceDate)) return @"";
    
    static NSDateFormatter *fmt = nil;
    /// 由于NSDateFormatter 有一定的性能问题 故全局共享一个
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
        ///  真机调试的时候，必须加上这句
        fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    });
    // 判断是否为今年
    if (sourceDate.mh_isThisYear) {
        if (sourceDate.mh_isToday) { // 今天
            NSDateComponents *cmps = [sourceDate mh_deltaWithNow];
            if (cmps.hour >= 1) { // 至少是1小时前发的
                return [NSString stringWithFormat:@"%zd小时前", cmps.hour];
            } else if (cmps.minute >= 1) { // 1~59分钟之前发的
                return [NSString stringWithFormat:@"%zd分钟前", cmps.minute];
            }else { // 1分钟内发的
                return @"刚刚";
            }
        } else if (sourceDate.mh_isYesterday) { // 昨天
            fmt.dateFormat = @"昨天 HH:mm";
            return [fmt stringFromDate:sourceDate];
        } else { // 至少是前天
            fmt.dateFormat = @"MM-dd HH:mm";
            return [fmt stringFromDate:sourceDate];
        }
    } else { // 非今年
        fmt.dateFormat = @"yyyy-MM-dd";
        return [fmt stringFromDate:sourceDate];
    }
}


/// 电话号码正则
+ (NSRegularExpression *)regexPhoneNumber{
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"\\d{3,4}[- ]?\\d{7,8}" options:kNilOptions error:NULL];
    });
    return regex;
}

/// 链接正则
+ (NSRegularExpression *)regexLinkUrl{
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)" options:kNilOptions error:NULL];
    });
    return regex;
}
@end
