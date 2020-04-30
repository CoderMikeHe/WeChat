//
//  MHLoginViewModel.m
//  WeChat
//
//  Created by senba on 2017/9/26.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHLoginViewModel.h"
#import "MHZoneCodeViewModel.h"
#import "MHWebViewModel.h"
#import "MHUser.h"
@interface MHLoginViewModel ()
/// closeCommand
@property (nonatomic, readwrite, strong) RACCommand *closeCommand;
/// loginCommand
@property (nonatomic, readwrite, strong) RACCommand *loginCommand;
/// selelctZoneComand
@property (nonatomic, readwrite, strong) RACCommand *selelctZoneComand;
/// error （PS；这个记录请求过程中的发生的错误，请求之前必须置nil）
@property (nonatomic, readwrite, strong) NSError *error;
/// 更多命令
@property (nonatomic, readwrite, strong) RACCommand *moreCommand;
/// 登录按钮有效性
@property (nonatomic, readwrite, strong) RACSignal *validLoginSignal;
@end

@implementation MHLoginViewModel

- (void)initialize{
    [super initialize];
    
    @weakify(self);
    self.closeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self.services dismissViewModelAnimated:YES completion:NULL];
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
    
    
    /// 登录命令
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
    self.loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber * selected) {
        @strongify(self);
        /// 判断QQ登录 还是 手机号登录
        if (selected.boolValue) { /// QQ登录/微信号/邮箱
            /// 发起请求去登录 self.account + self.password
            /// 将self.error = nil;
            self.error = nil;
            return [[self _fetchUserInfo] doNext:doNext];
        }
        return [RACSignal empty];
    }];
    
    self.selelctZoneComand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        MHZoneCodeViewModel *viewModel = [[MHZoneCodeViewModel alloc] initWithServices:self.services params:nil];
        [self.services presentViewModel:viewModel animated:YES completion:NULL];
        return [RACSignal empty];
    }];
    
    /// 按钮的有效性
    self.validLoginSignal = [[RACSignal
                                  combineLatest:@[RACObserve(self, account), RACObserve(self, password),RACObserve(self, phone), RACObserve(self, selected)]
                                  reduce:^(NSString *account, NSString *password , NSString *phone , NSNumber *selected) {
                                      if (selected.boolValue) {
                                          return @(MHStringIsNotEmpty(account) && MHStringIsNotEmpty(password));
                                      }else{
                                          return @(MHStringIsNotEmpty(phone));
                                      }
                                  }]
                                 distinctUntilChanged];
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
            
            /// 假设是这里统一都是qq号码登录
            user.qq = self.account;
            user.email = [NSString stringWithFormat:@"%@@qq.com",user.qq];       // PS：机智，拼接成QQ邮箱
            user.wechatId = @"mikehe";             // PS：瞎写的
            user.phone = @"13874385438";                // PS：瞎写的
            user.channel = MHUserLoginChannelTypeQQ;    // QQ登录
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
@end
