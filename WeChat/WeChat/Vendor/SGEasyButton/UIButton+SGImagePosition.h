//
//  如遇到问题或有更好方案，请通过以下方式进行联系
//      QQ：1357127436
//      Email：kingsic@126.com
//      GitHub：https://github.com/kingsic/SGEasyButton
//
//  UIButton+SGImagePosition.h
//  UIButton+SGImagePosition
//
//  Created by kingsic on 2017/8/7.
//  Copyright © 2017年 kingsic. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    /// 图片在左，文字在右
    SGImagePositionStyleDefault,
    /// 图片在右，文字在左
    SGImagePositionStyleRight,
    /// 图片在上，文字在下
    SGImagePositionStyleTop,
    /// 图片在下，文字在上
    SGImagePositionStyleBottom,
} SGImagePositionStyle;

@interface UIButton (SGImagePosition)
/**
 *  设置图片与文字样式
 *
 *  @param imagePositionStyle     图片位置样式
 *  @param spacing                图片与文字之间的间距
 */
- (void)SG_imagePositionStyle:(SGImagePositionStyle)imagePositionStyle spacing:(CGFloat)spacing;

/**
 *  设置图片与文字样式（推荐使用）
 *
 *  @param imagePositionStyle     图片位置样式
 *  @param spacing                图片与文字之间的间距
 *  @param imagePositionBlock     在此 Block 中设置按钮的图片、文字以及 contentHorizontalAlignment 属性
 */
- (void)SG_imagePositionStyle:(SGImagePositionStyle)imagePositionStyle spacing:(CGFloat)spacing imagePositionBlock:(void (^)(UIButton *button))imagePositionBlock;

@end
