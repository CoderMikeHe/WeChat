//
//  MHMainFrameMoreView.h
//  WeChat
//
//  Created by admin on 2020/5/30.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//  首页点击+ 弹出更多View

#import "MHView.h"
/// 类型
typedef NS_ENUM(NSUInteger, MHMainFrameMoreViewType) {
    MHMainFrameMoreViewTypeChat = 0,    /// 发起群聊
    MHMainFrameMoreViewTypeAddFriends,  /// 添加朋友
    MHMainFrameMoreViewTypeScan,        /// 扫一扫
    MHMainFrameMoreViewTypePay          /// 收付款
};


NS_ASSUME_NONNULL_BEGIN

@interface MHMainFrameMoreView : MHView
/// generate view
+ (instancetype)moreView;
@end

NS_ASSUME_NONNULL_END
