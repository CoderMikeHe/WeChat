//
//  MHConstant.h
//  WeChat
//
//  Created by senba on 2017/9/10.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/// Block
///------
typedef void (^VoidBlock)(void);
typedef BOOL (^BoolBlock)(void);
typedef int  (^IntBlock) (void);
typedef id   (^IDBlock)  (void);

typedef void (^VoidBlock_int)(int);
typedef BOOL (^BoolBlock_int)(int);
typedef int  (^IntBlock_int) (int);
typedef id   (^IDBlock_int)  (int);

typedef void (^VoidBlock_string)(NSString *);
typedef BOOL (^BoolBlock_string)(NSString *);
typedef int  (^IntBlock_string) (NSString *);
typedef id   (^IDBlock_string)  (NSString *);

typedef void (^VoidBlock_id)(id);
typedef BOOL (^BoolBlock_id)(id);
typedef int  (^IntBlock_id) (id);
typedef id   (^IDBlock_id)  (id);


#pragma mark - 应用相关的
/// 切换根控制器的通知 新特性
FOUNDATION_EXTERN NSString * const MHSwitchRootViewControllerNotification;
/// 切换根控制器的通知 UserInfo key
FOUNDATION_EXTERN NSString * const MHSwitchRootViewControllerUserInfoKey;

/// 插件Switch按钮值改变
FOUNDATION_EXTERN NSString * const MHDiscoverDidChangedNotification;




/// 全局分割线高度 .8
FOUNDATION_EXTERN CGFloat const MHGlobalBottomLineHeight;

/// 个性签名的最大字数为30
FOUNDATION_EXTERN NSUInteger const MHFeatureSignatureMaxWords;

/// 用户昵称的最大字数为20
FOUNDATION_EXTERN NSUInteger const MHNicknameMaxWords;

/// 简书首页地址
FOUNDATION_EXTERN NSString * const MHMyBlogHomepageUrl ;
/// 王者荣耀首页地址
FOUNDATION_EXTERN NSString * const MHPVPHomepageUrl ;
/// 和平精英首页地址
FOUNDATION_EXTERN NSString * const MHGPHomepageUrl;
/// 腾讯体育首页地址
FOUNDATION_EXTERN NSString * const MHSportsHomepageUrl;

/// 国家区号
FOUNDATION_EXTERN NSString * const MHMobileLoginZoneCodeKey ;
/// 手机号码
FOUNDATION_EXTERN NSString * const MHMobileLoginPhoneKey ;

/// 验证码时间
FOUNDATION_EXTERN NSUInteger const MHCaptchaFetchMaxWords;






/// 朋友圈
/// 类型
typedef NS_ENUM(NSUInteger, MHMomentContentType) {
    MHMomentContentTypeAttitude = 0,   /// 点赞
    MHMomentContentTypeComment ,       /// 评论
};

typedef NS_ENUM(NSUInteger, MHDefaultAvatarType) {
    MHDefaultAvatarTypeSmall = 0,  /// 小图 34x34
    MHDefaultAvatarTypeDefualt,    /// 默认 50x50
    MHDefaultAvatarTypeBig,        /// 大图 85x85
};
/// 占位头像
static inline UIImage *MHDefaultAvatar(MHDefaultAvatarType type)
{
    switch (type) {
        case MHDefaultAvatarTypeSmall:
            return [UIImage imageNamed:@"wx_avatar_default_small"];
            break;
        case MHDefaultAvatarTypeBig:
            return [UIImage imageNamed:@"wx_avatar_default_big"];
            break;
        default:
            return [UIImage imageNamed:@"wx_avatar_default"];
            break;
    }
}

/// 配图的占位图片
static inline UIImage *MHPicturePlaceholder()
{
    return [UIImage imageNamed:@"wx_timeline_image_placeholder"];
}







/// 全局细下滑线颜色 以及分割线颜色
#define WXGlobalBottomLineColor     [UIColor colorFromHexString:@"#D9D8D9"]
/// 全局黑色字体
#define WXGlobalBlackTextColor      [UIColor colorFromHexString:@"#000000"]
/// 全局灰色背景
#define WXGlobalGrayBackgroundColor [UIColor colorFromHexString:@"#EFEFF4"]

/// 全局tintColor
#define WXGlobalPrimaryTintColor  [UIColor colorFromHexString:@"#57BE6A"]


/// 全局Page 背景色
#define WXGlobalPrimaryBackgroundColor  [UIColor colorFromHexString:@"#ededed"]

/// 全局分割线高度
FOUNDATION_EXTERN CGFloat const WXGlobalBottomLineHeight;



