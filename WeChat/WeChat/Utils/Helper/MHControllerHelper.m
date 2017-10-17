//
//  MHControllerHelper.m
//  WeChat
//
//  Created by senba on 2017/9/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHControllerHelper.h"
#import "MHHomePageViewController.h"

@implementation MHControllerHelper

+ (UIViewController *)currentViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    
    /// CoderMikeHe Fixed : 这里必须要判断一下，否则取出来永远都是 MHHomePageViewController。这是架构上小缺(特)陷(性)。因为MHHomePageViewController的子控制器是UITabBarController，所以需要递归UITabBarController的所有的子控制器
    if ([resultVC isKindOfClass:[MHHomePageViewController class]]) {
        MHHomePageViewController *mainVc = (MHHomePageViewController *)resultVC;
        resultVC = [self _topViewController:mainVc.tabBarController];
    }
    
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

+ (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
}


+ (UINavigationController *)topNavigationController{
    return MHSharedAppDelegate.navigationControllerStack.topNavigationController;
}

+ (MHViewController *)topViewController
{
    MHViewController *topViewController = (MHViewController *)[self topNavigationController].topViewController;
    
    /// 确保解析出来的类 也是 MHViewController
    NSAssert([topViewController isKindOfClass:MHViewController.class], @"topViewController is not an MHViewController's subclass: %@", topViewController);
    
    return topViewController;
}

@end
