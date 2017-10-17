//
//  MHCommonGroupViewModel.m
//  WeChat
//
//  Created by senba on 2017/9/14.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHCommonGroupViewModel.h"

@implementation MHCommonGroupViewModel
+ (instancetype)groupViewModel{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _footerHeight = 21;
        _headerHeight = CGFLOAT_MIN;
    }
    return self;
}
@end
