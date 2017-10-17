//
//  MHTabBarController.h
//  WeChat
//
//  Created by senba on 2017/9/10.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  自定义`TabBarController` ,这里将`UITabBarController`作为自己的子控制器，其目的就是为了保证的继承的连续性，否则像平常我们自定义`UITabBarController`都是继承`UITabBarController`.

#import "MHViewController.h"

@interface MHTabBarController : MHViewController<UITabBarControllerDelegate>

/// The `tabBarController` instance
@property (nonatomic, readonly, strong) UITabBarController *tabBarController;

@end
