//
//  MHMobileLoginViewModel.h
//  WeChat
//
//  Created by senba on 2017/9/27.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHLoginBaseViewModel.h"




@interface MHMobileLoginViewModel : MHLoginBaseViewModel
/// closeCommand
@property (nonatomic, readonly, strong) RACCommand *closeCommand;
/// LoginCommand
@property (nonatomic, readonly, strong) RACCommand *loginCommand;
/// 更多命令
@property (nonatomic, readonly, strong) RACCommand *moreCommand;
/// phone
@property (nonatomic, readonly, copy) NSString *phone;
/// zoneCode
@property (nonatomic, readonly, copy) NSString *zoneCode;
/// password
@property (nonatomic, readwrite, copy) NSString *password;
/// captcha
@property (nonatomic, readwrite, copy) NSString *captcha;
/// 是否选中
@property (nonatomic, readwrite, assign) BOOL selected;
/// 登录按钮有效性
@property (nonatomic, readonly, strong) RACSignal *validLoginSignal;

/// 验证码命令
@property (nonatomic, readonly, strong) RACCommand *captchaCommand;
/// 验证码按钮能否点击
@property (nonatomic, readonly, strong) RACSignal *validCaptchaSignal;
/// 验证码显示
@property (nonatomic, readonly, copy) NSString *captchaTitle;

/// error （PS；这个记录请求过程中的发生的错误，请求之前必须置nil）
@property (nonatomic, readonly, strong) NSError *error;
@end
