//
//  UIAlertController+MHColor.h
//  WeChat
//
//  Created by CoderMikeHe on 2017/8/18.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (MHColor)
/// 统一按钮样式 不写系统默认的蓝色
@property (nonatomic , readwrite, strong) UIColor *tintColor;
/// 标题的颜色
@property (nonatomic , readwrite, strong) UIColor *titleColor;
/// 信息的颜色
@property (nonatomic , readwrite, strong) UIColor *messageColor;
@end


@interface UIAlertAction (MHColor)

/**< 按钮title字体颜色 */
@property (nonatomic , readwrite, strong) UIColor *textColor;

@end
