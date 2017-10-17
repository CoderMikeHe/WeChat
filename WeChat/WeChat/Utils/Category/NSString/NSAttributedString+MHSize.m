//
//  NSAttributedString+MHSize.m
//  SenbaUsed
//
//  Created by senba on 2017/5/29.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "NSAttributedString+MHSize.h"

@implementation NSAttributedString (MHSize)
- (CGSize)mh_sizeWithLimitSize:(CGSize)limitSize
{
    CGSize theSize;
    CGRect rect = [self boundingRectWithSize:limitSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    theSize.width = ceil(rect.size.width);
    theSize.height = ceil(rect.size.height);
    return theSize;
}

- (CGSize)mh_sizeWithLimitWidth:(CGFloat)limitWidth
{
    return [self mh_sizeWithLimitSize:CGSizeMake(limitWidth, MAXFLOAT)];
}
@end
