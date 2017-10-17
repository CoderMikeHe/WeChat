//
//  NSObject+MHAlert.m
//  WeChat
//
//  Created by CoderMikeHe on 2017/8/14.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//
//  提醒

#import <Foundation/Foundation.h>

@interface NSObject (MHAlert)

/**
 弹出alertController，并且只有一个action按钮，切记只是警示作用，无事件处理

 @param title title
 @param message message
 @param confirmTitle confirmTitle 按钮的title
 */
+ (void)mh_showAlertViewWithTitle:(NSString *)title message:(NSString *)message confirmTitle:(NSString *)confirmTitle;


/**
 弹出alertController，并且只有一个action按钮，有处理事件

 @param title title
 @param message message
 @param confirmTitle confirmTitle 按钮title
 @param confirmAction 按钮的点击事件处理
 */
+ (void)mh_showAlertViewWithTitle:(NSString *)title message:(NSString *)message confirmTitle:(NSString *)confirmTitle confirmAction:(void(^)())confirmAction;


/**
 弹出alertController，并且有两个个action按钮，分别有处理事件

 @param title title
 @param message Message
 @param confirmTitle 右边按钮的title
 @param cancelTitle 左边按钮的title
 @param confirmAction 右边按钮的点击事件
 @param cancelAction 左边按钮的点击事件
 */
+ (void)mh_showAlertViewWithTitle:(NSString *)title message:(NSString *)message confirmTitle:(NSString *)confirmTitle cancelTitle:(NSString *)cancelTitle confirmAction:(void(^)())confirmAction cancelAction:(void(^)())cancelAction;


@end
