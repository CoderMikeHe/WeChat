//
//  NSError+MHExtension.m
//  SenbaUsed
//
//  Created by senba on 2017/5/22.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "NSError+MHExtension.h"

@implementation NSError (MHExtension)
+ (NSString *)mh_tipsFromError:(NSError *)error
{
    if (error)
    {
        NSString *tipStr = nil;
        if (error.userInfo[@"msg"]) {
            tipStr = [error.userInfo objectForKey:@"msg"];
        } else if (error.domain) {
            tipStr = error.domain;
        } else {
            tipStr = error.localizedDescription;
        }
        return tipStr;
    }
    return nil;
}
@end
