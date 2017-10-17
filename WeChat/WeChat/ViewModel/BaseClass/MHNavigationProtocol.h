//
//  MHNavigationProtocol.h
//  WeChat
//
//  Created by senba on 2017/9/10.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  关于导航栏跳转（Push/Pop   Present/Dismiss）的协议

#import <Foundation/Foundation.h>
#import "MHViewModel.h"

@protocol MHNavigationProtocol <NSObject>
/// Pushes the corresponding view controller.
///
/// Uses a horizontal slide transition.
/// Has no effect if the corresponding view controller is already in the stack.
///
/// viewModel - the view model
/// animated  - use animation or not
- (void)pushViewModel:(MHViewModel *)viewModel animated:(BOOL)animated;

/// Pops the top view controller in the stack.
///
/// animated - use animation or not
- (void)popViewModelAnimated:(BOOL)animated;

/// Pops until there's only a single view controller left on the stack.
///
/// animated - use animation or not
- (void)popToRootViewModelAnimated:(BOOL)animated;

/// Present the corresponding view controller.
///
/// viewModel  - the view model
/// animated   - use animation or not
/// completion - the completion handler
- (void)presentViewModel:(MHViewModel *)viewModel animated:(BOOL)animated completion:(VoidBlock)completion;

/// Dismiss the presented view controller.
///
/// animated   - use animation or not
/// completion - the completion handler
- (void)dismissViewModelAnimated:(BOOL)animated completion:(VoidBlock)completion;

/// Reset the corresponding view controller as the root view controller of the application's window.
///
/// viewModel - the view model
- (void)resetRootViewModel:(MHViewModel *)viewModel;

@end
