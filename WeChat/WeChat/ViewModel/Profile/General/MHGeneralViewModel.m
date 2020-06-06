//
//  MHGeneralViewModel.m
//  WeChat
//
//  Created by senba on 2017/12/19.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHGeneralViewModel.h"
#import "MHCommonSwitchItemViewModel.h"
#import "MHCommonArrowItemViewModel.h"
#import "MHCommonCenterItemViewModel.h"
#import "MHDiscoverManagerViewModel.h"

@interface MHGeneralViewModel ()
/// 清除聊天记录de的命令
@property (nonatomic, readwrite, strong) RACCommand *clearChatRecordsCommand;
/// 清除聊天记录de的回调
@property (nonatomic, readwrite, strong) RACSubject *clearChatRecordsSubject;
@end


@implementation MHGeneralViewModel
- (void)initialize{
    [super initialize];
    @weakify(self);
    self.title = @"通用";
    self.style = UITableViewStyleGrouped;
    
    /// 第一组
    MHCommonGroupViewModel *group0 = [MHCommonGroupViewModel groupViewModel];
    /// 多语言
    MHCommonArrowItemViewModel * language = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"多语言"];
    language.operation = ^{
        @strongify(self);
        
    };
    group0.itemViewModels = @[language];
    
    
    /// 第二组
    MHCommonGroupViewModel *group1 = [MHCommonGroupViewModel groupViewModel];
    /// 字体大小
    MHCommonArrowItemViewModel * fontSize = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"字体大小"];
    fontSize.operation = ^{
        @strongify(self);
        
    };
    /// 聊天背景
    MHCommonArrowItemViewModel * chatBg = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"聊天背景"];
    /// 我的表情
    MHCommonArrowItemViewModel * myEmotion = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"我的表情"];
    /// 照片、视频和文件
    MHCommonArrowItemViewModel * resource = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"照片、视频和文件"];
    group1.itemViewModels = @[fontSize , chatBg , myEmotion , resource];
    
    
    /// 第三组
    MHCommonGroupViewModel *group2 = [MHCommonGroupViewModel groupViewModel];
    /// 听筒模式
    MHCommonSwitchItemViewModel *receiverMode = [MHCommonSwitchItemViewModel itemViewModelWithTitle:@"听筒模式"];
    receiverMode.key = MHPreferenceSettingReceiverMode;
    receiverMode.selectionStyle = UITableViewCellSelectionStyleNone;
    group2.itemViewModels = @[receiverMode];
    
    
    /// 第四组
    MHCommonGroupViewModel *group3 = [MHCommonGroupViewModel groupViewModel];
    /// 发现页管理
    MHCommonArrowItemViewModel * discoverManager = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"发现页管理"];
    discoverManager.destViewModelClass = [MHDiscoverManagerViewModel class];
    /// 功能
    MHCommonArrowItemViewModel * func = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"辅助功能"];
    group3.itemViewModels = @[ discoverManager, func ];
    
    
    /// 第五组
    MHCommonGroupViewModel *group4 = [MHCommonGroupViewModel groupViewModel];
    /// chatRecord 聊天记录
    MHCommonArrowItemViewModel * chatRecord = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"聊天记录备份与迁移"];
    /// 存储空间
    MHCommonArrowItemViewModel * storageSpace = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"存储空间"];
    group4.itemViewModels = @[ chatRecord , storageSpace ];
    
    /// 第六组
    MHCommonGroupViewModel *group5 = [MHCommonGroupViewModel groupViewModel];
    /// 清空聊天记录
    MHCommonCenterItemViewModel *clearChatRecords = [MHCommonCenterItemViewModel itemViewModelWithTitle:@"清除聊天记录"];
    clearChatRecords.operation = ^{
        @strongify(self);
        // 回调出去
        [self.clearChatRecordsSubject sendNext:nil];
    };
    group5.itemViewModels = @[ clearChatRecords ];
    
    /// 数据源
    self.dataSource = @[group0 , group1 , group2 , group3 , group4, group5];
    
    
    self.clearChatRecordsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        /// 模拟清除聊天记录的过程
        NSLog(@"-- 清除聊天记录 --");
        
        return [RACSignal empty];
    }];
    
    self.clearChatRecordsSubject = [RACSubject subject];
}
@end
