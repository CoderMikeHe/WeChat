//
//  MHMomentShareInfo.h
//  WeChat
//
//  Created by senba on 2018/2/1.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "MHObject.h"

@interface MHMomentShareInfo : MHObject

/// title
@property (nonatomic, readwrite, copy) NSString *title;
/// descr
@property (nonatomic, readwrite, copy) NSString *descr;
/// thumbImage
@property (nonatomic, readwrite, copy) NSURL *thumbImage;

/// 分享链接 -- 分享文章
@property (nonatomic, readwrite, copy) NSString *url;

/// shareInfoType
@property (nonatomic, readwrite, assign) MHMomentShareInfoType shareInfoType;

@end
