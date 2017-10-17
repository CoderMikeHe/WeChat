//
//  MHLoginCaptchaView.m
//  WeChat
//
//  Created by senba on 2017/9/25.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHLoginCaptchaView.h"

@implementation MHLoginCaptchaView

+ (instancetype)captchaView{
    return [self mh_viewFromXib];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    @weakify(self);
    /// 限制验证码位数 6
    [self.captchaTextField mh_limitMaxLength:6];
    
    /// 监听获取按钮的enable属性
    [[RACObserve(self.captchaBtn, enabled) skip:1] subscribeNext:^(NSNumber * enabled) {
        @strongify(self);
        self.captchaBtn.layer.borderColor = enabled.boolValue?MHColorFromHexString(@"#353535").CGColor:MHColorFromHexString(@"#C8C8C8").CGColor;
    }];
    
}
@end
