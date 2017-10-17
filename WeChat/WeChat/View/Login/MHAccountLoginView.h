//
//  MHAccountLoginView.h
//  WeChat
//
//  Created by senba on 2017/9/27.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  微信号、QQ号、邮箱登录

#import <UIKit/UIKit.h>

@interface MHAccountLoginView : UIView

/// 账号
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;

/// 密码
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;


+ (instancetype)accoutLoginView;
@end
