//
//  NSAttributedString+MHSize.h
//  WeChat
//
//  Created by senba on 2017/5/29.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (MHSize)
/**
 *  动态计算文字的宽高（多行）
 *  @param limitSize 限制的范围
 *
 *  @return 计算的宽高
 */
- (CGSize)mh_sizeWithLimitSize:(CGSize)limitSize;

/**
 *  动态计算文字的宽高（多行）
 *  @param limitWidth 限制宽度 ，高度不限制
 *
 *  @return 计算的宽高
 */
- (CGSize)mh_sizeWithLimitWidth:(CGFloat)limitWidth;
@end
