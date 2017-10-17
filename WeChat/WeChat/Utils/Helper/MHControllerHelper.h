//
//  MHControllerHelper.h
//  WeChat
//
//  Created by senba on 2017/9/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  管理视图控制器的工具类

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MHViewController.h"


@interface MHControllerHelper : NSObject

/// 获取当前正在显示控制器
+ (UIViewController *)currentViewController;

/// 获取MHNavigationControllerStack管理的栈顶导航栏控制器
+ (UINavigationController *)topNavigationController;

/// 获取MHNavigationControllerStack管理的栈顶导航栏控制器的 顶部控制器，理论上这个应该是 MHViewController的子类，但是他不一定是当前正在显示的视图控制器
+ (MHViewController *)topViewController;
@end
