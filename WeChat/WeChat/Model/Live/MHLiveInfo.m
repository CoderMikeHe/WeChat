//
//  MHLiveInfo.m
//  WeChat
//
//  Created by senba on 2017/11/3.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHLiveInfo.h"

@implementation MHLiveInfo
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"list":[MHLiveRoom class]};
}

@end
