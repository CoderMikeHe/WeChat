//
//  NSDateFormatter+Extension.m
//  YBJY
//
//  Created by apple on 16/8/11.
//  Copyright © 2016年 YouBeiJiaYuan. All rights reserved.
//

#import "NSDateFormatter+Extension.h"

@implementation NSDateFormatter (Extension)
+ (instancetype)mh_dateFormatter
{
    return [[self alloc] init];
}

+ (instancetype)mh_dateFormatterWithFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[self alloc] init];
    dateFormatter.dateFormat = dateFormat;
    return dateFormatter;
}

+ (instancetype)mh_defaultDateFormatter
{
    return [self mh_dateFormatterWithFormat:@"yyyy-MM-dd HH:mm:ss"];
}
@end
