//
//  MHConstInline.h
//  WeChat
//
//  Created by senba on 2017/9/21.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#ifndef MHConstInline_h
#define MHConstInline_h

/// 网络图片的占位图片
static inline UIImage *MHWebImagePlaceholder(){
    return [UIImage imageNamed:@"placeholder_image"];
}

/// 网络头像
static inline UIImage *MHWebAvatarImagePlaceholder(){
    return [UIImage imageNamed:@"DefaultProfileHead_66x66"];
}

/// 适配
static inline CGFloat MHPxConvertToPt(CGFloat px){
    return ceil(px * [UIScreen mainScreen].bounds.size.width/414.0f);
}




/// 辅助方法 创建一个文件夹
static inline void MHCreateDirectoryAtPath(NSString *path){
    BOOL isDir = NO;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
    if (isExist) {
        if (!isDir) {
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
            [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        }
    } else {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
}
/// 微信重要数据备份的文件夹路径，通过NSFileManager来访问
static inline NSString *MHWeChatDocDirPath(){
    return [MHDocumentDirectory stringByAppendingPathComponent:MH_WECHAT_DOC_NAME];
}
/// 通过NSFileManager来获取指定重要数据的路径
static inline NSString *MHFilePathFromWeChatDoc(NSString *filename){
    NSString *docPath = MHWeChatDocDirPath();
    MHCreateDirectoryAtPath(docPath);
    return [docPath stringByAppendingPathComponent:filename];
}

/// 微信轻量数据备份的文件夹路径，通过NSFileManager来访问
static inline NSString *MHWeChatCacheDirPath(){
    return [MHCachesDirectory stringByAppendingPathComponent:MH_WECHAT_CACHE_NAME];
}
/// 通过NSFileManager来访问 获取指定轻量数据的路径
static inline NSString *MHFilePathFromWeChatCache(NSString *filename){
    NSString *cachePath = MHWeChatCacheDirPath();
    MHCreateDirectoryAtPath(cachePath);
    return [cachePath stringByAppendingPathComponent:filename];
}



#endif /* MHConstInline_h */
