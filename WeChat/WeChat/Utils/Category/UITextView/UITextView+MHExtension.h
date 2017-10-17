//
//  UITextView+MHExtension.h
//  WeChat
//
//  Created by CoderMikeHe on 2017/9/6.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (MHExtension)
/// 限制最大长度
- (void)mh_limitMaxLength:(NSInteger)maxLength;
@end