/// 微信朋友圈常量定义区
/// 头像宽高 15
FOUNDATION_EXTERN CGFloat const MHMomentProfileViewAvatarViewWH;
/// 消息tips宽高 40
FOUNDATION_EXTERN CGFloat const MHMomentProfileViewTipsViewHeight ;
/// 消息tips宽高 181
FOUNDATION_EXTERN CGFloat const MHMomentProfileViewTipsViewWidth ;
/// 消息tipsView内部的头像宽高 30
FOUNDATION_EXTERN CGFloat const MHMomentProfileViewTipsViewAvatarWH ;
/// 消息tipsView内部的头像距离tipsView边距 5
FOUNDATION_EXTERN CGFloat const MHMomentProfileViewTipsViewInnerInset ;
/// 消息tipsView内部的右箭头距离tipsView边距 11
FOUNDATION_EXTERN CGFloat const MHMomentProfileViewTipsViewRightInset ;
/// 消息tipsView内部的右箭头宽高 15
FOUNDATION_EXTERN CGFloat const MHMomentProfileViewTipsViewRightArrowWH ;


//// 朋友圈说说
/// 说说内容距离顶部的间距 16
FOUNDATION_EXTERN CGFloat const MHMomentContentTopInset;
/// 说说内容距离左右屏幕的间距 20
FOUNDATION_EXTERN CGFloat const MHMomentContentLeftOrRightInset;
/// 内容（控件）之间的的间距 10
FOUNDATION_EXTERN CGFloat const MHMomentContentInnerMargin;
/// 用户头像的大小 44x44
FOUNDATION_EXTERN CGFloat const MHMomentAvatarWH;

/// 向上箭头W
FOUNDATION_EXTERN CGFloat const MHMomentUpArrowViewWidth ;
/// 向上箭头H
FOUNDATION_EXTERN CGFloat const MHMomentUpArrowViewHeight ;

/// 全文、收起W
FOUNDATION_EXTERN CGFloat const MHMomentExpandButtonWidth ;
/// 全文、收起H
FOUNDATION_EXTERN CGFloat const MHMomentExpandButtonHeight ;

/// pictureView中图片之间的的间距 6
FOUNDATION_EXTERN CGFloat const MHMomentPhotosViewItemInnerMargin;
/// pictureView中图片的大小 86x86 (屏幕尺寸>320)
FOUNDATION_EXTERN CGFloat const MHMomentPhotosViewItemWH1;
/// pictureView中图片的大小 70x70 (屏幕尺寸<=320)
FOUNDATION_EXTERN CGFloat const MHMomentPhotosViewItemWH2;

/// 分享内容高度
FOUNDATION_EXTERN CGFloat const MHMomentShareInfoViewHeight;

/// videoView高度
FOUNDATION_EXTERN CGFloat const MHMomentVideoViewHeight ;
/// videoView宽度
FOUNDATION_EXTERN CGFloat const MHMomentVideoViewWidth ;


/// 微信正文内容的显示最大行数（PS：如果超过最大值，那么正文内容就单行显示，可以点击正文内容查看全部内容）
FOUNDATION_EXTERN NSUInteger const MHMomentContentTextMaxCriticalRow ;
/// 微信正文内容显示（全文/收起）的临界行
FOUNDATION_EXTERN NSUInteger const MHMomentContentTextExpandCriticalRow ;

/// pictureView最多显示的图片数
FOUNDATION_EXTERN NSUInteger const MHMomentPhotosMaxCount ;
/// pictureView显示图片的最大列数
#define MHMomentMaxCols(__photosCount) ((__photosCount==4)?2:3)


/// 微信昵称字体大小
#define MHMomentScreenNameFont MHMediumFont(16.0f)
/// 微信正文字体大小
#define MHMomentContentFont MHRegularFont_15
/// 微信地址+时间+来源的字体大小
#define MHMomentCreatedAtFont MHRegularFont_12
/// 微信（全文/收起）字体大小
#define MHMomentExpandTextFont MHRegularFont_16

/// 微信评论正文字体大小
#define MHMomentCommentContentFont MHRegularFont_14
/// 微信评论的昵称的字体大小
#define MHMomentCommentScreenNameFont  MHMediumFont(14.0f)




/// 微信昵称字体颜色
#define MHMomentScreenNameTextColor [UIColor colorFromHexString:@"#5B6A92"]
/// 微信正文（链接、电话）的颜色
#define MHMomentContentUrlTextColor [UIColor colorFromHexString:@"#4380D1"]
/// 微信正文字体颜色
#define MHMomentContentTextColor WXGlobalBlackTextColor
/// 微信时间颜色
#define MHMomentCreatedAtTextColor [UIColor colorFromHexString:@"#737373"]



