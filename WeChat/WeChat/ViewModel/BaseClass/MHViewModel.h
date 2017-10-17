//
//  MHViewModel.h
//  WeChat
//
//  Created by senba on 2017/9/10.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  所有自定义的视图模型的基类

#import <Foundation/Foundation.h>

/// MVVM View
/// The base map of 'params'
/// The `params` parameter in `-initWithParams:` method.
/// Key-Values's key
/// 传递唯一ID的key：例如：商品id 用户id...
FOUNDATION_EXTERN NSString *const MHViewModelIDKey;
/// 传递导航栏title的key：例如 导航栏的title...
FOUNDATION_EXTERN NSString *const MHViewModelTitleKey;
/// 传递数据模型的key：例如 商品模型的传递 用户模型的传递...
FOUNDATION_EXTERN NSString *const MHViewModelUtilKey;
/// 传递webView Request的key：例如 webView request...
FOUNDATION_EXTERN NSString *const MHViewModelRequestKey;

@protocol MHViewModelServices;

@interface MHViewModel : NSObject


/// Initialization method. This is the preferred way to create a new view model.
///
/// services - The service bus of the `Model` layer.
/// params   - The parameters to be passed to view model.
///
/// Returns a new view model.
- (instancetype)initWithServices:(id<MHViewModelServices>)services params:(NSDictionary *)params;

/// The `services` parameter in `-initWithServices:params:` method.
@property (nonatomic, strong, readonly) id<MHViewModelServices> services;

/// The `params` parameter in `-initWithParams:` method.
/// The `params` Key's `kBaseViewModelParamsKey`
@property (nonatomic, readonly, copy) NSDictionary *params;

/// navItem.title
@property (nonatomic, readwrite, copy) NSString *title;
/// 返回按钮的title，default is nil 。
/// 如果设置了该值，那么当Push到一个新的控制器,则导航栏左侧按钮的title为backTitle
@property (nonatomic, readwrite, copy) NSString *backTitle;

/// The callback block.
@property (nonatomic, readwrite, copy) VoidBlock_id callback;

/// A RACSubject object, which representing all errors occurred in view model.
@property (nonatomic, readonly, strong) RACSubject *errors;

/** should fetch local data when viewModel init . default is YES */
@property (nonatomic, readwrite, assign) BOOL shouldFetchLocalDataOnViewModelInitialize;
/** should request data when viewController videwDidLoad . default is YES*/
@property (nonatomic, readwrite, assign) BOOL shouldRequestRemoteDataOnViewDidLoad;
/// will disappear signal
@property (nonatomic, strong, readonly) RACSubject *willDisappearSignal;


/// Whether the interactive pop gesture is disabled when contained in a navigation
/// stack. (是否取消掉左滑pop的功能（栈底控制器无效），默认为NO，不取消)
@property (nonatomic, readwrite, assign) BOOL interactivePopDisabled;

/// Indicate this view controller prefers its navigation bar hidden or not,
/// checked when view controller based navigation bar's appearance is enabled.
/// Default to NO, bars are more likely to show.
/// 是否隐藏该控制器的导航栏 默认是不隐藏 (NO)
@property (nonatomic, readwrite, assign) BOOL prefersNavigationBarHidden;

/// 是否隐藏该控制器的导航栏底部的分割线 默认不隐藏 （NO）
@property (nonatomic, readwrite, assign) BOOL prefersNavigationBarBottomLineHidden;

/// 是否让IQKeyboardManager的管理键盘的事件 默认是YES（管理）
@property (nonatomic, readwrite, assign) BOOL keyboardEnable;

/// 是否键盘弹起的时候，点击其他局域键盘弹起 默认是 YES
@property (nonatomic, readwrite, assign) BOOL shouldResignOnTouchOutside;

/// An additional method, in which you can initialize data, RACCommand etc.
///
/// This method will be execute after the execution of `-initWithParams:` method. But
/// the premise is that you need to inherit `BaseViewModel`.
- (void)initialize;
@end
