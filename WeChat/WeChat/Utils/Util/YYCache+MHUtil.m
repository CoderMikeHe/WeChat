//
//  YYCache+MHUtil.m
//  WeChat
//
//  Created by admin on 2020/5/14.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "YYCache+MHUtil.h"
/// 获取缓存的key
NSString * const MHSearchMusicHistoryCacheKey = @"MHSearchMusicHistoryCacheKey";

/// 整个应用的利用YYCache来做磁盘和内存缓存的文件名称，切记该文件只能使用YYCache来做处理 具有相同名称的多个实例将缓存不稳定
static NSString *const MHYYCacheName = @"com.yy.cache";

/// 整个应用的利用YYCache来做磁盘和内存缓存的文件目录，切记该文件只能使用YYCache来做处理
static inline NSString * MHYYCachePath(){
    NSString *cachePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:MHYYCacheName];
    return cachePath;
}

@implementation YYCache (MHUtil)

+ (instancetype)sharedCache {
    static YYCache *sharedCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCache = [[YYCache alloc] initWithPath:MHYYCachePath()];
    });
    return sharedCache;
}

@end
