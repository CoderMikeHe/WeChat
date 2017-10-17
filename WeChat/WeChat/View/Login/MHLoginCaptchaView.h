//
//  MHLoginCaptchaView.h
//  WeChat
//
//  Created by senba on 2017/9/25.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHLoginCaptchaView : UIView
/// init
+ (instancetype)captchaView;

/// default is 45
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *captchaTextFieldLeftCons;
/// captchaTextField
@property (weak, nonatomic) IBOutlet UITextField *captchaTextField;

/// 获取验证码
@property (weak, nonatomic) IBOutlet UIButton *captchaBtn;


@end
