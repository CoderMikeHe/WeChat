//
//  MHPreferenceSettingHelper.m
//  WeChat
//
//  Created by senba on 2017/10/14.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  项目的偏好设置工具类

#import "MHPreferenceSettingHelper.h"
/// 偏好设置
#define MHUserDefaults [NSUserDefaults standardUserDefaults]

/// 存储language
NSString * const MHPreferenceSettingLanguage = @"MHPreferenceSettingLanguage";


/// ---- 新消息通知
/// 接收新消息通知
NSString * const MHPreferenceSettingReceiveNewMessageNotification = @"MHPreferenceSettingReceiveNewMessageNotification";
/// 接收语音和视频聊天邀请通知
NSString * const MHPreferenceSettingReceiveVoiceOrVideoNotification = @"MHPreferenceSettingReceiveVoiceOrVideoNotification";
/// 视频聊天、语音聊天铃声
NSString * const MHPreferenceSettingVoiceOrVideoChatRing = @"MHPreferenceSettingVoiceOrVideoChatRing" ;
/// 通知显示消息详情
NSString * const MHPreferenceSettingNotificationShowDetailMessage = @"MHPreferenceSettingNotificationShowDetailMessage" ;
/// 消息提醒铃声
NSString * const MHPreferenceSettingMessageAlertVolume = @"MHPreferenceSettingMessageAlertVolume";
/// 消息提醒震动
NSString * const MHPreferenceSettingMessageAlertVibration = @"MHPreferenceSettingMessageAlertVibration";


/// ---- 设置消息免打扰
NSString * const MHPreferenceSettingMessageFreeInterruption = @"MHPreferenceSettingMessageFreeInterruption" ;

/// ---- 隐私
/// 加我为朋友时需要验证
NSString * const MHPreferenceSettingAddFriendNeedVerify = @"MHPreferenceSettingAddFriendNeedVerify";
/// 向我推荐通讯录朋友
NSString * const MHPreferenceSettingRecommendFriendFromContactsList = @"MHPreferenceSettingRecommendFriendFromContactsList";
/// 允许陌生人查看十条朋友圈
NSString * const MHPreferenceSettingAllowStrongerWatchTenMoments = @"MHPreferenceSettingAllowStrongerWatchTenMoments";
/// 开启朋友圈入口
NSString * const MHPreferenceSettingOpenFriendMomentsEntrance = @"MHPreferenceSettingOpenFriendMomentsEntrance";
/// 朋友圈更新提醒
NSString * const MHPreferenceSettingFriendMomentsUpdateAlert = @"MHPreferenceSettingFriendMomentsUpdateAlert";

/// ---- 通用
/// 听筒模式
NSString * const MHPreferenceSettingReceiverMode = @"MHPreferenceSettingReceiverMode";



/// 存储看一看（全新）
NSString * const MHPreferenceSettingLookArtboard = @"MHPreferenceSettingLookArtboard";

/// 存储搜一搜（全新）
NSString * const MHPreferenceSettingSearchArtboard = @"MHPreferenceSettingSearchArtboard" ;

/// ---- 发现页
/// 朋友圈
NSString * const MHPreferenceSettingMoments = @"MHPreferenceSettingMoments" ;
/// 视频号
NSString * const MHPreferenceSettingFinder = @"MHPreferenceSettingFinder";
/// 扫一扫
NSString * const MHPreferenceSettingScan = @"MHPreferenceSettingScan";
/// 摇一摇
NSString * const MHPreferenceSettingShake = @"MHPreferenceSettingShake";
/// 看一看
NSString * const MHPreferenceSettingLook = @"MHPreferenceSettingLook";
/// 搜一搜
NSString * const MHPreferenceSettingSearch = @"MHPreferenceSettingSearch";
/// 附近的人
NSString * const MHPreferenceSettingNearby = @"MHPreferenceSettingNearby";
/// 购物
NSString * const MHPreferenceSettingShopping = @"MHPreferenceSettingShopping";
/// 游戏
NSString * const MHPreferenceSettingGame = @"MHPreferenceSettingGame";
/// 小程序
NSString * const MHPreferenceSettingMoreApps = @"MHPreferenceSettingMoreApps";

@implementation MHPreferenceSettingHelper

+ (id)objectForKey:(NSString *)defaultName{
    return [MHUserDefaults objectForKey:defaultName];
}

+ (void)setObject:(id)value forKey:(NSString *)defaultName
{
    [MHUserDefaults setObject:value forKey:defaultName];
    [MHUserDefaults synchronize];
}

+ (BOOL)boolForKey:(NSString *)defaultName
{
    return [MHUserDefaults boolForKey:defaultName];
}

+ (void)setBool:(BOOL)value forKey:(NSString *)defaultName
{
    [MHUserDefaults setBool:value forKey:defaultName];
    [MHUserDefaults synchronize];
}
@end
