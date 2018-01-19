//
//  MHDebugTouchView.h
//  WeChat
//
//  Created by senba on 2017/11/26.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  调试指示器 方便测试妹子测试

#import <UIKit/UIKit.h>

@interface MHDebugTouchView : UIImageView
/// init
MHSingletonH(Instance);

/// 设置显示or隐藏
- (void)setHide:(BOOL)hide;
- (BOOL)isHide;
@end
