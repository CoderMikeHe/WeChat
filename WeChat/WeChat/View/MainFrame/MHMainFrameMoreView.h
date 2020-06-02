//
//  MHMainFrameMoreView.h
//  WeChat
//
//  Created by admin on 2020/5/30.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//  首页点击+ 弹出更多View  用block回调 好久没写回调了...

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

/// 点击 mask 回调
@property (nonatomic, readwrite, copy) void (^maskAction)();

/// 点击 menuItem 回调
@property (nonatomic, readwrite, copy) void (^menuItemAction)(MHMainFrameMoreViewType type);

/// generate view
+ (instancetype)moreView;
/// 显示
- (void)show;
/// 隐藏
- (void)hideWithCompletion:(void (^)())completion;

@end

NS_ASSUME_NONNULL_END
