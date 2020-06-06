//
//  MHConstant.m
//  WeChat
//
//  Created by senba on 2017/9/10.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHConstant.h"
#import <UIKit/UIKit.h>

#pragma mark - 应用相关的
/// 切换根控制器的通知 新特性
NSString * const MHSwitchRootViewControllerNotification = @"MHSwitchRootViewControllerNotification";
/// 切换根控制器的通知 UserInfo key
NSString * const MHSwitchRootViewControllerUserInfoKey = @"MHSwitchRootViewControllerUserInfoKey";

/// - 插件/发现页管理
/// 插件Switch按钮值改变
NSString * const MHDiscoverDidChangedNotification = @"MHDiscoverDidChangedNotification";


/// 全局分割线高度 .5
CGFloat const MHGlobalBottomLineHeight = 0.8f;

/// 个性签名的最大字数为30
NSUInteger const MHFeatureSignatureMaxWords = 30;

/// 用户昵称的最大字数为20
NSUInteger const MHNicknameMaxWords = 20;


/// 简书首页地址
NSString * const MHMyBlogHomepageUrl = @"http://www.jianshu.com/u/126498da7523";

/// 国家区号
NSString * const MHMobileLoginZoneCodeKey = @"MHMobileLoginZoneCodeKey";
/// 手机号码
NSString * const MHMobileLoginPhoneKey = @"MHMobileLoginPhoneKey";

/// 验证码时间
NSUInteger const MHCaptchaFetchMaxWords = 60;


/// 朋友圈 ---
/// 分割线高度
CGFloat const WXGlobalBottomLineHeight = .5f;


/// 以下是 微信朋友圈常量定义区

/// profileView
/// 头像宽高 15
CGFloat const MHMomentProfileViewAvatarViewWH = 75.0f;
/// 消息tips宽高 40
CGFloat const MHMomentProfileViewTipsViewHeight = 40.0f;
/// 消息tips宽高 181
CGFloat const MHMomentProfileViewTipsViewWidth = 181.0f;
/// 消息tipsView内部的头像宽高 30
CGFloat const MHMomentProfileViewTipsViewAvatarWH = 30.0f;
/// 消息tipsView内部的头像距离tipsView边距 5
CGFloat const MHMomentProfileViewTipsViewInnerInset = 5.0f;
/// 消息tipsView内部的右箭头距离tipsView边距 11
CGFloat const MHMomentProfileViewTipsViewRightInset = 11.0f;
/// 消息tipsView内部的右箭头宽高 15
CGFloat const MHMomentProfileViewTipsViewRightArrowWH = 15.0f;

/// 说说内容距离顶部的间距 16
CGFloat const MHMomentContentTopInset = 16.0f;
/// 说说内容距离左右屏幕的间距 20
CGFloat const MHMomentContentLeftOrRightInset = 20.0f;
/// 内容（控件）之间的的间距 10
CGFloat const MHMomentContentInnerMargin = 10.0f;
/// 用户头像的大小 44x44
CGFloat const MHMomentAvatarWH = 44.0f;

/// 向上箭头W 45
CGFloat const MHMomentUpArrowViewWidth = 45.0f;
/// 向上箭头H 6
CGFloat const MHMomentUpArrowViewHeight = 6.0f;

/// 全文、收起W
CGFloat const MHMomentExpandButtonWidth = 35.0f;
/// 全文、收起H
CGFloat const MHMomentExpandButtonHeight = 25.0f;

/// pictureView中图片之间的的间距 6
CGFloat const MHMomentPhotosViewItemInnerMargin = 6.0f;
/// pictureView中图片的大小 86x86 (屏幕尺寸>320)
CGFloat const MHMomentPhotosViewItemWH1 = 86.0f;
/// pictureView中图片的大小 70x70 (屏幕尺寸<=320)
CGFloat const MHMomentPhotosViewItemWH2 = 70.0f;

/// 分享内容高度
CGFloat const MHMomentShareInfoViewHeight = 50.0f;

/// videoView高度
CGFloat const MHMomentVideoViewHeight = 181.0f;
/// videoView宽度
CGFloat const MHMomentVideoViewWidth = 103.0f;


/// 微信正文内容的显示最大行数（PS：如果超过最大值，那么正文内容就单行显示，可以点击正文内容查看全部内容）
NSUInteger const MHMomentContentTextMaxCriticalRow = 12000;
/// 微信正文内容显示（全文/收起）的临界行
NSUInteger const MHMomentContentTextExpandCriticalRow = 6;
/// pictureView最多显示的图片数
NSUInteger const MHMomentPhotosMaxCount = 9;


/// 单张图片的最大高度（等比例）180 (ps：别问我为什么，我量出来的)
CGFloat const MHMomentPhotosViewSingleItemMaxHeight = 180;


/// 更多按钮宽高 (实际：25x25)
CGFloat const MHMomentOperationMoreBtnWH = 25;

/// footerViewHeight
CGFloat const MHMomentFooterViewHeight = 15;





//// 评论和点赞view 常量
/// 评论内容距离顶部的间距 5
CGFloat const MHMomentCommentViewContentTopOrBottomInset = 5;
/// 评论内容距离评论View左右屏幕的间距 9
CGFloat const MHMomentCommentViewContentLeftOrRightInset = 9;

/// 点赞内容距离顶部的间距 7
CGFloat const MHMomentCommentViewAttitudesTopOrBottomInset = 7;


/// 更多操作View的Size 181x39
CGFloat const MHMomentOperationMoreViewWidth = 181.0f;
CGFloat const MHMomentOperationMoreViewHeight = 39.0f;

/// 微信动画时间 .25f
NSTimeInterval const MHMommentAnimatedDuration = .2f;


/// 链接key
NSString * const MHMomentLinkUrlKey = @"MHMomentLinkUrlKey";
/// 电话号码key
NSString * const MHMomentPhoneNumberKey = @"MHMomentPhoneNumberKey";
/// 位置key
NSString * const MHMomentLocationNameKey = @"MHMomentLocationNameKey";

/// 用户信息key
NSString * const MHMomentUserInfoKey = @"MHMomentUserInfoKey";


/// 评论View
/** 弹出评论框View最小高度 */
CGFloat const MHMomentCommentToolViewMinHeight = 60;
/** 弹出评论框View最大高度 */
CGFloat const MHMomentCommentToolViewMaxHeight = 130;
/** 弹出评论框View的除了编辑框的高度 */
CGFloat const MHMomentCommentToolViewWithNoTextViewHeight = 20;


