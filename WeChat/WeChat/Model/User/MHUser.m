//
//  MHUser.m
//  WeChat
//
//  Created by senba on 2017/10/9.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHUser.h"

@implementation MHUser
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"screenName"         : @"screen_name",
             @"profileImageUrl"    : @"profile_image_url",
             @"avatarLarge"        : @"avatar_large"
             };
}


/// 实现
- (BOOL)isEqual:(MHUser *)object
{
    /// 重写比对规则
    if([object isKindOfClass:[self class]])
    {
        return [self.idstr isEqualToString:object.idstr];
    }
    return [super isEqual:object];
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        _coverImage = MHImageNamed(@"Kris");
    }
    return self;
}
@end
