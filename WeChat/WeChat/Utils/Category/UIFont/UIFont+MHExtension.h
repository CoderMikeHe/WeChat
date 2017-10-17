//
//  UIFont+MHExtension.h
//  MHDevLibExample
//
//  Created by apple on 16/5/12.
//  Copyright © 2016年 Mike_He. All rights reserved.
//
/**
 *  Mike_He 但是苹方字体 iOS9.0+出现  需要做适配
 *  这个分类主要用来 字体...
 (
 "PingFangSC-Ultralight",
 "PingFangSC-Regular",
 "PingFangSC-Semibold",
 "PingFangSC-Thin",
 "PingFangSC-Light",
 "PingFangSC-Medium"
 )
 */

// IOS版本
#define MHIOSVersion ([[[UIDevice currentDevice] systemVersion] floatValue])


/// 设置系统的字体大小（YES：粗体 NO：常规）
#define MHFont(__size__,__bold__) ((__bold__)?([UIFont boldSystemFontOfSize:__size__]):([UIFont systemFontOfSize:__size__]))

/// 极细体
#define MHUltralightFont(__size__) ((MHIOSVersion<9.0)?MHFont(__size__ , YES):[UIFont mh_fontForPingFangSC_UltralightFontOfSize:__size__])

/// 纤细体
#define MHThinFont(__size__)       ((MHIOSVersion<9.0)?MHFont(__size__ , YES):[UIFont mh_fontForPingFangSC_ThinFontOfSize:__size__])

/// 细体
#define MHLightFont(__size__)      ((MHIOSVersion<9.0)?MHFont(__size__ , YES):[UIFont mh_fontForPingFangSC_LightFontOfSize:__size__])

// 中等
#define MHMediumFont(__size__)     ((MHIOSVersion<9.0)?MHFont(__size__ , YES):[UIFont mh_fontForPingFangSC_MediumFontOfSize:__size__])

// 常规
#define MHRegularFont(__size__)    ((MHIOSVersion<9.0)?MHFont(__size__ , NO):[UIFont mh_fontForPingFangSC_RegularFontOfSize:__size__])

/** 中粗体 */
#define MHSemiboldFont(__size__)   ((MHIOSVersion<9.0)?MHFont(__size__ , YES):[UIFont mh_fontForPingFangSC_SemiboldFontOfSize:__size__])



/// 苹方常规字体 10
#define MHRegularFont_10 MHRegularFont(10.0f)
/// 苹方常规字体 11
#define MHRegularFont_11 MHRegularFont(11.0f)
/// 苹方常规字体 12
#define MHRegularFont_12 MHRegularFont(12.0f)
/// 苹方常规字体 13
#define MHRegularFont_13 MHRegularFont(13.0f)
/** 苹方常规字体 14 */
#define MHRegularFont_14 MHRegularFont(14.0f)
/// 苹方常规字体 15
#define MHRegularFont_15 MHRegularFont(15.0f)
/// 苹方常规字体 16
#define MHRegularFont_16 MHRegularFont(16.0f)
/// 苹方常规字体 17
#define MHRegularFont_17 MHRegularFont(17.0f)
/// 苹方常规字体 18
#define MHRegularFont_18 MHRegularFont(18.0f)
/// 苹方常规字体 19
#define MHRegularFont_19 MHRegularFont(19.0f)
/// 苹方常规字体 20
#define MHRegularFont_20 MHRegularFont(20.0f)


#import <UIKit/UIKit.h>

@interface UIFont (MHExtension)

/**
 *  苹方极细体
 *
 *  @param fontSize 字体大小
 *
 */
+(instancetype) mh_fontForPingFangSC_UltralightFontOfSize:(CGFloat)fontSize;

/**
 *  苹方常规体
 *
 *  @param fontSize 字体大小
 *
 */
+(instancetype) mh_fontForPingFangSC_RegularFontOfSize:(CGFloat)fontSize;

/**
 *  苹方中粗体
 *
 *  @param fontSize 字体大小
 *
 */
+(instancetype) mh_fontForPingFangSC_SemiboldFontOfSize:(CGFloat)fontSize;

/**
 *  苹方纤细体
 *
 *  @param fontSize 字体大小
 *
 */
+(instancetype) mh_fontForPingFangSC_ThinFontOfSize:(CGFloat)fontSize;

/**
 *  苹方细体
 *
 *  @param fontSize 字体大小
 *
 */
+(instancetype) mh_fontForPingFangSC_LightFontOfSize:(CGFloat)fontSize;

/**
 *  苹方中黑体
 *
 *  @param fontSize 字体大小
 *
 */
+(instancetype) mh_fontForPingFangSC_MediumFontOfSize:(CGFloat)fontSize;




@end
