//
//  MHLiveInfo.h
//  WeChat
//
//  Created by senba on 2017/11/3.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  热门直播信息

#import "MHObject.h"
#import "MHLiveRoom.h"
@interface MHLiveInfo : MHObject

/// 直播间列表
@property (nonatomic, readwrite, copy) NSArray <MHLiveRoom *> *list;

/// 总页数
@property (nonatomic, readwrite, assign) NSInteger totalPage;

/// 是否同城
@property (nonatomic, readwrite, assign) BOOL samecity;

/// hotConfig
@property (nonatomic, readwrite, assign) NSInteger hotConfig;

/// hotswitch
@property (nonatomic, readwrite, assign) id hotswitch;

/// hotswitch2
@property (nonatomic, readwrite, copy) NSArray *hotswitch2;

@end
