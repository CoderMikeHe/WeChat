//
//  MHGroupChatViewModel.h
//  WeChat
//
//  Created by admin on 2020/5/21.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHTableViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MHGroupChatViewModel : MHTableViewModel
/// toUsers 聊天对象群
@property (nonatomic, readonly, copy) NSArray *toUsers;

/// 点击导航栏更多按钮
@property (nonatomic, readonly, strong) RACCommand *moreCommand;
@end

NS_ASSUME_NONNULL_END
