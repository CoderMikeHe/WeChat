//
//  MHLoginPasswordView.m
//  WeChat
//
//  Created by senba on 2017/9/25.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHLoginPasswordView.h"

@implementation MHLoginPasswordView

+ (instancetype)passwordView{
    return [self mh_viewFromXib];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    /// 限制密码位数 16
    [self.passwordTextField mh_limitMaxLength:16];
}
@end
