//
//  MHMoments.m
//  MHDevelopExample
//
//  Created by senba on 2017/7/7.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHMoments.h"

/// 多条说说
@implementation MHMoments
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"moments" : [MHMoment class]};
}
@end
