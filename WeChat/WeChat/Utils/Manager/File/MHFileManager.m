//
//  MHFileManager.m
//  WeChat
//
//  Created by senba on 2017/10/10.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHFileManager.h"

@implementation MHFileManager

/**
 *  文件管理器
 */
+ (NSFileManager *)fileManager
{
    return [NSFileManager defaultManager];
}
/**
 *  该路径是否存在
 */
+ (BOOL)isPathExist:(NSString *)path
{
    return [[self fileManager] fileExistsAtPath:path];
}
/**
 *  该文件是否存在
 */
+ (BOOL)isFileExist:(NSString *)path
{
    BOOL isDirectory;
    return [[self fileManager] fileExistsAtPath:path isDirectory:&isDirectory] && !isDirectory;
}
/**
 *  该文件夹是否存在
 */
+ (BOOL)isDirectoryExist:(NSString *)path
{
    BOOL isDirectory;
    return [[self fileManager] fileExistsAtPath:path isDirectory:&isDirectory] && isDirectory;
}

/**
 *  移除该文件
 */
+ (BOOL)removeFile:(NSString *)path
{
    return [[self fileManager] removeItemAtPath:path error:nil];
}

/** 创建目录 */
+ (BOOL)createDirectoryAtPath:(NSString *)path
{
    return [[self fileManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
}

/**
 *  文件个数
 */
+ (NSUInteger)fileCountInPath:(NSString *)path
{
    NSUInteger count = 0;
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:path];
    for (__unused NSString *fileName in fileEnumerator) {
        count += 1;
    }
    return count;
}

/**
 *  目录大小
 */
+ (unsigned long long)folderSizeAtPath:(NSString *)path
{
    __block unsigned long long totalFileSize = 0;
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:path];
    for (NSString *fileName in fileEnumerator) {
        NSString *filePath = [path stringByAppendingPathComponent:fileName];
        NSDictionary *fileAttrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        totalFileSize += fileAttrs.fileSize;
    }
    return totalFileSize;
}


#pragma mark User directory methods
/**
 *  应用文件路径
 */
+ (NSString *)appDocumentDirectoryPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}
/**
 *  应用资源路径
 */
+ (NSString *)appResourcePath
{
    return [[NSBundle mainBundle] resourcePath];
}
/**
 *  应用缓存路径
 */
+ (NSString *)appCachesDirectoryPath
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

@end
