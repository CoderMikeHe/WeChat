//
//  AppDelegate.h
//  WeChat
//
//  Created by senba on 2017/9/4.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHNavigationControllerStack.h"
#import "MHViewModelServicesImpl.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

/// 窗口
@property (strong, nonatomic) UIWindow *window;

/// APP管理的导航栏的堆栈
@property (nonatomic, readonly, strong) MHNavigationControllerStack *navigationControllerStack;

/// 获取AppDelegate
+ (AppDelegate *)sharedDelegate;


@end

