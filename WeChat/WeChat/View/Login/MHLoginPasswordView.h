//
//  MHLoginPasswordView.h
//  WeChat
//
//  Created by senba on 2017/9/25.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHLoginPasswordView : UIView
/// init
+ (instancetype)passwordView;

/// passwordTextField
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

/// left default is 65
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwordTextFieldLeftCons;

@end
