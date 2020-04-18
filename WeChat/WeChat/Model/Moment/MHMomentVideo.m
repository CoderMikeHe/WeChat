//
//  MHMomentVideo.m
//  WeChat
//
//  Created by senba on 2018/2/2.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "MHMomentVideo.h"

@implementation MHMomentVideo

- (void)setFileName:(NSString *)fileName{
    _fileName = [fileName copy];
    
    /// 这里设置封面和播放地址  因为这里都是本地的
    if (!MHStringIsNotEmpty(fileName)) return;
    NSString *urlStr = [[NSBundle mainBundle]pathForResource:fileName ofType:nil];
    self.playUrl = [NSURL fileURLWithPath:urlStr];
    
    /// 获取视频第一政
    self.coverImage = [UIImage mh_thumbnailImageForVideo:self.playUrl atTime:1];
    
    // 写到本地
    NSData *data = UIImageJPEGRepresentation(self.coverImage, 1);
    NSString *cache = MHCachesDirectory;
    BOOL rst = [data writeToFile:@"/Users/admin/Desktop/2019WeChat/Src/moments/abc.png" atomically:NO];
    NSLog(@"%d   %@",rst , cache);
}

@end
