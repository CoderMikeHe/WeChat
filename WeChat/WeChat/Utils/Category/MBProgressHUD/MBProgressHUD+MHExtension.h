//
//
//  MBProgressHUD+MHExtension.m
//
//  Created by apple on 16/5/10.
//  Copyright © 2016年 CoderMikeHe. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (MHExtension)

/// in window
/// 提示信息
+ (MBProgressHUD *)mh_showTips:(NSString *)tipStr;

/// 提示错误
+ (MBProgressHUD *)mh_showErrorTips:(NSError *)error;

/// 进度view
+ (MBProgressHUD *)mh_showProgressHUD:(NSString *)titleStr;

/// 隐藏hud
+ (void)mh_hideHUD;




/// in special view
/// 提示信息
+ (MBProgressHUD *)mh_showTips:(NSString *)tipStr addedToView:(UIView *)view;

/// 提示错误
+ (MBProgressHUD *)mh_showErrorTips:(NSError *)error addedToView:(UIView *)view;

/// 进度view
+ (MBProgressHUD *)mh_showProgressHUD:(NSString *)titleStr addedToView:(UIView *)view;

/// 隐藏hud
+ (void)mh_hideHUDForView:(UIView *)view;


@end
