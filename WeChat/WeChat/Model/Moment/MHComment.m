//
//  MHComment.m
//  WeChat
//
//  Created by senba on 2017/12/21.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHComment.h"

@implementation MHComment
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"createdAt"        : @"created_at",
             @"momentIdstr"      : @"moment_idstr",
             @"toUser"           : @"to_user",
             @"fromUser"         : @"from_user"
             };
}
@end
