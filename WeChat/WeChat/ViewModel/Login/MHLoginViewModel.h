//
//  MHLoginViewModel.h
//  WeChat
//
//  Created by senba on 2017/9/26.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHLoginBaseViewModel.h"

@interface MHLoginViewModel : MHLoginBaseViewModel
/// closeCommand
@property (nonatomic, readonly, strong) RACCommand *closeCommand;
/// 更多命令
@property (nonatomic, readonly, strong) RACCommand *moreCommand;
/// LoginCommand
@property (nonatomic, readonly, strong) RACCommand *loginCommand;
/// selelctZoneComand
@property (nonatomic, readonly, strong) RACCommand *selelctZoneComand;

/// 是否选中
@property (nonatomic, readwrite, assign) BOOL selected;

/// QQ登录/微信号/邮箱
/// account
@property (nonatomic, readwrite, copy) NSString * account;
/// password
@property (nonatomic, readwrite, copy) NSString *password;

/// 手机号登录
/// phone
@property (nonatomic, readwrite, copy) NSString *phone;
/// zoneCode
@property (nonatomic, readwrite, copy) NSString *zoneCode;
/// 登录按钮有效性
@property (nonatomic, readonly, strong) RACSignal *validLoginSignal;


/// error （PS；这个记录请求过程中的发生的错误，请求之前必须置nil）
@property (nonatomic, readonly, strong) NSError *error;
@end
