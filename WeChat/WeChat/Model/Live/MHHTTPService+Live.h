//
//  MHHTTPService+Live.h
//  WeChat
//
//  Created by senba on 2017/10/19.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  获取直播相关的接口

#import "MHHTTPService.h"
#import "MHLiveRoom.h"

@interface MHHTTPService (Live)

/// https://live.9158.com/Room/GetHotLive_v2?cache=3&lat=22.54192103514200&lon=113.96939828211362&page=1&province=%E5%B9%BF%E4%B8%9C%E7%9C%81&type=0&useridx=61856069
/**
 获取直播间列表
 @param useridx The current special ` user ` 's idstr
 @param type ；类型：type = 0 为热门
 @param page 获取第几页的数据
 @param lat 维度 ， 可以传 nil ， 则会获取定位的维度
 @param lon 经度 ， 可以传 nil ， 则会获取定位的经度
 @param province 省份 可以传 nil 则会获取定位的省份
 @return Returns a signal which will send complete, or error.
 */
- (RACSignal *)fetchLivesWithUseridx:(NSString *)useridx type:(NSInteger)type page:(NSInteger)page lat:(NSNumber *)lat lon:(NSNumber *)lon province:(NSString *)province;

@end
