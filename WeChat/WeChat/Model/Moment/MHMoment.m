//
//  MHMoment.m
//  WeChat
//
//  Created by senba on 2017/12/20.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHMoment.h"

@implementation MHMoment
- (NSMutableArray<MHComment *> *)commentsList
{
    if (_commentsList == nil) {
        _commentsList = [[NSMutableArray alloc] init];
    }
    return _commentsList;
}

- (NSMutableArray<MHUser *> *)attitudesList
{
    if (_attitudesList == nil) {
        _attitudesList = [NSMutableArray array];
    }
    return _attitudesList;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"createdAt"        : @"created_at",
             @"sourceAllowClick" : @"source_allowclick",
             @"sourceUrl"        : @"source_url",
             @"attitudesStatus"  : @"attitudes_status",
             @"attitudesCount"   : @"attitudes_count",
             @"attitudesList"    : @"attitudes_list",
             @"commentsCount"    : @"comments_count",
             @"commentsList"     : @"comments_list",
             @"picInfos"         : @"pic_infos"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"picInfos"        : [MHPicture class],
             @"commentsList"    : [MHComment class],
             @"attitudesList"   : [MHUser class]
             };
}
@end
