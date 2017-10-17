//
//  MHNavigationControllerStack.h
//  WeChat
//
//  Created by senba on 2017/9/5.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  `view` 层维护一个 `MHNavigationController` 的堆栈 MHNavigationControllerStack ，不管是 push/pop 还是 present/dismiss ，都使用栈顶的 MHNavigationController 来执行导航操作，且并且保证 present 出来的是一个 MHNavigationController 。

#import <Foundation/Foundation.h>

@protocol MHViewModelServices;

@interface MHNavigationControllerStack : NSObject
/// Initialization method. This is the preferred way to create a new navigation controller stack.
///
/// services - The service bus of the `Model` layer.
///
/// Returns a new navigation controller stack.
- (instancetype)initWithServices:(id<MHViewModelServices>)services;

/// Pushes the navigation controller.
///
/// navigationController - the navigation controller
- (void)pushNavigationController:(UINavigationController *)navigationController;

/// Pops the top navigation controller in the stack.
///
/// Returns the popped navigation controller.
- (UINavigationController *)popNavigationController;

/// Retrieves the top navigation controller in the stack.
///
/// Returns the top navigation controller in the stack.
- (UINavigationController *)topNavigationController;
@end
