//
//  MHConstEnum.h
//  WeChat
//
//  Created by senba on 2017/9/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  所有枚举定义区域

#ifndef MHConstEnum_h
#define MHConstEnum_h

/// tababr item tag
typedef NS_ENUM(NSUInteger, MHTabBarItemTagType) {
    MHTabBarItemTagTypeMainFrame = 0,    /// 消息回话
    MHTabBarItemTagTypeContacts,         /// 通讯录
    MHTabBarItemTagTypeDiscover,         /// 发现
    MHTabBarItemTagTypeProfile,          /// 我的
};


/// 切换根控制器类型
typedef NS_ENUM(NSUInteger, MHSwitchRootViewControllerFromType) {
    MHSwitchRootViewControllerFromTypeNewFeature = 0,  /// 新特性
    MHSwitchRootViewControllerFromTypeLogin,           /// 登录
    MHSwitchRootViewControllerFromTypeLogout,          /// 登出
};

/// 用户登录的渠道
typedef NS_ENUM(NSUInteger, MHUserLoginChannelType) {
    MHUserLoginChannelTypeQQ = 0,           /// qq登录
    MHUserLoginChannelTypeEmail,            /// 邮箱登录
    MHUserLoginChannelTypeWeChatId,         /// 微信号登录
    MHUserLoginChannelTypePhone,            /// 手机号登录
};

/// 用户性别
typedef NS_ENUM(NSUInteger, MHUserGenderType) {
    MHUserGenderTypeMale =0,            /// 男
    MHUserGenderTypeFemale,             /// nv
};

/// 插件详情说明
typedef NS_ENUM(NSUInteger, MHPlugDetailType) {
    MHPlugDetailTypeLook = 0,     /// 看一看
    MHPlugDetailTypeSearch,       /// 搜一搜
};


/// 微信朋友圈类型 （0 配图  1 video 2 share）
typedef NS_ENUM(NSUInteger, MHMomentExtendType) {
    MHMomentExtendTypePicture = 0, /// 配图
    MHMomentExtendTypeVideo,       /// 视频
    MHMomentExtendTypeShare,       /// 分享
};


/// 微信朋友圈分享内容的类型
typedef NS_ENUM(NSUInteger, MHMomentShareInfoType) {
    MHMomentShareInfoTypeWebPage = 0, /// 网页
    MHMomentShareInfoTypeMusic,       /// 音乐
};

/// 导航栏搜索状态
typedef NS_ENUM(NSUInteger, MHNavSearchBarState) {
    MHNavSearchBarStateDefault = 0,  /// 展示模式
    MHNavSearchBarStateSearch        /// 搜索模式
};


// 搜索类型 <微信、通讯录>
typedef NS_ENUM(NSInteger, MHSearchType) {
    MHSearchTypeDefault = -1,  // All
    MHSearchTypeMoments = 0,   // 朋友圈
    MHSearchTypeSubscriptions, // 文章
    MHSearchTypeOfficialAccounts, // 公众号
    MHSearchTypeMiniprogram,   // 小程序
    MHSearchTypeMusic,         // 音乐
    MHSearchTypeSticker        // 表情
};


// 搜索模式 <微信、通讯录>
typedef NS_ENUM(NSInteger, MHSearchMode) {
    MHSearchModeDefault = 0, // 默认模式，比如 搜索-搜索音乐 进入时便是默认模式
    MHSearchModeRelated,     // 输入框输入文字 关联的场景
    MHSearchModeSearch       // 点击键盘搜索 或者 点击关联出来的内容 进入搜索模式
};


/// 默认模式搜索到的类型
typedef NS_ENUM(NSUInteger, MHSearchDefaultType) {
    MHSearchDefaultTypeDefault = 0,   // 默认场景
    MHSearchDefaultTypeContacts = 1,  // 搜索联系人
    MHSearchDefaultTypeGroupChat,     // 群聊
    MHSearchDefaultTypeOfficialAccounts, // 关注的公众号
    MHSearchDefaultTypeChatRecord,       // 聊天记录
    MHSearchDefaultTypeCollect,          // 收藏
    MHSearchDefaultTypeSearch            // 搜一搜
};

#endif /* MHConstEnum_h */