/// 点击文字高亮的颜色
#define MHMomentTextHighlightBackgroundColor [UIColor colorFromHexString:@"#C7C7C7"]



/// 单张图片的最大高度（等比例）180 (ps：别问我为什么，我量出来的)
FOUNDATION_EXTERN CGFloat const MHMomentPhotosViewSingleItemMaxHeight;


/// 更多按钮宽高 (实际：25x25)
FOUNDATION_EXTERN CGFloat const MHMomentOperationMoreBtnWH ;


/// footerViewHeight
FOUNDATION_EXTERN CGFloat const MHMomentFooterViewHeight ;




//// 评论和点赞view 常量
/// 评论内容距离顶部的间距 5
FOUNDATION_EXTERN CGFloat const MHMomentCommentViewContentTopOrBottomInset;
/// 评论内容距离评论View左右屏幕的间距 9
FOUNDATION_EXTERN CGFloat const MHMomentCommentViewContentLeftOrRightInset;
/// 点赞内容距离顶部的间距 7
FOUNDATION_EXTERN CGFloat const MHMomentCommentViewAttitudesTopOrBottomInset;

/// 评论or点赞 view的背景色
#define MHMomentCommentViewBackgroundColor [UIColor colorFromHexString:@"#F3F3F5"]
/// 评论or点赞 view的选中的背景色
#define MHMomentCommentViewSelectedBackgroundColor [UIColor colorFromHexString:@"#CED2DE"]


/// 更多操作View的Size 181x39
/// 更多操作View的Size 181x39
FOUNDATION_EXTERN CGFloat const MHMomentOperationMoreViewWidth ;
FOUNDATION_EXTERN CGFloat const MHMomentOperationMoreViewHeight ;

/// 微信动画时间 .25f
FOUNDATION_EXTERN NSTimeInterval const MHMommentAnimatedDuration;


/**
 YYTextHighlight *highlight = [YYTextHighlight new];
 highlight.userInfo = @{kWBLinkHrefName : href};
 */
//// 这里是点击文本链接（or其他）跳转，通过该key从userInfo中取出对应的数据
/// 点击链接
FOUNDATION_EXTERN NSString * const MHMomentLinkUrlKey ;
/// 电话号码key
FOUNDATION_EXTERN NSString * const MHMomentPhoneNumberKey ;
/// 点击位置
FOUNDATION_EXTERN NSString * const MHMomentLocationNameKey;
/// 点击用户昵称
FOUNDATION_EXTERN NSString * const MHMomentUserInfoKey;


/// 评论View
/** 弹出评论框View最小高度 */
FOUNDATION_EXTERN CGFloat const MHMomentCommentToolViewMinHeight;
/** 弹出评论框View最大高度 */
FOUNDATION_EXTERN CGFloat const MHMomentCommentToolViewMaxHeight ;
/** 弹出评论框View的除了编辑框的高度 */
FOUNDATION_EXTERN CGFloat const MHMomentCommentToolViewWithNoTextViewHeight;


//// ---------------- 微信首页模块 ----------------
/// 下拉显示小程序 临界点0  80.0f
FOUNDATION_EXTERN CGFloat const MHPulldownAppletCriticalPoint0;
/// 下拉显示小程序 临界点1  130.0f
FOUNDATION_EXTERN CGFloat const MHPulldownAppletCriticalPoint1;
/// 下拉显示小程序 临界点2  160.0f
FOUNDATION_EXTERN CGFloat const MHPulldownAppletCriticalPoint2;
/// 下拉显示小程序 临界点3  240.0f
FOUNDATION_EXTERN CGFloat const MHPulldownAppletCriticalPoint3;

/// 下拉显示小程序和隐藏小程序 动画时间 .35f
FOUNDATION_EXTERN NSTimeInterval const MHPulldownAppletRefreshingDuration;


//// ---------------- inline ----------------

/// 图片的宽度 （九宫格）
static inline CGFloat MHMomentPhotosViewItemWidth(){
    CGFloat itemW = ([UIScreen mainScreen].bounds.size.width<=320)? MHMomentPhotosViewItemWH2:MHMomentPhotosViewItemWH1;
    return itemW;
}


/// 单张图片的最大宽度（方形or等比例）
static inline CGFloat MHMomentPhotosViewSingleItemMaxWidth(){
    CGFloat itemW = MHMomentPhotosViewItemWidth();
    return MHMomentPhotosViewItemInnerMargin + itemW*2;
}

/// 计算微信说说正文的limitWidth或者评论View的宽度
static inline CGFloat MHMomentCommentViewWidth() {
    return ([UIScreen mainScreen].bounds.size.width - MHMomentContentLeftOrRightInset*2 -MHMomentAvatarWH - MHMomentContentInnerMargin);
}
