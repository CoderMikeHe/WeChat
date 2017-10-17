//
//  MHFileManager.h
//  WeChat
//
//  Created by senba on 2017/10/10.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHFileManager : NSObject
#pragma mark - File manager methods
/**
 *  文件管理器
 */
+ (NSFileManager *)fileManager;
/**
 *  该路径是否存在
 */
+ (BOOL)isPathExist:(NSString *)path;
/**
 *  该文件是否存在
 */
+ (BOOL)isFileExist:(NSString *)path;
/**
 *  该文件夹是否存在
 */
+ (BOOL)isDirectoryExist:(NSString *)path;
/**
 *  移除该文件
 */
+ (BOOL)removeFile:(NSString *)path;
/**
 *  创建目录
 */
+ (BOOL)createDirectoryAtPath:(NSString *)path;
/**
 *  文件个数
 */
+ (NSUInteger)fileCountInPath:(NSString *)path;
/**
 *  目录大小
 */
+ (unsigned long long)folderSizeAtPath:(NSString *)path;

#pragma mark User directory methods
/**
 *  应用文件路径
 */
+ (NSString *)appDocumentDirectoryPath;
/**
 *  应用资源路径
 */
+ (NSString *)appResourcePath;
/**
 *  应用缓存路径
 */
+ (NSString *)appCachesDirectoryPath;
@end
