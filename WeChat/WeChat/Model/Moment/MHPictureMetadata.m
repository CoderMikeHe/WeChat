//
//  MHPictureMetadata.m
//  WeChat
//
//  Created by senba on 2017/12/21.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHPictureMetadata.h"

@implementation MHPictureMetadata
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"cutType" : @"cut_type"};
}
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    
    if ([_type isEqualToString:@"GIF"]) {
        _badgeType = MHPictureBadgeTypeGIF;
    } else {
        if (_width > 0 && (float)_height / _width > 3) {
            _badgeType = MHPictureBadgeTypeLong;
        }
    }
    return YES;
}
@end
