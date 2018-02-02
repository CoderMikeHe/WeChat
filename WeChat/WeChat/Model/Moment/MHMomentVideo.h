//
//  MHMomentVideo.h
//  WeChat
//
//  Created by senba on 2018/2/2.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//  视频

#import "MHObject.h"

@interface MHMomentVideo : MHObject
/// idstr
@property (nonatomic, readwrite, copy) NSString *idstr;

/// playUrl
@property (nonatomic, readwrite, copy) NSURL *playUrl;

/// duration
@property (nonatomic, readwrite, assign) NSInteger duration;

/// coverUrl
@property (nonatomic, readwrite, copy) NSURL *coverUrl;

/// fileName 这里用的是本地视频
@property (nonatomic, readwrite, copy) NSString *fileName;
@property (nonatomic, readwrite, strong) UIImage *coverImage;
@end
