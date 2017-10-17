//
//  UILabel+MHExtension.m
//  WeChat
//
//  Created by senba on 2017/9/25.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "UILabel+MHExtension.h"

@implementation UILabel (MHExtension)
+ (instancetype)mh_labelWithText:(NSString *)text fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor {
    return [self mh_labelWithText:text font:[UIFont systemFontOfSize:fontSize] textColor:textColor];
}


+ (instancetype)mh_labelWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor
{
    UILabel *label = [[self alloc] init];
    label.text = text;
    label.font = font;
    label.textColor = textColor;
    label.numberOfLines = 0;
    [label sizeToFit];
    return label;
}

@end
