//
//  MHMomentBackgroundView.h
//  WeChat
//
//  Created by senba on 2018/1/18.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//  主要用来 点击或者长按显示背景颜色

#import <UIKit/UIKit.h>

@interface MHMomentBackgroundView : UIView
/// 基础设置
- (void)setup;
/// 初始化子控件
- (void)setupSubViews;

/// 点击回调
@property (nonatomic, readwrite, copy) void (^touchBlock)(MHMomentBackgroundView *view);
/// 长按回调
@property (nonatomic, readwrite, copy) void (^longPressBlock)(MHMomentBackgroundView *view);
@end
