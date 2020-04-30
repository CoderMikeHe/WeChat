//
//  MHCommitViewModel.m
//  WeChat
//
//  Created by senba on 2017/10/12.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHCommitViewModel.h"
#import "YYTimer.h"

@interface MHCommitViewModel ()
/// closeCommand
@property (nonatomic, readwrite, strong) RACCommand *closeCommand;
/// 验证码命令
@property (nonatomic, readwrite, strong) RACCommand *captchaCommand;
/// 提交命令
@property (nonatomic, readwrite, strong) RACCommand *commitCommand;
/// 提交按钮有效性
@property (nonatomic, readwrite, strong) RACSignal *validCommitSignal;
/// phone
@property (nonatomic, readwrite, copy) NSString *phone;
/// zoneCode
@property (nonatomic, readwrite, copy) NSString *zoneCode;

/// 验证码显示
@property (nonatomic, readwrite, copy) NSString *captchaTitle;
/// Timer
@property (nonatomic, readwrite, strong) YYTimer *timer;
/// Count
@property (nonatomic, readwrite, assign) NSUInteger count;

/// error （PS；这个记录请求过程中的发生的错误，请求之前必须置nil）
@property (nonatomic, readwrite, strong) NSError *error;
@end

@implementation MHCommitViewModel

- (instancetype)initWithServices:(id<MHViewModelServices>)services params:(NSDictionary *)params
{
    if (self = [super initWithServices:services params:params]) {
        self.phone = params[MHMobileLoginPhoneKey];
        self.zoneCode = params[MHMobileLoginZoneCodeKey];
    }
    return self;
}

-(void)initialize{
    [super initialize];
    @weakify(self);
    self.closeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self.services dismissViewModelAnimated:YES completion:NULL];
        return [RACSignal empty];
    }];
    
    self.captchaCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        self.count = MHCaptchaFetchMaxWords;
        self.captchaTitle = @"接收短信大约需要60秒";
        self.timer = [YYTimer timerWithTimeInterval:1 target:self selector:@selector(_timerValueChanged:) repeats:YES];
        return [RACSignal empty];
    }];
    
    
    void (^doNext)(MHUser *) = ^(MHUser *user){
        @strongify(self);
        /// 存储登录账号
        [SAMKeychain setRawLogin:self.phone];
        
        /// 存储用户数据
        [[self.services client] loginUser:user];
        
        /// 切换更控制器
        dispatch_async(dispatch_get_main_queue(), ^{
            /// 发通知
            [[NSNotificationCenter defaultCenter] postNotificationName:MHSwitchRootViewControllerNotification object:nil userInfo:@{MHSwitchRootViewControllerUserInfoKey:@(MHSwitchRootViewControllerFromTypeLogin)}];
        });
    };
    self.commitCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        self.error = nil; // 先置nil
        return [[self _fetchUserInfo] doNext:doNext];
    }];
    
    self.validCommitSignal = [RACObserve(self, captcha) map:^id(NSString * captcha) {
        return @(captcha.length>0);
    }];
}
#pragma mark - 辅助方法
- (RACSignal *) _fetchUserInfo{
    @weakify(self);
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        @weakify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @strongify(self);
            /// 假设请求到数据模型是  MHUser模型
            MHUser *user = [[MHUser alloc] init];
            user.screenName = @"Mike-乱港三千-Mr_元先森";
            user.idstr = @"61856069";
            user.profileImageUrl = [NSURL URLWithString:@"http://tva3.sinaimg.cn/crop.0.6.264.264.180/93276e1fjw8f5c6ob1pmpj207g07jaa5.jpg"];
            /// 用户的封面
            user.coverImageUrl = [NSURL URLWithString:@"http://p1.gexing.com/G1/M00/7A/83/rBACE1TW-cjDb2yHAAGORXsJM6w706.jpg"];
            user.coverImage = MHImageNamed(@"Kris.jpeg");
            
            /// 假设是这里统一都是qq号码登录
            user.qq = @"491273090";
            user.email = [NSString stringWithFormat:@"%@@qq.com",user.qq];       // PS：机智，拼接成QQ邮箱
            user.wechatId = @"mikehe";             // PS：瞎写的
            user.phone = self.phone;                    // PS：瞎写的
            user.channel = MHUserLoginChannelTypePhone; // 手机号登录
            [subscriber sendNext:user];
            /// 必须sendCompleted 否则command.executing一直为1 导致HUD 一直 loading
            [subscriber sendCompleted];
        });
        return [RACDisposable disposableWithBlock:^{
            /// 取消任务
        }];
    }] doError:^(NSError *error) {
        @strongify(self);
        self.error = error;
    }];
}

#pragma mark - Action
- (void)_timerValueChanged:(YYTimer *)timer
{
    self.count--;
    if (self.count == 0) {
        [timer invalidate];
        self.timer = nil;
        [self _resetCaptcha];
        return;
    }
    self.captchaTitle = [NSString stringWithFormat:@"接收短信大约需要%zd秒", self.count];
}
#pragma mark - 辅助方法
- (void)_resetCaptcha {
    self.captchaTitle = @"如果未收到验证码短信，请返回上个界面，重新获取验证码即可。";
}
@end
