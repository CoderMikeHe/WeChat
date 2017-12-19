//
//  MHAccountSecurityViewModel.m
//  WeChat
//
//  Created by senba on 2017/12/7.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHAccountSecurityViewModel.h"
#import "MHCommonLabelItemViewModel.h"
#import "MHCommonArrowItemViewModel.h"

@implementation MHAccountSecurityViewModel
- (void)initialize{
    [super initialize];
    @weakify(self);
    self.title = @"账号与安全";
    
    MHUser *user = self.services.client.currentUser;
    
    /// 第一组
    MHCommonGroupViewModel *group0 = [MHCommonGroupViewModel groupViewModel];
    /// 微信号
    MHCommonItemViewModel *wechatId = [MHCommonItemViewModel itemViewModelWithTitle:@"微信号"];
    wechatId.selectionStyle = UITableViewCellSelectionStyleNone;
    wechatId.subtitle = user.wechatId;
    /// 手机号
    MHCommonArrowItemViewModel *phoneNum = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"手机号"];
    phoneNum.centerRightViewName = @"ProfileLockOn_17x17";
    phoneNum.subtitle = user.phone;
    group0.itemViewModels = @[ wechatId , phoneNum];
    
    /// 第二组
    MHCommonGroupViewModel *group1 = [MHCommonGroupViewModel groupViewModel];
    /// 微信密码
    MHCommonArrowItemViewModel *password = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"微信密码"];
    password.subtitle = @"已设置";
    /// 声音锁
    MHCommonArrowItemViewModel *voiceLock = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"声音锁"];
    voiceLock.subtitle = @"未设置";
    /// 通用
    group1.itemViewModels = @[ password , voiceLock];
    
    /// 第三组
    MHCommonGroupViewModel *group2 = [MHCommonGroupViewModel groupViewModel];
    /// 应急联系人
    MHCommonArrowItemViewModel *emergencyContact = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"应急联系人"];
    /// 登录设备管理
    MHCommonArrowItemViewModel *deviceManager = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"登录设备管理"];
    /// 更多安全设置
    MHCommonArrowItemViewModel *moreSecuritySetting = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"更多安全设置"];
    group2.itemViewModels = @[ emergencyContact , deviceManager, moreSecuritySetting];
    
    
    /// 第三组
    MHCommonGroupViewModel *group3 = [MHCommonGroupViewModel groupViewModel];
    /// 微信安全中心
    MHCommonArrowItemViewModel *securityCenter = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"微信安全中心"];
    group3.itemViewModels = @[securityCenter];
    group3.footer = @"如果遇到账号信息泄露、忘记密码、诈骗等账号安全问题，可前往微信安全中心。";
    
    /// 计算 20
    CGFloat limitWidth = MH_SCREEN_WIDTH - 2 * 20;
    CGFloat footerHeight = [group3.footer mh_sizeWithFont:MHRegularFont_14 limitWidth:limitWidth].height + 5 *2;
    group3.footerHeight = footerHeight;
    
    self.dataSource = @[group0 , group1 , group2 , group3];
    
}
@end
