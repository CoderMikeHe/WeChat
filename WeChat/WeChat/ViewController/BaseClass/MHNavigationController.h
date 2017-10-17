//
//  MHNavigationController.h
//  WeChat
//
//  Created by senba on 2017/9/7.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  所有自定义导航栏视图控制器的基类

#import <UIKit/UIKit.h>

@interface MHNavigationController : UINavigationController
/// 显示导航栏的细线
- (void)showNavigationBottomLine;
/// 隐藏导航栏的细线
- (void)hideNavigationBottomLine;
@end
