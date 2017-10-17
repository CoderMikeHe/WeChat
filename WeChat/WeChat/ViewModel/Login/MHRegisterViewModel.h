//
//  MHRegisterViewModel.h
//  WeChat
//
//  Created by senba on 2017/10/12.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHLoginBaseViewModel.h"

@interface MHRegisterViewModel : MHLoginBaseViewModel

/// closeCommand
@property (nonatomic, readonly, strong) RACCommand *closeCommand;
/// registerCommand
@property (nonatomic, readonly, strong) RACCommand *registerCommand;
/// selelctZoneComand
@property (nonatomic, readonly, strong) RACCommand *selelctZoneComand;
/// 验证码命令
@property (nonatomic, readonly, strong) RACCommand *captchaCommand;
/// 手机号注册
/// phone
@property (nonatomic, readwrite, copy) NSString *phone;
/// zoneCode
@property (nonatomic, readwrite, copy) NSString *zoneCode;
/// 注册按钮有效性
@property (nonatomic, readonly, strong) RACSignal *validRegisterSignal;
/// error （PS；这个记录请求过程中的发生的错误，请求之前必须置nil）
@property (nonatomic, readonly, strong) NSError *error;


@end
