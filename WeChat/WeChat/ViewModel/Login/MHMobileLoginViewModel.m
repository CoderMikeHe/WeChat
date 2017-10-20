//
//  MHMobileLoginViewModel.m
//  WeChat
//
//  Created by senba on 2017/9/27.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHMobileLoginViewModel.h"
#import "MHWebViewModel.h"
#import "YYTimer.h"


@interface MHMobileLoginViewModel ()
/// closeCommand
@property (nonatomic, readwrite, strong) RACCommand *closeCommand;
/// loginCommand
@property (nonatomic, readwrite, strong) RACCommand *loginCommand;

/// phone
@property (nonatomic, readwrite, copy) NSString *phone;
/// zoneCode
@property (nonatomic, readwrite, copy) NSString *zoneCode;
/// error （PS；这个记录请求过程中的发生的错误，请求之前必须置nil）
@property (nonatomic, readwrite, strong) NSError *error;
/// 更多命令
@property (nonatomic, readwrite, strong) RACCommand *moreCommand;
/// 登录按钮有效性
@property (nonatomic, readwrite, strong) RACSignal *validLoginSignal;

/// 验证码命令
@property (nonatomic, readwrite, strong) RACCommand *captchaCommand;
/// 验证码按钮能否点击
@property (nonatomic, readwrite, strong) RACSignal *validCaptchaSignal;
/// 验证码显示
@property (nonatomic, readwrite, copy) NSString *captchaTitle;
/// Timer
@property (nonatomic, readwrite, strong) YYTimer *timer;
/// Count
@property (nonatomic, readwrite, assign) NSUInteger count;
/// valid (有效性)
@property (nonatomic, readwrite, assign) BOOL valid;
@end
@implementation MHMobileLoginViewModel
- (instancetype)initWithServices:(id<MHViewModelServices>)services params:(NSDictionary *)params
{
    if (self = [super initWithServices:services params:params]) {
        self.phone = params[MHMobileLoginPhoneKey];
        self.zoneCode = params[MHMobileLoginZoneCodeKey];
    }
    
    return self;
}


- (void)initialize{
    [super initialize];
    
    @weakify(self);
    self.closeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self.services popViewModelAnimated:YES];
        return [RACSignal empty];
    }];
    
    /// 更多命令
    self.moreCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber * index) {
        @strongify(self);
        MHViewModel *viewModel = nil;
        if (index.integerValue == 1){  /// 找回密码
            NSURL *url = [NSURL URLWithString:MHMyBlogHomepageUrl];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            MHWebViewModel * webViewModel = [[MHWebViewModel alloc] initWithServices:self.services params:@{MHViewModelRequestKey:request}];
            /// 去掉关闭按钮
            webViewModel.shouldDisableWebViewClose = YES;
            viewModel = webViewModel;
        }else if (index.integerValue == 2){  /// 前往微信安全中心
            NSURL *url = [NSURL URLWithString:MHMyBlogHomepageUrl];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            MHWebViewModel * webViewModel = [[MHWebViewModel alloc] initWithServices:self.services params:@{MHViewModelRequestKey:request}];
            /// 去掉关闭按钮
            webViewModel.shouldDisableWebViewClose = YES;
            viewModel = webViewModel;
        }
        if (viewModel) [self.services presentViewModel:viewModel animated:YES completion:NULL];
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
    
    /// 登录命令
    self.loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber * selected) {
        @strongify(self);
        /// 判断QQ登录 还是 手机号登录
        /// 将self.error = nil;
        self.error = nil;
        if (selected.boolValue) { /// 验证码登录
            /// 发起请求去
            return [[self _fetchUserInfo] doNext:doNext];
        }else{  /// 密码登录
            /// 发起请求去
            return [[self _fetchUserInfo] doNext:doNext];
        }
        return [RACSignal empty];
    }];
    
    
    /// 按钮的有效性
    self.validLoginSignal = [[RACSignal
                              combineLatest:@[RACObserve(self, password),RACObserve(self, captcha), RACObserve(self, selected)]
                              reduce:^(NSString *password , NSString *captcha , NSNumber *selected) {
                                  if (selected.boolValue) {
                                      return @(MHStringIsNotEmpty(captcha));
                                  }else{
                                      return @(MHStringIsNotEmpty(password));
                                  }
                              }]
                             distinctUntilChanged];
    
    
    /// 验证码按钮有效性
    self.captchaTitle = @"获取验证码";
    RAC(self, valid) = [[RACObserve(self, timer.valid) map:^id(NSNumber * value) {
        return @(!value.boolValue);
    }] distinctUntilChanged];
    /// 验证码有效性
    self.validCaptchaSignal = RACObserve(self,valid);
    self.captchaCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        /// 将错误置为nil
        self.error = nil;
        self.valid = NO;
        self.captchaTitle = @"发送中...";
        /// 执行
        @weakify(self);
        return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            });
            return [RACDisposable disposableWithBlock:^{
            }];
        }] doNext:^(id x) {
            @strongify(self);
            self.count = MHCaptchaFetchMaxWords;
            self.captchaTitle = @"60s后重新发送";
            self.timer = [YYTimer timerWithTimeInterval:1 target:self selector:@selector(_timerValueChanged:) repeats:YES];
        }] doError:^(NSError *error) {
            @strongify(self);
            self.error = error;
        }];
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
            user.wechatId = @"codermikehe";             // PS：瞎写的
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
    self.captchaTitle = [NSString stringWithFormat:@"%zds后重新发送", self.count];
}
#pragma mark - 辅助方法
- (void)_resetCaptcha {
    self.valid = YES;
    self.captchaTitle = @"获取验证码";
}
@end
