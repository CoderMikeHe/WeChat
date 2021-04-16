//
//  MHContactInfoViewModel.m
//  WeChat
//
//  Created by zhangguangqun on 2021/4/14.
//  Copyright © 2021 CoderMikeHe. All rights reserved.
//

#import "MHContactInfoViewModel.h"
#import "MHContactsItemViewModel.h"
#import "MHCommonArrowItemViewModel.h"
#import "MHContactInfoHeaderViewModel.h"
#import "MHContactInfoContactItemViewModel.h"

@interface MHContactInfoViewModel ()
/// 联系人
@property (nonatomic, readwrite, strong) MHUser *contact;

@end

@implementation MHContactInfoViewModel

- (void)initialize{
    [super initialize];
    
    [self _configureData];
}

- (instancetype)initWithServices:(id<MHViewModelServices>)services params:(NSDictionary *)params{
    if (self = [super initWithServices:services params:params]) {
        self.contact = params[MHViewModelUtilKey];
    }
    return self;
}

- (void)_configureData{
    /// 第一组
    MHCommonGroupViewModel *group1 = [MHCommonGroupViewModel groupViewModel];
    /// 联系人信息
    MHContactInfoHeaderViewModel *contactInfoHeader = [[MHContactInfoHeaderViewModel alloc] initViewModelWithUser:self.contact];
    /// 设置备注和标签
    MHCommonArrowItemViewModel *setCommentAndTag = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"设置备注和标签"];
    group1.itemViewModels = @[contactInfoHeader, setCommentAndTag];
    
    /// 第二组
    MHCommonGroupViewModel *group2 = [MHCommonGroupViewModel groupViewModel];
    MHCommonArrowItemViewModel *moment = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"朋友圈"];
    MHCommonArrowItemViewModel *moreInfo = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"更多信息"];
    group2.itemViewModels = @[moment, moreInfo];
    
    /// 第三组
    MHCommonGroupViewModel *group3 = [MHCommonGroupViewModel groupViewModel];
    MHContactInfoContactItemViewModel *sendMessage = [[MHContactInfoContactItemViewModel alloc] initViewModelWithIconName:@"icons_outlined_chats.svg" andLabelString:@"发消息"];
    MHContactInfoContactItemViewModel *videoCall = [[MHContactInfoContactItemViewModel alloc] initViewModelWithIconName:@"icons_outlined_videocall.svg" andLabelString:@"音视频通话"];
    group3.itemViewModels = @[sendMessage, videoCall];

    self.dataSource = @[group1, group2, group3];
}

@end
