//
//  UIView+MHExtension.h
//  MHDevLibExample
//
//  Created by apple on 16/6/14.
//  Copyright © 2016年 Mike_He. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MHExtension)

/**
 * 判断一个控件是否真正显示在主窗口
 */
- (BOOL)mh_isShowingOnKeyWindow;

/**
 * xib创建的view
 */
+ (instancetype)mh_viewFromXib;

/**
 * xib创建的view
 */
+ (instancetype)mh_viewFromXibWithFrame:(CGRect)frame;

/**
 * xib中显示的属性
 */
@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable BOOL masksToBounds;

@end
