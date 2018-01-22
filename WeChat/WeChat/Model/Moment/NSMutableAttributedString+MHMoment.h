//
//  NSMutableAttributedString+MHMoment.h
//  WeChat
//
//  Created by senba on 2018/1/22.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//  主要用于微博内容的公共处理

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (MHMoment)
/// 内容正则（链接 ， 表情 ， 手机号） fontSize： 表情的字体大小
- (void)mh_regexContentWithWithEmojiImageFontSize:(CGFloat)fontSize;
@end
