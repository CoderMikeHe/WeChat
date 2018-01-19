//
//  MHAccountLoginViewModel.m
//  WeChat
//
//  Created by senba on 2017/9/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHAccountLoginViewModel.h"
#import "MHWebViewModel.h"
#import "MHLoginViewModel.h"
#import "MHRegisterViewModel.h"
#import "YYTimer.h"


@interface MHAccountLoginViewModel ()
/// loginCommand
@property (nonatomic, readwrite, strong) RACCommand *loginCommand;
/// 登录按钮有效性
@property (nonatomic, readwrite, strong) RACSignal *validLoginSignal;
/// 更多命令
@property (nonatomic, readwrite, strong) RACCommand *moreCommand;
/// error （PS；这个记录请求过程中的发生的错误，请求之前必须置nil）
@property (nonatomic, readwrite, strong) NSError *error;

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


@implementation MHAccountLoginViewModel

- (void)initialize{
    [super initialize];
    
    @weakify(self);
    void (^doNext)(MHUser *) = ^(MHUser *user){
        @strongify(self);
        /// 存储登录账号
        [SAMKeychain setRawLogin:self.account];
        
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
        if (!selected.boolValue) { /// QQ登录/微信号/邮箱
            /// 发起请求去登录 self.account + self.password
            return [[self _fetchUserInfoWithUserLoginChannel:MHUserLoginChannelTypeQQ] doNext:doNext];
        }else{ /// 手机号登录
            return [[self _fetchUserInfoWithUserLoginChannel:MHUserLoginChannelTypePhone] doNext:doNext];
        }
        return [RACSignal empty];
    }];
  
    /// 按钮的有效性
    self.validLoginSignal = [[RACSignal
                              combineLatest:@[RACObserve(self, account), RACObserve(self, password),RACObserve(self, phone),RACObserve(self, captcha), RACObserve(self, selected)]
                              reduce:^(NSString *account, NSString *password , NSString *phone , NSString * captcha, NSNumber *selected) {
                                  if (!selected.boolValue) {
                                      return @(MHStringIsNotEmpty(account) && MHStringIsNotEmpty(password));
                                  }else{
                                      return @(MHStringIsNotEmpty(phone) && MHStringIsNotEmpty(captcha));
                                  }
                              }]
                             distinctUntilChanged];
    
    
    /// 更多命令
    self.moreCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber * index) {
        @strongify(self);
        MHViewModel *viewModel = nil;
        if (index.integerValue == 1) {       /// 切换账号
            viewModel = [[MHLoginViewModel alloc] initWithServices:self.services params:nil];
        }else if (index.integerValue == 2){  /// 找回密码
            NSURL *url = [NSURL URLWithString:MHMyBlogHomepageUrl];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            MHWebViewModel * webViewModel = [[MHWebViewModel alloc] initWithServices:self.services params:@{MHViewModelRequestKey:request}];
            /// 去掉关闭按钮
            webViewModel.shouldDisableWebViewClose = YES;
            viewModel = webViewModel;
        }else if (index.integerValue == 3){  /// 前往微信安全中心
            NSURL *url = [NSURL URLWithString:MHMyBlogHomepageUrl];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            MHWebViewModel * webViewModel = [[MHWebViewModel alloc] initWithServices:self.services params:@{MHViewModelRequestKey:request}];
            /// 去掉关闭按钮
            webViewModel.shouldDisableWebViewClose = YES;
            viewModel = webViewModel;
        }else if (index.integerValue == 4){  /// 注册
            viewModel = [[MHRegisterViewModel alloc] initWithServices:self.services params:nil];
        }
        if (viewModel) [self.services presentViewModel:viewModel animated:YES completion:NULL];
        return [RACSignal empty];
    }];
    
    
    
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
- (RACSignal *) _fetchUserInfoWithUserLoginChannel:(MHUserLoginChannelType)channel{
    @weakify(self);
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        /// 发起请求 模拟网络请求 由于是已经有账号了.直接把沙盒的数据返回即可
        @strongify(self);
        @weakify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @strongify(self);
            /// 假设请求到数据模型是  MHUser模型
            MHUser *user = self.services.client.currentUser;
            user.channel = channel;     // 用户登录的渠道
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
