//
//  MHPicture.m
//  WeChat
//
//  Created by senba on 2017/12/21.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHPicture.h"

@implementation MHPicture
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"picID" : @"pic_id",
             @"keepSize" : @"keep_size",
             @"photoTag" : @"photo_tag",
             @"objectID" : @"object_id",
             @"middlePlus" : @"middleplus"};
}
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    // 自动 model-mapper 不能完成的，这里可以进行额外处理
    MHPictureMetadata *meta = _large ? _large : _largest ? _largest : _original;
    _badgeType = meta.badgeType;
    return YES;
}
@end
