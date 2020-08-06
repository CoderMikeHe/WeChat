//
//  MHPreferenceSettingHelper.h
//  WeChat
//
//  Created by senba on 2017/10/14.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 存储language
FOUNDATION_EXTERN NSString * const MHPreferenceSettingLanguage ;

/// ---- 我-视频动态
/// 视频动态 下拉
FOUNDATION_EXTERN NSString * const MHPreferenceSettingPulldownVideoTrends ;
/// 视频动态 点击右上角的camera
FOUNDATION_EXTERN NSString * const MHPreferenceSettingCameraVideoTrends ;


/// ---- 新消息通知
/// 接收新消息通知
FOUNDATION_EXTERN NSString * const MHPreferenceSettingReceiveNewMessageNotification ;
/// 接收语音和视频聊天邀请通知
FOUNDATION_EXTERN NSString * const MHPreferenceSettingReceiveVoiceOrVideoNotification ;
/// 视频聊天、语音聊天铃声
FOUNDATION_EXTERN NSString * const MHPreferenceSettingVoiceOrVideoChatRing ;
/// 通知显示消息详情
FOUNDATION_EXTERN NSString * const MHPreferenceSettingNotificationShowDetailMessage ;
/// 消息提醒铃声
FOUNDATION_EXTERN NSString * const MHPreferenceSettingMessageAlertVolume ;
/// 消息提醒震动
FOUNDATION_EXTERN NSString * const MHPreferenceSettingMessageAlertVibration ;


/// ---- 设置消息免打扰
FOUNDATION_EXTERN NSString * const MHPreferenceSettingMessageFreeInterruption ;


/// ---- 隐私
/// 加我为朋友时需要验证
FOUNDATION_EXTERN NSString * const MHPreferenceSettingAddFriendNeedVerify ;
/// 向我推荐通讯录朋友
FOUNDATION_EXTERN NSString * const MHPreferenceSettingRecommendFriendFromContactsList ;
/// 允许陌生人查看十条朋友圈
FOUNDATION_EXTERN NSString * const MHPreferenceSettingAllowStrongerWatchTenMoments ;
/// 开启朋友圈入口
FOUNDATION_EXTERN NSString * const MHPreferenceSettingOpenFriendMomentsEntrance ;
/// 朋友圈更新提醒
FOUNDATION_EXTERN NSString * const MHPreferenceSettingFriendMomentsUpdateAlert ;


/// ---- 通用
/// 听筒模式
FOUNDATION_EXTERN NSString * const MHPreferenceSettingReceiverMode ;

/// ---- 插件
/// 存储看一看（全新）
FOUNDATION_EXTERN NSString * const MHPreferenceSettingLookArtboard ;
/// 存储搜一搜（全新）
FOUNDATION_EXTERN NSString * const MHPreferenceSettingSearchArtboard ;

/// ---- 发现页
/// 朋友圈
FOUNDATION_EXTERN NSString * const MHPreferenceSettingMoments ;
/// 视频号
FOUNDATION_EXTERN NSString * const MHPreferenceSettingFinder ;
/// 扫一扫
FOUNDATION_EXTERN NSString * const MHPreferenceSettingScan ;
/// 摇一摇
FOUNDATION_EXTERN NSString * const MHPreferenceSettingShake ;
/// 看一看
FOUNDATION_EXTERN NSString * const MHPreferenceSettingLook ;
/// 搜一搜
FOUNDATION_EXTERN NSString * const MHPreferenceSettingSearch ;
/// 附近的人
FOUNDATION_EXTERN NSString * const MHPreferenceSettingNearby ;
/// 购物
FOUNDATION_EXTERN NSString * const MHPreferenceSettingShopping;
/// 游戏
FOUNDATION_EXTERN NSString * const MHPreferenceSettingGame ;
/// 小程序
FOUNDATION_EXTERN NSString * const MHPreferenceSettingMoreApps ;


@interface MHPreferenceSettingHelper : NSObject

+ (id)objectForKey:(NSString *)defaultName;
+ (void)setObject:(id)value forKey:(NSString *)defaultName;

+ (BOOL)boolForKey:(NSString *)defaultName;
+ (void)setBool:(BOOL)value forKey:(NSString *)defaultName;
@end
