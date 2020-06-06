//
//  MHSettingViewModel.m
//  WeChat
//
//  Created by senba on 2017/10/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHSettingViewModel.h"
#import "MHCommonArrowItemViewModel.h"
#import "MHCommonCenterItemViewModel.h"
#import "MHPlugViewModel.h"
#import "MHAccountSecurityViewModel.h"
#import "MHNotificationViewModel.h"
#import "MHWebViewModel.h"
#import "MHAboutUsViewModel.h"
#import "MHPrivacyViewModel.h"
#import "MHGeneralViewModel.h"
@interface MHSettingViewModel ()
/// 登出的命令
@property (nonatomic, readwrite, strong) RACCommand *logoutCommand;
/// 登出回调
@property (nonatomic, readwrite, strong) RACSubject *logoutSubject;
@end

@implementation MHSettingViewModel
- (void)initialize{
    [super initialize];
    @weakify(self);
    self.title = @"设置";
    self.prefersNavigationBarBottomLineHidden = NO;
    
    /// 第一组
    MHCommonGroupViewModel *group0 = [MHCommonGroupViewModel groupViewModel];
    
    ///账号与安全
    MHCommonArrowItemViewModel *accountSecurity = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"账号与安全"];
    accountSecurity.destViewModelClass = [MHAccountSecurityViewModel class];
    group0.itemViewModels = @[ accountSecurity ];
    
    /// 第二组
    MHCommonGroupViewModel *group1 = [MHCommonGroupViewModel groupViewModel];
    /// 新消息通知
    MHCommonArrowItemViewModel *messageNote = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"新消息通知"];
    messageNote.destViewModelClass = [MHNotificationViewModel class];
    /// 隐私
    MHCommonArrowItemViewModel *private = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"隐私"];
    private.destViewModelClass = [MHPrivacyViewModel class];
    
    /// 通用
    MHCommonArrowItemViewModel *general = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"通用"];
    general.destViewModelClass = [MHGeneralViewModel class];
    group1.itemViewModels = @[ messageNote , private , general];
    
    /// 第三组
    MHCommonGroupViewModel *group2 = [MHCommonGroupViewModel groupViewModel];
    /// 帮助与反馈
    MHCommonArrowItemViewModel *help = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"帮助与反馈"];
    help.operation = ^{
        @strongify(self);
        NSURL *url = [NSURL URLWithString:MHMyBlogHomepageUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        MHWebViewModel * viewModel = [[MHWebViewModel alloc] initWithServices:self.services params:@{MHViewModelRequestKey:request}];
        /// 去掉关闭按钮
        viewModel.shouldDisableWebViewClose = YES;
        [self.services pushViewModel:viewModel animated:YES];
    };
    
    /// 关于微信
    MHCommonArrowItemViewModel *aboutUs = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"关于微信"];
    aboutUs.destViewModelClass = [MHAboutUsViewModel class];
    group2.itemViewModels = @[ help , aboutUs];
    
    /// 第四组
    MHCommonGroupViewModel *group3 = [MHCommonGroupViewModel groupViewModel];
    /// 插件
    MHCommonArrowItemViewModel *plug = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"插件"];
    plug.centerLeftViewName = @"WeChat_Lab_Logo_small_15x17";
    plug.destViewModelClass = [MHPlugViewModel class];
    group3.itemViewModels = @[ plug ];
    
    /// 第五组
    MHCommonGroupViewModel *group4 = [MHCommonGroupViewModel groupViewModel];
    /// 插
    MHCommonCenterItemViewModel *changeAccount = [MHCommonCenterItemViewModel itemViewModelWithTitle:@"切换账号"];
    group4.itemViewModels = @[ changeAccount ];
    
    /// 第六组
    MHCommonGroupViewModel *group5 = [MHCommonGroupViewModel groupViewModel];
    /// 插
    MHCommonCenterItemViewModel *logout = [MHCommonCenterItemViewModel itemViewModelWithTitle:@"退出登录"];
    logout.operation = ^{
        @strongify(self);
        // 回调出去
        [self.logoutSubject sendNext:nil];
    };
    
    group5.itemViewModels = @[ logout ];
    
    self.dataSource = @[group0 , group1 , group2 , group3, group4, group5];
    

    /// 退出回调
    self.logoutSubject = [RACSubject subject];
    
    /// 退出登录的命令
    self.logoutCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        /// 删除账号
        [SAMKeychain deleteRawLogin];
        /// 先退出用户
        [[self.services client] logoutUser];
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            /// 延迟一段时间
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                /// 这里切换 到账号登录的界面
                [MHNotificationCenter postNotificationName:MHSwitchRootViewControllerNotification object:nil userInfo:@{MHSwitchRootViewControllerUserInfoKey:@(MHSwitchRootViewControllerFromTypeLogout)}];
                [subscriber sendNext:nil];
                [subscriber sendCompleted]; 
            });
            return [RACDisposable disposableWithBlock:^{
                
            }];
        }];
    }];
    
    
}
@end
