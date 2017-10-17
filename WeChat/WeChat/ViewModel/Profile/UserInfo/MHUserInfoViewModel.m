//
//  MHUserInfoViewModel.m
//  WeChat
//
//  Created by senba on 2017/9/21.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHUserInfoViewModel.h"
#import "MHCommonAvatarItemViewModel.h"
#import "MHCommonLabelItemViewModel.h"
#import "MHCommonQRCodeItemViewModel.h"
#import "MHMoreInfoViewModel.h"
#import "MHModifyNicknameViewModel.h"
@interface MHUserInfoViewModel ()
/// The current `user`.
@property (nonatomic, readwrite , strong) MHUser *user;
@end

@implementation MHUserInfoViewModel

- (instancetype)initWithServices:(id<MHViewModelServices>)services params:(NSDictionary *)params{
    if (self = [super initWithServices:services params:params]) {
        /// 获取user
        self.user = params[MHViewModelUtilKey];
    }
    return self;
}

- (void)initialize{
    [super initialize];
    @weakify(self);
    self.title = @"个人信息";
    
    /// 第一组
    MHCommonGroupViewModel *group0 = [MHCommonGroupViewModel groupViewModel];
    /// 头像
    MHCommonAvatarItemViewModel *avatar = [MHCommonAvatarItemViewModel itemViewModelWithTitle:@"头像"];
    avatar.avatar = self.user.profileImageUrl.absoluteString;
    avatar.rowHeight = 83.0f;
    
    /// 名字
    MHCommonArrowItemViewModel *nickname = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"名字"];
    nickname.subtitle = self.user.screenName;
    @weakify(nickname);
    nickname.operation = ^{
        @strongify(self);
        @strongify(nickname);
        NSString *value = MHStringIsNotEmpty(self.user.screenName)?self.user.screenName:@"";
        MHModifyNicknameViewModel *viewModel = [[MHModifyNicknameViewModel alloc] initWithServices:self.services params:@{MHViewModelUtilKey:value}];
        [self.services presentViewModel:viewModel animated:YES completion:NULL];
        
        /// 设置block
        @weakify(self);
        @weakify(nickname);
        viewModel.callback = ^(NSString *screenName) {
            @strongify(self);
            @strongify(nickname);
            self.user.screenName = screenName;
            [[self.services client] saveUser:self.user];
            nickname.subtitle = screenName;
            
            // “手动触发self.dataSource的KVO”，必写。
            [self willChangeValueForKey:@"dataSource"];
            // “手动触发self.now的KVO”，必写。
            [self didChangeValueForKey:@"dataSource"];
        };
    };
    
    /// 微信号
    MHCommonItemViewModel *wechatId = [MHCommonItemViewModel itemViewModelWithTitle:@"微信号"];
    wechatId.selectionStyle = UITableViewCellSelectionStyleNone;
    wechatId.subtitle = self.user.wechatId;
    
    /// 二维码
    MHCommonQRCodeItemViewModel *qrCode = [MHCommonQRCodeItemViewModel itemViewModelWithTitle:@"我的二维码"];
    
    /// 更多
    MHCommonArrowItemViewModel *moreInfo = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"更多"];
    /// 将用户数据 传递过去
    moreInfo.destViewModelClass = [MHMoreInfoViewModel class];
    
    
    
    group0.itemViewModels = @[avatar , nickname , wechatId , qrCode , moreInfo];
    
    /// 第二组
    MHCommonGroupViewModel *group1 = [MHCommonGroupViewModel groupViewModel];
    /// 我的地址
    MHCommonArrowItemViewModel *address = [MHCommonArrowItemViewModel itemViewModelWithTitle:@"我的地址"];
    group1.itemViewModels = @[address];
    
    self.dataSource = @[group0 , group1];
}

@end
