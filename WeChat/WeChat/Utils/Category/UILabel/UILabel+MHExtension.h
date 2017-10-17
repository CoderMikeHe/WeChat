//
//  UILabel+MHExtension.h
//  WeChat
//
//  Created by senba on 2017/9/25.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (MHExtension)
/// 创建文本标签
///
/// @param text     文本
/// @param fontSize 字体大小
/// @param textColor    颜色
///
/// @return UILabel
+ (instancetype)mh_labelWithText:(NSString *)text fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor;
+ (instancetype)mh_labelWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor;
@end
