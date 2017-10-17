//
//  MHAccountLoginView.m
//  WeChat
//
//  Created by senba on 2017/9/27.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHAccountLoginView.h"

@implementation MHAccountLoginView

+ (instancetype)accoutLoginView{
    return [self mh_viewFromXib];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    /// 限制密码位数 16
    [self.passwordTextField mh_limitMaxLength:16];
    /// 限制QQ位数 11
    [self.accountTextField mh_limitMaxLength:11];
}
@end
