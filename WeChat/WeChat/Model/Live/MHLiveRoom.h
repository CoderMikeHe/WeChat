//
//  MHLiveRoom.h
//  WeChat
//
//  Created by senba on 2017/10/19.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHObject.h"

@interface MHLiveRoom : MHObject

/// pos
@property (nonatomic, readwrite, assign) NSInteger pos;
/// useridx 用户索引
@property (nonatomic, readwrite, assign) NSInteger useridx;
/// userId 用户Id
@property (nonatomic, readwrite, copy) NSString *userId;
/// gender 0 girl 1 boy 性别
@property (nonatomic, readwrite, assign) BOOL gender;
/// 昵称
@property (nonatomic, readwrite, copy) NSString *myname;
/// 头像
@property (nonatomic, readwrite, strong) NSURL *smallpic;
/// bigpic 封面
@property (nonatomic, readwrite, strong) NSURL *bigpic;
/// allnum 观众
@property (nonatomic, readwrite, copy) NSString * allnum;
/// roomid 直播间id
@property (nonatomic, readwrite, copy) NSString *roomid;
/// serverid 服务id
@property (nonatomic, readwrite, assign) NSInteger serverid;
/// 位置
@property (nonatomic, readwrite, copy) NSString *gps;
/// flv 直播流地址
@property (nonatomic, readwrite, copy) NSString *flv;
/// 主播等级
@property (nonatomic, readwrite, assign) NSInteger anchorlevel;
/// 星等级
@property (nonatomic, readwrite, assign) NSInteger starlevel;
/// familyName
@property (nonatomic, readwrite, copy) NSString *familyName;
/// isSign
@property (nonatomic, readwrite, assign) BOOL isSign;
/// nation
@property (nonatomic, readwrite, copy) NSString *nation;
/// nationFlag
@property (nonatomic, readwrite, copy) NSString *nationFlag;
/// distance
@property (nonatomic, readwrite, assign) NSInteger distance;
/// gameid
@property (nonatomic, readwrite, assign) NSInteger gameid;
@end

