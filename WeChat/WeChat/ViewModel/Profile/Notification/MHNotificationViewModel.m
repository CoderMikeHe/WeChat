//
//  MHNotificationViewModel.m
//  WeChat
//
//  Created by senba on 2017/12/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHNotificationViewModel.h"
#import "MHCommonSwitchItemViewModel.h"
#import "MHCommonArrowItemViewModel.h"
#import "MHFreeInterruptionViewModel.h"
@implementation MHNotificationViewModel
- (void)initialize{
    [super initialize];
    @weakify(self);
    self.title = @"新消息通知";
    
    /// 第一组
    MHCommonGroupViewModel *group0 = [MHCommonGroupViewModel groupViewModel];
    /// 接收新消息通知
    MHCommonSwitchItemViewModel *notification = [MHCommonSwitchItemViewModel itemViewModelWithTitle:@"接收新消息通知"];
    notification.key = MHPreferenceSettingReceiveNewMessageNotification;
    notification.selectionStyle = UITableViewCellSelectionStyleNone;
    /// 接收语音和视频聊天通知
    MHCommonSwitchItemViewModel * voiceOrVideo= [MHCommonSwitchItemViewModel itemViewModelWithTitle:@"接收语音和视频聊天邀请通知"];
    voiceOrVideo.key = MHPreferenceSettingReceiveVoiceOrVideoNotification;
    voiceOrVideo.selectionStyle = UITableViewCellSelectionStyleNone;
    /// 视频聊天、语音聊天铃声
    MHCommonSwitchItemViewModel * voiceOrVideoChat= [MHCommonSwitchItemViewModel itemViewModelWithTitle:@"视频聊天、语音聊天铃声"];
    voiceOrVideoChat.key = MHPreferenceSettingVoiceOrVideoChatRing;
    voiceOrVideoChat.selectionStyle = UITableViewCellSelectionStyleNone;
    group0.itemViewModels = @[notification , voiceOrVideo , voiceOrVideoChat];
    
    /// 第二组
    MHCommonGroupViewModel *group1 = [MHCommonGroupViewModel groupViewModel];
    /// 通知显示消息详情
    MHCommonSwitchItemViewModel * messageDetail= [MHCommonSwitchItemViewModel itemViewModelWithTitle:@"通知显示消息详情"];
    messageDetail.key = MHPreferenceSettingNotificationShowDetailMessage;
    messageDetail.selectionStyle = UITableViewCellSelectionStyleNone;
    
    group1.footer = @"关闭后，当收到消息时，通知提示将不再显示发信人和内容摘要。";
    CGFloat limitWidth = MH_SCREEN_WIDTH - 2 * 20;
    CGFloat footerHeight1 = [group1.footer mh_sizeWithFont:MHRegularFont_14 limitWidth:limitWidth].height + 5 *2;
    group1.footerHeight = footerHeight1;
    group1.itemViewModels = @[messageDetail];
    
    /// 第三组
    MHCommonGroupViewModel *group2 = [MHCommonGroupViewModel groupViewModel];
    /// 功能消息免打扰
    MHCommonArrowItemViewModel * freeInterruption = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"功能消息免打扰"];
    freeInterruption.operation = ^{
        @strongify(self);
        MHFreeInterruptionViewModel *viewModel = [[MHFreeInterruptionViewModel alloc] initWithServices:self.services params:nil];
        [self.services presentViewModel:viewModel animated:YES completion:NULL];
    };
    group2.footer = @"设置系统功能消息提示声音和震动的时段。";
    CGFloat footerHeight2 = [group2.footer mh_sizeWithFont:MHRegularFont_14 limitWidth:limitWidth].height + 5 *2;
    group2.footerHeight = footerHeight2;
    group2.headerHeight = 21;
    group2.itemViewModels = @[freeInterruption];
 
    /// 第四组
    MHCommonGroupViewModel *group3 = [MHCommonGroupViewModel groupViewModel];
    
    /// 声音
    MHCommonSwitchItemViewModel * volume= [MHCommonSwitchItemViewModel itemViewModelWithTitle:@"声音"];
    volume.key = MHPreferenceSettingMessageAlertVolume;
    volume.selectionStyle = UITableViewCellSelectionStyleNone;
    /// 震动
    MHCommonSwitchItemViewModel * vibration= [MHCommonSwitchItemViewModel itemViewModelWithTitle:@"震动"];
    vibration.key = MHPreferenceSettingMessageAlertVibration;
    vibration.selectionStyle = UITableViewCellSelectionStyleNone;
    
    group3.itemViewModels = @[volume , vibration];
    group3.footer = @"当微信在运行时，你可以设置是否需要声音或者震动。";
    group3.headerHeight = 21;
    /// 计算 20
    CGFloat footerHeight3 = [group3.footer mh_sizeWithFont:MHRegularFont_14 limitWidth:limitWidth].height + 5 *2;
    group3.footerHeight = footerHeight3;
    group3.itemViewModels = @[volume , vibration];
    
    self.dataSource = @[group0 , group1 , group2 , group3];
    
    
}
@end
