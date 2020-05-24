//
//  MHSearchDefaultGroupChatItemViewModel.h
//  WeChat
//
//  Created by 何千元 on 2020/5/23.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchDefaultItemViewModel.h"
#import "WPFPerson.h"
NS_ASSUME_NONNULL_BEGIN

@interface MHSearchDefaultGroupChatItemViewModel : MHSearchDefaultItemViewModel
/// 群聊名称
@property (nonatomic, readonly, copy) NSString *groupChatName;
/// 子标题
@property (nonatomic, readonly, copy) NSAttributedString *subtitleAttr;
/// person
@property (nonatomic, readonly, strong) WPFPerson *person;
/// 群聊用户
@property (nonatomic, readonly, copy) NSArray *groupUsers;

/// 初始化
- (instancetype)initWithPerson:(WPFPerson *)person groupUsers:(NSArray *)users;

@end

NS_ASSUME_NONNULL_END
