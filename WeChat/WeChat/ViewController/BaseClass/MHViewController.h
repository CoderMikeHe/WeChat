//
//  MHViewController.h
//  WeChat
//
//  Created by senba on 2017/9/10.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  所有自定义视图控制器的基类

#import <UIKit/UIKit.h>
#import "MHViewModel.h"

@interface MHViewController : UIViewController
/// The `viewModel` parameter in `-initWithViewModel:` method.
@property (nonatomic, readonly, strong) MHViewModel *viewModel;

/// 截图（Push/Pop Present/Dismiss 过度过程中的缩略图）
@property (nonatomic, readwrite, strong) UIView *snapshot;

/// navBarDivider
@property (nonatomic, readonly, weak) UIView *navBarDivider;
/**
 统一使用该方法初始化，子类中直接声明对于的'readonly' 的 'viewModel'属性，
 并在@implementation内部加上关键词 '@dynamic viewModel;'
 @dynamic A相当于告诉编译器：“参数A的getter和setter方法并不在此处，
 而在其他地方实现了或者生成了，当你程序运行的时候你就知道了，
 所以别警告我了”这样程序在运行的时候，
 对应参数的getter和setter方法就会在其他地方去寻找，比如父类。
 */
/// Initialization method. This is the preferred way to create a new view.
///
/// viewModel - corresponding view model
///
/// Returns a new view.
- (instancetype)initWithViewModel:(MHViewModel *)viewModel;

/// Binds the corresponding view model to the view.(绑定数据模型)
- (void)bindViewModel;
@end
